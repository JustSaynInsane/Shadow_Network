-- ============================================
-- SHADOW ELITES - SHADOW NPC APPEARANCE
-- Mysterious character with glowing green mask
-- ============================================

-- ============================================
-- SHADOW NPC OUTFIT (Based on screenshot)
-- ============================================

local ShadowOutfit = {
    components = {
        -- MASK (The glowing one - RESTRICTED!)
        [1] = {drawable = 137, texture = 4}, -- Green/black tactical mask
        
        -- JACKET
        [11] = {drawable = 385, texture = 0}, -- Black hooded jacket
        
        -- SHIRT
        [8] = {drawable = 15, texture = 0}, -- Black undershirt
        
        -- LEGS
        [4] = {drawable = 7, texture = 0}, -- Black tactical pants
        
        -- HANDS
        [3] = {drawable = 96, texture = 0}, -- Black gloves
        
        -- SHOES
        [6] = {drawable = 134, texture = 0}, -- Black tactical boots
        
        -- Other components (default/hidden)
        [0] = {drawable = 0, texture = 0},   -- Face (hidden by mask)
        [2] = {drawable = 0, texture = 0},   -- Hair (hidden by hood)
        [5] = {drawable = 0, texture = 0},   -- Bag (none)
        [7] = {drawable = 0, texture = 0},   -- Accessories (none)
        [9] = {drawable = 0, texture = 0},   -- Body armor (none)
        [10] = {drawable = 0, texture = 0},  -- Decals (none)
    },
    
    props = {
        [0] = {drawable = -1, texture = 0}, -- Hat (none - has hood)
        [1] = {drawable = -1, texture = 0}, -- Glasses (none - has mask)
        [2] = {drawable = -1, texture = 0}, -- Ear accessories (none)
        [6] = {drawable = -1, texture = 0}, -- Watch (none)
        [7] = {drawable = -1, texture = 0}, -- Bracelet (none)
    }
}

-- ============================================
-- CREATE SHADOW NPC WITH GLOWING MASK
-- ============================================

local function CreateShadowNPC(coords, heading)
    -- Use FREEMODE ped model (supports clothing changes!)
    local model = `mp_m_freemode_01`
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    -- Create the NPC
    local npc = CreatePed(4, model, coords.x, coords.y, coords.z, heading, false, true)
    
    -- Make invincible and stationary
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    
    -- Set ped as male (required for freemode model)
    SetPedDefaultComponentVariation(npc)
    
    -- ============================================
    -- APPLY OUTFIT FROM SCREENSHOT
    -- ============================================
    
    for component, data in pairs(ShadowOutfit.components) do
        SetPedComponentVariation(npc, component, data.drawable, data.texture, 0)
    end
    
    for prop, data in pairs(ShadowOutfit.props) do
        if data.drawable == -1 then
            ClearPedProp(npc, prop)
        else
            SetPedPropIndex(npc, prop, data.drawable, data.texture, true)
        end
    end
    
    -- ============================================
    -- GREEN GLOWING MASK EFFECT
    -- ============================================
    
    -- Method 1: Green particle effect on mask
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
        Wait(10)
    end
    
    UseParticleFxAssetNextCall("core")
    local particle = StartParticleFxLoopedOnEntityBone(
        "exp_grd_grenade_smoke",  -- Green smoke/glow effect
        npc,
        0.0, 0.0, 0.0,   -- Offset from bone
        0.0, 0.0, 0.0,   -- Rotation
        GetPedBoneIndex(npc, 31086), -- Head bone
        0.15,  -- Scale (subtle glow)
        false, false, false
    )
    
    -- Set particle color to GREEN
    SetParticleFxLoopedColour(particle, 0.0, 1.0, 0.0, false) -- RGB: Green
    
    -- Method 2: Green light source on mask
    CreateThread(function()
        while DoesEntityExist(npc) do
            local headPos = GetPedBoneCoords(npc, 31086, 0.0, 0.0, 0.0) -- Head bone position
            
            -- Draw green light emanating from mask
            DrawLightWithRange(
                headPos.x, headPos.y, headPos.z, -- Position
                0, 255, 0,  -- RGB: Bright green
                0.5,        -- Range (subtle glow)
                2.5         -- Intensity
            )
            
            Wait(0)
        end
    end)
    
    if Config.Debug then
        print('^2[Shadow Elites]^7 Created Shadow NPC with glowing green mask')
    end
    
    return npc, particle
end

exports('CreateShadowNPC', CreateShadowNPC)

-- ============================================
-- EXPORT OUTFIT DATA (for blacklisting)
-- ============================================

exports('GetShadowMask', function()
    return {
        drawable = 137,
        texture = 4
    }
end)