-- ============================================
-- SHADOW LORE SYSTEM - SERVER (CORRECTED)
-- Compatible with Config.LoreFragments structure
-- GTA 5 Lore-Accurate Agency Names
-- Place in: shadow_elites_progression/server/lore.lua
-- ============================================

-- Load lore data (uses Config tables)
local LoreData = require 'data.lore_data'  -- Our data loader

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

local function GetPlayerByCitizenId(citizenid)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local Player = exports.qbx_core:GetPlayer(tonumber(playerId))
        if Player and Player.PlayerData.citizenid == citizenid then
            return Player
        end
    end
    return nil
end

-- ============================================
-- CORE COLLECTION FUNCTION
-- ============================================

---@param citizenid string Player identifier
---@param loreType string Type: usb, note, document, artifact
---@param loreId number ID within type
---@param location string|nil Where player found it
---@return boolean success
function GiveLoreItem(citizenid, loreType, loreId, location)
    -- Validate inputs
    if not citizenid or not loreType or not loreId then
        print('^1[Lore System] ERROR: Missing parameters in GiveLoreItem^7')
        return false
    end
    
    -- Check if already collected
    local exists = MySQL.scalar.await(
        'SELECT id FROM shadow_lore_collected WHERE identifier = ? AND lore_type = ? AND lore_id = ?',
        {citizenid, loreType, loreId}
    )
    
    if exists then
        print(string.format('^3[Lore System] %s already has %s #%d^7', citizenid, loreType, loreId))
        return false
    end
    
    -- Get lore data from our data loader
    local loreData = LoreData.GetItem(loreType, loreId)
    if not loreData then
        print('^1[Lore System] ERROR: Invalid lore type/id^7')
        return false
    end
    
    local itemName = loreData.item_name
    local foundLocation = location or loreData.found_location or 'Unknown'
    
    -- Insert into database
    MySQL.insert.await(
        'INSERT INTO shadow_lore_collected (identifier, lore_type, lore_id, item_name, found_location) VALUES (?, ?, ?, ?, ?)',
        {citizenid, loreType, loreId, itemName, foundLocation}
    )
    
    -- Update progression counts
    local typeColumn = 'lore_' .. (loreType == 'usb' and 'usbs' or 
                                   loreType == 'note' and 'notes' or 
                                   loreType == 'document' and 'documents' or 'artifacts') .. '_collected'
    
    MySQL.update.await(
        'UPDATE criminal_progression SET lore_items_collected = lore_items_collected + 1, ' .. typeColumn .. ' = ' .. typeColumn .. ' + 1 WHERE identifier = ?',
        {citizenid}
    )
    
    -- Give physical item to player
    local Player = GetPlayerByCitizenId(citizenid)
    if Player then
        local added = exports.ox_inventory:AddItem(Player.PlayerData.source, itemName, 1)
        
        if added then
            -- Send notification
            TriggerClientEvent('ox_lib:notify', Player.PlayerData.source, {
                title = '📜 Lore Fragment Discovered',
                description = loreData.title or 'New fragment unlocked',
                type = 'success',
                duration = 5000,
                position = 'top'
            })
            
            -- Send to tablet if open
            TriggerClientEvent('shadow_tablet:client:loreUnlocked', Player.PlayerData.source, {
                type = loreType,
                id = loreId,
                title = loreData.title,
                location = foundLocation
            })
            
            print(string.format('^2[Lore System] %s collected %s #%d (%s)^7', 
                citizenid, loreType, loreId, loreData.title))
        else
            print('^3[Lore System] WARNING: Failed to add item to inventory (inventory full?)^7')
        end
    end
    
    -- Check collection milestones
    CheckCollectionMilestones(citizenid)
    
    return true
end

-- Export for other resources
exports('GiveLoreItem', GiveLoreItem)

-- ============================================
-- COLLECTION PROGRESS
-- ============================================

---@param citizenid string Player identifier
---@return table progress
function GetCollectionProgress(citizenid)
    local result = MySQL.single.await(
        'SELECT lore_items_collected, lore_usbs_collected, lore_notes_collected, lore_documents_collected, lore_artifacts_collected FROM criminal_progression WHERE identifier = ?',
        {citizenid}
    )
    
    if not result then
        return {
            total = {collected = 0, total = 88},
            usb = {collected = 0, total = 25},
            note = {collected = 0, total = 40},
            document = {collected = 0, total = 15},
            artifact = {collected = 0, total = 11}
        }
    end
    
    return {
        total = {
            collected = result.lore_items_collected or 0,
            total = 88
        },
        usb = {
            collected = result.lore_usbs_collected or 0,
            total = 25
        },
        note = {
            collected = result.lore_notes_collected or 0,
            total = 40
        },
        document = {
            collected = result.lore_documents_collected or 0,
            total = 15
        },
        artifact = {
            collected = result.lore_artifacts_collected or 0,
            total = 11
        }
    }
end

exports('GetCollectionProgress', GetCollectionProgress)

-- ============================================
-- MILESTONE REWARDS
-- ============================================

function CheckCollectionMilestones(citizenid)
    local progress = GetCollectionProgress(citizenid)
    local Player = GetPlayerByCitizenId(citizenid)
    
    if not Player then return end
    
    local source = Player.PlayerData.source
    local totalCollected = progress.total.collected
    
    -- 10 items milestone - $50,000 cash + "Collector" title
    if totalCollected == 10 then
        Player.Functions.AddMoney('cash', 50000)
        TriggerClientEvent('ox_lib:notify', source, {
            title = '🏆 Milestone Unlocked',
            description = 'Collector Achievement: $50,000 reward!',
            type = 'success',
            duration = 8000
        })
        
        -- Send Shadow Network message if that system exists
        TriggerEvent('shadow_network:server:sendMessage', source, 'lore_milestone_10', 'organized')
    end
    
    -- 25 items milestone - Unique Shadow mask
    if totalCollected == 25 then
        exports.ox_inventory:AddItem(source, 'shadow_mask', 1)
        TriggerClientEvent('ox_lib:notify', source, {
            title = '🎭 Rare Item Unlocked',
            description = 'Received: Shadow Network Mask',
            type = 'success',
            duration = 8000
        })
    end
    
    -- All 25 USBs collected - +5% XP boost
    if progress.usb.collected == 25 then
        MySQL.update.await(
            'UPDATE criminal_progression SET xp_bonus = xp_bonus + 0.05 WHERE identifier = ?',
            {citizenid}
        )
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = '📚 Complete Collection',
            description = 'All story fragments collected! +5% XP boost unlocked',
            type = 'success',
            duration = 10000
        })
        
        TriggerEvent('shadow_network:server:sendMessage', source, 'lore_usbs_complete', 'organized')
    end
    
    -- All 40 notes collected - Exclusive tattoo
    if progress.note.collected == 40 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = '🗒️ Archivist Achievement',
            description = 'All physical notes collected! Check tattoo shops for exclusive design',
            type = 'success',
            duration = 10000
        })
    end
    
    -- All 15 documents collected - Hidden heist unlocked
    if progress.document.collected == 15 then
        MySQL.update.await(
            'UPDATE criminal_progression SET shadow_unlocked_humane_labs = 1 WHERE identifier = ?',
            {citizenid}
        )
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = '🔓 Secret Unlocked',
            description = 'All classified documents collected! Hidden heist now available',
            type = 'success',
            duration = 10000
        })
        
        TriggerEvent('shadow_network:server:sendMessage', source, 'lore_documents_complete', 'organized')
    end
    
    -- All 11 artifacts collected - "Eighth Sin" eligibility
    if progress.artifact.collected == 11 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = '💎 Legendary Collector',
            description = 'All artifacts collected! You have proven worthy... The Shadow Network watches.',
            type = 'inform',
            duration = 15000
        })
        
        TriggerEvent('shadow_network:server:sendMessage', source, 'lore_artifacts_complete', 'organized')
    end
    
    -- ALL 88 items collected - Shadow Scholar
    if totalCollected == 88 then
        Player.Functions.AddMoney('crypto', 1000000)
        
        MySQL.update.await(
            'UPDATE criminal_progression SET lore_collection_complete = 1, lore_scholar_title = 1 WHERE identifier = ?',
            {citizenid}
        )
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = '👑 SHADOW SCHOLAR',
            description = 'You have collected every fragment of Shadow Network history. The truth is yours. $1,000,000 crypto awarded.',
            type = 'success',
            duration = 20000
        })
        
        -- Server-wide announcement
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message system"><b>SHADOW NETWORK:</b> A scholar has emerged. {0} has uncovered the complete truth.</div>',
            args = {Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname}
        })
        
        TriggerEvent('shadow_network:server:sendMessage', source, 'lore_complete', 'organized')
    end
end

-- ============================================
-- TABLET NUI CALLBACKS
-- ============================================

-- Get all lore fragments for tablet UI
lib.callback.register('shadow_tablet:server:getLoreFragments', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {ok = false, fragments = {}} end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Get collected items
    local collected = MySQL.query.await(
        'SELECT lore_type, lore_id, found_location, found_date, read_count FROM shadow_lore_collected WHERE identifier = ?',
        {citizenid}
    )
    
    local collectedMap = {}
    for _, item in ipairs(collected) do
        local key = item.lore_type .. '_' .. item.lore_id
        collectedMap[key] = item
    end
    
    -- Build fragments list from Config.LoreFragments
    local fragments = {}
    local allUSBs = LoreData.GetAllUSBs()
    
    for i = 1, 25 do
        local usbData = allUSBs[i]
        if usbData then
            local key = 'usb_' .. i
            local isCollected = collectedMap[key] ~= nil
            
            table.insert(fragments, {
                id = 'usb_' .. i,
                number = i,
                title = usbData.title,
                content = usbData.content,
                foundLocation = isCollected and collectedMap[key].found_location or '',
                foundDate = isCollected and collectedMap[key].found_date or nil,
                unlocked = isCollected,
                unlockCondition = usbData.unlock_condition
            })
        end
    end
    
    return {ok = true, fragments = fragments}
end)

-- Mark fragment as read
lib.callback.register('shadow_tablet:server:markFragmentRead', function(source, data)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {ok = false} end
    
    local citizenid = Player.PlayerData.citizenid
    local fragmentId = data.fragmentId
    
    -- Parse fragment ID (e.g., "usb_1" -> type="usb", id=1)
    local loreType, loreId = fragmentId:match("(%a+)_(%d+)")
    loreId = tonumber(loreId)
    
    if not loreType or not loreId then
        return {ok = false, message = 'Invalid fragment ID'}
    end
    
    -- Update read count
    MySQL.update.await(
        'UPDATE shadow_lore_collected SET read_count = read_count + 1, last_read = NOW() WHERE identifier = ? AND lore_type = ? AND lore_id = ?',
        {citizenid, loreType, loreId}
    )
    
    return {ok = true}
end)

-- Get note data (for client reading)
lib.callback.register('shadow_lore:server:getNote', function(source, noteType, noteId)
    -- This would get data for physical notes when read
    local note = LoreData.GetItem('note', noteId)
    return note
end)

-- Get document data (for client reading)
lib.callback.register('shadow_lore:server:getDocument', function(source, docId)
    local doc = LoreData.GetItem('document', docId)
    return doc
end)

-- Get artifact data (for client examination)
lib.callback.register('shadow_lore:server:getArtifact', function(source, artifactId)
    local artifact = LoreData.GetItem('artifact', artifactId)
    return artifact
end)

-- Collect from world pickup
lib.callback.register('shadow_lore:server:collectFromWorld', function(source, loreType, loreId)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    local success = GiveLoreItem(Player.PlayerData.citizenid, loreType, loreId, 'World Pickup')
    return success
end)

-- ============================================
-- HEIST REWARD INTEGRATION
-- ============================================

-- Hook into heist completion
AddEventHandler('shadow_elites:server:levelUp', function(source, tree, newLevel)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Level milestone USB rewards
    if tree == 'organized' then
        if newLevel == 3 then
            GiveLoreItem(citizenid, 'usb', 2, 'Organized Crime Level 3')
        elseif newLevel == 5 then
            GiveLoreItem(citizenid, 'usb', 6, 'WAR - Level 5')
        elseif newLevel == 7 then
            GiveLoreItem(citizenid, 'usb', 16, 'Level 7 Achievement')
        elseif newLevel == 10 then
            GiveLoreItem(citizenid, 'artifact', 1, 'WAR\'s Challenge Coin - Level 10')
        end
    elseif tree == 'narcotics' then
        if newLevel == 3 then
            GiveLoreItem(citizenid, 'usb', 3, 'Narcotics Level 3')
        elseif newLevel == 5 then
            GiveLoreItem(citizenid, 'usb', 7, 'FAMINE - Level 5')
        elseif newLevel == 10 then
            GiveLoreItem(citizenid, 'artifact', 2, 'FAMINE\'s Ancient Scale - Level 10')
        end
    elseif tree == 'auto_theft' then
        if newLevel == 3 then
            GiveLoreItem(citizenid, 'usb', 4, 'Auto Theft Level 3')
        elseif newLevel == 5 then
            GiveLoreItem(citizenid, 'usb', 8, 'CONQUEST - Level 5')
        elseif newLevel == 10 then
            GiveLoreItem(citizenid, 'artifact', 3, 'CONQUEST\'s White Trophy - Level 10')
        end
    end
end)

-- Random drop on heist completion (5% chance)
RegisterNetEvent('shadow_elites:server:heistCompleted', function(heistType)
    local source = source
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- 5% chance for random note drop
    if math.random(1, 100) <= 5 then
        -- Get random uncollected note
        local collected = MySQL.query.await(
            'SELECT lore_id FROM shadow_lore_collected WHERE identifier = ? AND lore_type = "note"',
            {citizenid}
        )
        
        local collectedIds = {}
        for _, item in ipairs(collected) do
            collectedIds[item.lore_id] = true
        end
        
        -- Find random uncollected note
        local availableNotes = {}
        for i = 1, 40 do
            if not collectedIds[i] then
                table.insert(availableNotes, i)
            end
        end
        
        if #availableNotes > 0 then
            local randomNote = availableNotes[math.random(1, #availableNotes)]
            GiveLoreItem(citizenid, 'note', randomNote, 'Random drop during ' .. heistType)
        end
    end
end)

-- ============================================
-- ADMIN COMMANDS
-- ============================================

lib.addCommand('givelore', {
    help = 'Give lore item to player',
    params = {
        {name = 'id', type = 'playerId', help = 'Player ID'},
        {name = 'type', help = 'Lore type (usb/note/document/artifact)'},
        {name = 'number', type = 'number', help = 'Item number (1-88)'},
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
    
    local success = GiveLoreItem(Player.PlayerData.citizenid, args.type, args.number, 'Admin Command')
    
    TriggerClientEvent('ox_lib:notify', source, {
        description = success and string.format('Gave %s #%d to player', args.type, args.number) or 'Failed to give lore item (already collected?)',
        type = success and 'success' or 'error'
    })
end)

lib.addCommand('lorestats', {
    help = 'View player lore collection stats',
    params = {
        {name = 'id', type = 'playerId', help = 'Player ID'},
    },
    restricted = 'group.admin'
}, function(source, args)
    local Player = exports.qbx_core:GetPlayer(args.id)
    if not Player then return end
    
    local progress = GetCollectionProgress(Player.PlayerData.citizenid)
    
    print('^2============================================^7')
    print('^2Lore Collection Stats for ' .. Player.PlayerData.charinfo.firstname .. '^7')
    print('^2============================================^7')
    print(string.format('Total: %d / %d (%.1f%%)', 
        progress.total.collected, progress.total.total, 
        (progress.total.collected / progress.total.total) * 100))
    print(string.format('USB Drives: %d / %d', progress.usb.collected, progress.usb.total))
    print(string.format('Physical Notes: %d / %d', progress.note.collected, progress.note.total))
    print(string.format('Classified Documents: %d / %d', progress.document.collected, progress.document.total))
    print(string.format('Legendary Artifacts: %d / %d', progress.artifact.collected, progress.artifact.total))
    print('^2============================================^7')
end)

print('^2[Shadow Lore System] Server loaded successfully! (Config-compatible)^7')

-- Get player's complete lore collection for tablet UI
function GetPlayerLoreCollection(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Get collected items
    local collected = MySQL.query.await(
        'SELECT lore_type, lore_id, found_location, found_date, read_count FROM shadow_lore_collected WHERE identifier = ?',
        {citizenid}
    )
    
    local collectedMap = {}
    for _, item in ipairs(collected) do
        local key = item.lore_type .. '_' .. item.lore_id
        collectedMap[key] = item
    end
    
    -- Build fragments list from Config.LoreFragments
    local fragments = {}
    local allUSBs = LoreData.GetAllUSBs()
    
    for i = 1, 25 do
        local usbData = allUSBs[i]
        if usbData then
            local key = 'usb_' .. i
            local isCollected = collectedMap[key] ~= nil
            
            table.insert(fragments, {
                id = 'usb_' .. i,
                number = i,
                title = usbData.title,
                content = usbData.content,
                foundLocation = isCollected and collectedMap[key].found_location or '',
                foundDate = isCollected and collectedMap[key].found_date or nil,
                unlocked = isCollected,
                unlockCondition = usbData.unlock_condition
            })
        end
    end
    
    return fragments
end

-- Mark lore fragment as read
function MarkLoreFragmentRead(source, fragmentId)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Parse fragment ID (e.g., "usb_1" -> type="usb", id=1)
    local loreType, loreId = fragmentId:match("(%a+)_(%d+)")
    loreId = tonumber(loreId)
    
    if not loreType or not loreId then
        return false
    end
    
    -- Update read count
    MySQL.update.await(
        'UPDATE shadow_lore_collected SET read_count = read_count + 1, last_read = NOW() WHERE identifier = ? AND lore_type = ? AND lore_id = ?',
        {citizenid, loreType, loreId}
    )
    
    return true
end

-- Export these functions so shadow_tablet can call them
exports('GetPlayerLoreCollection', GetPlayerLoreCollection)
exports('MarkLoreFragmentRead', MarkLoreFragmentRead)

print('^2[Shadow Lore] Export functions registered for shadow_tablet^7')