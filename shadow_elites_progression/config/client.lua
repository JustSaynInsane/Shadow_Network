-- ============================================
-- SHADOW ELITES - CLIENT CONFIG
-- Client-only settings
-- ============================================

Config = Config or {}

-- ============================================
-- UI SETTINGS
-- ============================================

Config.Client = {
    -- Refresh progression data interval (milliseconds)
    refreshInterval = 30000, -- 30 seconds
    
    -- Show progression command
    showProgressionCommand = 'progression',
}

-- ============================================
-- WASHING MACHINE LOCATIONS (Week 2)
-- ============================================

Config.WashingMachines = {
    -- Example locations (add more in Week 2)
    {coords = vector3(-42.99, -1108.19, 26.42)}, -- Apartment building
}

-- ============================================
-- FRONT BUSINESS LOCATIONS (Week 2)
-- ============================================

Config.FrontBusinessLocations = {
    -- Car washes, laundromats, etc. (add in Week 2)
}

return Config