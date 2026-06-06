local ox_inventory = exports.ox_inventory
local searchedTrash = {} -- Track searched trash locally

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function DebugPrint(...)
    if Config.Debug then
        print('^3[TRASH SEARCH]^7', ...)
    end
end

local function Notify(data)
    lib.notify(data)
end

-- ============================================
-- SEARCH FUNCTION
-- ============================================

local function SearchTrash(entity, trashType)
    local entityId = NetworkGetNetworkIdFromEntity(entity)
    
    -- Check if already searched (client-side check)
    if searchedTrash[entityId] then
        Notify(Config.Notifications.on_cooldown)
        return
    end
    
    -- Trigger server-side search
    DebugPrint('Searching', trashType, 'with network ID:', entityId)
    
    -- Show progress bar
    if lib.progressCircle({
        duration = 5000,
        label = 'Searching trash...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',  -- ✅ CORRECT!
            clip = 'machinic_loop_mechandplayer'
        },
    }) then
        -- Progress completed
        TriggerServerEvent('trash_search:search', entityId, trashType)
        
        -- Mark as searched locally
        searchedTrash[entityId] = true
        
        -- Remove from local cache after cooldown
        SetTimeout(Config.SearchCooldown * 1000, function()
            searchedTrash[entityId] = nil
        end)
    else
        -- Progress cancelled
        Notify({
            title = 'Cancelled',
            description = 'Search cancelled',
            type = 'error',
            duration = 2000
        })
    end
end

-- ============================================
-- OX_TARGET SETUP
-- ============================================

CreateThread(function()
    DebugPrint('Setting up ox_target for trash searching...')
    
    -- TRASH CANS
    exports.ox_target:addModel(Config.Props.trash_can, {
        {
            name = 'search_trash_can',
            icon = 'fa-solid fa-magnifying-glass',
            label = 'Search Trash Can',
            onSelect = function(data)
                SearchTrash(data.entity, 'trash_can')
            end,
            distance = 2.0,
        }
    })
    
    -- DUMPSTERS
    exports.ox_target:addModel(Config.Props.dumpster, {
        {
            name = 'search_dumpster',
            icon = 'fa-solid fa-dumpster',
            label = 'Search Dumpster',
            onSelect = function(data)
                SearchTrash(data.entity, 'dumpster')
            end,
            distance = 2.5,
        }
    })
    
    -- RECYCLING BINS
    exports.ox_target:addModel(Config.Props.recycling_bin, {
        {
            name = 'search_recycling',
            icon = 'fa-solid fa-recycle',
            label = 'Search Recycling Bin',
            onSelect = function(data)
                SearchTrash(data.entity, 'recycling_bin')
            end,
            distance = 2.0,
        }
    })
    
    DebugPrint('Ox_target setup complete!')
end)

-- ============================================
-- RECEIVE SEARCH RESULTS FROM SERVER
-- ============================================

RegisterNetEvent('trash_search:receiveResults', function(results, trashType)
    if not results or #results == 0 then
        Notify(Config.Notifications.found_nothing)
        return
    end
    
    -- Check for blueprints and show special notification
    for _, result in ipairs(results) do
        if result.item and string.match(result.item, 'blueprint_') then
            local itemData = exports.ox_inventory:Items()[result.item]
            local label = itemData and itemData.label or result.item
            
            Notify({
                title = Config.Notifications.found_blueprint.title,
                description = string.format(Config.Notifications.found_blueprint.description, label),
                type = Config.Notifications.found_blueprint.type,
                duration = Config.Notifications.found_blueprint.duration
            })
            return -- Show blueprint notification and exit
        end
    end
    
    -- If no blueprint, show generic found item notification
    Notify({
        title = 'Items Found',
        description = 'You found some items in the trash',
        type = 'success',
        duration = 3000
    })
end)

-- ============================================
-- BLIPS (Optional)
-- ============================================

if Config.ShowBlips then
    CreateThread(function()
        -- This would spawn blips at fixed locations if you want
        -- For now, we rely on ox_target instead
        DebugPrint('Trash blips disabled in config')
    end)
end

-- ============================================
-- CLEANUP ON RESOURCE STOP
-- ============================================

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Clean up ox_target
    exports.ox_target:removeModel(Config.Props.trash_can, 'search_trash_can')
    exports.ox_target:removeModel(Config.Props.dumpster, 'search_dumpster')
    exports.ox_target:removeModel(Config.Props.recycling_bin, 'search_recycling')
    
    DebugPrint('Cleaned up ox_target!')
end)
