local ox_inventory = exports.ox_inventory
local searchedTrash = {} -- Track searched trash server-side

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function DebugPrint(...)
    if Config.Debug then
        print('^3[TRASH SEARCH]^7', ...)
    end
end

local function GetPlayerIdentifier(source)
    if Config.Framework == 'qbx' or Config.Framework == 'qb' then
        local Player = exports.qbx_core:GetPlayer(source)
        return Player and Player.PlayerData.citizenid or nil
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer and xPlayer.identifier or nil
    end
    return tostring(source) -- Fallback to source ID
end

local function CanCarryItem(source, item, amount)
    return ox_inventory:CanCarryItem(source, item, amount)
end

local function AddItem(source, item, amount)
    return ox_inventory:AddItem(source, item, amount)
end

-- ============================================
-- XP SYSTEM INTEGRATION (FIXED - DUAL TREE!)
-- ============================================

local function GiveXP(source, trashType)
    -- XP amounts based on trash type difficulty
    -- Trash searching is the BASE ACTIVITY (Level 0) for BOTH Narcotics AND Organized Crime
    local xpAmounts = {
        trash_can = {
            narcotics = 3,    -- Finding drug materials
            organized = 3,    -- Petty crime basics
        },
        recycling_bin = {
            narcotics = 4,
            organized = 4,
        },
        dumpster = {
            narcotics = 5,
            organized = 5,    -- Bigger dumpsters = more crime XP
        },
    }
    
    local xpData = xpAmounts[trashType] or {narcotics = 3, organized = 1}
    
    -- Give XP to BOTH trees (trash searching is entry to criminal life)
    local narcSuccess = pcall(function()
        exports['shadow_elites_progression']:AddXP(source, 'narcotics', xpData.narcotics)
    end)
    
    local orgSuccess = pcall(function()
        exports['shadow_elites_progression']:AddXP(source, 'organized', xpData.organized)
    end)
    
    if narcSuccess and orgSuccess then
        DebugPrint('Gave', xpData.narcotics, 'narcotics XP and', xpData.organized, 'organized XP to player', source)
    else
        DebugPrint('WARNING: Failed to give XP - shadow_elites_progression may not be running')
    end
end

-- ============================================
-- COOLDOWN MANAGEMENT
-- ============================================

local function IsOnCooldown(entityId)
    if searchedTrash[entityId] then
        local timeLeft = searchedTrash[entityId] - os.time()
        if timeLeft > 0 then
            DebugPrint('Entity', entityId, 'on cooldown for', timeLeft, 'seconds')
            return true
        else
            searchedTrash[entityId] = nil
        end
    end
    return false
end

local function SetCooldown(entityId)
    searchedTrash[entityId] = os.time() + Config.SearchCooldown
    DebugPrint('Set cooldown for entity', entityId, 'for', Config.SearchCooldown, 'seconds')
end

-- ============================================
-- LOOT GENERATION
-- ============================================

local function GenerateLoot(trashType)
    local lootTable = Config.Loot[trashType]
    if not lootTable then
        DebugPrint('ERROR: No loot table for', trashType)
        return {}
    end
    
    local results = {}
    
    -- Add guaranteed items
    if lootTable.guaranteed then
        for _, item in ipairs(lootTable.guaranteed) do
            local amount = math.random(item.min, item.max)
            table.insert(results, {
                item = item.item,
                amount = amount
            })
            DebugPrint('Guaranteed:', item.item, 'x' .. amount)
        end
    end
    
    -- Roll for chance-based items
    if lootTable.items then
        for _, item in ipairs(lootTable.items) do
            local roll = math.random(1, 100)
            if roll <= item.chance then
                local amount = math.random(item.min, item.max)
                table.insert(results, {
                    item = item.item,
                    amount = amount
                })
                DebugPrint('Rolled:', item.item, 'x' .. amount, '(chance:', item.chance .. '%)')
            end
        end
    end
    
    return results
end

-- ============================================
-- MAIN SEARCH HANDLER
-- ============================================

RegisterNetEvent('trash_search:search', function(entityId, trashType)
    local source = source
    
    if not entityId or not trashType then
        DebugPrint('ERROR: Missing entityId or trashType')
        return
    end
    
    -- Check cooldown
    if IsOnCooldown(entityId) then
        TriggerClientEvent('ox_lib:notify', source, Config.Notifications.on_cooldown)
        return
    end
    
    -- Generate loot
    local loot = GenerateLoot(trashType)
    
    if not loot or #loot == 0 then
        TriggerClientEvent('trash_search:receiveResults', source, {}, trashType)
        SetCooldown(entityId)
        return
    end
    
    -- Give items to player
    local givenItems = {}
    for _, result in ipairs(loot) do
        if CanCarryItem(source, result.item, result.amount) then
            if AddItem(source, result.item, result.amount) then
                table.insert(givenItems, result)
                DebugPrint('Gave player', result.item, 'x' .. result.amount)
            end
        else
            TriggerClientEvent('ox_lib:notify', source, Config.Notifications.inventory_full)
            break
        end
    end
    
    -- Give XP for searching (only if items were found)
    if #givenItems > 0 then
        GiveXP(source, trashType)
    end
    
    -- Send results to client
    TriggerClientEvent('trash_search:receiveResults', source, givenItems, trashType)
    
    -- Set cooldown
    SetCooldown(entityId)
    
    -- Optional: Log to console/database
    if Config.Debug then
        local identifier = GetPlayerIdentifier(source)
        DebugPrint('Player', identifier, 'searched', trashType, 'and received', #givenItems, 'items')
    end
end)

-- ============================================
-- CLEANUP COOLDOWNS PERIODICALLY
-- ============================================

CreateThread(function()
    while true do
        Wait(60000) -- Every 1 minute
        
        local currentTime = os.time()
        local cleaned = 0
        
        for entityId, expireTime in pairs(searchedTrash) do
            if currentTime >= expireTime then
                searchedTrash[entityId] = nil
                cleaned = cleaned + 1
            end
        end
        
        if cleaned > 0 then
            DebugPrint('Cleaned', cleaned, 'expired cooldowns')
        end
    end
end)

-- ============================================
-- ADMIN COMMANDS (Optional)
-- ============================================

lib.addCommand('resettrash', {
    help = 'Reset all trash search cooldowns (admin only)',
    restricted = 'group.admin'
}, function(source)
    searchedTrash = {}
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Reset Complete',
        description = 'All trash search cooldowns have been reset',
        type = 'success'
    })
    DebugPrint('Admin', source, 'reset all trash cooldowns')
end)