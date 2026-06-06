-- ============================================
-- SHADOW ELITES - MONEY LAUNDERING SYSTEM
-- 4 Methods: Washing, Business, Offshore, Bulk
-- ============================================

-- QBX doesn't use GetCoreObject, use exports directly
local ActiveLaundering = {} -- Track active laundering operations

-- ============================================
-- METHOD 1: WASHING MACHINES
-- ============================================

RegisterNetEvent('shadow_elites:server:startWashingMachine', function(locationId, amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check if player has black money
    local blackMoney = exports.ox_inventory:Search(src, 'count', 'black_money')
    if blackMoney < amount then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = 'Not enough dirty money',
            type = 'error'
        })
    end
    
    -- Remove black money
    exports.ox_inventory:RemoveItem(src, 'black_money', amount)
    
    -- Calculate output and time
    local outputAmount = math.floor(amount * Config.Laundering.washingMachine.outputRate)
    local timeRequired = (amount / 1000) * Config.Laundering.washingMachine.timePerK -- seconds
    
    -- Create laundering operation in database
    MySQL.insert([[
        INSERT INTO laundering_operations 
        (identifier, method, input_type, input_amount, output_amount, start_time, complete_time)
        VALUES (?, 'washing_machine', 'black_money', ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? SECOND))
    ]], {
        Player.PlayerData.citizenid,
        amount,
        outputAmount,
        timeRequired
    }, function(operationId)
        if operationId then
            -- Track operation
            ActiveLaundering[operationId] = {
                src = src,
                identifier = Player.PlayerData.citizenid,
                outputAmount = outputAmount,
                completeAt = os.time() + timeRequired
            }
            
            -- Notify player
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Money Laundering',
                description = string.format('$%s laundering... Complete in %d minutes', 
                    exports.qbx_core:CommaValue(amount), math.ceil(timeRequired / 60)),
                type = 'success',
                duration = 7000
            })
            
            -- Set timer to complete
            SetTimeout(timeRequired * 1000, function()
                CompleteLaundering(operationId)
            end)
        end
    end)
end)

-- ============================================
-- METHOD 2: FRONT BUSINESSES
-- ============================================

RegisterNetEvent('shadow_elites:server:startBusinessLaundering', function(businessId, amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check level requirement
    if (Player.PlayerData.metadata.organized_level or 0) < Config.Laundering.frontBusiness.requiresLevel then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = string.format('Requires Organized Crime Level %d', 
                Config.Laundering.frontBusiness.requiresLevel),
            type = 'error'
        })
    end
    
    -- Check minimum batch size
    if amount < Config.Laundering.frontBusiness.batchSize then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = string.format('Minimum $%s per batch', 
                exports.qbx_core:CommaValue(Config.Laundering.frontBusiness.batchSize)),
            type = 'error'
        })
    end
    
    -- Check ownership of business
    MySQL.query('SELECT * FROM front_businesses WHERE id = ? AND identifier = ?', 
        {businessId, Player.PlayerData.citizenid}, function(result)
        if not result or not result[1] then
            return TriggerClientEvent('ox_lib:notify', src, {
                description = 'You don\'t own this business',
                type = 'error'
            })
        end
        
        -- Check if player has black money
        local blackMoney = exports.ox_inventory:Search(src, 'count', 'black_money')
        if blackMoney < amount then
            return TriggerClientEvent('ox_lib:notify', src, {
                description = 'Not enough dirty money',
                type = 'error'
            })
        end
        
        -- Remove black money
        exports.ox_inventory:RemoveItem(src, 'black_money', amount)
        
        -- Calculate output and time
        local batches = math.ceil(amount / Config.Laundering.frontBusiness.batchSize)
        local outputAmount = math.floor(amount * Config.Laundering.frontBusiness.outputRate)
        local timeRequired = batches * Config.Laundering.frontBusiness.timePerBatch
        
        -- Create laundering operation
        MySQL.insert([[
            INSERT INTO laundering_operations 
            (identifier, method, input_type, input_amount, output_amount, location_id, start_time, complete_time)
            VALUES (?, 'front_business', 'black_money', ?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? SECOND))
        ]], {
            Player.PlayerData.citizenid,
            amount,
            outputAmount,
            businessId,
            timeRequired
        }, function(operationId)
            if operationId then
                ActiveLaundering[operationId] = {
                    src = src,
                    identifier = Player.PlayerData.citizenid,
                    outputAmount = outputAmount,
                    completeAt = os.time() + timeRequired
                }
                
                TriggerClientEvent('ox_lib:notify', src, {
                    title = 'Business Laundering',
                    description = string.format('$%s laundering... Complete in %d minutes', 
                        exports.qbx_core:CommaValue(amount), math.ceil(timeRequired / 60)),
                    type = 'success',
                    duration = 7000
                })
                
                SetTimeout(timeRequired * 1000, function()
                    CompleteLaundering(operationId)
                end)
            end
        end)
    end)
end)

-- ============================================
-- METHOD 3: OFFSHORE ACCOUNTS
-- ============================================

RegisterNetEvent('shadow_elites:server:startOffshore', function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check level requirement
    if (Player.PlayerData.metadata.organized_level or 0) < Config.Laundering.offshore.requiresLevel then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = string.format('Requires Organized Crime Level %d', 
                Config.Laundering.offshore.requiresLevel),
            type = 'error'
        })
    end
    
    -- Check if player has marked bills
    local markedBills = exports.ox_inventory:Search(src, 'count', 'markedbills')
    if markedBills < amount then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = 'Not enough marked bills',
            type = 'error'
        })
    end
    
    -- Remove marked bills
    exports.ox_inventory:RemoveItem(src, 'markedbills', amount)
    
    -- Calculate output and time
    local outputAmount = math.floor(amount * Config.Laundering.offshore.outputRate)
    local timeRequired = (amount / 1000) * Config.Laundering.offshore.timePerK
    
    -- Police alert chance
    if math.random() < Config.Laundering.offshore.policeAlertChance then
        -- Alert police
        local coords = GetEntityCoords(GetPlayerPed(src))
        TriggerEvent('police:server:policeAlert', {
            coords = coords,
            title = 'Suspicious Wire Transfer',
            description = 'Large offshore wire transfer detected',
        })
    end
    
    -- Create laundering operation
    MySQL.insert([[
        INSERT INTO laundering_operations 
        (identifier, method, input_type, input_amount, output_amount, start_time, complete_time)
        VALUES (?, 'offshore', 'markedbills', ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? SECOND))
    ]], {
        Player.PlayerData.citizenid,
        amount,
        outputAmount,
        timeRequired
    }, function(operationId)
        if operationId then
            ActiveLaundering[operationId] = {
                src = src,
                identifier = Player.PlayerData.citizenid,
                outputAmount = outputAmount,
                completeAt = os.time() + timeRequired
            }
            
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Offshore Transfer',
                description = string.format('$%s transferring... Complete in %d minutes', 
                    exports.qbx_core:CommaValue(amount), math.ceil(timeRequired / 60)),
                type = 'success',
                duration = 7000
            })
            
            SetTimeout(timeRequired * 1000, function()
                CompleteLaundering(operationId)
            end)
        end
    end)
end)

-- ============================================
-- METHOD 4: BULK DROP (EMERGENCY)
-- ============================================

RegisterNetEvent('shadow_elites:server:bulkDrop', function(moneyType, amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check level requirement
    if (Player.PlayerData.metadata.organized_level or 0) < Config.Laundering.bulkDrop.requiresLevel then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = string.format('Requires Organized Crime Level %d', 
                Config.Laundering.bulkDrop.requiresLevel),
            type = 'error'
        })
    end
    
    -- Check cooldown
    local lastBulkDrop = Player.PlayerData.metadata.last_bulk_drop or 0
    if os.time() < lastBulkDrop + Config.Laundering.bulkDrop.cooldown then
        local remaining = math.ceil((lastBulkDrop + Config.Laundering.bulkDrop.cooldown - os.time()) / 3600)
        return TriggerClientEvent('ox_lib:notify', src, {
            description = string.format('Bulk drop on cooldown (%d hours remaining)', remaining),
            type = 'error'
        })
    end
    
    -- Validate money type
    if moneyType ~= 'black_money' and moneyType ~= 'markedbills' then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = 'Invalid money type',
            type = 'error'
        })
    end
    
    -- Check if player has the money
    local hasMoney = exports.ox_inventory:Search(src, 'count', moneyType)
    if hasMoney < amount then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = 'Not enough dirty money',
            type = 'error'
        })
    end
    
    -- Remove dirty money
    exports.ox_inventory:RemoveItem(src, moneyType, amount)
    
    -- Calculate output (70% return - INSTANT!)
    local outputAmount = math.floor(amount * Config.Laundering.bulkDrop.outputRate)
    
    -- Give clean money immediately
    exports.ox_inventory:AddItem(src, 'money', outputAmount)
    
    -- Set cooldown
    Player.Functions.SetMetaData('last_bulk_drop', os.time())
    
    -- Log to database
    MySQL.insert([[
        INSERT INTO laundering_operations 
        (identifier, method, input_type, input_amount, output_amount, status, start_time, complete_time)
        VALUES (?, 'bulk_drop', ?, ?, ?, 'completed', NOW(), NOW())
    ]], {
        Player.PlayerData.citizenid,
        moneyType,
        amount,
        outputAmount
    })
    
    -- Notify
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Emergency Bulk Drop',
        description = string.format('Laundered $%s instantly (30%% fee)', 
            exports.qbx_core:CommaValue(amount)),
        type = 'success',
        duration = 7000
    })
    
    -- Add XP
    TriggerEvent('shadow_elites:server:addXP', src, 'organized', math.floor(amount / 10000))
end)

-- ============================================
-- COMPLETE LAUNDERING OPERATION
-- ============================================

function CompleteLaundering(operationId)
    local operation = ActiveLaundering[operationId]
    if not operation then return end
    
    -- Update database
    MySQL.update([[
        UPDATE laundering_operations 
        SET status = 'completed'
        WHERE id = ?
    ]], {operationId})
    
    -- Find player
    local Player = exports.qbx_core:GetPlayerByCitizenId(operation.identifier)
    if Player then
        -- Give clean money
        exports.ox_inventory:AddItem(Player.PlayerData.source, 'money', operation.outputAmount)
        
        -- Notify
        TriggerClientEvent('ox_lib:notify', Player.PlayerData.source, {
            title = 'Laundering Complete',
            description = string.format('Received $%s clean money', 
                exports.qbx_core:CommaValue(operation.outputAmount)),
            type = 'success',
            duration = 7000
        })
        
        -- Add XP
        TriggerEvent('shadow_elites:server:addXP', Player.PlayerData.source, 'organized', 
            math.floor(operation.outputAmount / 10000))
        
        -- Update stats
        local totalLaundered = Player.PlayerData.metadata.total_money_laundered or 0
        Player.Functions.SetMetaData('total_money_laundered', totalLaundered + operation.outputAmount)
    end
    
    -- Remove from active operations
    ActiveLaundering[operationId] = nil
end

-- ============================================
-- CHECK ACTIVE LAUNDERING OPERATIONS
-- ============================================

lib.callback.register('shadow_elites:server:getActiveLaundering', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {} end
    
    local operations = {}
    MySQL.query([[
        SELECT * FROM laundering_operations 
        WHERE identifier = ? AND status = 'in_progress'
        ORDER BY start_time DESC
    ]], {Player.PlayerData.citizenid}, function(result)
        if result then
            for _, op in ipairs(result) do
                local timeRemaining = os.difftime(
                    os.time(op.complete_time), 
                    os.time()
                )
                
                table.insert(operations, {
                    id = op.id,
                    method = op.method,
                    inputAmount = op.input_amount,
                    outputAmount = op.output_amount,
                    timeRemaining = math.max(0, timeRemaining)
                })
            end
        end
    end)
    
    return operations
end)

-- ============================================
-- BUY FRONT BUSINESS
-- ============================================

RegisterNetEvent('shadow_elites:server:buyFrontBusiness', function(businessType, businessName, coords)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Find business price
    local businessConfig = nil
    for _, config in ipairs(Config.Laundering.frontBusiness.businessTypes) do
        if config.type == businessType then
            businessConfig = config
            break
        end
    end
    
    if not businessConfig then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = 'Invalid business type',
            type = 'error'
        })
    end
    
    -- Check if player has money
    local money = exports.ox_inventory:Search(src, 'count', 'money')
    if money < businessConfig.price then
        return TriggerClientEvent('ox_lib:notify', src, {
            description = string.format('Need $%s to purchase', 
                exports.qbx_core:CommaValue(businessConfig.price)),
            type = 'error'
        })
    end
    
    -- Remove money
    exports.ox_inventory:RemoveItem(src, 'money', businessConfig.price)
    
    -- Create business
    MySQL.insert([[
        INSERT INTO front_businesses 
        (identifier, business_type, business_name, location_coords)
        VALUES (?, ?, ?, ?)
    ]], {
        Player.PlayerData.citizenid,
        businessType,
        businessName,
        json.encode(coords)
    }, function(businessId)
        if businessId then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Business Purchased',
                description = string.format('You now own: %s', businessName),
                type = 'success',
                duration = 7000
            })
        end
    end)
end)

-- ============================================
-- RESOURCE START: Load active operations
-- ============================================

CreateThread(function()
    MySQL.query('SELECT * FROM laundering_operations WHERE status = "in_progress"', {}, function(result)
        if result then
            for _, op in ipairs(result) do
                local timeRemaining = os.difftime(
                    os.time(op.complete_time), 
                    os.time()
                )
                
                if timeRemaining > 0 then
                    ActiveLaundering[op.id] = {
                        identifier = op.identifier,
                        outputAmount = op.output_amount,
                        completeAt = os.time() + timeRemaining
                    }
                    
                    SetTimeout(timeRemaining * 1000, function()
                        CompleteLaundering(op.id)
                    end)
                else
                    -- Already expired, complete immediately
                    CompleteLaundering(op.id)
                end
            end
            
            print(string.format('^2[Shadow Elites]^7 Loaded %d active laundering operations', #result))
        end
    end)
end)