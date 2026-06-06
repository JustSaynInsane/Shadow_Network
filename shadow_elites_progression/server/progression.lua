-- ============================================
-- SHADOW ELITES - PROGRESSION SYSTEM
-- XP, Leveling, and Shadow Network Unlocks
-- VERSION 2.0 - WITH EXPORTS FOR INTEGRATION
-- ============================================

-- QBX doesn't use GetCoreObject, use exports directly

-- ============================================
-- UPDATED AddXP FUNCTION
-- Replace the AddXP function in progression.lua (lines 16-95)
-- This version triggers tablet refresh AFTER XP changes
-- ============================================

---@param source number Player source
---@param tree string Tree name (narcotics, organized, auto_theft)
---@param amount number XP amount to add
local function AddXP(source, tree, amount)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    local metadata = Player.PlayerData.metadata
    local currentXP = metadata[tree .. '_xp'] or 0
    local currentLevel = metadata[tree .. '_level'] or 0
    
    -- Add XP
    local newXP = currentXP + amount
    Player.Functions.SetMetaData(tree .. '_xp', newXP)
    
    -- Send XP gained notification to tablet
    TriggerClientEvent('shadow_tablet:client:xpGained', source, {
        skillTree = tree,
        xp = amount,
        newTotal = newXP
    })
    
    -- Check for level up
    local Config = require 'config.shared' -- Adjust path as needed
    local xpNeeded = Config.Progression.xpPerLevel[currentLevel + 1]
    
    if xpNeeded and newXP >= xpNeeded then
        -- Level up!
        local newLevel = currentLevel + 1
        Player.Functions.SetMetaData(tree .. '_level', newLevel)
        
        -- Server event for tracking
        TriggerEvent('shadow_elites:server:levelUp', source, tree, newLevel)
        
        -- Award skill point
        local currentPoints = metadata[tree .. '_skill_points'] or 0
        Player.Functions.SetMetaData(tree .. '_skill_points', currentPoints + 1)
        
        -- Send level up notification to tablet
        TriggerClientEvent('shadow_tablet:client:levelUp', source, {
            skillTree = tree,
            newLevel = newLevel,
            skillPoints = currentPoints + 1
        })
        
        -- Check for Level 5 (Shadow Network unlock)
        if newLevel == 5 and not metadata.shadow_network_unlocked then
            Player.Functions.SetMetaData('shadow_network_unlocked', true)
            
            -- Unlock Shadow Network in tablet
            TriggerEvent('shadow_tablet:server:unlockShadowNetwork', source)
            
            -- Send Shadow Network unlock message to tablet
            TriggerEvent('shadow_network:server:sendMessage', source, 'level5_welcome', tree)
        end
        
        -- Send milestone messages for specific levels
        if newLevel == 3 then
            TriggerEvent('shadow_network:server:sendMessage', source, 'level3_' .. tree, tree)
        elseif newLevel == 7 then
            TriggerEvent('shadow_network:server:sendMessage', source, 'level7_' .. tree, tree)
        elseif newLevel == 10 then
            Player.Functions.SetMetaData('reached_level_10_' .. tree, true)
            TriggerEvent('shadow_network:server:sendMessage', source, 'level10_' .. tree, tree)
            
            -- Check if player has reached Level 10 in all trees (LEGENDARY STATUS)
            local allTreesMax = true
            for _, skillTree in ipairs({'narcotics', 'organized', 'auto_theft'}) do
                if (metadata[skillTree .. '_level'] or 0) < 10 then
                    allTreesMax = false
                    break
                end
            end
            
            if allTreesMax then
                Player.Functions.SetMetaData('legendary_status', true)
                TriggerEvent('shadow_network:server:sendMessage', source, 'legendary_status', tree)
            end
        end
    end
    
    -- 🚨 FIX: FORCE TABLET TO REFRESH AFTER XP CHANGE
    -- Wait a tiny bit for metadata to save
    SetTimeout(100, function()
        TriggerClientEvent('shadow_elites:client:refreshProgression', source)
    end)
    
    return true
end

-- ============================================
-- EXPORT: ADD XP (MAIN INTEGRATION POINT)
-- ============================================

---@param source number Player source
---@param tree string Tree name (narcotics, organized, auto_theft)
---@param amount number XP amount to add
---@return boolean success
exports('AddXP', function(source, tree, amount)
    if type(source) ~= 'number' then
        print('^1[Shadow Elites] ERROR: Invalid source in AddXP export^7')
        return false
    end
    
    if type(tree) ~= 'string' or not (tree == 'narcotics' or tree == 'organized' or tree == 'auto_theft') then
        print('^1[Shadow Elites] ERROR: Invalid tree in AddXP export. Must be: narcotics, organized, or auto_theft^7')
        return false
    end
    
    if type(amount) ~= 'number' or amount <= 0 then
        print('^1[Shadow Elites] ERROR: Invalid amount in AddXP export^7')
        return false
    end
    
    return AddXP(source, tree, amount)
end)

-- ============================================
-- EXPORT: GET PLAYER LEVEL
-- ============================================

---@param source number Player source
---@param tree string Tree name (narcotics, organized, auto_theft)
---@return number level
exports('GetLevel', function(source, tree)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return 0 end
    
    return Player.PlayerData.metadata[tree .. '_level'] or 0
end)

-- ============================================
-- EXPORT: GET PLAYER XP
-- ============================================

---@param source number Player source
---@param tree string Tree name (narcotics, organized, auto_theft)
---@return number xp
exports('GetXP', function(source, tree)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return 0 end
    
    return Player.PlayerData.metadata[tree .. '_xp'] or 0
end)

-- ============================================
-- EXPORT: CHECK LEVEL REQUIREMENT
-- ============================================

---@param source number Player source
---@param tree string Tree name (narcotics, organized, auto_theft)
---@param requiredLevel number Required level
---@return boolean meetsRequirement
exports('CheckLevel', function(source, tree, requiredLevel)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    local playerLevel = Player.PlayerData.metadata[tree .. '_level'] or 0
    return playerLevel >= requiredLevel
end)

-- ============================================
-- EXPORT: GET ALL PROGRESSION DATA
-- ============================================

---@param source number Player source
---@return table progression data
exports('GetProgression', function(source)
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
        legendaryStatus = metadata.legendary_status or false,
    }
end)

-- ============================================
-- EXPORT: TRACK HEIST COMPLETION
-- ============================================

---@param source number Player source
---@param heistType string Heist type (fleeca_bank, jewelry_store, pacific_standard)
---@return boolean success
exports('CompleteHeist', function(source, heistType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    local completionKey = 'heist_completions_' .. heistType
    local currentCount = Player.PlayerData.metadata[completionKey] or 0
    Player.Functions.SetMetaData(completionKey, currentCount + 1)
    
    -- Send completion message to Shadow Network
    TriggerEvent('shadow_network:server:sendMessage', source, 'heist_completed_' .. heistType, 'organized')
    
    return true
end)

-- ============================================
-- EXPORT: GET HEIST COMPLETIONS
-- ============================================

---@param source number Player source
---@param heistType string Heist type
---@return number completions
exports('GetHeistCompletions', function(source, heistType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return 0 end
    
    local completionKey = 'heist_completions_' .. heistType
    return Player.PlayerData.metadata[completionKey] or 0
end)

-- ============================================
-- ADMIN COMMANDS
-- ============================================

-- Add XP command
lib.addCommand('addcrimxp', {
    help = 'Add criminal XP to player',
    params = {
        { name = 'id', type = 'playerId', help = 'Player ID' },
        { name = 'tree', help = 'Skill tree (narcotics/organized/auto_theft)' },
        { name = 'amount', type = 'number', help = 'XP amount' },
    },
    restricted = 'group.admin'
}, function(source, args)
    local tree = args.tree:lower()
    if not (tree == 'narcotics' or tree == 'organized' or tree == 'auto_theft') then
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Invalid tree! Use: narcotics, organized, or auto_theft',
            type = 'error'
        })
    end
    
    AddXP(args.id, tree, args.amount)
    
    TriggerClientEvent('ox_lib:notify', source, {
        description = string.format('Added %d XP to %s tree for player %d', args.amount, tree, args.id),
        type = 'success'
    })
end)

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
        legendaryStatus = metadata.legendary_status or false,
    }
end)

-- Complete heist command
lib.addCommand('completeheist', {
    help = 'Mark heist as completed for player',
    params = {
        { name = 'id', type = 'playerId', help = 'Player ID' },
        { name = 'heist', help = 'Heist type (fleeca/jewelry/pacific)' },
    },
    restricted = 'group.admin'
}, function(source, args)
    local heistType = args.heist:lower() .. '_bank'
    if args.heist:lower() == 'jewelry' then
        heistType = 'jewelry_store'
    elseif args.heist:lower() == 'pacific' then
        heistType = 'pacific_standard'
    end
    
    exports['shadow_elites_progression']:CompleteHeist(args.id, heistType)
    
    TriggerClientEvent('ox_lib:notify', source, {
        description = string.format('Completed %s for player', args.heist),
        type = 'success'
    })
end)

-- View player stats
lib.addCommand('crimstats', {
    help = 'View player criminal stats',
    params = {
        { name = 'id', type = 'playerId', help = 'Player ID' },
    },
    restricted = 'group.admin'
}, function(source, args)
    local Player = exports.qbx_core:GetPlayer(args.id)
    if not Player then return end
    
    local metadata = Player.PlayerData.metadata
    
    print('^2============================================^7')
    print('^2Criminal Stats for ' .. Player.PlayerData.charinfo.firstname .. '^7')
    print('^2============================================^7')
    print(string.format('Narcotics: Level %d (%d XP)', 
        metadata.narcotics_level or 0, metadata.narcotics_xp or 0))
    print(string.format('Organized Crime: Level %d (%d XP)', 
        metadata.organized_level or 0, metadata.organized_xp or 0))
    print(string.format('Auto Theft: Level %d (%d XP)', 
        metadata.auto_theft_level or 0, metadata.auto_theft_xp or 0))
    print('^2============================================^7')
    print(string.format('Fleeca Completions: %d', metadata.heist_completions_fleeca_bank or 0))
    print(string.format('Jewelry Completions: %d', metadata.heist_completions_jewelry_store or 0))
    print(string.format('Pacific Completions: %d', metadata.heist_completions_pacific_standard or 0))
    print('^2============================================^7')
end)

print('^2[Shadow Elites Progression] Loaded successfully with exports!^7')