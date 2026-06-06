-- ============================================
-- SHADOW ELITES - UPDATED SHARED CONFIG
-- Corrected Level Requirements & Progression
-- ============================================

-- THIS REPLACES YOUR config/shared.lua FILE
-- Copy entire contents and replace!

Config = Config or {}

-- ============================================
-- FRAMEWORK SETTINGS
-- ============================================

Config.Framework = 'qbx'
Config.Inventory = 'ox_inventory'
Config.Phone = 'npwd'

-- ============================================
-- PROGRESSION SETTINGS
-- ============================================

Config.Progression = {
    -- XP required per level (0-10)
    xpPerLevel = {
        [0] = 0,
        [1] = 500,      -- Was 100 (5x slower)
        [2] = 1250,     -- Was 250 (5x slower)
        [3] = 2500,     -- Was 500 (5x slower)
        [4] = 4250,     -- Was 850 (5x slower)
        [5] = 6500,     -- Was 1300 (Shadow Network unlocks!)
        [6] = 9500,     -- Was 1900
        [7] = 13000,    -- Was 2600
        [8] = 17500,    -- Was 3500
        [9] = 23000,    -- Was 4600
        [10] = 30000,   -- Was 6000 (Max level = Legendary!)
    },
    
    skillPointsPerLevel = 1,
    maxLevel = 10,
}

-- ============================================
-- XP REWARDS (How much XP for each activity)
-- ============================================

Config.XPRewards = {
    -- NARCOTICS TREE
    narcotics = {
        -- TRASH SEARCHING (Level 0 - Base activity for BOTH trees!)
        trash_can = 3,           -- Trash cans also give +1 Organized XP
        recycling_bin = 4,       -- Also gives +1 Organized XP
        dumpster = 5,            -- Also gives +2 Organized XP
        
        -- DRUG ACTIVITIES
        corner_sale = 5,         -- Per drug sale
        delivery_complete = 15,  -- Per delivery
        weed_harvest = 8,        -- Per plant
        weed_sale = 3,
    },
    
    -- ORGANIZED CRIME TREE
    organized = {
        -- TRASH SEARCHING (Level 0 - Base activity for BOTH trees!)
        trash_can = 3,           -- Petty crime basics (also gives +3 Narcotics XP)
        recycling_bin = 4,       -- (also gives +4 Narcotics XP)
        dumpster = 5,            -- Bigger dumpsters (also gives +5 Narcotics XP)
        
        -- CRIMINAL ACTIVITIES
        house_robbery = 25,      -- Per house (from completeHouse event)
        store_robbery = 35,      -- NEW: 5 register + 10 holdup + 15 safe + 5 bonus
        bank_truck = 75,         -- NEW: Bank trucks (Level 3)
        fleeca_bank = 50,        -- Level 4: 6×8 lockers + 2 bonus
        paleto_bank = 50,        -- Level 4: 6×8 lockers + 2 bonus
        jewelry_store = 75,      -- Level 5: 8×8-11 vitrines + 15 bonus
        pacific_standard = 150,  -- Level 7: 15×10 lockers
    },
    
    -- AUTO THEFT TREE
    auto_theft = {
        vehicle_boost_d = 8,
        vehicle_boost_c = 15,
        vehicle_boost_b = 30,
        vehicle_boost_a = 45,
        vehicle_boost_s = 80,
        chop_shop = 10,
        vin_scratch = 25,
        race_win_d = 5,
        race_win_c = 10,
        race_win_b = 15,
        race_win_a = 20,
        race_win_s = 30,
    },
}

-- ============================================
-- SHADOW NETWORK SETTINGS
-- ============================================

Config.ShadowNetwork = {
    -- Shadow Network unlocks at Level 5 (any tree)
    unlockLevel = 5,
    unlockTree = 'any',
    
    -- NPC Settings
    npcMode = 'hybrid',
    npcModel = 'mp_m_freemode_01',
    
    -- Meeting Locations
    meetingLocations = {
        jewelry_unlocked = {
            coords = vector3(745.59, 1299.44, 359.3),
            heading = 183.82,
            scenario = 'WORLD_HUMAN_SMOKING',
            label = 'Secluded Overlook',
        },
        
        pacific_unlocked = {
            coords = vector3(745.59, 1299.44, 359.3),
            heading = 183.82,
            scenario = 'WORLD_HUMAN_GUARD_STAND',
            label = 'Shadow Contact',
        },
    },
}

-- ============================================
-- HEIST PROGRESSION GATES (UPDATED!)
-- ============================================

Config.HeistProgression = {
    -- HOUSE ROBBERY
    house_robbery = {
        requiredLevel = 1,
        requiredTree = 'organized',
        requiredCompletions = {},
        shadowUnlock = false,
    },
    
    -- STORE ROBBERY
    store_robbery = {
        requiredLevel = 2,
        requiredTree = 'organized',
        requiredCompletions = {},
        shadowUnlock = false,
    },
    
    -- BANK TRUCK (NEW GATEWAY!)
    bank_truck = {
        requiredLevel = 3,
        requiredTree = 'organized',
        requiredCompletions = {},
        shadowUnlock = false,
        description = 'Armored transport carrying cash',
    },
    
    -- FLEECA BANK (Requires 2 truck completions)
    fleeca_bank = {
        requiredLevel = 4,
        requiredTree = 'organized',
        requiredCompletions = {
            bank_truck = 2, -- Must complete 2 trucks first!
        },
        shadowUnlock = false,
        description = 'Small bank - prove yourself',
    },
    
    -- PALETO BANK (Requires 2 trucks + 3 Fleecas)
    paleto_bank = {
        requiredLevel = 4,
        requiredTree = 'organized',
        requiredCompletions = {
            bank_truck = 2,  -- Must complete 2 trucks
            fleeca_bank = 3, -- Must complete 3 Fleecas
        },
        shadowUnlock = false,
        description = 'Rural bank - higher risk',
    },
    
    -- ====================================
    -- SHADOW NETWORK TIER (Level 5+)
    -- ====================================
    
    -- JEWELRY STORE (Shadow Network unlocked!)
    jewelry_store = {
        requiredLevel = 5,
        requiredTree = 'organized',
        requiredCompletions = {
            fleeca_bank = 3, -- Must complete 3 Fleecas
        },
        shadowUnlock = true, -- Shadow Network message sent
        description = 'First Shadow Network job',
    },
    
    -- PACIFIC STANDARD (Elite tier!)
    pacific_standard = {
        requiredLevel = 7,
        requiredTree = 'organized',
        requiredCompletions = {
            fleeca_bank = 5, -- Must complete 5 Fleecas
            paleto_bank = 2, -- Must complete 2 Paletos
            jewelry_store = 1, -- Must complete jewelry once
        },
        shadowUnlock = true,
        description = 'The big one - elite status',
    },
}

-- ============================================
-- HEIST REQUIREMENTS (FULL CONFIG)
-- ============================================

Config.HeistRequirements = {
    house_robbery = {
        minLevel = 1,
        minCrew = 1,
        maxCrew = 5,
        requiredItems = {
            {item = 'lockpick', amount = 1, consumed = true},
        },
        cooldown = 0,
        duration = 300,
        xpReward = 25,
        unlockRequirement = nil,
    },
    
    store_robbery = {
        minLevel = 2,
        minCrew = 1,
        maxCrew = 5,
        requiredItems = {}, -- Just need a weapon
        cooldown = 0,
        duration = 300,
        xpReward = 35, -- NEW: 5+10+15+5
        unlockRequirement = nil,
    },
    
    bank_truck = {
        minLevel = 3,
        minCrew = 2,
        maxCrew = 5,
        requiredItems = {
            {item = 'c4_bomb', amount = 1, consumed = true},
        },
        cooldown = 1800,
        duration = 600,
        xpReward = 75, -- Gateway to banks!
        unlockRequirement = nil,
    },
    
    fleeca_bank = {
        minLevel = 4,
        minCrew = 1,
        maxCrew = 5,
        requiredItems = {
            {item = 'thermite', amount = 1, consumed = true}, -- Power box
            {item = 'alarm_hacker', amount = 1, consumed = true}, -- Alarm system
            {item = 'electronickit', amount = 1, consumed = true}, -- Vault hack
        },
        cooldown = 3600,
        duration = 900,
        xpReward = 50, -- NEW: 6×8 + 2 bonus
        unlockRequirement = nil,
        completionTracking = {
            field = 'heist_completions_fleeca_bank',
            required = 3, -- Need 3 for Paleto/Jewelry
        },
    },
    
    paleto_bank = {
        minLevel = 4,
        minCrew = 2,
        maxCrew = 5,
        requiredItems = {
            {item = 'thermite', amount = 2, consumed = true}, -- Power box + vault
            {item = 'alarm_hacker', amount = 1, consumed = true},
            {item = 'electronickit', amount = 1, consumed = true},
            {item = 'security_card_01', amount = 1, consumed = true},
        },
        cooldown = 3600,
        duration = 900,
        xpReward = 50,
        unlockRequirement = nil,
        completionTracking = {
            field = 'heist_completions_paleto_bank',
            required = 2, -- Need 2 for Pacific
        },
    },
    
    jewelry_store = {
        minLevel = 5,
        minCrew = 2,
        maxCrew = 5,
        requiredItems = {
            {item = 'thermite', amount = 1, consumed = true}, -- Power box
            {item = 'alarm_hacker', amount = 1, consumed = true},
            {item = 'gatecrack', amount = 1, consumed = true},
        },
        cooldown = 3600,
        duration = 900,
        xpReward = 75, -- NEW: 8×8-11 + 15 bonus
        unlockRequirement = 'shadow_network_unlocked', -- Shadow Network required!
        completionTracking = {
            field = 'heist_completions_jewelry_store',
            required = 1, -- Need 1 for Pacific
        },
    },
    
    pacific_standard = {
        minLevel = 7,
        minCrew = 3,
        maxCrew = 5,
        requiredItems = {
            {item = 'thermite', amount = 3, consumed = true}, -- Power box + 2 vaults
            {item = 'alarm_hacker', amount = 1, consumed = true},
            {item = 'security_card_02', amount = 2, consumed = true},
            {item = 'trojan_usb', amount = 2, consumed = true},
        },
        cooldown = 7200,
        duration = 900,
        xpReward = 150, -- Elite tier!
        unlockRequirement = 'shadow_network_unlocked',
    },
}

-- ============================================
-- BLACK MARKET ITEMS (Updated with alarm hacker!)
-- ============================================

Config.BlackMarketItems = {
    -- BASIC TOOLS
    {item = 'lockpick', price = 200, level = 0},
    {item = 'advancedlockpick', price = 500, level = 1},
    {item = 'screwdriver', price = 50, level = 0},
    
    -- HEIST EQUIPMENT
    {item = 'electronickit', price = 5000, level = 2},
    {item = 'alarm_hacker', price = 8000, level = 3}, -- NEW ITEM!
    {item = 'gatecrack', price = 10000, level = 5},
    {item = 'trojan_usb', price = 8000, level = 3},
    
    -- EXPLOSIVES
    {item = 'thermite', price = 20000, level = 3},
    {item = 'c4_bomb', price = 15000, level = 3},
    
    -- SECURITY CARDS
    {item = 'security_card_01', price = 15000, level = 3},
    {item = 'security_card_02', price = 25000, level = 5},
    
    -- WEAPONS (Level restricted!)
    {item = 'weapon_pistol', price = 5000, level = 1},
    {item = 'weapon_pistol50', price = 12000, level = 3},
    {item = 'weapon_smg', price = 25000, level = 5},
    {item = 'weapon_assaultrifle', price = 50000, level = 7},
    
    -- ARMOR
    {item = 'armor', price = 5000, level = 2},
    {item = 'heavy_armor', price = 15000, level = 5},
}

-- ============================================
-- LEVEL 10 BONUSES (Cross-tree rewards)
-- ============================================

Config.Level10Bonuses = {
    narcotics = {
        label = 'Drug Kingpin',
        description = 'Drug sales +20%, Laundering fees -10%',
        effects = {
            drugSaleBonus = 1.20,
            launderingFeeReduction = 0.10,
        },
    },
    
    organized = {
        label = 'Criminal Mastermind',
        description = 'Heist payouts +15%, Police alerts -20%',
        effects = {
            heistPayoutBonus = 1.15,
            policeAlertReduction = 0.20,
        },
    },
    
    auto_theft = {
        label = 'Master Thief',
        description = 'Boost payouts +20%, Lockpick success +15%',
        effects = {
            boostPayoutBonus = 1.20,
            lockpickSuccessBonus = 0.15,
        },
    },
}

-- ============================================
-- CREW SYSTEM
-- ============================================

Config.Crew = {
    maxMembers = 5,
    minMembersForHeist = 1,
    
    levelSystem = {
        mode = 'leader_only',
        xpScaling = {
            withinRange = {levels = 3, multiplier = 1.0},
            slightlyLow = {levels = 6, multiplier = 0.75},
            veryLow = {levels = 99, multiplier = 0.50},
        },
        moneyPenalty = false,
    },
}

-- ============================================
-- NOTIFICATIONS
-- ============================================

Config.Notifications = {
    showXPGain = true,
    showLevelUp = true,
    showShadowMessages = true,
    duration = 5000,
}

Config.Debug = true

-- ============================================
-- SKILL TREES
-- ============================================

Config.SkillTrees = {
    narcotics = {
        label = 'Narcotics',
        icon = '💊',
        color = '#00ff00',
        description = 'Drug dealing, production, and distribution',
    },
    
    organized = {
        label = 'Organized Crime',
        icon = '💰',
        color = '#ff0000',
        description = 'Heists, robberies, and money laundering',
    },
    
    auto_theft = {
        label = 'Auto Theft',
        icon = '🚗',
        color = '#0099ff',
        description = 'Vehicle boosting, chop shops, and VIN scratching',
    },
}

return Config