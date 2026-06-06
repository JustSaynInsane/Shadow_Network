-- ============================================
-- HEIST PLAN STUDY SYSTEM
-- Right-click heist plans to view details
-- ============================================

exports('studyHeistPlan', function(source, itemName)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    -- Check if player has the plan
    local hasItem = exports.ox_inventory:Search(source, 'count', itemName)
    if hasItem < 1 then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'You don\'t have this plan',
            type = 'error'
        })
        return
    end
    
    -- Send plan details to client
    TriggerClientEvent('shadow_elites:client:showHeistPlan', source, itemName)
end)

-- ============================================
-- ACTIVATE HEIST (With Requirement Checking)
-- ============================================

lib.callback.register('shadow_elites:server:activateHeist', function(source, heistType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false, message = 'Player not found'} end
    
    local heistConfig = Config.HeistRequirements[heistType]
    if not heistConfig then
        return {success = false, message = 'Invalid heist type'}
    end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get player progression
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    if not progression then
        return {success = false, message = 'No criminal progression found'}
    end
    
    -- CHECK 1: Level requirement
    if (progression.organized_level or 0) < heistConfig.minLevel then
        return {
            success = false, 
            message = string.format('Requires Organized Crime Level %d', heistConfig.minLevel)
        }
    end
    
    -- CHECK 2: Shadow Network unlock (if required)
    if heistConfig.unlockRequirement then
        if not progression[heistConfig.unlockRequirement] or progression[heistConfig.unlockRequirement] == 0 then
            return {
                success = false,
                message = 'You haven\'t unlocked this heist yet'
            }
        end
    end
    
    -- CHECK 2.5: Completion requirements (NEW!)
    if heistConfig.requiredCompletions then
        for requiredHeist, requiredCount in pairs(heistConfig.requiredCompletions) do
            local completions = exports['shadow_elites_progression']:GetHeistCompletions(source, requiredHeist)
            if completions < requiredCount then
                return {
                    success = false,
                    message = string.format('Complete %d %s first (%d/%d)', 
                        requiredCount, requiredHeist, completions, requiredCount)
                }
            end
        end
    end    
        
    -- CHECK 3: Get player's crew
    local crewId = MySQL.scalar.await('SELECT crew_id FROM criminal_crew_members WHERE identifier = ?', {identifier})
    if not crewId then
        return {success = false, message = 'You must be in a crew to start a heist'}
    end
    
    -- CHECK 4: Crew size
    local crewMembers = MySQL.query.await('SELECT * FROM criminal_crew_members WHERE crew_id = ?', {crewId})
    local crewSize = #crewMembers
    
    if crewSize < heistConfig.minCrew then
        return {
            success = false,
            message = string.format('Need at least %d crew members', heistConfig.minCrew)
        }
    end
    
    if crewSize > heistConfig.maxCrew then
        return {
            success = false,
            message = string.format('Maximum %d crew members allowed', heistConfig.maxCrew)
        }
    end
    
    -- CHECK 5: Required items (leader must have them)
    for _, requirement in ipairs(heistConfig.requiredItems) do
        local count = exports.ox_inventory:Search(source, 'count', requirement.item)
        if count < requirement.amount then
            return {
                success = false,
                message = string.format('Missing: %s (need %d)', requirement.item, requirement.amount)
            }
        end
    end
    
    -- CHECK 6: Cooldown
    if heistConfig.cooldown > 0 then
        local lastHeist = MySQL.scalar.await([[
            SELECT MAX(started_at) FROM criminal_heist_activations 
            WHERE crew_id = ? AND heist_type = ?
        ]], {crewId, heistType})
        
        if lastHeist then
            local timeSince = os.time() - os.time(lastHeist)
            if timeSince < heistConfig.cooldown then
                local remaining = math.ceil((heistConfig.cooldown - timeSince) / 60)
                return {
                    success = false,
                    message = string.format('Heist on cooldown (%d minutes remaining)', remaining)
                }
            end
        end
    end
    
    -- ALL CHECKS PASSED! Consume items
    for _, requirement in ipairs(heistConfig.requiredItems) do
        if requirement.consumed then
            exports.ox_inventory:RemoveItem(source, requirement.item, requirement.amount)
        end
    end
    
    -- Create heist activation in database
    MySQL.insert([[
        INSERT INTO criminal_heist_activations 
        (crew_id, heist_type, leader_identifier, started_at, duration, active)
        VALUES (?, ?, ?, NOW(), ?, 1)
    ]], {
        crewId,
        heistType,
        identifier,
        heistConfig.duration
    })
    
    -- Notify all crew members
    for _, member in ipairs(crewMembers) do
        local memberPlayer = exports.qbx_core:GetPlayerByCitizenId(member.identifier)
        if memberPlayer then
            TriggerClientEvent('ox_lib:notify', memberPlayer.PlayerData.source, {
                title = 'Heist Activated',
                description = string.format('%s activated! You have %d minutes.', 
                    heistType:gsub('_', ' '), 
                    math.floor(heistConfig.duration / 60)),
                type = 'success',
                duration = 10000
            })
        end
    end
    
    return {success = true, message = 'Heist activated!'}
end)