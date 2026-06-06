-- ============================================
-- SHADOW ELITES - CREW MANAGEMENT (SERVER)
-- Week 2: Crew system for heist coordination
-- ============================================

-- ============================================
-- CREATE CREW
-- ============================================

lib.callback.register('shadow_elites:server:createCrew', function(source, crewName)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false, message = 'Player not found'} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Check if player is already in a crew
    local existing = MySQL.scalar.await('SELECT crew_id FROM criminal_crew_members WHERE identifier = ?', {identifier})
    if existing then
        return {success = false, message = 'You are already in a crew. Leave your current crew first.'}
    end
    
    -- Check if crew name is taken
    local nameTaken = MySQL.scalar.await('SELECT id FROM criminal_crews WHERE crew_name = ?', {crewName})
    if nameTaken then
        return {success = false, message = 'Crew name already taken. Choose a different name.'}
    end
    
    -- Validate crew name (3-50 characters, alphanumeric + spaces)
    if not crewName or #crewName < 3 or #crewName > 50 then
        return {success = false, message = 'Crew name must be 3-50 characters.'}
    end
    
    -- Create the crew
    local crewId = MySQL.insert.await('INSERT INTO criminal_crews (crew_name, leader_identifier) VALUES (?, ?)', {
        crewName,
        identifier
    })
    
    if not crewId then
        return {success = false, message = 'Failed to create crew. Database error.'}
    end
    
    -- Add leader as first member
    MySQL.insert.await('INSERT INTO criminal_crew_members (crew_id, identifier, rank) VALUES (?, ?, ?)', {
        crewId,
        identifier,
        'leader'
    })
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s created crew: %s (ID: %d)', 
            Player.PlayerData.charinfo.firstname, crewName, crewId))
    end
    
    return {success = true, message = string.format('Crew "%s" created successfully!', crewName), crewId = crewId}
end)

-- ============================================
-- INVITE PLAYER TO CREW
-- ============================================

lib.callback.register('shadow_elites:server:inviteToCrew', function(source, targetId)
    local Player = exports.qbx_core:GetPlayer(source)
    local Target = exports.qbx_core:GetPlayer(targetId)
    
    if not Player or not Target then
        return {success = false, message = 'Player not found.'}
    end
    
    local identifier = Player.PlayerData.citizenid
    local targetIdentifier = Target.PlayerData.citizenid
    
    -- Get player's crew
    local crewData = MySQL.single.await([[
        SELECT cm.crew_id, cm.rank, c.crew_name, c.leader_identifier
        FROM criminal_crew_members cm
        JOIN criminal_crews c ON cm.crew_id = c.id
        WHERE cm.identifier = ?
    ]], {identifier})
    
    if not crewData then
        return {success = false, message = 'You are not in a crew.'}
    end
    
    -- Check if player is leader
    if crewData.rank ~= 'leader' then
        return {success = false, message = 'Only the crew leader can invite members.'}
    end
    
    -- Check if target is already in a crew
    local targetCrew = MySQL.scalar.await('SELECT crew_id FROM criminal_crew_members WHERE identifier = ?', {targetIdentifier})
    if targetCrew then
        return {success = false, message = string.format('%s is already in a crew.', Target.PlayerData.charinfo.firstname)}
    end
    
    -- Check if invitation already exists
    local existingInvite = MySQL.scalar.await([[
        SELECT id FROM criminal_crew_invitations 
        WHERE crew_id = ? AND invitee_identifier = ? AND expires_at > NOW()
    ]], {crewData.crew_id, targetIdentifier})
    
    if existingInvite then
        return {success = false, message = 'You already sent an invitation to this player.'}
    end
    
    -- Check crew size (max 5 members)
    local memberCount = MySQL.scalar.await('SELECT COUNT(*) FROM criminal_crew_members WHERE crew_id = ?', {crewData.crew_id})
    if memberCount >= Config.Crew.maxMembers then
        return {success = false, message = string.format('Crew is full (%d/%d members).', memberCount, Config.Crew.maxMembers)}
    end
    
    -- Create invitation
    MySQL.insert.await([[
        INSERT INTO criminal_crew_invitations (crew_id, inviter_identifier, invitee_identifier)
        VALUES (?, ?, ?)
    ]], {crewData.crew_id, identifier, targetIdentifier})
    
    -- Notify target player
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Crew Invitation',
        description = string.format('%s invited you to join "%s"', Player.PlayerData.charinfo.firstname, crewData.crew_name),
        type = 'inform',
        duration = 10000,
    })
    
    -- Notify inviter
    TriggerClientEvent('ox_lib:notify', source, {
        description = string.format('Invitation sent to %s', Target.PlayerData.charinfo.firstname),
        type = 'success'
    })
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s invited %s to crew: %s', 
            Player.PlayerData.charinfo.firstname, Target.PlayerData.charinfo.firstname, crewData.crew_name))
    end
    
    return {success = true, message = 'Invitation sent!'}
end)

-- ============================================
-- GET PENDING INVITATIONS
-- ============================================

lib.callback.register('shadow_elites:server:getPendingInvites', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get all pending invitations
    local invites = MySQL.query.await([[
        SELECT ci.id, ci.crew_id, c.crew_name, ci.inviter_identifier, ci.expires_at
        FROM criminal_crew_invitations ci
        JOIN criminal_crews c ON ci.crew_id = c.id
        WHERE ci.invitee_identifier = ? AND ci.expires_at > NOW()
        ORDER BY ci.created_at DESC
    ]], {identifier})
    
    return invites or {}
end)

-- ============================================
-- ACCEPT CREW INVITATION
-- ============================================

lib.callback.register('shadow_elites:server:acceptInvitation', function(source, inviteId)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false, message = 'Player not found'} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get invitation
    local invite = MySQL.single.await([[
        SELECT ci.crew_id, c.crew_name
        FROM criminal_crew_invitations ci
        JOIN criminal_crews c ON ci.crew_id = c.id
        WHERE ci.id = ? AND ci.invitee_identifier = ? AND ci.expires_at > NOW()
    ]], {inviteId, identifier})
    
    if not invite then
        return {success = false, message = 'Invitation not found or expired.'}
    end
    
    -- Check if player is already in a crew
    local existing = MySQL.scalar.await('SELECT crew_id FROM criminal_crew_members WHERE identifier = ?', {identifier})
    if existing then
        return {success = false, message = 'You are already in a crew.'}
    end
    
    -- Check crew size
    local memberCount = MySQL.scalar.await('SELECT COUNT(*) FROM criminal_crew_members WHERE crew_id = ?', {invite.crew_id})
    if memberCount >= Config.Crew.maxMembers then
        return {success = false, message = 'Crew is full.'}
    end
    
    -- Add to crew
    MySQL.insert.await('INSERT INTO criminal_crew_members (crew_id, identifier, rank) VALUES (?, ?, ?)', {
        invite.crew_id,
        identifier,
        'member'
    })
    
    -- Delete invitation
    MySQL.query.await('DELETE FROM criminal_crew_invitations WHERE id = ?', {inviteId})
    
    -- Notify player
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Crew Joined',
        description = string.format('You joined "%s"!', invite.crew_name),
        type = 'success',
        duration = 7000
    })
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s joined crew: %s', 
            Player.PlayerData.charinfo.firstname, invite.crew_name))
    end
    
    return {success = true, message = 'Joined crew!', crewName = invite.crew_name}
end)

-- ============================================
-- DECLINE CREW INVITATION
-- ============================================

lib.callback.register('shadow_elites:server:declineInvitation', function(source, inviteId)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Delete invitation
    local deleted = MySQL.query.await([[
        DELETE FROM criminal_crew_invitations 
        WHERE id = ? AND invitee_identifier = ?
    ]], {inviteId, identifier})
    
    if deleted then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Invitation declined',
            type = 'inform'
        })
        return {success = true}
    end
    
    return {success = false}
end)

-- ============================================
-- GET CREW INFO
-- ============================================

lib.callback.register('shadow_elites:server:getCrewInfo', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get crew info
    local crewInfo = MySQL.single.await([[
        SELECT c.id, c.crew_name, c.leader_identifier, c.total_heists, c.total_earnings,
               cm.rank, cm.joined_at
        FROM criminal_crew_members cm
        JOIN criminal_crews c ON cm.crew_id = c.id
        WHERE cm.identifier = ?
    ]], {identifier})
    
    if not crewInfo then return nil end
    
    -- Get all members
    local members = MySQL.query.await([[
        SELECT cm.identifier, cm.rank, cm.joined_at, cm.heists_participated
        FROM criminal_crew_members cm
        WHERE cm.crew_id = ?
        ORDER BY cm.rank DESC, cm.joined_at ASC
    ]], {crewInfo.id})
    
    -- Enrich member data with player names
    for i, member in ipairs(members) do
        local memberPlayer = MySQL.single.await('SELECT charinfo FROM players WHERE citizenid = ?', {member.identifier})
        if memberPlayer and memberPlayer.charinfo then
            local charinfo = json.decode(memberPlayer.charinfo)
            member.name = string.format('%s %s', charinfo.firstname, charinfo.lastname)
        else
            member.name = 'Unknown'
        end
        
        -- Check if member is online
        local onlinePlayer = exports.qbx_core:GetPlayerByCitizenId(member.identifier)
        member.isOnline = (onlinePlayer ~= nil)
    end
    
    crewInfo.members = members
    crewInfo.memberCount = #members
    crewInfo.isLeader = (crewInfo.rank == 'leader')
    
    return crewInfo
end)

-- ============================================
-- LEAVE CREW
-- ============================================

lib.callback.register('shadow_elites:server:leaveCrew', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false, message = 'Player not found'} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Check if player is crew leader
    local isLeader = MySQL.scalar.await([[
        SELECT cm.rank FROM criminal_crew_members cm
        WHERE cm.identifier = ?
    ]], {identifier})
    
    if isLeader == 'leader' then
        return {success = false, message = 'Leaders cannot leave. Disband the crew or transfer leadership first.'}
    end
    
    -- Remove from crew
    MySQL.query.await('DELETE FROM criminal_crew_members WHERE identifier = ?', {identifier})
    
    TriggerClientEvent('ox_lib:notify', source, {
        description = 'You left the crew',
        type = 'inform'
    })
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s left their crew', Player.PlayerData.charinfo.firstname))
    end
    
    return {success = true, message = 'Left crew'}
end)

-- ============================================
-- KICK MEMBER (LEADER ONLY)
-- ============================================

lib.callback.register('shadow_elites:server:kickMember', function(source, targetIdentifier)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false, message = 'Player not found'} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Check if player is leader
    local crewData = MySQL.single.await([[
        SELECT cm.crew_id, cm.rank FROM criminal_crew_members cm
        WHERE cm.identifier = ?
    ]], {identifier})
    
    if not crewData or crewData.rank ~= 'leader' then
        return {success = false, message = 'Only the crew leader can kick members'}
    end
    
    -- Can't kick yourself
    if targetIdentifier == identifier then
        return {success = false, message = 'Cannot kick yourself. Use disband instead.'}
    end
    
    -- Check if target is in the same crew
    local targetCrew = MySQL.scalar.await([[
        SELECT crew_id FROM criminal_crew_members WHERE identifier = ?
    ]], {targetIdentifier})
    
    if targetCrew ~= crewData.crew_id then
        return {success = false, message = 'Player is not in your crew'}
    end
    
    -- Kick member
    MySQL.query.await('DELETE FROM criminal_crew_members WHERE identifier = ?', {targetIdentifier})
    
    -- Notify if online
    local targetPlayer = exports.qbx_core:GetPlayerByCitizenId(targetIdentifier)
    if targetPlayer then
        TriggerClientEvent('ox_lib:notify', targetPlayer.PlayerData.source, {
            title = 'Kicked from Crew',
            description = 'You were removed from the crew',
            type = 'error',
            duration = 7000
        })
    end
    
    TriggerClientEvent('ox_lib:notify', source, {
        description = 'Member kicked from crew',
        type = 'success'
    })
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s kicked member from crew', Player.PlayerData.charinfo.firstname))
    end
    
    return {success = true, message = 'Member kicked'}
end)

-- ============================================
-- DISBAND CREW (LEADER ONLY)
-- ============================================

lib.callback.register('shadow_elites:server:disbandCrew', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {success = false, message = 'Player not found'} end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get crew data
    local crewData = MySQL.single.await([[
        SELECT cm.crew_id, cm.rank, c.crew_name
        FROM criminal_crew_members cm
        JOIN criminal_crews c ON cm.crew_id = c.id
        WHERE cm.identifier = ?
    ]], {identifier})
    
    if not crewData or crewData.rank ~= 'leader' then
        return {success = false, message = 'Only the crew leader can disband the crew'}
    end
    
    -- Delete crew (cascade will remove members and invitations)
    MySQL.query.await('DELETE FROM criminal_crews WHERE id = ?', {crewData.crew_id})
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Crew Disbanded',
        description = string.format('"%s" has been disbanded', crewData.crew_name),
        type = 'inform',
        duration = 7000
    })
    
    if Config.Debug then
        print(string.format('^2[Shadow Elites]^7 %s disbanded crew: %s', 
            Player.PlayerData.charinfo.firstname, crewData.crew_name))
    end
    
    return {success = true, message = 'Crew disbanded'}
end)

-- ============================================
-- CLEAN UP EXPIRED INVITATIONS (every 5 minutes)
-- ============================================

CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes
        
        MySQL.query.await('DELETE FROM criminal_crew_invitations WHERE expires_at < NOW()')
        
        if Config.Debug then
            print('^2[Shadow Elites]^7 Cleaned up expired crew invitations')
        end
    end
end)