-- ============================================
-- SHADOW ELITES - NPC CONTROL (CLIENT)
-- Spawn and manage Shadow Network NPCs
-- ============================================

local ActiveNPCs = {} -- Track spawned NPCs

-- ============================================
-- SPAWN SHADOW NPC
-- ============================================

RegisterNetEvent('shadow_elites:client:spawnNPC', function(locationType, location)
    -- Check if NPC already exists at this location
    if ActiveNPCs[locationType] then
        if DoesEntityExist(ActiveNPCs[locationType].npc) then
            DeleteEntity(ActiveNPCs[locationType].npc)
        end
        ActiveNPCs[locationType] = nil
    end
    
    -- Create Shadow NPC with custom outfit and glowing green mask
    local npc, particle = exports['shadow_elites_progression']:CreateShadowNPC(
        location.coords, 
        location.heading
    )
    
    -- Set scenario
    if location.scenario then
        TaskStartScenarioInPlace(npc, location.scenario, 0, true)
    end
    
    -- Store NPC and particle effect
    ActiveNPCs[locationType] = {
        npc = npc,
        particle = particle
    }
    
    -- Create interaction point
    exports.ox_target:addLocalEntity(npc, {
        {
            name = 'shadow_npc_' .. locationType,
            label = 'Speak with Contact',
            icon = 'fas fa-user-secret',
            distance = 2.5,
            onSelect = function()
                InteractWithShadowNPC(locationType)
            end
        }
    })
    
    if Config.Debug then
        print('^2[Shadow Elites]^7 Spawned Shadow NPC at ' .. locationType)
    end
end)

-- ============================================
-- INTERACT WITH SHADOW NPC
-- ============================================

function InteractWithShadowNPC(locationType)
    local dialogues = {
        jewelry_unlocked = {
            title = 'Mysterious Contact',
            description = [[The shadowy figure speaks in a low voice...

"You've proven yourself. Three banks. Clean getaways. Not many crews can say that.

Time to step up.

There's a jewelry store job - Vangelico. High risk, high reward.

I have the plans right here. Every guard rotation. Every camera blind spot. Everything you need.

Take them. When you're ready, start the heist and don't get caught."

*He slides a folder across the table then he takes a drag from his cigarette and fades into the shadows*]],
            options = {
                {
                    title = 'Accept Plans',
                    icon = 'file-contract',
                    onSelect = function()
                        -- Get jewelry heist plans from Shadow
                        local result = lib.callback.await('shadow_elites:server:meetShadow', false, 'jewelry_unlock')
                        
                        if result and result.success then
                            lib.notify({
                                title = 'Shadow Network',
                                description = result.message,
                                type = 'success',
                                duration = 10000
                            })
                        else
                            lib.notify({
                                title = 'Shadow Network',
                                description = result and result.message or 'Something went wrong',
                                type = 'error',
                                duration = 7000
                            })
                        end
                    end
                },
                {
                    title = 'Leave',
                    icon = 'circle-xmark',
                }
            }
        },
        
        pacific_unlocked = {
            title = 'Shadow Network Contact',
            description = [[The well-dressed man looks you over carefully...

"So... you're the ones who hit Vangelico. Not bad. Most crews panic when the glass breaks. You kept your heads. That's rare.

I have a proposition for you.

The Pacific Standard Bank. Downtown. You know the one. Biggest vault in the city. Millions in cash, safety deposit boxes, the works.

These plans? They costed me years to obtain. Security layouts. Vault timers. Guard schedules. Everything.

But if you pull it off? You'll be legends.

Think it over. When you're ready, check the app.

Oh, and one more thing...

Don't fuck this up. The heat on a job like that? It'll make Vangelico look like a parking ticket.

Good luck."]],
            options = {
                {
                    title = 'Accept Plans',
                    icon = 'file-contract',
                    onSelect = function()
                        -- Get Pacific heist plans from Shadow
                        local result = lib.callback.await('shadow_elites:server:meetShadow', false, 'pacific_unlock')
                        
                        if result and result.success then
                            lib.notify({
                                title = 'Shadow Network',
                                description = result.message,
                                type = 'success',
                                duration = 10000
                            })
                        else
                            lib.notify({
                                title = 'Shadow Network',
                                description = result and result.message or 'Something went wrong',
                                type = 'error',
                                duration = 7000
                            })
                        end
                    end
                },
                {
                    title = 'Leave',
                    icon = 'circle-xmark',
                }
            }
        },
    }
    
    local dialogue = dialogues[locationType]
    if dialogue then
        lib.registerContext({
            id = 'shadow_npc_dialogue',
            title = dialogue.title,
            options = dialogue.options,
        })
        
        -- Show description first as alert
        lib.alertDialog({
            header = dialogue.title,
            content = dialogue.description,
            centered = true,
            cancel = true,
        })
        
        -- Then show options
        Wait(100)
        lib.showContext('shadow_npc_dialogue')
    end
end

-- ============================================
-- CLIENT EVENT: Set GPS Waypoint (already have this in your shadow_network.lua)
-- ============================================

RegisterNetEvent('shadow_elites:client:setWaypoint', function(coords)
    SetNewWaypoint(coords.x, coords.y)
    
    lib.notify({
        title = 'GPS Updated',
        description = 'Meeting location marked on your GPS',
        type = 'inform',
        duration = 7000
    })
end)

-- ============================================
-- ADMIN: REMOVE NPC
-- ============================================

RegisterCommand('removeshadownpc', function()
    for location, data in pairs(ActiveNPCs) do
        if DoesEntityExist(data.npc) then
            if data.particle then
                StopParticleFxLooped(data.particle, false)
            end
            DeleteEntity(data.npc)
        end
        ActiveNPCs[location] = nil
    end
    
    lib.notify({
        description = 'All Shadow NPCs removed',
        type = 'success'
    })
end, false)

-- ============================================
-- CLEANUP ON RESOURCE STOP
-- ============================================

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for location, data in pairs(ActiveNPCs) do
            if DoesEntityExist(data.npc) then
                if data.particle then
                    StopParticleFxLooped(data.particle, false)
                end
                DeleteEntity(data.npc)
            end
        end
    end
end)