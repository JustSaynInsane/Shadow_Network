-- ============================================
-- SHADOW ELITES - MONEY LAUNDERING (CLIENT)
-- Client-side laundering interactions
-- ============================================

-- ============================================
-- MONEY LAUNDERING LOCATION
-- ============================================

CreateThread(function()
    -- Underground location
    exports.ox_target:addBoxZone({
        coords = vec3(-1454.32, -411.39, 35.91),
        size = vec3(3, 3, 2),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'launder_money',
                icon = 'fa-solid fa-money-bill-transfer',
                label = 'Launder Money',
                onSelect = function()
                    openLaunderMenu()
                end
            },
            {
                name = 'sell_jewelry',
                icon = 'fa-solid fa-gem',
                label = 'Sell Jewelry',
                onSelect = function()
                    openFenceMenu()
                end
            }
        }
    })
end)

-- ============================================
-- LAUNDER MENU
-- ============================================

function openLaunderMenu()
    lib.callback('shadow_elites:server:getLaunderableAmounts', false, function(amounts)
        if not amounts or not amounts.hasAny then
            lib.notify({
                description = 'You have no dirty money to launder.',
                type = 'error'
            })
            return
        end
        
        local options = {}
        
        -- Black money option
        if amounts.blackMoney > 0 then
            local cleanAmount = math.floor(amounts.blackMoney * 0.90)
            local fee = amounts.blackMoney - cleanAmount
            
            table.insert(options, {
                title = '💵 Launder Black Money',
                description = string.format('Amount: $%s\nFee (10%%): $%s\nClean: $%s',
                    lib.math.groupdigits(amounts.blackMoney),
                    lib.math.groupdigits(fee),
                    lib.math.groupdigits(cleanAmount)),
                icon = 'money-bill',
                onSelect = function()
                    lib.callback('shadow_elites:server:launderMoney', false, function(result)
                        if result.success then
                            lib.notify({
                                title = 'Money Laundered',
                                description = result.message,
                                type = 'success',
                                duration = 7000
                            })
                            
                            -- Reopen menu if they have more
                            Wait(500)
                            openLaunderMenu()
                        else
                            lib.notify({
                                description = result.message,
                                type = 'error'
                            })
                        end
                    end, 'black_money', amounts.blackMoney)
                end
            })
        end
        
        -- Marked bills option
        if amounts.markedBills > 0 then
            local cleanAmount = math.floor(amounts.markedBills * 0.85)
            local fee = amounts.markedBills - cleanAmount
            
            table.insert(options, {
                title = '💰 Launder Marked Bills',
                description = string.format('Amount: $%s\nFee (15%%): $%s\nClean: $%s',
                    lib.math.groupdigits(amounts.markedBills),
                    lib.math.groupdigits(fee),
                    lib.math.groupdigits(cleanAmount)),
                icon = 'money-bill-transfer',
                iconColor = '#ff6b6b',
                onSelect = function()
                    lib.callback('shadow_elites:server:launderMoney', false, function(result)
                        if result.success then
                            lib.notify({
                                title = 'Money Laundered',
                                description = result.message,
                                type = 'success',
                                duration = 7000
                            })
                            
                            -- Reopen menu
                            Wait(500)
                            openLaunderMenu()
                        else
                            lib.notify({
                                description = result.message,
                                type = 'error'
                            })
                        end
                    end, 'markedbills', amounts.markedBills)
                end
            })
        end
        
        lib.registerContext({
            id = 'launder_menu',
            title = '💵 Money Laundering',
            options = options
        })
        
        lib.showContext('launder_menu')
    end)
end

-- ============================================
-- JEWELRY FENCE MENU
-- ============================================

function openFenceMenu()
    lib.callback('shadow_elites:server:getJewelryInventory', false, function(jewelry)
        if not jewelry or #jewelry == 0 then
            lib.notify({
                description = 'You have no jewelry to sell.',
                type = 'error'
            })
            return
        end
        
        local options = {}
        
        for _, item in ipairs(jewelry) do
            table.insert(options, {
                title = string.format('%s (x%d)', item.label, item.count),
                description = string.format('Value: $%s each\nFence pays: $%s (85%%)\nTotal: $%s',
                    lib.math.groupdigits(item.value),
                    lib.math.groupdigits(item.fencePrice),
                    lib.math.groupdigits(item.fencePrice * item.count)),
                icon = 'gem',
                iconColor = '#ffd700',
                onSelect = function()
                    -- Confirm sale
                    local alert = lib.alertDialog({
                        header = 'Sell Jewelry?',
                        content = string.format('Sell all %dx %s for $%s?',
                            item.count,
                            item.label,
                            lib.math.groupdigits(item.fencePrice * item.count)),
                        centered = true,
                        cancel = true
                    })
                    
                    if alert == 'confirm' then
                        lib.callback('shadow_elites:server:sellJewelry', false, function(result)
                            if result.success then
                                lib.notify({
                                    title = 'Jewelry Sold',
                                    description = result.message,
                                    type = 'success'
                                })
                                
                                -- Reopen menu
                                Wait(500)
                                openFenceMenu()
                            else
                                lib.notify({
                                    description = result.message,
                                    type = 'error'
                                })
                            end
                        end, item.name)
                    end
                end
            })
        end
        
        lib.registerContext({
            id = 'fence_menu',
            title = '💎 Underground Fence',
            options = options
        })
        
        lib.showContext('fence_menu')
    end)
end