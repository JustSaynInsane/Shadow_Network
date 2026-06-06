-- ============================================
-- SHADOW ELITES - SHADOW NETWORK SYSTEM
-- Cryptic Messages & Heist Unlocks
-- ============================================

-- QBX doesn't use GetCoreObject, use exports directly
local ActiveNPCs = {} -- Track spawned Shadow NPCs

-- ============================================
-- SHADOW NETWORK MESSAGES
-- ============================================

lib.callback.register('shadow_elites:server:isCriminal', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    -- Check if cop
    local policeJobs = {'police', 'sheriff', 'state', 'doj', 'ambulance'}
    for _, job in ipairs(policeJobs) do
        if Player.PlayerData.job.name == job then
            return false  -- Cops can't be criminals!
        end
    end
    
    -- Check criminal progression
    local identifier = Player.PlayerData.citizenid
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then
        return false  -- No record = not a criminal
    end
    
    -- Must have at least Level 1 in any tree
    local totalLevel = (progression.organized_level or 0) + 
                       (progression.narcotics_level or 0) + 
                       (progression.auto_theft_level or 0)
    
    return totalLevel > 0
end)

lib.callback.register('shadow_elites:server:getProgression', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get from database
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then
        -- Create new record
        MySQL.insert([[
            INSERT INTO criminal_progression (identifier, organized_xp, organized_level)
            VALUES (?, ?, ?)
        ]], {identifier, 0, 0})
        
        return {
            organized_level = 0,
            organized_xp = 0,
            narcotics_level = 0,
            narcotics_xp = 0,
            auto_theft_level = 0,
            auto_theft_xp = 0,
        }
    end
    
    return progression
end)

local ShadowMessages = {
    level5_welcome = {
        sender = 'Unknown',
        subject = '...',
        message = [[You've caught our attention.

The streets whisper your name. You've proven yourself capable, but this is only the beginning.

True power lies in the shadows.

Check your phone. A new world awaits.

- S.N.]],
    },
    
    first_fleeca = {
        sender = 'Unknown',
        subject = 'Impressive',
        message = [[Clean work on that bank job.

You're learning. Keep this up and bigger opportunities will reveal themselves.

Watch for our signal.

- S.N.]],
    },
    
    jewelry_unlocked = {
        sender = 'Unknown',
        subject = 'An Opportunity',
        message = [[We've been watching your progress.

You've proven yourself on small jobs. Time to step up. There's a jewelry store downtown - high risk, high reward.

The plan will cost you, but the payoff... worth it.

Check the Shadow Network app.

- S.N.]],
    },
    
    jewelry_completed = {
        sender = 'Unknown',
        subject = 'Well Done',
        message = [[Exceptional work on Vangelico.

You handled the pressure. The police. The chaos. Very few make it out of there alive, let alone with the goods.

We need to meet. Face to face.

Come to the location marked on your map. Come alone. Or bring your crew. Your choice.

But come tonight.

- S.N.]],
        waypoint = vector3(-1454.32, -411.39, 35.91),
    },
    
    pacific_completed = {
        sender = 'S.N.',
        subject = 'Legend',
        message = [[You did it.

The Pacific Standard. The holy grail. Half the city is looking for you right now.

Lay low. Launder that money. Don't get cocky.

When things cool down... we'll talk about Humane Labs.

- S.N.]],
    },
    -- ADD AFTER the existing messages (around line 141)

    level3_organized = {
        sender = 'Unknown',
        subject = 'First Step',
        message = [[You're making progress.

The streets are noticing. Bank trucks carry serious cash - high risk, high reward.

Prove yourself with 2 successful hits. Then we'll talk about real banks.

- S.N.]],
    },
    
    bank_truck_completed = {
        sender = 'Unknown',
        subject = 'Capability Confirmed',
        message = [[Clean work on that armored transport.

You handled the heat. The guards. The escape. Not bad.

Complete one more truck job and you'll unlock access to the banks.

- S.N.]],
    },
    
    fleeca_unlocked = {
        sender = 'Unknown',
        subject = 'Banks Open',
        message = [[You've proven yourself with the trucks.

Time to step up. Fleeca banks and Paleto are now available to you.

Small banks, big opportunities. Don't get greedy.

- S.N.]],
    },
}

-- ============================================
-- CORRECTED SHADOW MESSAGE SENDING FOR NPWD 3.x
-- Inserts directly into database (no export needed)
-- ============================================

---@param source number Player source
---@param messageType string Type of message to send
local function sendShadowMessage(source, messageType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    local message = ShadowMessages[messageType]
    if not message then return end
    
    -- Get player phone number (QBX stores it in charinfo)
    local phoneNumber = Player.PlayerData.charinfo and Player.PlayerData.charinfo.phone
    
    -- Check if player has a phone number
    if not phoneNumber or phoneNumber == '' then
        if Config.Debug then
            print('^1[Shadow Elites] Player ' .. source .. ' has no phone number assigned!^7')
        end
        
        -- Send fallback notification
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Unknown Contact',
            description = 'Check your messages...',
            type = 'inform',
            duration = 10000,
        })
        
        if message.waypoint then
            TriggerClientEvent('shadow_elites:client:setWaypoint', source, message.waypoint)
        end
        return
    end
    
    -- Get player identifier for NPWD
    local identifier = Player.PlayerData.citizenid
    
    -- NPWD 3.x: Insert directly into database
    local success, err = pcall(function()
        -- Step 1: Create or get conversation
        local conversationList = json.encode({phoneNumber, 'UNKNOWN'})
        
        -- Check if conversation exists
        local conversation = MySQL.single.await([[
            SELECT id FROM npwd_messages_conversations 
            WHERE conversation_list = ? 
            LIMIT 1
        ]], {conversationList})
        
        local conversationId
        if not conversation then
            -- Create new conversation
            conversationId = MySQL.insert.await([[
                INSERT INTO npwd_messages_conversations (conversation_list, label, is_group_chat)
                VALUES (?, '', 0)
            ]], {conversationList})
            
            -- Add participant
            MySQL.insert.await([[
                INSERT INTO npwd_messages_participants (conversation_id, participant, unread_count)
                VALUES (?, ?, 1)
            ]], {conversationId, identifier})
        else
            conversationId = conversation.id
            
            -- Increment unread count
            MySQL.update.await([[
                UPDATE npwd_messages_participants 
                SET unread_count = unread_count + 1 
                WHERE conversation_id = ? AND participant = ?
            ]], {conversationId, identifier})
        end
        
        -- Step 2: Insert message
        local messageId = MySQL.insert.await([[
            INSERT INTO npwd_messages (message, user_identifier, conversation_id, isRead, author, visible)
            VALUES (?, ?, ?, 0, 'UNKNOWN', 1)
        ]], {message.message, identifier, conversationId})
        
        -- Step 3: Update last message in conversation
        MySQL.update.await([[
            UPDATE npwd_messages_conversations 
            SET last_message_id = ?, updatedAt = NOW() 
            WHERE id = ?
        ]], {messageId, conversationId})
        
        if Config.Debug then
            print(string.format('^2[Shadow Elites]^7 Sent Shadow message to %s (conversation: %d, message: %d)', 
                identifier, conversationId, messageId))
        end
    end)
    
    if not success then
        if Config.Debug then
            print('^1[Shadow Elites] Failed to send NPWD message: ' .. tostring(err) .. '^7')
        end
        
        -- Fallback to notification
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Unknown Number',
            description = 'You received a mysterious message...',
            type = 'inform',
            duration = 7000,
        })
    else
        -- Success notification
        if Config.Notifications and Config.Notifications.showShadowMessages then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Unknown Number',
                description = 'Check your phone for a new message',
                type = 'inform',
                duration = 5000,
            })
        end
        
        -- Trigger NPWD notification
        TriggerClientEvent('phone:notification', source, {
            appId = 'MESSAGES',
            content = 'New message from Unknown',
        })
    end
    
    -- Set waypoint if message has one
    if message.waypoint then
        TriggerClientEvent('shadow_elites:client:setWaypoint', source, message.waypoint)
    end
end

-- Replace the RegisterNetEvent handler in shadow_network.lua with this:
RegisterNetEvent('shadow_elites:server:sendShadowMessage', function(messageType)
    sendShadowMessage(source, messageType)
end)

-- ============================================
-- ADMIN: SEND CUSTOM SHADOW MESSAGE
-- ============================================

lib.addCommand('shadowcustom', {
    help = 'Send custom Shadow Network message',
    params = {
        { name = 'id', type = 'playerId', help = 'Player ID' },
        { name = 'subject', type = 'string', help = 'Message subject' },
        { name = 'message', type = 'string', help = 'Message content' },
    },
    restricted = 'group.admin'
}, function(source, args)
    local Player = exports.qbx_core:GetPlayer(args.id)
    if not Player then 
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Player not found',
            type = 'error'
        })
    end
    
    -- Get player phone number
    local phoneNumber = Player.PlayerData.charinfo and Player.PlayerData.charinfo.phone
    
    if not phoneNumber or phoneNumber == '' then
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Player has no phone number assigned',
            type = 'error'
        })
    end
    
    -- Try to send message
    local success, err = pcall(function()
        exports.npwd:sendMessage({
            source = source,  -- Player who receives it
            number = 'UNKNOWN',
            message = message.message,
        })
    end)
    
    if success then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Custom Shadow message sent',
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Failed to send message: NPWD error',
            type = 'error'
        })
        
        if Config.Debug then
            print('^1[Shadow Elites] NPWD error: ' .. tostring(err) .. '^7')
        end
    end
end)

-- ============================================
-- SPAWN SHADOW NPC
-- ============================================

RegisterNetEvent('shadow_elites:server:spawnNPC', function(locationType)
    local src = source  -- source is implicit in RegisterNetEvent
    
    local location = Config.ShadowNetwork.meetingLocations[locationType]
    if not location then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = 'Invalid meeting location',
            type = 'error'
        })
    end
    
    -- Spawn NPC for all clients
    TriggerClientEvent('shadow_elites:client:spawnNPC', -1, locationType, location)
    
    -- Track NPC
    ActiveNPCs[locationType] = {
        coords = location.coords,
        heading = location.heading,
        scenario = location.scenario,
    }
end)

lib.addCommand('spawnshadownpc', {
    help = 'Spawn Shadow Network NPC',
    params = {
        { name = 'location', type = 'string', help = 'Location type (jewelry_unlocked/pacific_unlocked)' },
    },
    restricted = 'group.admin'
}, function(source, args)
    local location = Config.ShadowNetwork.meetingLocations[args.location]
    if not location then
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Invalid location! Use: jewelry_unlocked or pacific_unlocked',
            type = 'error'
        })
    end
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 Spawning NPC at: %.2f, %.2f, %.2f', 
            location.coords.x, location.coords.y, location.coords.z))
    end
    
    -- Spawn the NPC
    TriggerEvent('shadow_elites:server:spawnNPC', args.location)
    
    -- Set GPS waypoint for the admin
    TriggerClientEvent('shadow_elites:client:setWaypoint', source, location.coords)
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 Sent waypoint to player %d: %.2f, %.2f', 
            source, location.coords.x, location.coords.y))
    end
    
    -- Send notification with location info
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Shadow NPC Spawned',
        description = string.format('Location: %s\nGPS: %.0f, %.0f\nCheck your map!', 
            location.label, location.coords.x, location.coords.y),
        type = 'success',
        duration = 7000
    })
end)

-- ============================================
-- ADMIN: TELEPORT TO SHADOW NPC
-- ============================================

lib.addCommand('gotoshadownpc', {
    help = 'Teleport to Shadow NPC location',
    params = {
        { name = 'location', type = 'string', help = 'Location type (jewelry_unlocked/pacific_unlocked)' },
    },
    restricted = 'group.admin'
}, function(source, args)
    local location = Config.ShadowNetwork.meetingLocations[args.location]
    if not location then
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Invalid location! Use: jewelry_unlocked or pacific_unlocked',
            type = 'error'
        })
    end
    
    -- Teleport admin to NPC location
    TriggerClientEvent('shadow_elites:client:teleportToNPC', source, location.coords)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Teleported',
        description = 'Sent to ' .. location.label,
        type = 'success'
    })
end)

-- ============================================
-- UNLOCK SHADOW HEIST
-- ============================================

RegisterNetEvent('shadow_elites:server:unlockShadowHeist', function(source, heistType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    local unlockField = 'shadow_unlocked_' .. heistType
    Player.Functions.SetMetaData(unlockField, true)
    
    -- Update database
    MySQL.update(string.format([[
        UPDATE criminal_progression 
        SET %s = TRUE
        WHERE identifier = ?
    ]], unlockField), {Player.PlayerData.citizenid})
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Shadow Network',
        description = string.format('%s heist unlocked', heistType:gsub('_', ' ')),
        type = 'success',
        duration = 7000,
    })
end)

lib.addCommand('unlockshadowheist', {
    help = 'Unlock Shadow heist for player',
    params = {
        { name = 'id', type = 'playerId', help = 'Player ID' },
        { name = 'heist', type = 'string', help = 'Heist type' },
    },
    restricted = 'group.admin'
}, function(source, args)
    TriggerEvent('shadow_elites:server:unlockShadowHeist', args.id, args.heist)
    TriggerClientEvent('ox_lib:notify', source, {
        description = 'Shadow heist unlocked',
        type = 'success'
    })
end)

-- ============================================
-- MEETING LOCATION REACHED
-- ============================================

-- Shadow meeting system (for jewelry plans)
lib.callback.register('shadow_elites:server:meetShadow', function(source, meetingType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false, message = 'Player not found'} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Define rewards
    local meetingRewards = {
        jewelry_unlock = {
            item = 'jewelry_heist_plan',
            amount = 1,
            message = 'The Shadow hands you detailed plans for Vangelico Jewelry Store.',
            metaField = 'shadow_met_jewelry',
            unlockField = 'shadow_unlocked_jewelry',
        },
        pacific_unlock = {
            item = 'pacific_heist_plan',
            amount = 1,
            message = 'The Shadow reveals classified plans for Pacific Standard Bank.',
            metaField = 'shadow_met_pacific',
            unlockField = 'shadow_unlocked_pacific',
        },
    }
    
    local reward = meetingRewards[meetingType]
    if not reward then
        return {success = false, message = 'Invalid meeting type'}
    end
    
    -- Check progression
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then
        return {success = false, message = 'Progression data not found'}
    end
    
    -- Check if already met
    if progression[reward.metaField] and progression[reward.metaField] == 1 then
        return {success = false, message = 'You\'ve already received these plans from Shadow.'}
    end
    
    -- Check if unlocked
    if not progression[reward.unlockField] or progression[reward.unlockField] == 0 then
        return {success = false, message = 'Shadow has nothing for you right now. Prove yourself first.'}
    end
    
    -- Give item
    local added = exports.ox_inventory:AddItem(source, reward.item, reward.amount)
    
    if not added then
        return {success = false, message = 'Your inventory is full. Make space and try again.'}
    end
    
    -- Mark as met
    MySQL.query.await(string.format([[
        UPDATE criminal_progression 
        SET %s = 1 
        WHERE identifier = ?
    ]], reward.metaField), {identifier})
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s met Shadow: %s', 
            Player.PlayerData.charinfo.firstname, reward.item))
    end
    
    return {success = true, message = reward.message, item = reward.item}
end)

-- Heist completion tracking
local activeHeists = {}

exports('CompleteHeist', function(source, heistType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    local identifier = Player.PlayerData.citizenid
    local crewId = MySQL.scalar.await('SELECT crew_id FROM criminal_crew_members WHERE identifier = ?', {identifier})
    
    if not crewId then return false end
    
    local activation = MySQL.single.await([[
        SELECT id FROM criminal_heist_activations 
        WHERE crew_id = ? AND heist_type = ? AND started = 1 AND completed = 0
    ]], {crewId, heistType})
    
    if not activation then return false end
    
    -- Track for 5-minute window
    activeHeists[source] = {
        heist_type = heistType,
        crew_id = crewId,
        activation_id = activation.id,
        identifier = identifier,
        completion_time = os.time(),
    }
    
    if Config.Debug then
        print(string.format('^3[Shadow Elites]^7 %s completed %s - 5min escape window', 
            Player.PlayerData.charinfo.firstname, heistType))
    end
    
    -- 5-minute timer
    SetTimeout(300000, function()
        CheckHeistEscape(source, heistType)
    end)
    
    return true
end)

function CheckHeistEscape(source, heistType)
    local heistData = activeHeists[source]
    if not heistData then return end
    
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then
        activeHeists[source] = nil
        return
    end
    
    local isJailed = Player.PlayerData.metadata.injail or false
    
    if isJailed then
        -- CAUGHT!
        MySQL.query.await([[
            UPDATE criminal_heist_activations 
            SET completed = 1, successful = 0 
            WHERE id = ?
        ]], {heistData.activation_id})
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Heist Failed',
            description = 'You got caught! This heist doesn\'t count toward progression.',
            type = 'error',
            duration = 10000
        })
        
        activeHeists[source] = nil
        return
    end
    
    -- SUCCESS!
    MySQL.query.await([[
        UPDATE criminal_heist_activations 
        SET completed = 1, successful = 1 
        WHERE id = ?
    ]], {heistData.activation_id})
    
    local completionField = heistType .. '_successful'
    MySQL.query.await(string.format([[
        UPDATE criminal_progression 
        SET %s = %s + 1 
        WHERE identifier = ?
    ]], completionField, completionField), {heistData.identifier})
    
    MySQL.query.await([[
        UPDATE criminal_crews 
        SET total_heists = total_heists + 1, last_heist = NOW() 
        WHERE id = ?
    ]], {heistData.crew_id})
    
    CheckShadowUnlocks(source, heistType)
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s ESCAPED! Heist counts!', 
            Player.PlayerData.charinfo.firstname))
    end
    
    activeHeists[source] = nil
end

function CheckShadowUnlocks(source, heistType)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    local identifier = Player.PlayerData.citizenid
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then return end
    
    -- After first bank truck
    if heistType == 'bank_truck' then
        local truckCount = progression.bank_truck_successful or 0
        
        if truckCount == 1 then
            -- Send message after first truck
            SetTimeout(30000, function()
                TriggerEvent('shadow_elites:server:sendShadowMessage', source, 'bank_truck_completed')
            end)
            
            if Config.Debug then
                print(string.format('^2[Shadow Elites]^7 %s completed first bank truck! (1/2)', 
                    Player.PlayerData.charinfo.firstname))
            end
        elseif truckCount >= 2 and (not progression.fleeca_unlocked or progression.fleeca_unlocked == 0) then
            -- Unlock Fleeca/Paleto after 2 trucks
            MySQL.query.await([[
                UPDATE criminal_progression 
                SET fleeca_unlocked = 1, paleto_unlocked = 1
                WHERE identifier = ?
            ]], {identifier})
            
            SetTimeout(30000, function()
                TriggerEvent('shadow_elites:server:sendShadowMessage', source, 'fleeca_unlocked')
            end)
            
            if Config.Debug then
                print(string.format('^2[Shadow Elites]^7 %s unlocked Fleeca/Paleto! (2 trucks complete)', 
                    Player.PlayerData.charinfo.firstname))
            end
        end
    end
    
    -- After 3 successful Fleecas → Unlock Jewelry
    if heistType == 'fleeca_bank' then
        local fleecaCount = progression.fleeca_bank_successful or 0
        
        if fleecaCount >= 3 and (not progression.shadow_unlocked_jewelry or progression.shadow_unlocked_jewelry == 0) then
            MySQL.query.await([[
                UPDATE criminal_progression 
                SET shadow_unlocked_jewelry = 1 
                WHERE identifier = ?
            ]], {identifier})
            
            SetTimeout(30000, function()
                TriggerEvent('shadow_elites:server:sendShadowMessage', source, 'jewelry_unlocked')
            end)
            
            if Config.Debug then
                print(string.format('^2[Shadow Elites]^7 %s unlocked Jewelry! (3 Fleecas)', 
                    Player.PlayerData.charinfo.firstname))
            end
        end
    end
    
    -- After successful Jewelry → Unlock Pacific
    if heistType == 'jewelry_store' then
        if not progression.shadow_unlocked_pacific or progression.shadow_unlocked_pacific == 0 then
            MySQL.query.await([[
                UPDATE criminal_progression 
                SET shadow_unlocked_pacific = 1 
                WHERE identifier = ?
            ]], {identifier})
            
            SetTimeout(30000, function()
                TriggerEvent('shadow_elites:server:sendShadowMessage', source, 'jewelry_completed')
            end)
            
            if Config.Debug then
                print(string.format('^2[Shadow Elites]^7 %s unlocked Pacific! (Jewelry done)', 
                    Player.PlayerData.charinfo.firstname))
            end
        end
    end
    
    -- After successful Pacific
    if heistType == 'pacific_standard' then
        SetTimeout(30000, function()
            TriggerEvent('shadow_elites:server:sendShadowMessage', source, 'pacific_completed')
        end)
        
        if Config.Debug then
            print(string.format('^2[Shadow Elites]^7 %s completed Pacific Standard!', 
                Player.PlayerData.charinfo.firstname))
        end
    end
end

-- Jail detection
RegisterNetEvent('qbx_core:server:setMetaData', function(meta, value)
    if meta ~= 'injail' then return end
    
    local src = source
    local heistData = activeHeists[src]
    
    if heistData and value == true then
        MySQL.query.await([[
            UPDATE criminal_heist_activations 
            SET completed = 1, successful = 0 
            WHERE id = ?
        ]], {heistData.activation_id})
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Caught!',
            description = 'Busted! This heist doesn\'t count.',
            type = 'error',
            duration = 10000
        })
        
        activeHeists[src] = nil
    end
end)

-- Cleanup
AddEventHandler('playerDropped', function()
    if activeHeists[source] then
        activeHeists[source] = nil
    end
end)

-- ============================================
-- NPWD APP CALLBACKS (Different from command system)
-- ============================================

-- Get progression for NPWD app (nested format)
lib.callback.register('shadow_network:server:getProgression', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get from database
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then
        -- Return default structure (nested for React)
        return {
            narcotics = { level = 0, xp = 0 },
            organized = { level = 0, xp = 0 },
            auto_theft = { level = 0, xp = 0 }
        }
    end
    
    -- Convert flat DB format to nested format for React
    return {
        narcotics = {
            level = progression.narcotics_level or 0,
            xp = progression.narcotics_xp or 0
        },
        organized = {
            level = progression.organized_level or 0,
            xp = progression.organized_xp or 0
        },
        auto_theft = {
            level = progression.auto_theft_level or 0,
            xp = progression.auto_theft_xp or 0
        }
    }
end)

-- Get player stats for NPWD app
lib.callback.register('shadow_network:server:getStats', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil end
    
    local identifier = Player.PlayerData.citizenid
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then
        return {
            name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            totalLevels = 0,
            totalSkillPoints = 0,
            totalHeists = 0
        }
    end
    
    local totalLevels = (progression.narcotics_level or 0) + 
                       (progression.organized_level or 0) + 
                       (progression.auto_theft_level or 0)
    
    local totalSkillPoints = (progression.narcotics_skill_points or 0) + 
                            (progression.organized_skill_points or 0) + 
                            (progression.auto_theft_skill_points or 0)
    
    return {
        name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        totalLevels = totalLevels,
        totalSkillPoints = totalSkillPoints,
        totalHeists = progression.total_heists_completed or 0
    }
end)

-- Get Shadow contacts for NPWD app
lib.callback.register('shadow_network:server:getContacts', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {} end
    
    local identifier = Player.PlayerData.citizenid
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then return {} end
    
    local contacts = {}
    
    -- Shadow - Boosting (Auto Theft Level 5)
    if (progression.auto_theft_level or 0) >= 5 then
        table.insert(contacts, {
            id = 'shadow_boosting',
            name = 'Shadow - Boosting',
            phone = '555-0101',
            color = '#9b59b6',
            unlocked = true
        })
    end
    
    -- Shadow - Operations (Organized Crime Level 5)
    if (progression.organized_level or 0) >= 5 then
        table.insert(contacts, {
            id = 'shadow_operations',
            name = 'Shadow - Operations',
            phone = '555-0102',
            color = '#e74c3c',
            unlocked = true
        })
    end
    
    -- Shadow - Distribution (Narcotics Level 5)
    if (progression.narcotics_level or 0) >= 5 then
        table.insert(contacts, {
            id = 'shadow_distribution',
            name = 'Shadow - Distribution',
            phone = '555-0103',
            color = '#2ecc71',
            unlocked = true
        })
    end
    
    return contacts
end)

-- Get messages for NPWD app (if you created the messages table)
lib.callback.register('shadow_network:server:getMessages', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Check if messages table exists
    local hasTable = MySQL.scalar.await([[
        SELECT COUNT(*) FROM information_schema.tables 
        WHERE table_schema = DATABASE() AND table_name = 'shadow_network_messages'
    ]])
    
    if hasTable == 0 then
        return {} -- Table doesn't exist yet
    end
    
    -- Get messages from database
    local messages = MySQL.query.await([[
        SELECT * FROM shadow_network_messages 
        WHERE identifier = ? 
        ORDER BY timestamp DESC 
        LIMIT 50
    ]], {identifier})
    
    if not messages then return {} end
    
    -- Format for React app
    local formattedMessages = {}
    for _, msg in ipairs(messages) do
        table.insert(formattedMessages, {
            id = msg.id,
            contact = msg.contact_id,
            message = msg.message,
            timestamp = msg.timestamp,
            read = msg.read == 1
        })
    end
    
    return formattedMessages
end)

-- Check app access for NPWD app
lib.callback.register('shadow_network:server:checkAccess', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    -- Check if cop
    local policeJobs = {'police', 'sheriff', 'state', 'doj', 'ambulance'}
    for _, job in ipairs(policeJobs) do
        if Player.PlayerData.job.name == job then
            return false
        end
    end
    
    -- Check criminal progression
    local identifier = Player.PlayerData.citizenid
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then
        return false
    end
    
    -- Must have at least Level 1 in any tree
    local totalLevel = (progression.organized_level or 0) + 
                       (progression.narcotics_level or 0) + 
                       (progression.auto_theft_level or 0)
    
    return totalLevel > 0
end)

-- Get available heists for NPWD app
lib.callback.register('shadow_network:server:getAvailableHeists', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {} end
    
    local identifier = Player.PlayerData.citizenid
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then return {} end
    
    local heists = {}
    
    -- Fleeca Banks (Level 3+)
    if (progression.organized_level or 0) >= 3 then
        table.insert(heists, {
            id = 'fleeca',
            name = 'Fleeca Bank',
            icon = '🏦',
            requiredLevel = 3,
            unlocked = true,
            completed = progression.fleeca_bank_successful or 0
        })
    end
    
    -- Jewelry Store (Shadow unlocked)
    if progression.shadow_unlocked_jewelry == 1 then
        table.insert(heists, {
            id = 'jewelry',
            name = 'Vangelico Jewelry',
            icon = '💎',
            requiredLevel = 5,
            unlocked = true,
            completed = progression.jewelry_store_successful or 0
        })
    end
    
    -- Pacific Standard (Shadow unlocked)
    if progression.shadow_unlocked_pacific == 1 then
        table.insert(heists, {
            id = 'pacific',
            name = 'Pacific Standard',
            icon = '🏛️',
            requiredLevel = 8,
            unlocked = true,
            completed = progression.pacific_bank_successful or 0
        })
    end
    
    return heists
end)

-- Start heist from NPWD app
lib.callback.register('shadow_network:server:startHeist', function(source, heistId)
    -- This would trigger your heist activation system
    -- For now, just return success
    return true, 'Heist activated! Check your GPS.'
end)

-- Get crew info for NPWD app
lib.callback.register('shadow_network:server:getCrewInfo', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get crew info
    local crewMember = MySQL.single.await([[
        SELECT c.*, cm.role 
        FROM criminal_crews c
        JOIN criminal_crew_members cm ON c.id = cm.crew_id
        WHERE cm.identifier = ?
    ]], {identifier})
    
    if not crewMember then
        return nil
    end
    
    -- Get members
    local members = MySQL.query.await([[
        SELECT cm.identifier, cm.role, cm.joined_at
        FROM criminal_crew_members cm
        WHERE cm.crew_id = ?
    ]], {crewMember.id})
    
    return {
        id = crewMember.id,
        name = crewMember.name,
        role = crewMember.role,
        members = members or {},
        level = crewMember.level or 1,
        totalHeists = crewMember.total_heists or 0
    }
end)

-- Request boosting contract for NPWD app
lib.callback.register('shadow_network:server:requestBoost', function(source)
    -- Trigger boosting system
    TriggerEvent('shadow_boosting:server:requestContract', source)
    return true, 'Contract requested'
end)

-- Get active boosting contract for NPWD app
lib.callback.register('shadow_network:server:getActiveContract', function(source)
    -- Get from boosting system
    local success, contract = pcall(function()
        return exports.shadow_elites_boosting:GetActiveContract(source)
    end)
    
    if success and contract then
        return contract
    end
    
    return nil
end)

-- TEST COMMAND - Add at bottom of file
lib.addCommand('testprogression', {
    help = 'Test shadow network progression callback',
    restricted = 'group.admin'
}, function(source, args)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then
        print('^1[TEST] Player not found^7')
        return
    end
    
    local identifier = Player.PlayerData.citizenid
    print('^3[TEST] Testing progression for: ' .. identifier .. '^7')
    
    -- Get from database
    local progression = MySQL.single.await('SELECT * FROM criminal_progression WHERE identifier = ?', {identifier})
    
    if not progression then
        print('^1[TEST] No progression record found!^7')
        
        -- Try to create one
        MySQL.insert('INSERT INTO criminal_progression (identifier, organized_xp, organized_level) VALUES (?, ?, ?)', 
            {identifier, 0, 0})
        
        print('^2[TEST] Created new record^7')
    else
        print('^2[TEST] Found progression:^7')
        print('  Organized Level: ' .. (progression.organized_level or 0))
        print('  Organized XP: ' .. (progression.organized_xp or 0))
        print('  Narcotics Level: ' .. (progression.narcotics_level or 0))
        print('  Auto Theft Level: ' .. (progression.auto_theft_level or 0))
    end
    
    -- Test the callback directly
    local result = {
        narcotics = {
            level = progression and progression.narcotics_level or 0,
            xp = progression and progression.narcotics_xp or 0
        },
        organized = {
            level = progression and progression.organized_level or 0,
            xp = progression and progression.organized_xp or 0
        },
        auto_theft = {
            level = progression and progression.auto_theft_level or 0,
            xp = progression and progression.auto_theft_xp or 0
        }
    }
    
    print('^2[TEST] Callback would return:^7')
    print(json.encode(result, {indent = true}))
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Test Complete',
        description = 'Check server console for results',
        type = 'success'
    })
end)

-- ============================================
-- CORRECTED /shadowcustom COMMAND FOR NPWD 3.x
-- Replace the existing command in shadow_network.lua
-- ============================================

lib.addCommand('shadowcustom', {
    help = 'Send custom Shadow Network message',
    params = {
        { name = 'id', type = 'playerId', help = 'Player ID' },
        { name = 'subject', type = 'string', help = 'Message subject (unused but required)' },
        { name = 'message', type = 'string', help = 'Message content' },
    },
    restricted = 'group.admin'
}, function(source, args)
    local Player = exports.qbx_core:GetPlayer(args.id)
    if not Player then 
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Player not found',
            type = 'error'
        })
    end
    
    -- Get player phone number
    local phoneNumber = Player.PlayerData.charinfo and Player.PlayerData.charinfo.phone
    
    if not phoneNumber or phoneNumber == '' then
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Player has no phone number assigned',
            type = 'error'
        })
    end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Insert into NPWD database (3.x method)
    local success, err = pcall(function()
        -- Create or get conversation
        local conversationList = json.encode({phoneNumber, 'UNKNOWN'})
        
        local conversation = MySQL.single.await([[
            SELECT id FROM npwd_messages_conversations 
            WHERE conversation_list = ? 
            LIMIT 1
        ]], {conversationList})
        
        local conversationId
        if not conversation then
            conversationId = MySQL.insert.await([[
                INSERT INTO npwd_messages_conversations (conversation_list, label, is_group_chat)
                VALUES (?, '', 0)
            ]], {conversationList})
            
            MySQL.insert.await([[
                INSERT INTO npwd_messages_participants (conversation_id, participant, unread_count)
                VALUES (?, ?, 1)
            ]], {conversationId, identifier})
        else
            conversationId = conversation.id
            
            MySQL.update.await([[
                UPDATE npwd_messages_participants 
                SET unread_count = unread_count + 1 
                WHERE conversation_id = ? AND participant = ?
            ]], {conversationId, identifier})
        end
        
        -- Insert message
        local messageId = MySQL.insert.await([[
            INSERT INTO npwd_messages (message, user_identifier, conversation_id, isRead, author, visible)
            VALUES (?, ?, ?, 0, 'UNKNOWN', 1)
        ]], {args.message, identifier, conversationId})
        
        -- Update last message
        MySQL.update.await([[
            UPDATE npwd_messages_conversations 
            SET last_message_id = ?, updatedAt = NOW() 
            WHERE id = ?
        ]], {messageId, conversationId})
        
        if Config.Debug then
            print(string.format('^2[Shadow Elites]^7 Custom message sent to %s', identifier))
        end
    end)
    
    if success then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Custom Shadow message sent successfully',
            type = 'success'
        })
        
        TriggerClientEvent('ox_lib:notify', args.id, {
            title = 'Unknown Number',
            description = 'Check your phone for a new message',
            type = 'inform',
            duration = 5000
        })
        
        -- Trigger NPWD notification
        TriggerClientEvent('phone:notification', args.id, {
            appId = 'MESSAGES',
            content = 'New message from Unknown',
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Failed to send message: Database error',
            type = 'error'
        })
        
        if Config.Debug then
            print('^1[Shadow Elites] Database error: ' .. tostring(err) .. '^7')
        end
    end
end)

lib.addCommand('testphone', {
    help = 'Test if player has phone number assigned',
    params = {
        { name = 'id', type = 'playerId', help = 'Player ID (optional, defaults to self)', optional = true },
    },
    restricted = 'group.admin'
}, function(source, args)
    local targetId = args.id or source
    local Player = exports.qbx_core:GetPlayer(targetId)
    
    if not Player then
        return TriggerClientEvent('ox_lib:notify', source, {
            description = 'Player not found',
            type = 'error'
        })
    end
    
    local phoneNumber = Player.PlayerData.charinfo and Player.PlayerData.charinfo.phone
    local hasPhone = phoneNumber and phoneNumber ~= ''
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Phone Number Check',
        description = hasPhone and 
            string.format('Player has phone: %s', phoneNumber) or
            'Player has NO phone number assigned!',
        type = hasPhone and 'success' or 'error',
        duration = 7000
    })
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 Player %d phone: %s', 
            targetId, 
            hasPhone and phoneNumber or 'NONE'
        ))
    end
end)