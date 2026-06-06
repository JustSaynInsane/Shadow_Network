Config = {}

-- ============================================
-- GENERAL SETTINGS
-- ============================================

Config.Framework = 'qbx' -- 'qbx', 'qb', 'esx', or 'standalone'
Config.Inventory = 'ox_inventory' -- Only ox_inventory supported for now

-- Search cooldown (how long before can search same trash again)
Config.SearchCooldown = 150 -- 5 minutes in seconds (300 = 5 mins)

-- Show blips on map for trash cans?
Config.ShowBlips = false -- Set to true if you want blips

-- Enable debug prints?
Config.Debug = true

-- ============================================
-- SEARCH TIMES
-- ============================================

Config.SearchTime = {
    trash_can = 5000,      -- 5 seconds to search trash can
    dumpster = 8000,       -- 8 seconds to search dumpster
    recycling_bin = 6000,  -- 6 seconds to search recycling
}

-- ============================================
-- LOOT TABLES
-- ============================================

Config.Loot = {
    -- TRASH CANS (Small bins, trash bags on street)
    trash_can = {
        -- Always get some junk
        guaranteed = {
            { item = 'garbage', min = 1, max = 3 },
        },
        
        -- Possible additional loot
        items = {
            -- BLUEPRINTS (15% total chance)
            { item = 'blueprint_lockpick',    chance = 8,  min = 1, max = 1 },  -- 8%
            { item = 'blueprint_bandage',     chance = 4,  min = 1, max = 1 },  -- 4%
            { item = 'blueprint_jerrycan',    chance = 2,  min = 1, max = 1 },  -- 2%
            { item = 'blueprint_repairkit',   chance = 1,  min = 1, max = 1 },  -- 1%
            
            -- MATERIALS (30% total chance)
            { item = 'plastic',               chance = 12, min = 1, max = 3 },  -- 12%
            { item = 'rubber',                chance = 8,  min = 1, max = 2 },  -- 8%
            { item = 'glass',                 chance = 6,  min = 1, max = 2 },  -- 6%
            
            -- RANDOM ITEMS (20% total chance)
            { item = 'cigarette',             chance = 8,  min = 1, max = 3 },  -- 8%
            { item = 'lighter',               chance = 5,  min = 1, max = 1 },  -- 5%
            { item = 'water',                 chance = 4,  min = 1, max = 1 },  -- 4%
            { item = 'sandwich',              chance = 3,  min = 1, max = 1 },  -- 3%
            
            -- MONEY (10% total chance)
            { item = 'money',                 chance = 10, min = 5, max = 25 },  -- 10%
        },
    },
    
    -- DUMPSTERS (Big green dumpsters)
    dumpster = {
        guaranteed = {
            { item = 'garbage', min = 2, max = 5 },
        },
        
        items = {
            -- BLUEPRINTS (20% total chance - better than trash cans)
            { item = 'blueprint_lockpick',        chance = 10, min = 1, max = 1 },  -- 10%
            { item = 'blueprint_bandage',         chance = 5,  min = 1, max = 1 },  -- 5%
            { item = 'blueprint_jerrycan',        chance = 3,  min = 1, max = 1 },  -- 3%
            { item = 'blueprint_repairkit',       chance = 2,  min = 1, max = 1 },  -- 2%
            { item = 'screwdriverset',            chance = 12, min = 1, max = 2 },  -- 15% chance
            
            -- MATERIALS (40% total chance)
            { item = 'plastic',                   chance = 15, min = 2, max = 5 },  -- 15%
            { item = 'rubber',                    chance = 10, min = 2, max = 4 },  -- 10%
            { item = 'glass',                     chance = 8,  min = 1, max = 3 },  -- 8%
            
            -- RANDOM ITEMS (25% total chance)
            { item = 'cigarette',                 chance = 10, min = 2, max = 5 },  -- 10%
            { item = 'lighter',                   chance = 6,  min = 1, max = 2 },  -- 6%
            { item = 'water',                     chance = 5,  min = 1, max = 2 },  -- 5%
            { item = 'burger',                    chance = 4,  min = 1, max = 1 },  -- 4%
            
            -- MONEY (15% total chance)
            { item = 'money',                     chance = 15, min = 10, max = 50 }, -- 15%
        },
    },
    
    -- RECYCLING BINS (Blue recycling bins)
    recycling_bin = {
        guaranteed = {
            { item = 'garbage', min = 1, max = 2 },
        },
        
        items = {
            -- BLUEPRINTS (12% total chance)
            { item = 'blueprint_lockpick',    chance = 5,  min = 1, max = 1 },
            { item = 'blueprint_bandage',     chance = 4,  min = 1, max = 1 },
            { item = 'blueprint_jerrycan',    chance = 2,  min = 1, max = 1 },
            { item = 'blueprint_repairkit',   chance = 1,  min = 1, max = 1 },
            
            -- MATERIALS (50% total chance - focus on recyclables)
            { item = 'plastic',               chance = 20, min = 2, max = 6 },  -- Lots of plastic
            { item = 'glass',                 chance = 15, min = 2, max = 5 },  -- Lots of glass
            { item = 'copper',                chance = 5,  min = 1, max = 2 },  -- Copper wire
            
            -- MONEY (8% total chance)
            { item = 'money',                 chance = 8,  min = 5, max = 30 },
        },
    },
}

-- ============================================
-- SEARCHABLE PROPS
-- ============================================

Config.Props = {
    -- TRASH CANS
    trash_can = {
        `prop_bin_01a`,
        `prop_bin_02a`,
        `prop_bin_03a`,
        `prop_bin_04a`,
        `prop_bin_05a`,
        `prop_bin_06a`,
        `prop_bin_07a`,
        `prop_bin_07b`,
        `prop_bin_07c`,
        `prop_bin_08a`,
        `prop_bin_08open`,
        `prop_bin_10a`,
        `prop_bin_10b`,
        `prop_bin_11a`,
        `prop_bin_11b`,
        `prop_bin_12a`,
        `prop_bin_13a`,
        `prop_bin_14a`,
        `prop_bin_14b`,
        `prop_cs_bin_01`,
        `prop_cs_bin_02`,
        `prop_cs_bin_03`,
        `zprop_bin_01a_old`,
    },
    
    -- DUMPSTERS
    dumpster = {
        `prop_dumpster_01a`,
        `prop_dumpster_02a`,
        `prop_dumpster_02b`,
        `prop_dumpster_3a`,
        `prop_dumpster_4a`,
        `prop_dumpster_4b`,
        `prop_cs_dumpster_01a`,
        `p_dumpster_t`,
    },
    
    -- RECYCLING BINS
    recycling_bin = {
        `prop_recyclebin_01a`,
        `prop_recyclebin_02a`,
        `prop_recyclebin_02b`,
        `prop_recyclebin_03_a`,
        `prop_recyclebin_04_a`,
        `prop_recyclebin_04_b`,
        `prop_recyclebin_05_a`,
    },
}

-- ============================================
-- NOTIFICATIONS
-- ============================================

Config.Notifications = {
    searching = {
        title = 'Searching',
        description = 'Digging through trash...',
        type = 'info',
        duration = 5000
    },
    
    found_blueprint = {
        title = '📜 Blueprint Found!',
        description = 'You found a %s!',
        type = 'success',
        duration = 8000
    },
    
    found_item = {
        title = 'Found Item',
        description = 'You found %sx %s',
        type = 'success',
        duration = 3000
    },
    
    found_nothing = {
        title = 'Nothing',
        description = 'Just garbage...',
        type = 'error',
        duration = 3000
    },
    
    on_cooldown = {
        title = 'Already Searched',
        description = 'This has been searched recently',
        type = 'error',
        duration = 3000
    },
    
    inventory_full = {
        title = 'Inventory Full',
        description = 'You cannot carry any more items',
        type = 'error',
        duration = 3000
    },
}
