-- ============================================
-- SHADOW ELITES - CREW UI (CLIENT)
-- Week 2: Client-side crew menu interface
-- ============================================

-- ============================================
-- HELPER FUNCTION: Format MySQL timestamps
-- ============================================

local function formatDate(mysqlTimestamp)
    if not mysqlTimestamp then return 'Unknown' end
    
    -- MySQL timestamp format: "YYYY-MM-DD HH:MM:SS"
    -- Convert to readable format
    local year, month, day = string.match(mysqlTimestamp, "(%d+)-(%d+)-(%d+)")
    if year and month and day then
        return string.format('%s/%s/%s', month, day, year)
    end
    return 'Unknown'
end

local function formatTime(mysqlTimestamp)
    if not mysqlTimestamp then return 'Unknown' end
    
    -- Extract time from MySQL timestamp
    local hour, min = string.match(mysqlTimestamp, "%d+-%d+-%d+ (%d+):(%d+)")
    if hour and min then
        hour = tonumber(hour)
        local ampm = hour >= 12 and 'PM' or 'AM'
        hour = hour > 12 and hour - 12 or (hour == 0 and 12 or hour)
        return string.format('%02d:%s %s', hour, min, ampm)
    end
    return 'Unknown'
end

-- ============================================
-- FORWARD DECLARATIONS (Fix function order)
-- ============================================

local openCrewMenu
local openNoCrewMenu
local openCreateCrewDialog
local openMembersMenu
local openInviteMenu
local openManageMenu
local openInvitationsMenu
local confirmLeaveCrew
local confirmDisbandCrew

-- ============================================
-- MAIN CREW MENU
-- ============================================

function openCrewMenu()
    -- Get crew info
    local crewInfo = lib.callback.await('shadow_elites:server:getCrewInfo', false)
    
    if not crewInfo then
        -- Player is not in a crew - show join/create options
        openNoCrewMenu()
        return
    end
    
    -- Player is in a crew - show crew management
    local options = {
        {
            title = string.format('📋 %s', crewInfo.crew_name),
            description = string.format('%d/%d members | %d heists | $%s earned', 
                crewInfo.memberCount, 
                Config.Crew.maxMembers,
                crewInfo.total_heists,
                lib.math.groupdigits(crewInfo.total_earnings)),
            icon = 'users',
            disabled = true,
        },
        {
            title = 'View Members',
            description = 'See all crew members and their status',
            icon = 'user-group',
            onSelect = function()
                openMembersMenu(crewInfo)
            end
        },
    }
    
    -- Leader-only options
    if crewInfo.isLeader then
        table.insert(options, {
            title = 'Invite Player',
            description = 'Invite a nearby player to join your crew',
            icon = 'user-plus',
            onSelect = function()
                openInviteMenu()
            end
        })
        
        table.insert(options, {
            title = 'Manage Members',
            description = 'Kick members from the crew',
            icon = 'user-minus',
            onSelect = function()
                openManageMenu(crewInfo)
            end
        })
        
        table.insert(options, {
            title = '⚠️ Disband Crew',
            description = 'Permanently delete the crew',
            icon = 'trash',
            onSelect = function()
                confirmDisbandCrew()
            end
        })
    else
        -- Member options
        table.insert(options, {
            title = 'Leave Crew',
            description = 'Leave your current crew',
            icon = 'right-from-bracket',
            onSelect = function()
                confirmLeaveCrew()
            end
        })
    end
    
    lib.registerContext({
        id = 'shadow_crew_menu',
        title = 'Crew Management',
        options = options
    })
    
    lib.showContext('shadow_crew_menu')
end

-- ============================================
-- NO CREW MENU (Create or Join)
-- ============================================

function openNoCrewMenu()
    -- Check for pending invitations
    local invites = lib.callback.await('shadow_elites:server:getPendingInvites', false)
    
    local options = {
        {
            title = 'Create Crew',
            description = 'Start your own criminal crew',
            icon = 'plus',
            onSelect = function()
                openCreateCrewDialog()
            end
        },
    }
    
    -- Show pending invitations
    if invites and #invites > 0 then
        table.insert(options, {
            title = string.format('📬 Pending Invitations (%d)', #invites),
            description = 'View and accept crew invitations',
            icon = 'envelope',
            onSelect = function()
                openInvitationsMenu(invites)
            end
        })
    else
        table.insert(options, {
            title = 'No Invitations',
            description = 'You have no pending crew invitations',
            icon = 'envelope-open',
            disabled = true,
        })
    end
    
    lib.registerContext({
        id = 'shadow_no_crew_menu',
        title = 'Crew Management',
        options = options
    })
    
    lib.showContext('shadow_no_crew_menu')
end

-- ============================================
-- CREATE CREW DIALOG
-- ============================================

function openCreateCrewDialog()
    local input = lib.inputDialog('Create Crew', {
        {
            type = 'input',
            label = 'Crew Name',
            description = '3-50 characters',
            required = true,
            min = 3,
            max = 50
        }
    })
    
    if not input then return end
    
    local crewName = input[1]
    
    -- Create crew
    local result = lib.callback.await('shadow_elites:server:createCrew', false, crewName)
    
    if result.success then
        lib.notify({
            title = 'Crew Created',
            description = result.message,
            type = 'success',
            duration = 7000
        })
        
        -- Open crew menu
        Wait(500)
        openCrewMenu()
    else
        lib.notify({
            title = 'Failed to Create Crew',
            description = result.message,
            type = 'error',
            duration = 7000
        })
    end
end

-- ============================================
-- VIEW MEMBERS MENU
-- ============================================

function openMembersMenu(crewInfo)
    local options = {}
    
    for _, member in ipairs(crewInfo.members) do
        local rankIcon = member.rank == 'leader' and '👑' or '👤'
        local statusIcon = member.isOnline and '🟢' or '⚫'
        
        table.insert(options, {
            title = string.format('%s %s %s', rankIcon, statusIcon, member.name),
            description = string.format('%s | Heists: %d | Joined: %s', 
                member.rank:upper(),
                member.heists_participated,
                formatDate(member.joined_at)),
            icon = member.rank == 'leader' and 'crown' or 'user',
            disabled = true,
        })
    end
    
    table.insert(options, {
        title = '← Back',
        icon = 'arrow-left',
        onSelect = function()
            openCrewMenu()
        end
    })
    
    lib.registerContext({
        id = 'shadow_members_menu',
        title = string.format('%s - Members', crewInfo.crew_name),
        options = options
    })
    
    lib.showContext('shadow_members_menu')
end

-- ============================================
-- INVITE PLAYER MENU
-- ============================================

-- Helper function to get nearby players manually
local function getManualNearbyPlayers(radius)
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local players = {}
    
    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(myCoords - targetCoords)
        
        if playerId ~= PlayerId() and distance <= radius then
            table.insert(players, {
                id = GetPlayerServerId(playerId),
                name = GetPlayerName(playerId),
                coords = targetCoords,
                distance = distance
            })
        end
    end
    
    return players
end

function openInviteMenu()
    local myCoords = GetEntityCoords(PlayerPedId())
    local nearbyPlayers = lib.getNearbyPlayers(myCoords, 10.0, true)
    
    -- Debug logging
    if Config.Debug then
        print('^3[Shadow Elites - Debug]^7 getNearbyPlayers result:')
        if nearbyPlayers then
            print(string.format('^3[Shadow Elites - Debug]^7 Found %d nearby players', #nearbyPlayers))
            for i, player in ipairs(nearbyPlayers) do
                print(string.format('^3[Shadow Elites - Debug]^7 Player %d: id=%s, name=%s, distance=%s, coords=%s', 
                    i, 
                    tostring(player.id), 
                    tostring(player.name),
                    tostring(player.distance),
                    tostring(player.coords)))
            end
        else
            print('^3[Shadow Elites - Debug]^7 getNearbyPlayers returned nil!')
        end
    end
    
    -- Fallback to manual detection if ox_lib fails
    if not nearbyPlayers or #nearbyPlayers == 0 then
        if Config.Debug then
            print('^3[Shadow Elites - Debug]^7 Using manual nearby player detection as fallback')
        end
        nearbyPlayers = getManualNearbyPlayers(10.0)
    end
    
    if not nearbyPlayers or #nearbyPlayers == 0 then
        lib.notify({
            description = 'No players nearby (within 10 meters)',
            type = 'error',
            duration = 5000
        })
        return
    end
    
    local options = {}
    
    for _, player in ipairs(nearbyPlayers) do
        -- Calculate distance manually if not provided
        local distance = player.distance
        if not distance and player.coords then
            distance = #(myCoords - player.coords)
        end
        
        -- Get player name (try different fields)
        local playerName = player.name or 'Unknown Player'
        
        -- Build description with nil checks
        local desc
        if player.id and distance then
            desc = string.format('Server ID: %d | Distance: %.1fm', player.id, distance)
        elseif player.id then
            desc = string.format('Server ID: %d', player.id)
        else
            desc = 'Nearby player'
        end
        
        table.insert(options, {
            title = playerName,
            description = desc,
            icon = 'user-plus',
            onSelect = function()
                -- Invite player
                local result = lib.callback.await('shadow_elites:server:inviteToCrew', false, player.id)
                
                if result.success then
                    lib.notify({
                        description = result.message,
                        type = 'success'
                    })
                else
                    lib.notify({
                        description = result.message,
                        type = 'error'
                    })
                end
                
                -- Reopen menu
                Wait(500)
                openCrewMenu()
            end
        })
    end
    
    table.insert(options, {
        title = '← Back',
        icon = 'arrow-left',
        onSelect = function()
            openCrewMenu()
        end
    })
    
    lib.registerContext({
        id = 'shadow_invite_menu',
        title = 'Invite Player',
        options = options
    })
    
    lib.showContext('shadow_invite_menu')
end

-- ============================================
-- MANAGE MEMBERS MENU (Kick)
-- ============================================

function openManageMenu(crewInfo)
    local options = {}
    
    for _, member in ipairs(crewInfo.members) do
        -- Skip leader
        if member.rank ~= 'leader' then
            local statusIcon = member.isOnline and '🟢' or '⚫'
            
            table.insert(options, {
                title = string.format('%s %s', statusIcon, member.name),
                description = string.format('Kick %s from the crew', member.name),
                icon = 'user-minus',
                onSelect = function()
                    -- Confirm kick
                    local alert = lib.alertDialog({
                        header = 'Kick Member',
                        content = string.format('Are you sure you want to kick %s from the crew?', member.name),
                        centered = true,
                        cancel = true
                    })
                    
                    if alert == 'confirm' then
                        local result = lib.callback.await('shadow_elites:server:kickMember', false, member.identifier)
                        
                        if result.success then
                            lib.notify({
                                description = result.message,
                                type = 'success'
                            })
                            
                            -- Reload menu
                            Wait(500)
                            openCrewMenu()
                        else
                            lib.notify({
                                description = result.message,
                                type = 'error'
                            })
                        end
                    end
                end
            })
        end
    end
    
    if #options == 0 then
        table.insert(options, {
            title = 'No Members to Manage',
            description = 'Only the leader is in this crew',
            icon = 'info',
            disabled = true,
        })
    end
    
    table.insert(options, {
        title = '← Back',
        icon = 'arrow-left',
        onSelect = function()
            openCrewMenu()
        end
    })
    
    lib.registerContext({
        id = 'shadow_manage_menu',
        title = 'Manage Members',
        options = options
    })
    
    lib.showContext('shadow_manage_menu')
end

-- ============================================
-- INVITATIONS MENU
-- ============================================

function openInvitationsMenu(invites)
    local options = {}
    
    for _, invite in ipairs(invites) do
        table.insert(options, {
            title = invite.crew_name,
            description = string.format('Invitation from this crew | Expires: %s', 
                formatTime(invite.expires_at)),
            icon = 'envelope',
            onSelect = function()
                -- Confirm accept
                local alert = lib.alertDialog({
                    header = 'Accept Invitation',
                    content = string.format('Do you want to join "%s"?', invite.crew_name),
                    centered = true,
                    cancel = true,
                    labels = {
                        confirm = 'Accept',
                        cancel = 'Decline'
                    }
                })
                
                if alert == 'confirm' then
                    local result = lib.callback.await('shadow_elites:server:acceptInvitation', false, invite.id)
                    
                    if result.success then
                        lib.notify({
                            title = 'Joined Crew',
                            description = result.message,
                            type = 'success'
                        })
                        
                        -- Open crew menu
                        Wait(500)
                        openCrewMenu()
                    else
                        lib.notify({
                            description = result.message,
                            type = 'error'
                        })
                    end
                else
                    -- Decline invitation
                    lib.callback.await('shadow_elites:server:declineInvitation', false, invite.id)
                    
                    -- Reload invitations menu
                    Wait(500)
                    openNoCrewMenu()
                end
            end
        })
    end
    
    table.insert(options, {
        title = '← Back',
        icon = 'arrow-left',
        onSelect = function()
            openNoCrewMenu()
        end
    })
    
    lib.registerContext({
        id = 'shadow_invitations_menu',
        title = 'Crew Invitations',
        options = options
    })
    
    lib.showContext('shadow_invitations_menu')
end

-- ============================================
-- LEAVE CREW CONFIRMATION
-- ============================================

function confirmLeaveCrew()
    local alert = lib.alertDialog({
        header = 'Leave Crew',
        content = 'Are you sure you want to leave your crew?',
        centered = true,
        cancel = true
    })
    
    if alert == 'confirm' then
        local result = lib.callback.await('shadow_elites:server:leaveCrew', false)
        
        if result.success then
            lib.notify({
                description = result.message,
                type = 'success'
            })
            
            -- Open no crew menu
            Wait(500)
            openNoCrewMenu()
        else
            lib.notify({
                description = result.message,
                type = 'error'
            })
        end
    end
end

-- ============================================
-- DISBAND CREW CONFIRMATION
-- ============================================

function confirmDisbandCrew()
    local alert = lib.alertDialog({
        header = '⚠️ Disband Crew',
        content = 'This will permanently delete your crew. All members will be removed. This CANNOT be undone!',
        centered = true,
        cancel = true
    })
    
    if alert == 'confirm' then
        local result = lib.callback.await('shadow_elites:server:disbandCrew', false)
        
        if result.success then
            lib.notify({
                title = 'Crew Disbanded',
                description = result.message,
                type = 'success'
            })
            
            -- Open no crew menu
            Wait(500)
            openNoCrewMenu()
        else
            lib.notify({
                description = result.message,
                type = 'error'
            })
        end
    end
end

-- ============================================
-- CREW COMMAND
-- ============================================

RegisterCommand('crew', function()
    openCrewMenu()
end)

-- ============================================
-- NOTIFICATION WHEN INVITED
-- ============================================

RegisterNetEvent('shadow_elites:client:crewInvited', function(crewName, inviterName)
    lib.notify({
        title = 'Crew Invitation',
        description = string.format('%s invited you to join "%s". Use /crew to view invitations.', inviterName, crewName),
        type = 'inform',
        duration = 10000
    })
end)