-- ============================================
-- SHADOW ELITES - SERVER MAIN
-- Core progression system logic
-- ============================================

-- QBX doesn't use GetCoreObject, use exports directly

-- ============================================
-- PLAYER DATA LOADING
-- ============================================

-- Load player's criminal progression on player loaded
RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
    local src = Player.PlayerData.source
    local identifier = Player.PlayerData.citizenid
    
    -- Load criminal progression from database
    MySQL.query('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] then
            -- Player has existing progression
            local data = result[1]
            
            -- Set metadata
            Player.Functions.SetMetaData('narcotics_xp', data.narcotics_xp)
            Player.Functions.SetMetaData('narcotics_level', data.narcotics_level)
            Player.Functions.SetMetaData('narcotics_skill_points', data.narcotics_skill_points)
            
            Player.Functions.SetMetaData('organized_xp', data.organized_xp)
            Player.Functions.SetMetaData('organized_level', data.organized_level)
            Player.Functions.SetMetaData('organized_skill_points', data.organized_skill_points)
            
            Player.Functions.SetMetaData('auto_theft_xp', data.auto_theft_xp)
            Player.Functions.SetMetaData('auto_theft_level', data.auto_theft_level)
            Player.Functions.SetMetaData('auto_theft_skill_points', data.auto_theft_skill_points)
            
            Player.Functions.SetMetaData('shadow_network_unlocked', data.shadow_network_unlocked)
            
            -- Level 10 milestones
            Player.Functions.SetMetaData('reached_level_10_narcotics', data.reached_level_10_narcotics)
            Player.Functions.SetMetaData('reached_level_10_organized', data.reached_level_10_organized)
            Player.Functions.SetMetaData('reached_level_10_auto_theft', data.reached_level_10_auto_theft)
            
            -- Heist completions
            Player.Functions.SetMetaData('heist_completions_fleeca_bank', data.heist_completions_fleeca_bank)
            Player.Functions.SetMetaData('heist_completions_jewelry_store', data.heist_completions_jewelry_store)
            Player.Functions.SetMetaData('heist_completions_pacific_standard', data.heist_completions_pacific_standard)
            
            -- Shadow unlocks
            Player.Functions.SetMetaData('shadow_unlocked_pacific_standard', data.shadow_unlocked_pacific_standard)
            Player.Functions.SetMetaData('shadow_unlocked_humane_labs', data.shadow_unlocked_humane_labs)
            Player.Functions.SetMetaData('shadow_unlocked_casino', data.shadow_unlocked_casino)
            
            if Config.Debug then
                print('^2[Shadow Elites]^7 Loaded progression for ' .. Player.PlayerData.charinfo.firstname)
            end
        else
            -- New player - create fresh progression entry
            MySQL.insert('INSERT INTO criminal_progression (identifier) VALUES (?)', {identifier}, function(insertId)
                if insertId then
                    -- Set all metadata to 0/false
                    Player.Functions.SetMetaData('narcotics_xp', 0)
                    Player.Functions.SetMetaData('narcotics_level', 0)
                    Player.Functions.SetMetaData('narcotics_skill_points', 0)
                    
                    Player.Functions.SetMetaData('organized_xp', 0)
                    Player.Functions.SetMetaData('organized_level', 0)
                    Player.Functions.SetMetaData('organized_skill_points', 0)
                    
                    Player.Functions.SetMetaData('auto_theft_xp', 0)
                    Player.Functions.SetMetaData('auto_theft_level', 0)
                    Player.Functions.SetMetaData('auto_theft_skill_points', 0)
                    
                    Player.Functions.SetMetaData('shadow_network_unlocked', false)
                    
                    if Config.Debug then
                        print('^2[Shadow Elites]^7 Created new progression for ' .. Player.PlayerData.charinfo.firstname)
                    end
                end
            end)
        end
    end)
end)

-- ============================================
-- SAVE PLAYER DATA ON LOGOUT
-- ============================================

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(Player)
    local identifier = Player.PlayerData.citizenid
    local metadata = Player.PlayerData.metadata
    
    -- Save all progression data
    MySQL.update([[
        UPDATE criminal_progression SET
            narcotics_xp = ?,
            narcotics_level = ?,
            narcotics_skill_points = ?,
            organized_xp = ?,
            organized_level = ?,
            organized_skill_points = ?,
            auto_theft_xp = ?,
            auto_theft_level = ?,
            auto_theft_skill_points = ?,
            shadow_network_unlocked = ?,
            reached_level_10_narcotics = ?,
            reached_level_10_organized = ?,
            reached_level_10_auto_theft = ?,
            heist_completions_fleeca_bank = ?,
            heist_completions_jewelry_store = ?,
            heist_completions_pacific_standard = ?,
            shadow_unlocked_pacific_standard = ?,
            shadow_unlocked_humane_labs = ?,
            shadow_unlocked_casino = ?,
            last_activity = NOW()
        WHERE identifier = ?
    ]], {
        metadata.narcotics_xp or 0,
        metadata.narcotics_level or 0,
        metadata.narcotics_skill_points or 0,
        metadata.organized_xp or 0,
        metadata.organized_level or 0,
        metadata.organized_skill_points or 0,
        metadata.auto_theft_xp or 0,
        metadata.auto_theft_level or 0,
        metadata.auto_theft_skill_points or 0,
        metadata.shadow_network_unlocked or false,
        metadata.reached_level_10_narcotics or false,
        metadata.reached_level_10_organized or false,
        metadata.reached_level_10_auto_theft or false,
        metadata.heist_completions_fleeca_bank or 0,
        metadata.heist_completions_jewelry_store or 0,
        metadata.heist_completions_pacific_standard or 0,
        metadata.shadow_unlocked_pacific_standard or false,
        metadata.shadow_unlocked_humane_labs or false,
        metadata.shadow_unlocked_casino or false,
        identifier
    })
    
    if Config.Debug then
        print('^2[Shadow Elites]^7 Saved progression for ' .. Player.PlayerData.charinfo.firstname)
    end
end)

-- ============================================
-- PERIODIC SAVE (every 10 minutes)
-- ============================================

CreateThread(function()
    while true do
        Wait(600000) -- 10 minutes
        
        -- Get all online players
        for _, player in pairs(GetPlayers()) do
            local Player = exports.qbx_core:GetPlayer(tonumber(player))
            if Player then
                local identifier = Player.PlayerData.citizenid
                local metadata = Player.PlayerData.metadata
            
            MySQL.update([[
                UPDATE criminal_progression SET
                    narcotics_xp = ?,
                    narcotics_level = ?,
                    narcotics_skill_points = ?,
                    organized_xp = ?,
                    organized_level = ?,
                    organized_skill_points = ?,
                    auto_theft_xp = ?,
                    auto_theft_level = ?,
                    auto_theft_skill_points = ?,
                    shadow_network_unlocked = ?,
                    last_activity = NOW()
                WHERE identifier = ?
            ]], {
                metadata.narcotics_xp or 0,
                metadata.narcotics_level or 0,
                metadata.narcotics_skill_points or 0,
                metadata.organized_xp or 0,
                metadata.organized_level or 0,
                metadata.organized_skill_points or 0,
                metadata.auto_theft_xp or 0,
                metadata.auto_theft_level or 0,
                metadata.auto_theft_skill_points or 0,
                metadata.shadow_network_unlocked or false,
                identifier
            })
            end
        end
        
        if Config.Debug then
            print('^2[Shadow Elites]^7 Auto-saved progression for all online players')
        end
    end
end)

-- ============================================
-- GET PLAYER PROGRESSION
-- ============================================

lib.callback.register('shadow_elites:server:getProgression', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil end
    
    local metadata = Player.PlayerData.metadata
    
    return {
        narcotics = {
            xp = metadata.narcotics_xp or 0,
            level = metadata.narcotics_level or 0,
            skillPoints = metadata.narcotics_skill_points or 0,
        },
        organized = {
            xp = metadata.organized_xp or 0,
            level = metadata.organized_level or 0,
            skillPoints = metadata.organized_skill_points or 0,
        },
        auto_theft = {
            xp = metadata.auto_theft_xp or 0,
            level = metadata.auto_theft_level or 0,
            skillPoints = metadata.auto_theft_skill_points or 0,
        },
        shadowNetworkUnlocked = metadata.shadow_network_unlocked or false,
    }
end)

lib.addCommand('shadowapp', {
    help = 'Open Shadow Network app'
}, function(source, args)
    -- Check if cop
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    local policeJobs = {'police', 'sheriff', 'state', 'doj'}
    for _, job in ipairs(policeJobs) do
        if Player.PlayerData.job.name == job then
            TriggerClientEvent('ox_lib:notify', source, {
                description = 'Access denied',
                type = 'error'
            })
            return
        end
    end
    
    -- Open app
    TriggerClientEvent('shadow_network:client:openApp', source)
end)

-- ============================================
-- DEBUG: Print when resource starts
-- ============================================

CreateThread(function()
    print('^2============================================^7')
    print('^2Shadow Elites - Criminal Progression^7')
    print('^2Version: 1.0.0^7')
    print('^2Status: ^2Online^7')
    print('^2============================================^7')
end)