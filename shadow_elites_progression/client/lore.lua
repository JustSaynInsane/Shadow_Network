-- ============================================
-- SHADOW LORE SYSTEM - CLIENT
-- Item usage, world spawns, and visual effects
-- Place in: shadow_elites_progression/client/lore.lua
-- ============================================

local activePickups = {}
local currentlyReading = false

-- ============================================
-- LORE FRAGMENT UNLOCKED NOTIFICATION
-- ============================================

RegisterNetEvent('shadow_tablet:client:loreUnlocked', function(data)
    -- Enhanced notification with visual flair
    lib.notify({
        title = '📜 Lore Fragment Discovered',
        description = data.title,
        type = 'success',
        duration = 8000,
        position = 'top',
        icon = 'file-text',
        iconColor = '#00ff88'
    })
    
    -- Play discovery sound
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    
    -- Visual effect
    CreateThread(function()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        -- Green particle effect
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do
            Wait(0)
        end
        
        UseParticleFxAssetNextCall("core")
        local particle = StartParticleFxLoopedAtCoord(
            "ent_dst_elec_crackle",
            coords.x, coords.y, coords.z + 1.0,
            0.0, 0.0, 0.0,
            0.5,
            false, false, false
        )
        
        Wait(2000)
        StopParticleFxLooped(particle, 0)
        RemoveNamedPtfxAsset("core")
    end)
end)

-- ============================================
-- USB DRIVE USAGE
-- ============================================

exports('useUSB', function(data, slot)
    if currentlyReading then
        lib.notify({
            description = 'Already reading a fragment',
            type = 'error'
        })
        return
    end
    
    currentlyReading = true
    
    -- Trigger tablet to open to lore tab
    local hasTablet = exports.ox_inventory:Search('count', 'shadow_tablet') > 0
    
    if hasTablet then
        -- Open tablet directly to lore tab
        TriggerEvent('shadow_tablet:client:use')
        
        -- After a delay, auto-select this fragment
        Wait(500)
        
        local usbNumber = tonumber(string.match(data.name, '%d+'))
        if usbNumber then
            SendNUIMessage({
                action = 'openLoreFragment',
                fragmentId = 'usb_' .. usbNumber
            })
        end
    else
        lib.notify({
            title = 'Encrypted USB Drive',
            description = 'You need a Shadow Tablet to decrypt this data',
            type = 'error',
            duration = 5000
        })
    end
    
    Wait(1000)
    currentlyReading = false
end)

-- ============================================
-- PHYSICAL NOTE USAGE
-- ============================================

exports('readNote', function(data, slot)
    if currentlyReading then
        lib.notify({
            description = 'Already reading something',
            type = 'error'
        })
        return
    end
    
    currentlyReading = true
    
    -- Get note data from server
    local noteType, noteId = string.match(data.name, 'shadow_note_(%a+)_(%d+)')
    noteId = tonumber(noteId)
    
    if not noteType or not noteId then
        currentlyReading = false
        return
    end
    
    lib.callback('shadow_lore:server:getNote', false, function(noteData)
        if not noteData then
            currentlyReading = false
            return
        end
        
        -- Display note in UI
        lib.alertDialog({
            header = noteData.title,
            content = noteData.content,
            centered = true,
            cancel = false,
            labels = {
                confirm = 'Close'
            }
        })
        
        currentlyReading = false
    end, noteType, noteId)
end)

-- ============================================
-- CLASSIFIED DOCUMENT USAGE
-- ============================================

exports('readDocument', function(data, slot)
    if currentlyReading then
        lib.notify({
            description = 'Already reading something',
            type = 'error'
        })
        return
    end
    
    currentlyReading = true
    
    local docId = tonumber(string.match(data.name, '%d+'))
    
    if not docId then
        currentlyReading = false
        return
    end
    
    lib.callback('shadow_lore:server:getDocument', false, function(docData)
        if not docData then
            currentlyReading = false
            return
        end
        
        -- Warning for high-risk documents
        if docData.risk_level == 'HIGH' or docData.risk_level == 'EXTREME' then
            lib.notify({
                title = '⚠️ WARNING',
                description = 'Reading classified government files. Police will be alerted!',
                type = 'warning',
                duration = 5000
            })
            
            -- Trigger wanted level
            Wait(2000)
            local stars = docData.risk_level == 'EXTREME' and 5 or 4
            TriggerServerEvent('police:server:SetCopCount', stars)
        end
        
        -- Display document
        lib.alertDialog({
            header = '🗂️ ' .. docData.title,
            content = docData.content,
            centered = true,
            cancel = false,
            labels = {
                confirm = 'Close'
            }
        })
        
        currentlyReading = false
    end, docId)
end)

-- ============================================
-- LEGENDARY ARTIFACT EXAMINATION
-- ============================================

exports('examineArtifact', function(data, slot)
    if currentlyReading then
        lib.notify({
            description = 'Already examining something',
            type = 'error'
        })
        return
    end
    
    currentlyReading = true
    
    local artifactId = tonumber(string.match(data.name, '%d+'))
    
    if not artifactId then
        currentlyReading = false
        return
    end
    
    lib.callback('shadow_lore:server:getArtifact', false, function(artifactData)
        if not artifactData then
            currentlyReading = false
            return
        end
        
        -- Enhanced visual for legendary artifacts
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        -- Golden particle effect
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do
            Wait(0)
        end
        
        UseParticleFxAssetNextCall("core")
        local particle = StartParticleFxLoopedAtCoord(
            "ent_dst_elec_fire_sp",
            coords.x, coords.y, coords.z + 1.0,
            0.0, 0.0, 0.0,
            1.0,
            false, false, false
        )
        
        -- Display artifact info
        local content = string.format(
            "%s\n\n%s\n\n💎 GAME EFFECT:\n%s",
            artifactData.description,
            artifactData.lore,
            artifactData.game_effect
        )
        
        lib.alertDialog({
            header = '💎 ' .. artifactData.name,
            content = content,
            centered = true,
            cancel = false,
            labels = {
                confirm = 'Close'
            }
        })
        
        Wait(2000)
        StopParticleFxLooped(particle, 0)
        RemoveNamedPtfxAsset("core")
        
        currentlyReading = false
    end, artifactId)
end)

-- ============================================
-- WORLD SPAWN PICKUPS
-- ============================================

-- Create lore pickup in world
function CreateLorePickup(coords, loreType, loreId, model)
    model = model or `prop_paper_bag_small`
    
    local pickup = CreateObject(model, coords.x, coords.y, coords.z - 1.0, true, false, false)
    FreezeEntityPosition(pickup, true)
    SetEntityAsMissionEntity(pickup, true, true)
    
    -- Add ox_target interaction
    exports.ox_target:addLocalEntity(pickup, {
        {
            name = 'collect_lore_' .. loreType .. '_' .. loreId,
            icon = 'fa-solid fa-file-text',
            label = 'Collect Document',
            distance = 2.0,
            onSelect = function()
                -- Trigger collection
                lib.callback('shadow_lore:server:collectFromWorld', false, function(success)
                    if success then
                        DeleteObject(pickup)
                        activePickups[loreType .. '_' .. loreId] = nil
                    else
                        lib.notify({
                            description = 'You already have this item',
                            type = 'error'
                        })
                    end
                end, loreType, loreId)
            end
        }
    })
    
    -- Store reference
    activePickups[loreType .. '_' .. loreId] = pickup
    
    return pickup
end

-- Spawn world notes (called from server or on player join)
RegisterNetEvent('shadow_lore:client:spawnWorldNotes', function(notes)
    for _, note in ipairs(notes) do
        CreateLorePickup(note.coords, note.type, note.id, note.model)
    end
end)

-- ============================================
-- CLEANUP
-- ============================================

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        -- Clean up all pickups
        for _, pickup in pairs(activePickups) do
            if DoesEntityExist(pickup) then
                DeleteObject(pickup)
            end
        end
        
        activePickups = {}
        currentlyReading = false
    end
end)

print('^2[Shadow Lore System] Client loaded successfully!^7')
