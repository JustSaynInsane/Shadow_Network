-- ============================================
-- SHADOW ELITES - SHADOW APP (CLIENT)
-- ============================================

local function isCop()
    local PlayerData = exports.qbx_core:GetPlayerData()
    local policeJobs = {'police', 'sheriff', 'state', 'doj', 'ambulance'}
    
    if not PlayerData or not PlayerData.job then return false end
    
    for _, job in ipairs(policeJobs) do
        if PlayerData.job.name == job then
            return true
        end
    end
    
    return false
end

local function isCriminal()
    local progression = lib.callback.await('shadow_elites:server:getProgression', false)
    
    if not progression then return false end
    
    local organized = progression.organized and progression.organized.level or 0
    local narcotics = progression.narcotics and progression.narcotics.level or 0
    local auto_theft = progression.auto_theft and progression.auto_theft.level or 0
    
    return (organized + narcotics + auto_theft) > 0
end

function openShadowNetworkApp()
    local progression = lib.callback.await('shadow_elites:server:getProgression', false)
    
    if not progression then
        lib.notify({
            description = 'Failed to load data',
            type = 'error'
        })
        return
    end
    
    local level = progression.organized and progression.organized.level or 0
    local options = {}
    
    -- TIER 0: Everyone
    table.insert(options, {
        title = '🗑️ Dumpster Diving',
        description = 'Search trash for items',
        icon = 'trash',
        onSelect = function()
            lib.notify({description = 'Find trash cans to search!', type = 'inform'})
        end
    })
    
    -- TIER 1: Level 1+
    if level >= 1 then
        table.insert(options, {
            title = '🏠 House Robberies',
            description = 'Break into homes',
            icon = 'house-chimney-crack',
            onSelect = function()
                lib.notify({description = 'Walk up to a house with a lockpick and press E!', type = 'inform'})
            end
        })
    else
        table.insert(options, {
            title = '🔒 More Activities',
            description = 'Reach Level 1 to unlock',
            icon = 'lock',
            disabled = true
        })
    end
    
    -- TIER 2: Level 3+
    if level >= 3 then
        table.insert(options, {
            title = '🏦 Bank Robberies',
            description = 'Small bank heists',
            icon = 'building-columns',
            onSelect = function()
                lib.notify({description = 'Bank robbery system coming soon!', type = 'inform'})
            end
        })
    end
    
    -- TIER 3: Level 5+
    if level >= 5 then
        table.insert(options, {
            title = '🎭 Shadow Network',
            description = 'Elite operations',
            icon = 'mask',
            iconColor = '#00ff00',
            onSelect = function()
                lib.notify({description = 'Shadow Network features coming in Week 3!', type = 'inform'})
            end
        })
    end
    
    lib.registerContext({
        id = 'shadow_app',
        title = '🎭 Shadow Network',
        options = options
    })
    
    lib.showContext('shadow_app')
end

RegisterNetEvent('shadow_network:client:openApp', function()
    if isCop() then
        lib.notify({description = 'Access denied', type = 'error'})
        return
    end
    
    if not isCriminal() then
        lib.notify({description = 'This app is not available', type = 'error'})
        return
    end
    
    openShadowNetworkApp()
end)

-- Register command CLIENT-SIDE
RegisterCommand('shadowapp', function()
    if isCop() then
        lib.notify({description = 'Access denied', type = 'error'})
        return
    end
    
    if not isCriminal() then
        lib.notify({description = 'This app is not available', type = 'error'})
        return
    end
    
    openShadowNetworkApp()
end, false)