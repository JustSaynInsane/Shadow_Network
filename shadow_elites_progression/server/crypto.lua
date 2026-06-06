-- ============================================
-- SHADOW NETWORK - CRYPTOCURRENCY SYSTEM
-- Realistic Money Flow + Price Fluctuation
-- ============================================

local cryptoMarket = {
    currentPrice = 1.00,
    basePrice = 1.00,
    minPrice = 0.70,
    maxPrice = 1.50,
    lastUpdate = os.time(),
}

local activeExchanges = {} -- Track ongoing crypto purchases
local exchangeLocations = {} -- Rotating exchange spots

-- ============================================
-- EXCHANGE LOCATIONS (Rotate Weekly)
-- ============================================

local EXCHANGE_SPOTS = {
    {
        id = 'dock_warehouse',
        label = 'Abandoned Warehouse',
        coords = vector3(1087.71, -3099.27, 5.90),
        heading = 90.0,
        description = 'Shady warehouse near the docks',
    },
    {
        id = 'downtown_office',
        label = 'Tech Startup Office',
        coords = vector3(-141.97, -620.05, 168.82),
        heading = 340.0,
        description = 'Legitimate business front downtown',
    },
    {
        id = 'metro_server',
        label = 'Underground Server Room',
        coords = vector3(-594.64, -1629.72, 33.01),
        heading = 270.0,
        description = 'Hidden server farm in metro station',
    },
}

-- Current active exchange (rotates)
local currentExchange = 1

-- ============================================
-- PRICE FLUCTUATION SYSTEM
-- ============================================

CreateThread(function()
    -- Load initial price from database
    local result = MySQL.single.await('SELECT current_price FROM shadow_crypto_market WHERE date = CURDATE()')
    if result then
        cryptoMarket.currentPrice = tonumber(result.current_price)
    end
    
    -- Update price every hour
    while true do
        Wait(3600000) -- 1 hour
        
        -- Random daily change (-10% to +15%)
        local change = math.random(-10, 15) / 100
        
        -- Apply change
        cryptoMarket.currentPrice = cryptoMarket.currentPrice * (1 + change)
        
        -- Clamp to min/max
        if cryptoMarket.currentPrice < cryptoMarket.minPrice then
            cryptoMarket.currentPrice = cryptoMarket.minPrice
        elseif cryptoMarket.currentPrice > cryptoMarket.maxPrice then
            cryptoMarket.currentPrice = cryptoMarket.maxPrice
        end
        
        -- Save to database
        MySQL.update('UPDATE shadow_crypto_market SET current_price = ?, daily_change = ? WHERE date = CURDATE()', {
            cryptoMarket.currentPrice,
            change
        })
        
        -- Notify all online players
        TriggerClientEvent('shadow_crypto:client:priceUpdate', -1, cryptoMarket.currentPrice, change)
        
        print(string.format('^2[CRYPTO]^7 Price updated: $%.4f (%.2f%% change)', 
            cryptoMarket.currentPrice, change * 100))
    end
end)

-- ============================================
-- EVENT-BASED PRICE CHANGES
-- ============================================

RegisterNetEvent('shadow_crypto:server:eventPriceChange', function(eventType)
    local priceChange = 0
    
    if eventType == 'major_heist_success' then
        priceChange = 0.05 -- +5%
    elseif eventType == 'police_raid' then
        priceChange = -0.08 -- -8%
    elseif eventType == 'new_laundering_spot' then
        priceChange = 0.03 -- +3%
    elseif eventType == 'market_crash' then
        priceChange = -0.15 -- -15%
    elseif eventType == 'market_boom' then
        priceChange = 0.20 -- +20%
    end
    
    if priceChange ~= 0 then
        cryptoMarket.currentPrice = cryptoMarket.currentPrice * (1 + priceChange)
        
        -- Clamp
        if cryptoMarket.currentPrice < cryptoMarket.minPrice then
            cryptoMarket.currentPrice = cryptoMarket.minPrice
        elseif cryptoMarket.currentPrice > cryptoMarket.maxPrice then
            cryptoMarket.currentPrice = cryptoMarket.maxPrice
        end
        
        -- Save
        MySQL.update('UPDATE shadow_crypto_market SET current_price = ? WHERE date = CURDATE()', {
            cryptoMarket.currentPrice
        })
        
        -- Notify
        TriggerClientEvent('shadow_crypto:client:eventPriceChange', -1, eventType, cryptoMarket.currentPrice, priceChange)
    end
end)

-- ============================================
-- CRYPTO WALLET SYSTEM
-- ============================================

-- Create wallet (one-time purchase)
RegisterNetEvent('shadow_crypto:server:purchaseWallet', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check if already has wallet
    local existing = MySQL.single.await('SELECT wallet_address FROM shadow_crypto_wallets WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    if existing then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Already Have Wallet',
            description = 'You already own a crypto wallet',
            type = 'error'
        })
        return
    end
    
    -- Check payment (Shadow Network special: FREE for Level 5+)
    local organizedLevel = exports['shadow_elites_progression']:GetLevel(src, 'organized')
    
    if organizedLevel >= 5 then
        -- FREE for Shadow Network members!
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Wallet Issued',
            description = 'Shadow Network has provided you with a crypto wallet',
            type = 'success',
            duration = 8000
        })
    else
        -- $10,000 for non-Shadow members
        if Player.PlayerData.money.cash < 10000 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Insufficient Funds',
                description = 'Need $10,000 cash',
                type = 'error'
            })
            return
        end
        
        Player.Functions.RemoveMoney('cash', 10000)
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Wallet Purchased',
            description = 'Crypto wallet activated for $10,000',
            type = 'success'
        })
    end
    
    -- Generate wallet address
    local walletAddress = 'SHX' .. math.random(100000, 999999)
    
    -- Create wallet
    MySQL.insert('INSERT INTO shadow_crypto_wallets (citizenid, wallet_address, balance, created_at) VALUES (?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        walletAddress,
        0.00,
        os.time()
    })
    
    TriggerClientEvent('shadow_crypto:client:walletCreated', src, walletAddress)
end)

-- ============================================
-- BUYING CRYPTO (Physical Money Drop-off)
-- ============================================

RegisterNetEvent('shadow_crypto:server:startExchange', function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check if has wallet
    local wallet = MySQL.single.await('SELECT * FROM shadow_crypto_wallets WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    if not wallet then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'No Wallet',
            description = 'Purchase a crypto wallet first',
            type = 'error'
        })
        return
    end
    
    -- Check if has marked bills or black money
    local markedBills = exports.ox_inventory:Search(src, 'count', 'markedbills')
    local blackMoney = exports.ox_inventory:Search(src, 'count', 'black_money')
    
    if markedBills == 0 and blackMoney == 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'No Dirty Money',
            description = 'You need marked bills or black money to exchange',
            type = 'error'
        })
        return
    end
    
    -- Get current exchange location
    local exchangeSpot = EXCHANGE_SPOTS[currentExchange]
    
    -- Send player to exchange
    TriggerClientEvent('shadow_crypto:client:goToExchange', src, exchangeSpot, amount)
end)

RegisterNetEvent('shadow_crypto:server:dropOffMoney', function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Verify player is at exchange
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local exchangeSpot = EXCHANGE_SPOTS[currentExchange]
    
    if #(coords - exchangeSpot.coords) > 5.0 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Not At Exchange',
            description = 'Go to the exchange location',
            type = 'error'
        })
        return
    end
    
    -- Calculate how much to remove
    local remaining = amount
    local removed = 0
    
    -- Try marked bills first
    local markedBills = exports.ox_inventory:GetItem(src, 'markedbills')
    if markedBills then
        for _, item in pairs(markedBills) do
            if remaining <= 0 then break end
            
            local worth = item.metadata.worth or 0
            if worth <= remaining then
                exports.ox_inventory:RemoveItem(src, 'markedbills', 1, item.metadata, item.slot)
                removed = removed + worth
                remaining = remaining - worth
            end
        end
    end
    
    -- Then black money
    if remaining > 0 then
        local blackMoney = exports.ox_inventory:Search(src, 'count', 'black_money')
        local toRemove = math.min(blackMoney, remaining)
        exports.ox_inventory:RemoveItem(src, 'black_money', toRemove)
        removed = removed + toRemove
        remaining = remaining - toRemove
    end
    
    if removed == 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'No Money',
            description = 'You don\'t have enough dirty money',
            type = 'error'
        })
        return
    end
    
    -- Calculate crypto amount (with conversion rate)
    local conversionRate = math.random(90, 98) / 100 -- 90-98% conversion
    local cryptoAmount = (removed * conversionRate) / cryptoMarket.currentPrice
    
    -- Add crypto to wallet
    MySQL.update('UPDATE shadow_crypto_wallets SET balance = balance + ? WHERE citizenid = ?', {
        cryptoAmount,
        Player.PlayerData.citizenid
    })
    
    -- Log transaction
    MySQL.insert('INSERT INTO shadow_crypto_transactions (citizenid, transaction_type, amount, conversion_rate, cash_amount, timestamp, description) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        'buy',
        cryptoAmount,
        conversionRate,
        removed,
        os.time(),
        'Exchanged dirty money for crypto'
    })
    
    -- Notify player
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Exchange Complete',
        description = string.format('Exchanged $%d for %.2f crypto\nRate: %.0f%%', 
            removed, cryptoAmount, conversionRate * 100),
        type = 'success',
        duration = 10000
    })
    
    TriggerClientEvent('shadow_crypto:client:exchangeComplete', src, cryptoAmount, removed, conversionRate)
end)

-- ============================================
-- CRYPTO TO CLEAN CASH
-- ============================================

-- Method 1: Business Front (slow but safe)
RegisterNetEvent('shadow_crypto:server:investInBusiness', function(businessType, cryptoAmount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check crypto balance
    local wallet = MySQL.single.await('SELECT balance FROM shadow_crypto_wallets WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    if not wallet or wallet.balance < cryptoAmount then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Insufficient Crypto',
            description = string.format('Need %.2f crypto', cryptoAmount),
            type = 'error'
        })
        return
    end
    
    -- Remove crypto
    MySQL.update('UPDATE shadow_crypto_wallets SET balance = balance - ? WHERE citizenid = ?', {
        cryptoAmount,
        Player.PlayerData.citizenid
    })
    
    -- Calculate clean cash (80% conversion over 24-48 hours)
    local cleanAmount = (cryptoAmount * cryptoMarket.currentPrice) * 0.80
    local washTime = math.random(24, 48) * 3600 -- 24-48 hours
    
    -- Log investment
    MySQL.insert('INSERT INTO shadow_business_fronts (citizenid, business_type, business_name, investment, purchased_at, active) VALUES (?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        businessType,
        'Front Business #' .. math.random(1000, 9999),
        cryptoAmount,
        os.time(),
        1
    })
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Investment Made',
        description = string.format('Invested %.2f crypto. Clean cash ready in %d hours', 
            cryptoAmount, washTime / 3600),
        type = 'success',
        duration = 10000
    })
    
    -- Schedule payout
    SetTimeout(washTime * 1000, function()
        local targetPlayer = exports.qbx_core:GetPlayerByCitizenId(Player.PlayerData.citizenid)
        if targetPlayer then
            targetPlayer.Functions.AddMoney('bank', cleanAmount)
            TriggerClientEvent('ox_lib:notify', targetPlayer.PlayerData.source, {
                title = 'Business Revenue',
                description = string.format('$%d deposited to bank', cleanAmount),
                type = 'success',
                duration = 10000
            })
        else
            -- Offline, add to database
            MySQL.update('UPDATE players SET money = JSON_SET(money, "$.bank", JSON_EXTRACT(money, "$.bank") + ?) WHERE citizenid = ?', {
                cleanAmount,
                Player.PlayerData.citizenid
            })
        end
    end)
end)

-- Method 2: Casino Exchange (fast but risky)
RegisterNetEvent('shadow_crypto:server:casinoExchange', function(cryptoAmount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check crypto balance
    local wallet = MySQL.single.await('SELECT balance FROM shadow_crypto_wallets WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    if not wallet or wallet.balance < cryptoAmount then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Insufficient Crypto',
            description = string.format('Need %.2f crypto', cryptoAmount),
            type = 'error'
        })
        return
    end
    
    -- 10% chance cops investigate
    local investigated = math.random(1, 100) <= 10
    
    if investigated then
        -- Cops alerted!
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'CASINO ALERT',
            description = 'Large transaction flagged! Authorities notified!',
            type = 'error',
            duration = 10000
        })
        
        TriggerEvent('police:server:policeAlert', '[CASINO] Suspicious large crypto exchange detected')
        
        -- Still get money, but cops coming
    end
    
    -- Remove crypto
    MySQL.update('UPDATE shadow_crypto_wallets SET balance = balance - ? WHERE citizenid = ?', {
        cryptoAmount,
        Player.PlayerData.citizenid
    })
    
    -- Calculate clean cash (70-90% instant conversion)
    local conversionRate = math.random(70, 90) / 100
    local cleanAmount = (cryptoAmount * cryptoMarket.currentPrice) * conversionRate
    
    Player.Functions.AddMoney('cash', cleanAmount)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = investigated and 'Exchange Complete (FLAGGED!)' or 'Exchange Complete',
        description = string.format('Received $%d cash (%.0f%% rate)', 
            cleanAmount, conversionRate * 100),
        type = investigated and 'warning' or 'success',
        duration = 10000
    })
end)

-- Method 3: Shadow Network Exchange (best rate for Level 8+)
RegisterNetEvent('shadow_crypto:server:shadowExchange', function(cryptoAmount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Check level requirement
    local maxLevel = 0
    for _, tree in ipairs({'narcotics', 'organized', 'auto_theft'}) do
        local level = exports['shadow_elites_progression']:GetLevel(src, tree)
        if level > maxLevel then maxLevel = level end
    end
    
    if maxLevel < 8 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'Requires Level 8 in any skill tree',
            type = 'error'
        })
        return
    end
    
    -- Check crypto balance
    local wallet = MySQL.single.await('SELECT balance FROM shadow_crypto_wallets WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    if not wallet or wallet.balance < cryptoAmount then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Insufficient Crypto',
            description = string.format('Need %.2f crypto', cryptoAmount),
            type = 'error'
        })
        return
    end
    
    -- Remove crypto
    MySQL.update('UPDATE shadow_crypto_wallets SET balance = balance - ? WHERE citizenid = ?', {
        cryptoAmount,
        Player.PlayerData.citizenid
    })
    
    -- Best conversion rate (95%)
    local cleanAmount = (cryptoAmount * cryptoMarket.currentPrice) * 0.95
    
    Player.Functions.AddMoney('bank', cleanAmount)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Shadow Exchange',
        description = string.format('Received $%d (95%% rate - Shadow Network premium)', cleanAmount),
        type = 'success',
        duration = 10000
    })
end)

-- ============================================
-- RACING SYSTEM INTEGRATION (Crypto Only)
-- ============================================

lib.callback.register('shadow_crypto:server:hasEnoughForRace', function(source, entryFee)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end
    
    local wallet = MySQL.single.await('SELECT balance FROM shadow_crypto_wallets WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    return wallet and wallet.balance >= entryFee
end)

RegisterNetEvent('shadow_crypto:server:chargeRaceEntry', function(entryFee)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    MySQL.update('UPDATE shadow_crypto_wallets SET balance = balance - ? WHERE citizenid = ?', {
        entryFee,
        Player.PlayerData.citizenid
    })
    
    -- Log transaction
    MySQL.insert('INSERT INTO shadow_crypto_transactions (citizenid, transaction_type, amount, timestamp, description) VALUES (?, ?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        'race_entry',
        entryFee,
        os.time(),
        'Race entry fee'
    })
end)

RegisterNetEvent('shadow_crypto:server:payRaceWinnings', function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    MySQL.update('UPDATE shadow_crypto_wallets SET balance = balance + ? WHERE citizenid = ?', {
        amount,
        Player.PlayerData.citizenid
    })
    
    -- Log transaction
    MySQL.insert('INSERT INTO shadow_crypto_transactions (citizenid, transaction_type, amount, timestamp, description) VALUES (?, ?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        'race_win',
        amount,
        os.time(),
        'Race winnings'
    })
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Race Victory!',
        description = string.format('Won %.2f crypto!', amount),
        type = 'success',
        duration = 8000
    })
end)

-- ============================================
-- CALLBACKS & EXPORTS
-- ============================================

lib.callback.register('shadow_crypto:server:getBalance', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return 0 end
    
    local wallet = MySQL.single.await('SELECT balance FROM shadow_crypto_wallets WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    return wallet and wallet.balance or 0
end)

lib.callback.register('shadow_crypto:server:getCurrentPrice', function()
    return cryptoMarket.currentPrice
end)

exports('GetCryptoPrice', function()
    return cryptoMarket.currentPrice
end)

exports('GetCryptoBalance', function(citizenid)
    local wallet = MySQL.single.await('SELECT balance FROM shadow_crypto_wallets WHERE citizenid = ?', {citizenid})
    return wallet and wallet.balance or 0
end)

-- ============================================
-- ROTATE EXCHANGE LOCATION (Weekly)
-- ============================================

CreateThread(function()
    while true do
        Wait(604800000) -- 1 week
        
        currentExchange = currentExchange + 1
        if currentExchange > #EXCHANGE_SPOTS then
            currentExchange = 1
        end
        
        local newSpot = EXCHANGE_SPOTS[currentExchange]
        TriggerClientEvent('shadow_crypto:client:exchangeMoved', -1, newSpot)
        
        print(string.format('^2[CRYPTO]^7 Exchange location rotated to: %s', newSpot.label))
    end
end)

-- ============================================
-- STARTUP
-- ============================================

print('^2[CRYPTO]^7 Cryptocurrency system loaded')
print('^2[CRYPTO]^7 Current price: $' .. string.format('%.4f', cryptoMarket.currentPrice))
print('^2[CRYPTO]^7 Exchange location: ' .. EXCHANGE_SPOTS[currentExchange].label)
print('^2[CRYPTO]^7 Conversion methods: Business (80% slow), Casino (70-90% fast risky), Shadow (95% L8+)')