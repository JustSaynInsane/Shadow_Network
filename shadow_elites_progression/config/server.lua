-- ============================================
-- SHADOW ELITES - SERVER CONFIG
-- Server-only settings
-- ============================================

Config = Config or {}

-- ============================================
-- SAVE INTERVALS
-- ============================================

Config.Server = {
    -- How often to auto-save player data (milliseconds)
    autoSaveInterval = 600000, -- 10 minutes
    
    -- Maximum laundering operations per player
    maxLaunderingOperations = 3,
}

-- ============================================
-- ADMIN GROUPS
-- ============================================

Config.AdminGroups = {
    'admin',
    'god',
}

return Config