fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Shadow Elites - Criminal Progression'
author 'Shadow Elites RP'
version '1.0.0'
description 'Complete criminal progression system with Shadow Network integration'

-- ============================================
-- DEPENDENCIES
-- ============================================

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_inventory',
    'oxmysql',
}

-- ============================================
-- SHARED FILES
-- ============================================

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config/shared.lua',
}

-- ============================================
-- CLIENT FILES
-- ============================================

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'config/client.lua',
    'client/main.lua',
    'client/shadow_app.lua',
    'client/shadow_appearance.lua',
    'client/npc_control.lua',
    'client/laundering.lua',
    'client/crew_ui.lua', -- Week 2: Crew management UI
    'client/heist_plans.lua',
    'client/lore.lua',
}

-- ============================================
-- SERVER FILES
-- ============================================

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/server.lua',
    'server/main.lua',
    'server/progression.lua',
    'server/laundering.lua',
    'server/shadow_network.lua',
    'server/crews.lua',
    'server/heist_activation.lua',
    'server/leadership.lua',
    'server/crypto.lua',
    'server/lore.lua',
}

files {
    'data/lore_data.lua',
    'data/lore_fragments.lua',
    'data/physical_notes.lua',
    'data/classified_documents.lua',
    'data/legendary_artifacts.lua',
}