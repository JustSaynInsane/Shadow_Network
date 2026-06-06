-- ============================================
-- SHADOW ELITES - CLIENT MAIN
-- Client-side progression display
-- ============================================

local PlayerData = {}
local ProgressionData = {}

-- ============================================
-- PLAYER LOADED EVENT
-- ============================================

-- Wait for player to be spawned and ready
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        return
    end
end)

-- Alternative: Use a simple spawn check
CreateThread(function()
    while true do
        Wait(5000)
        
        local player = PlayerId()
        if NetworkIsPlayerActive(player) and not PlayerData.citizenid then
            -- Player is active, try to load data
            local data = exports.qbx_core:GetPlayerData()
            if data and data.citizenid then
                PlayerData = data
                
                -- Load progression data
                ProgressionData = lib.callback.await('shadow_elites:server:getProgression', false)
                
                if Config.Debug then
                    print('^2[Shadow Elites]^7 Progression loaded')
                end
                
                break
            end
        end
    end
end)

-- ============================================
-- INSTALL SHADOW NETWORK APP
-- ============================================

RegisterNetEvent('shadow_elites:client:installShadowNetwork', function()
    -- Install NPWD app
--    exports['npwd']:addCustomApp({
--        id = 'shadow_network',
--        nameLocale = 'Shadow Network',
--        icon = '🌑',
--        color = '#1a1a1a',
--        path = '/shadow-network',
--        notificationIcon = '🌑'
--    })
    
    -- Notification
    lib.notify({
        title = 'New App Installed',
        description = 'Shadow Network app now available',
        type = 'success',
        duration = 7000,
    })
end)

-- ============================================
-- SET GPS WAYPOINT
-- ============================================

RegisterNetEvent('shadow_elites:client:setWaypoint', function(coords)
    if not coords then
        print('^1[Shadow Elites] No coords provided for waypoint!^7')
        return
    end
    
    -- Make sure coords are valid
    local x, y = coords.x or coords[1], coords.y or coords[2]
    
    if not x or not y then
        print('^1[Shadow Elites] Invalid coords for waypoint: ' .. tostring(coords) .. '^7')
        return
    end
    
    -- Set the waypoint
    SetNewWaypoint(x, y)
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 GPS waypoint set to: %.2f, %.2f', x, y))
    end
    
    lib.notify({
        title = 'GPS Updated',
        description = 'Waypoint set on your map',
        type = 'inform',
        duration = 5000,
    })
end)

-- ============================================
-- TELEPORT TO NPC (ADMIN)
-- ============================================

RegisterNetEvent('shadow_elites:client:teleportToNPC', function(coords)
    if not coords then return end
    
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 Teleported to: %.2f, %.2f, %.2f', coords.x, coords.y, coords.z))
    end
end)

-- ============================================
-- OPEN PROGRESSION MENU (DEBUG)
-- ============================================

RegisterCommand('progression', function()
    if not ProgressionData then
        ProgressionData = lib.callback.await('shadow_elites:server:getProgression', false)
    end
    
    if not ProgressionData then
        lib.notify({
            description = 'Failed to load progression data',
            type = 'error'
        })
        return
    end
    
    local options = {
        {
            title = '💊 Narcotics',
            description = string.format('Level %d | %d XP | %d Skill Points', 
                ProgressionData.narcotics.level,
                ProgressionData.narcotics.xp,
                ProgressionData.narcotics.skillPoints),
            icon = 'cannabis',
        },
        {
            title = '💰 Organized Crime',
            description = string.format('Level %d | %d XP | %d Skill Points', 
                ProgressionData.organized.level,
                ProgressionData.organized.xp,
                ProgressionData.organized.skillPoints),
            icon = 'vault',
        },
        {
            title = '🚗 Auto Theft',
            description = string.format('Level %d | %d XP | %d Skill Points', 
                ProgressionData.auto_theft.level,
                ProgressionData.auto_theft.xp,
                ProgressionData.auto_theft.skillPoints),
            icon = 'car',
        },
        {
            title = 'Shadow Network',
            description = ProgressionData.shadowNetworkUnlocked and 'Unlocked ✅' or 'Locked 🔒',
            icon = 'user-secret',
        },
    }
    
    lib.registerContext({
        id = 'shadow_progression_menu',
        title = 'Criminal Progression',
        options = options
    })
    
    lib.showContext('shadow_progression_menu')
end)

-- ============================================
-- DEBUG: TEST GPS WAYPOINT
-- ============================================

RegisterCommand('testwaypoint', function()
    -- Test waypoint at new Shadow NPC location (Vinewood Hills overlook)
    local testCoords = vector3(745.59, 1299.44, 359.3)
    
    SetNewWaypoint(testCoords.x, testCoords.y)
    
    lib.notify({
        title = 'Test Waypoint',
        description = 'GPS set to Vinewood Hills (745, 1299)',
        type = 'success'
    })
    
    print(string.format('^2[Shadow Elites]^7 Test waypoint set to: %.2f, %.2f, %.2f', testCoords.x, testCoords.y, testCoords.z))
end)

-- ============================================
-- REFRESH PROGRESSION DATA
-- ============================================

CreateThread(function()
    while true do
        Wait(30000) -- Refresh every 30 seconds
        
        if PlayerData and PlayerData.citizenid then
            ProgressionData = lib.callback.await('shadow_elites:server:getProgression', false)
        end
    end
end)