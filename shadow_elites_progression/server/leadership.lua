-- ============================================
-- SHADOW NETWORK - 4 HORSEMEN + 7 DEADLY SINS
-- Complete Leadership & Inner Circle System
-- ============================================

-- ============================================
-- THE 4 HORSEMEN (Server Admins)
-- ============================================

local HORSEMEN = {
    death = {
        name = 'Death',
        color = '#000000',          -- Pure black
        horse = 'Pale',
        role = 'Supreme Leader & Enforcer',
        description = 'Commands the Shadow Network. Delivers final judgment and punishment.',
        outfit = 'horseman_death',  -- Custom outfit identifier
        voice_effect = 'deep_distortion',
        permissions = {
            'all_commands',
            'promote_sin',
            'demote_sin',
            'punish_player',
            'spawn_contracts',
            'modify_economy',
            'access_all_data',
        },
    },
    
    war = {
        name = 'War',
        color = '#FF0000',          -- Blood red
        horse = 'Red',
        role = 'Heist Coordinator & Combat Specialist',
        description = 'Orchestrates all major heists and organized crime operations.',
        outfit = 'horseman_war',
        voice_effect = 'aggressive_distortion',
        permissions = {
            'spawn_heist_contracts',
            'modify_heist_rewards',
            'coordinate_crews',
            'promote_sin',
        },
    },
    
    famine = {
        name = 'Famine',
        color = '#1a1a1a',          -- Dark gray/black
        horse = 'Black',
        role = 'Economic Controller & Drug Lord',
        description = 'Controls drug trade, money laundering, and crypto economy.',
        outfit = 'horseman_famine',
        voice_effect = 'hollow_distortion',
        permissions = {
            'modify_crypto_prices',
            'control_laundering',
            'spawn_drug_contracts',
            'promote_sin',
        },
    },
    
    conquest = {
        name = 'Conquest',
        color = '#FFFFFF',          -- Pure white
        horse = 'White',
        role = 'Territory Expansion & Vehicle Operations',
        description = 'Manages boosting operations, territory control, and network expansion.',
        outfit = 'horseman_conquest',
        voice_effect = 'ethereal_distortion',
        permissions = {
            'spawn_boost_contracts',
            'modify_territories',
            'recruit_criminals',
            'promote_sin',
        },
    },
}

-- ============================================
-- THE 7 DEADLY SINS (Inner Circle - Players)
-- ============================================

local SINS = {
    pride = {
        name = 'Pride',
        color = '#9B30FF',          -- Royal purple
        symbol = '👑',
        outfit = 'sin_pride',
        criteria = 'highest_crew_rank',
        description = 'Highest crew rank and leadership skills',
    },
    
    greed = {
        name = 'Greed',
        color = '#FFD700',          -- Gold
        symbol = '💰',
        outfit = 'sin_greed',
        criteria = 'most_money_earned',
        description = 'Highest total earnings and laundering volume',
    },
    
    wrath = {
        name = 'Wrath',
        color = '#8B0000',          -- Dark red
        symbol = '⚔️',
        outfit = 'sin_wrath',
        criteria = 'most_combat_heists',
        description = 'Most successful violent heists and combat encounters',
    },
    
    envy = {
        name = 'Envy',
        color = '#00FF00',          -- Bright green
        symbol = '🚗',
        outfit = 'sin_envy',
        criteria = 'most_boosting',
        description = 'Highest vehicle theft and boosting count',
    },
    
    gluttony = {
        name = 'Gluttony',
        color = '#FF8C00',          -- Dark orange
        symbol = '💊',
        outfit = 'sin_gluttony',
        criteria = 'most_drugs_moved',
        description = 'Largest drug distribution volume',
    },
    
    sloth = {
        name = 'Sloth',
        color = '#708090',          -- Slate gray
        symbol = '🏢',
        outfit = 'sin_sloth',
        criteria = 'most_passive_income',
        description = 'Highest passive income from businesses',
    },
    
    lust = {
        name = 'Lust',
        color = '#DC143C',          -- Crimson
        symbol = '🎭',
        outfit = 'sin_lust',
        criteria = 'most_diverse_activities',
        description = 'Most varied criminal activities (jack of all trades)',
    },
}

-- Track current Sin assignments
local activeSins = {} -- {sin_name = {citizenid, name, stats}}

-- Track pending Sin trials
local pendingTrials = {} -- {citizenid = {trial_type, completion_time, approved_by}}

-- ============================================
-- SIN TRIAL SYSTEM
-- ============================================

--[[
    LEGENDARY PLAYER PROGRESSION:
    1. Player hits Level 10 in ALL three trees
    2. Shadow Network sends mysterious message
    3. Special "Ascension Trial" contract appears
    4. Player completes trial (custom heist/mission)
    5. Trial completion recorded, sent to 4 Horsemen
    6. Horsemen manually review and approve
    7. Player promoted to Inner Circle as a Sin
]]

RegisterNetEvent('shadow_network:server:startSinTrial', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check if player is Level 10 in all trees
    local narcotics = exports['shadow_elites_progression']:GetLevel(src, 'narcotics')
    local organized = exports['shadow_elites_progression']:GetLevel(src, 'organized')
    local autoTheft = exports['shadow_elites_progression']:GetLevel(src, 'auto_theft')
    
    if narcotics < 10 or organized < 10 or autoTheft < 10 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Not Ready',
            description = 'Reach Level 10 in ALL trees first',
            type = 'error'
        })
        return
    end
    
    -- Check if already a Sin
    for _, sinData in pairs(activeSins) do
        if sinData.citizenid == Player.PlayerData.citizenid then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Already Ascended',
                description = 'You are already part of the Inner Circle',
                type = 'error'
            })
            return
        end
    end
    
    -- Check if trial already pending
    if pendingTrials[Player.PlayerData.citizenid] then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Trial Pending',
            description = 'Your ascension awaits Horsemen approval',
            type = 'info'
        })
        return
    end
    
    -- Start trial
    TriggerClientEvent('shadow_network:client:beginAscensionTrial', src)
end)

RegisterNetEvent('shadow_network:server:completeSinTrial', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Record trial completion
    pendingTrials[Player.PlayerData.citizenid] = {
        name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        completion_time = os.time(),
        stats = {
            narcotics_level = exports['shadow_elites_progression']:GetLevel(src, 'narcotics'),
            organized_level = exports['shadow_elites_progression']:GetLevel(src, 'organized'),
            auto_theft_level = exports['shadow_elites_progression']:GetLevel(src, 'auto_theft'),
            total_heists = exports['shadow_elites_progression']:GetTotalCompletions(src),
            total_money = Player.PlayerData.money.cash + Player.PlayerData.money.bank,
        },
        approved_by = nil,
        approved_at = nil,
    }
    
    -- Save to database
    MySQL.insert('INSERT INTO shadow_sin_trials (citizenid, completion_time, stats) VALUES (?, ?, ?)', {
        Player.PlayerData.citizenid,
        os.time(),
        json.encode(pendingTrials[Player.PlayerData.citizenid].stats)
    })
    
    -- Notify player
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Trial Complete',
        description = 'The 4 Horsemen will review your ascension. You will be contacted.',
        type = 'success',
        duration = 10000
    })
    
    -- Notify all Horsemen (admins)
    TriggerEvent('shadow_network:server:notifyHorsemen', {
        title = '🎭 ASCENSION TRIAL COMPLETE',
        description = string.format('%s has completed their trial and awaits judgment', 
            Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname),
        type = 'info',
        duration = 15000
    })
end)

-- ============================================
-- HORSEMEN COMMANDS (Admin Only)
-- ============================================

-- View pending trials
lib.addCommand('sins:pending', {
    help = 'View pending Sin trial approvals (Horsemen only)',
    restricted = 'group.admin'
}, function(source)
    if not pendingTrials or next(pendingTrials) == nil then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'No Pending Trials',
            description = 'No players awaiting ascension',
            type = 'info'
        })
        return
    end
    
    -- Build list
    local trialList = '^2[PENDING SIN TRIALS]^7\n'
    for citizenid, trialData in pairs(pendingTrials) do
        trialList = trialList .. string.format(
            '\n^3%s^7 (ID: %s)\n  Levels: N%d / O%d / A%d\n  Heists: %d | Money: $%d\n',
            trialData.name,
            citizenid,
            trialData.stats.narcotics_level,
            trialData.stats.organized_level,
            trialData.stats.auto_theft_level,
            trialData.stats.total_heists,
            trialData.stats.total_money
        )
    end
    
    print(trialList)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Pending Trials',
        description = 'Check server console for list',
        type = 'info'
    })
end)

-- Approve Sin promotion
lib.addCommand('sins:approve', {
    help = 'Approve a player for Sin promotion (Usage: /sins:approve [citizenid] [sin_name])',
    restricted = 'group.admin'
}, function(source, args)
    local citizenid = args[1]
    local sinName = args[2]
    
    if not citizenid or not sinName then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Invalid Usage',
            description = 'Usage: /sins:approve [citizenid] [sin_name]',
            type = 'error'
        })
        return
    end
    
    -- Check if valid sin
    if not SINS[sinName:lower()] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Invalid Sin',
            description = 'Valid sins: pride, greed, wrath, envy, gluttony, sloth, lust',
            type = 'error'
        })
        return
    end
    
    -- Check if sin slot already taken
    if activeSins[sinName:lower()] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Slot Occupied',
            description = string.format('%s is already assigned to %s', sinName, activeSins[sinName:lower()].name),
            type = 'error'
        })
        return
    end
    
    -- Check if trial exists
    if not pendingTrials[citizenid] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'No Trial Found',
            description = 'This player has not completed a trial',
            type = 'error'
        })
        return
    end
    
    -- Promote to Sin
    local Approver = exports.qbx_core:GetPlayer(source)
    local trialData = pendingTrials[citizenid]
    
    activeSins[sinName:lower()] = {
        citizenid = citizenid,
        name = trialData.name,
        sin = sinName:lower(),
        promoted_at = os.time(),
        promoted_by = Approver.PlayerData.charinfo.firstname .. ' ' .. Approver.PlayerData.charinfo.lastname,
    }
    
    -- Save to database
    MySQL.insert('INSERT INTO shadow_sins (citizenid, sin_name, promoted_at, promoted_by) VALUES (?, ?, ?, ?)', {
        citizenid,
        sinName:lower(),
        os.time(),
        Approver.PlayerData.citizenid
    })
    
    -- Remove from pending
    pendingTrials[citizenid] = nil
    
    -- Notify Horsemen
    TriggerEvent('shadow_network:server:notifyHorsemen', {
        title = '👑 SIN ASCENSION',
        description = string.format('%s has been promoted to %s by %s', 
            trialData.name,
            SINS[sinName:lower()].name,
            Approver.PlayerData.charinfo.firstname),
        type = 'success',
        duration = 15000
    })
    
    -- Notify player (if online)
    local targetPlayer = exports.qbx_core:GetPlayerByCitizenId(citizenid)
    if targetPlayer then
        TriggerClientEvent('shadow_network:client:promotedToSin', targetPlayer.PlayerData.source, sinName:lower())
    end
    
    print(string.format('^2[SHADOW NETWORK]^7 %s promoted to %s by %s', 
        trialData.name, SINS[sinName:lower()].name, Approver.PlayerData.charinfo.firstname))
end)

-- Demote a Sin
lib.addCommand('sins:demote', {
    help = 'Demote a Sin from Inner Circle (Usage: /sins:demote [sin_name])',
    restricted = 'group.admin'
}, function(source, args)
    local sinName = args[1]
    
    if not sinName or not activeSins[sinName:lower()] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Invalid Sin',
            description = 'No active Sin with that name',
            type = 'error'
        })
        return
    end
    
    local sinData = activeSins[sinName:lower()]
    
    -- Remove from active sins
    activeSins[sinName:lower()] = nil
    
    -- Update database
    MySQL.update('UPDATE shadow_sins SET demoted_at = ? WHERE citizenid = ? AND sin_name = ?', {
        os.time(),
        sinData.citizenid,
        sinName:lower()
    })
    
    -- Notify
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Sin Demoted',
        description = string.format('%s has been removed from %s', sinData.name, SINS[sinName:lower()].name),
        type = 'success'
    })
    
    -- Notify player if online
    local targetPlayer = exports.qbx_core:GetPlayerByCitizenId(sinData.citizenid)
    if targetPlayer then
        TriggerClientEvent('shadow_network:client:demotedFromSin', targetPlayer.PlayerData.source)
    end
end)

-- List active Sins
lib.addCommand('sins:list', {
    help = 'List all active Deadly Sins (Horsemen only)',
    restricted = 'group.admin'
}, function(source)
    if not activeSins or next(activeSins) == nil then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'No Active Sins',
            description = 'The Inner Circle is empty',
            type = 'info'
        })
        return
    end
    
    local sinList = '^2[ACTIVE DEADLY SINS - INNER CIRCLE]^7\n'
    for sinName, sinData in pairs(activeSins) do
        local sinInfo = SINS[sinName]
        sinList = sinList .. string.format(
            '\n^3%s %s^7 - %s\n  Promoted: %s\n',
            sinInfo.symbol,
            sinInfo.name,
            sinData.name,
            os.date('%Y-%m-%d', sinData.promoted_at)
        )
    end
    
    print(sinList)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Active Sins',
        description = 'Check server console for list',
        type = 'info'
    })
end)

-- ============================================
-- SIN PERMISSIONS & ABILITIES
-- ============================================

-- Check if player is a Sin
function IsSin(citizenid)
    for _, sinData in pairs(activeSins) do
        if sinData.citizenid == citizenid then
            return true, sinData.sin
        end
    end
    return false, nil
end

-- Check if player has Sin permission
function HasSinPermission(citizenid, permission)
    local isSin, sinName = IsSin(citizenid)
    if not isSin then return false end
    
    -- All Sins have base permissions
    local basePermissions = {
        'moderate_messages',
        'spawn_minor_contracts',
        'mentor_players',
        'sin_council_chat',
        'xp_boost_aura',
    }
    
    for _, perm in ipairs(basePermissions) do
        if perm == permission then
            return true
        end
    end
    
    return false
end

-- ============================================
-- EXPORTS
-- ============================================

exports('GetHorsemen', function()
    return HORSEMEN
end)

exports('GetSins', function()
    return SINS
end)

exports('GetActiveSins', function()
    return activeSins
end)

exports('IsSin', IsSin)
exports('HasSinPermission', HasSinPermission)

-- ============================================
-- STARTUP
-- ============================================

-- Load active sins from database
CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM shadow_sins WHERE demoted_at IS NULL')
    
    if result then
        for _, row in ipairs(result) do
            activeSins[row.sin_name] = {
                citizenid = row.citizenid,
                name = row.player_name or 'Unknown',
                sin = row.sin_name,
                promoted_at = row.promoted_at,
                promoted_by = row.promoted_by,
            }
        end
    end
    
    print('^2[SHADOW NETWORK]^7 Loaded' .. #activeSins .. ' active Deadly Sins')
end)

print('^2[SHADOW NETWORK]^7 4 Horsemen + 7 Sins system loaded')
print('^2[SHADOW NETWORK]^7 Complete anonymity: ^2ENFORCED^7')
print('^2[SHADOW NETWORK]^7 Manual Sin approval: ^2ENABLED^7')