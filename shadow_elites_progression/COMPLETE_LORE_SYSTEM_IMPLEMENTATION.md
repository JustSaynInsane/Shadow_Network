# 🔥 COMPLETE LORE SYSTEM - IMPLEMENTATION GUIDE

**Everything your backend chat needs to build the entire lore system!** 📚💎

---

## 📊 LORE SYSTEM OVERVIEW:

### **Total Items: 88**

| Category | Count | Purpose |
|----------|-------|---------|
| USB Drives | 25 | Main story fragments (Shadow Network history) |
| Physical Notes | 40 | World collectibles (environmental storytelling) |
| Classified Documents | 15 | High-risk items (government/corporate files) |
| Legendary Artifacts | 11 | Endgame items (4 Horsemen + 7 Sins) |

---

## 📁 FILES PROVIDED:

### **1. COMPLETE_PHYSICAL_NOTES.lua**
**All 40 physical notes with:**
- Full content text
- Spawn locations (coordinates)
- Drop methods
- Rarity levels

**Categories:**
- 10 Burnt Papers (fire-damaged)
- 15 Torn/Crumpled Papers (discarded items)
- 8 Bloodstained Papers (crime scenes)
- 7 Water-Damaged Papers (near water)

### **2. COMPLETE_CLASSIFIED_DOCUMENTS.lua**
**All 15 classified documents with:**
- Full content text (investigation reports, case files)
- Spawn locations (government buildings)
- Risk levels (wanted level on acquisition)
- Rarity levels

**Categories:**
- 5 LSPD Files (police investigations)
- 5 Government Files (FBI, DEA, IRS, DOJ)
- 3 Corporate Files (bank, casino, port)
- 2 Personal Files (diary, resignation letter)

### **3. COMPLETE_LEGENDARY_ARTIFACTS.lua**
**All 11 legendary artifacts with:**
- Full descriptions (appearance, lore)
- Acquisition methods
- Game effects/buffs
- Display properties (visual/sound)

**Categories:**
- 4 Horsemen Artifacts (WAR, FAMINE, CONQUEST, DEATH)
- 7 Sin Artifacts (GREED, WRATH, ENVY, PRIDE, LUST, GLUTTONY, SLOTH)

### **4. SHADOW_LORE_FRAGMENTS.lua** (Already provided)
**All 25 USB drives with:**
- Complete story fragments
- Unlock conditions
- Level requirements

---

## 🗄️ DATABASE SCHEMA:

### **Table: shadow_lore_collected**

```sql
CREATE TABLE IF NOT EXISTS `shadow_lore_collected` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(50) NOT NULL,
  `lore_type` ENUM('usb', 'note', 'document', 'artifact') NOT NULL,
  `lore_id` INT NOT NULL,
  `found_location` VARCHAR(100),
  `found_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `read_count` INT DEFAULT 0,
  `last_read` TIMESTAMP NULL,
  
  INDEX `idx_identifier` (`identifier`),
  INDEX `idx_lore_type` (`lore_type`),
  INDEX `idx_found_date` (`found_date`),
  UNIQUE KEY `player_lore` (`identifier`, `lore_type`, `lore_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player lore collection tracking (88 total items)';
```

---

## 🎯 DROP METHODS EXPLAINED:

### **Method 1: World Spawns (30 items)**

**What it means:**
Items spawn in specific locations in the world. Players must physically find them.

**Implementation:**
```lua
-- Create pickup blip
local pickup = CreateObject(
    GetHashKey('prop_paper_bag_small'),
    coords.x, coords.y, coords.z,
    true, false, false
)

-- Interaction target
exports.ox_target:addLocalEntity(pickup, {
    {
        name = 'collect_lore',
        icon = 'fa-solid fa-file',
        label = 'Collect Document',
        onSelect = function()
            TriggerServerEvent('shadow_lore:server:collect', loreType, loreId)
        end
    }
})
```

**Examples:**
- Burnt papers in fire barrels
- Notes in trash cans
- Documents in filing cabinets
- Items on desks/tables

### **Method 2: Heist Rewards (15 items)**

**What it means:**
Items are guaranteed rewards for completing specific heists.

**Implementation:**
```lua
-- After heist completion
TriggerEvent('shadow_lore:server:giveHeistReward', source, heistType)

-- Server-side
RegisterServerEvent('shadow_lore:server:giveHeistReward')
AddEventHandler('shadow_lore:server:giveHeistReward', function(source, heistType)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if heistType == 'fleeca' then
        GiveLoreItem(Player.PlayerData.citizenid, 'usb', 1)
    elseif heistType == 'jewelry' then
        GiveLoreItem(Player.PlayerData.citizenid, 'usb', 10)
    elseif heistType == 'pacific' then
        GiveLoreItem(Player.PlayerData.citizenid, 'artifact', 1)
    end
end)
```

**Examples:**
- USB #1: First Fleeca completion
- USB #10: First Jewelry completion
- Artifact: Pacific Standard flawless

### **Method 3: Random Drops (20 items)**

**What it means:**
5-10% chance to drop on any heist/job completion.

**Implementation:**
```lua
-- After job completion
local chance = math.random(1, 100)
if chance <= 5 then -- 5% drop rate
    local randomNote = GetRandomUncolledNote(citizenid)
    if randomNote then
        GiveLoreItem(citizenid, 'note', randomNote.id)
    end
end
```

**Examples:**
- Random notes after heists
- Random documents from high-tier jobs
- Increased chance for higher-level activities

### **Method 4: High Risk Locations (15 items)**

**What it means:**
Items located in police station, government buildings. Taking them triggers wanted level.

**Implementation:**
```lua
-- When item taken
TriggerEvent('shadow_lore:server:collectDocument', source, docId)

-- Server-side
RegisterServerEvent('shadow_lore:server:collectDocument')
AddEventHandler('shadow_lore:server:collectDocument', function(source, docId)
    local document = GetDocument(docId)
    
    if document.risk_level == "HIGH" then
        -- Give wanted level
        TriggerClientEvent('police:SetCopCount', source, 4) -- 4 stars
        
        -- Alert police
        TriggerEvent('police:server:DocumentStolen', source, document.title)
    end
    
    -- Give lore item
    GiveLoreItem(GetIdentifier(source), 'document', docId)
end)
```

**Examples:**
- LSPD files from police station
- FBI files from FIB building
- IRS files from tax office

### **Method 5: Level Milestones (10 items)**

**What it means:**
Automatic rewards when reaching specific levels.

**Implementation:**
```lua
-- In your AddXP function (when leveling up)
if leveledUp then
    -- Check for lore rewards
    if skillTree == 'narcotics' and newLevel == 5 then
        GiveLoreItem(citizenid, 'usb', 7) -- FAMINE USB
    elseif skillTree == 'organized' and newLevel == 5 then
        GiveLoreItem(citizenid, 'usb', 6) -- WAR USB
    elseif skillTree == 'auto_theft' and newLevel == 5 then
        GiveLoreItem(citizenid, 'usb', 8) -- CONQUEST USB
    end
    
    -- Check for artifact rewards
    if newLevel == 10 then
        if skillTree == 'narcotics' then
            GiveLoreItem(citizenid, 'artifact', 2) -- FAMINE's Scale
        elseif skillTree == 'organized' then
            -- Special challenge for WAR's Coin
        elseif skillTree == 'auto_theft' then
            GiveLoreItem(citizenid, 'artifact', 3) -- CONQUEST's Trophy
        end
    end
end
```

### **Method 6: Black Market Purchase (8 items)**

**What it means:**
Specific lore items available for purchase from Black Market at high levels.

**Implementation:**
```lua
-- Add to Black Market catalog
{
    id = 'bm_lore_usb_22',
    name = 'Encrypted USB Drive',
    description = 'Contains Shadow Network philosophy',
    category = 'special',
    price = 25000, -- crypto
    level = 7,
    item_name = 'shadow_usb_22'
}
```

---

## 💾 OX_INVENTORY ITEMS:

### **USB Drives (25 items)**

```lua
-- items.lua in ox_inventory
['shadow_usb_01'] = {
    label = 'Encrypted USB Drive',
    weight = 10,
    stack = false,
    description = 'Fragment 01: The Beginning',
    client = {
        export = 'shadow_lore.useUSB'
    }
},
['shadow_usb_02'] = {
    label = 'Encrypted USB Drive',
    weight = 10,
    stack = false,
    description = 'Fragment 02: First Blood',
    client = {
        export = 'shadow_lore.useUSB'
    }
},
-- ... repeat for all 25 USBs
```

### **Physical Notes (40 items)**

```lua
['shadow_note_burnt_01'] = {
    label = 'Burnt Note',
    weight = 1,
    stack = false,
    description = 'Partially burnt paper with faded writing',
    client = {
        export = 'shadow_lore.readNote'
    }
},
['shadow_note_torn_11'] = {
    label = 'Torn Ledger Page',
    weight = 1,
    stack = false,
    description = 'Monthly profit records',
    client = {
        export = 'shadow_lore.readNote'
    }
},
-- ... etc for all 40 notes
```

### **Classified Documents (15 items)**

```lua
['shadow_doc_lspd_01'] = {
    label = 'LSPD Internal Memo',
    weight = 5,
    stack = false,
    description = 'CLASSIFIED - High risk to possess!',
    client = {
        export = 'shadow_lore.readDocument'
    }
},
-- ... etc for all 15 documents
```

### **Legendary Artifacts (11 items)**

```lua
['shadow_artifact_war_coin'] = {
    label = "WAR's Challenge Coin",
    weight = 50,
    stack = false,
    description = 'Blood-red military coin - Symbol of elite heist status',
    client = {
        export = 'shadow_lore.examineArtifact'
    }
},
['shadow_artifact_famine_scale'] = {
    label = "FAMINE's Ancient Scale",
    weight = 500,
    stack = false,
    description = 'Tarnished brass scale - Symbol of narcotics empire',
    client = {
        export = 'shadow_lore.examineArtifact'
    }
},
-- ... etc for all 11 artifacts
```

---

## 🎮 CLIENT-SIDE EXPORTS:

### **Using USB Drives**

```lua
-- client/lore.lua
exports('useUSB', function(data, slot)
    local usbId = tonumber(string.match(data.name, '%d+'))
    
    -- Play animation
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    
    -- Wait for animation
    Wait(3000)
    
    -- Open tablet to lore tab with USB
    SendNUIMessage({
        action = 'openLoreTab',
        usbId = usbId
    })
    
    -- Mark as collected
    TriggerServerEvent('shadow_lore:server:collectUSB', usbId)
    
    -- Clear animation
    ClearPedTasks(PlayerPedId())
end)
```

### **Reading Notes**

```lua
exports('readNote', function(data, slot)
    local noteId = tonumber(string.match(data.name, '%d+'))
    local noteType = string.match(data.name, 'note_(%a+)_')
    
    -- Get note content from server
    local note = lib.callback.await('shadow_lore:server:getNote', false, noteType, noteId)
    
    -- Display in UI
    SendNUIMessage({
        action = 'displayNote',
        title = note.title,
        content = note.content
    })
    
    -- Mark as collected
    TriggerServerEvent('shadow_lore:server:collectNote', noteType, noteId)
end)
```

### **Reading Documents**

```lua
exports('readDocument', function(data, slot)
    local docId = tonumber(string.match(data.name, '%d+'))
    
    -- Get document
    local doc = lib.callback.await('shadow_lore:server:getDocument', false, docId)
    
    -- Display in UI
    SendNUIMessage({
        action = 'displayDocument',
        title = doc.title,
        content = doc.content,
        risk = doc.risk_level
    })
    
    -- Mark as collected
    TriggerServerEvent('shadow_lore:server:collectDocument', docId)
end)
```

### **Examining Artifacts**

```lua
exports('examineArtifact', function(data, slot)
    local artifactId = tonumber(string.match(data.name, '%d+'))
    
    -- Get artifact details
    local artifact = lib.callback.await('shadow_lore:server:getArtifact', false, artifactId)
    
    -- Display detailed view
    SendNUIMessage({
        action = 'displayArtifact',
        name = artifact.name,
        description = artifact.description,
        lore = artifact.lore,
        effect = artifact.game_effect
    })
    
    -- Mark as collected
    TriggerServerEvent('shadow_lore:server:collectArtifact', artifactId)
end)
```

---

## 🖥️ SERVER-SIDE FUNCTIONS:

### **Core Collection Function**

```lua
-- server/lore.lua

function GiveLoreItem(citizenid, loreType, loreId, location)
    -- Check if already collected
    local exists = MySQL.scalar.await(
        'SELECT id FROM shadow_lore_collected WHERE identifier = ? AND lore_type = ? AND lore_id = ?',
        {citizenid, loreType, loreId}
    )
    
    if exists then
        return false -- Already have it
    end
    
    -- Insert into database
    MySQL.insert(
        'INSERT INTO shadow_lore_collected (identifier, lore_type, lore_id, found_location) VALUES (?, ?, ?, ?)',
        {citizenid, loreType, loreId, location or 'Unknown'}
    )
    
    -- Give physical item
    local Player = GetPlayerFromCitizenId(citizenid)
    if Player then
        local itemName = GetLoreItemName(loreType, loreId)
        Player.Functions.AddItem(itemName, 1)
        
        -- Notification
        TriggerClientEvent('shadow_lore:client:fragmentUnlocked', Player.PlayerData.source, {
            type = loreType,
            id = loreId,
            title = GetLoreTitle(loreType, loreId)
        })
    end
    
    -- Check for collection milestones
    CheckCollectionMilestones(citizenid)
    
    return true
end

exports('GiveLoreItem', GiveLoreItem)
```

### **Collection Progress**

```lua
function GetCollectionProgress(citizenid)
    local collected = MySQL.query.await(
        'SELECT lore_type, lore_id FROM shadow_lore_collected WHERE identifier = ?',
        {citizenid}
    )
    
    local progress = {
        usb = {collected = 0, total = 25},
        note = {collected = 0, total = 40},
        document = {collected = 0, total = 15},
        artifact = {collected = 0, total = 11},
        total = {collected = 0, total = 88}
    }
    
    for _, item in ipairs(collected) do
        progress[item.lore_type].collected = progress[item.lore_type].collected + 1
        progress.total.collected = progress.total.collected + 1
    end
    
    return progress
end

exports('GetCollectionProgress', GetCollectionProgress)
```

### **Milestone Rewards**

```lua
function CheckCollectionMilestones(citizenid)
    local progress = GetCollectionProgress(citizenid)
    local Player = GetPlayerFromCitizenId(citizenid)
    
    -- 10 items collected
    if progress.total.collected == 10 then
        Player.Functions.AddMoney('cash', 50000)
        -- Award "Collector" title
    end
    
    -- All USBs collected
    if progress.usb.collected == 25 then
        -- Give permanent +5% XP boost
        MySQL.update(
            'UPDATE shadow_progression SET xp_bonus = xp_bonus + 0.05 WHERE identifier = ?',
            {citizenid}
        )
    end
    
    -- All notes collected
    if progress.note.collected == 40 then
        -- Give exclusive tattoo
        -- (integration with tattoo system)
    end
    
    -- All documents collected
    if progress.document.collected == 15 then
        -- Unlock hidden heist
        -- (flag in database)
    end
    
    -- All artifacts collected
    if progress.artifact.collected == 11 then
        -- "Eighth Sin" eligibility (admin consideration)
        -- Mark player as legendary
    end
    
    -- ALL 88 items collected
    if progress.total.collected == 88 then
        Player.Functions.AddMoney('crypto', 1000000)
        -- Award "Shadow Scholar" title
        -- Award special vehicle
        -- Server-wide announcement
    end
end
```

---

## 🎁 COLLECTION REWARDS:

### **Milestone Rewards:**

| Items Collected | Reward | Type |
|----------------|--------|------|
| 10 | $50,000 cash + "Collector" title | Cash + Title |
| 25 | Unique Shadow mask (cosmetic) | Item |
| 50 | Special vehicle unlock | Vehicle |
| 88 (ALL) | $1,000,000 crypto + "Shadow Scholar" title + Legendary status | Ultimate |

### **Category Complete Bonuses:**

| Set | Bonus |
|-----|-------|
| All 25 USBs | +5% XP boost (permanent) |
| All 40 Notes | Exclusive Shadow tattoo |
| All 15 Documents | Hidden heist unlocked |
| All 11 Artifacts | "Eighth Sin" eligibility |

---

## 🚀 IMPLEMENTATION CHECKLIST:

### **Week 1: Database & Items**
- [ ] Create shadow_lore_collected table
- [ ] Add all 88 items to ox_inventory
- [ ] Test item usage exports
- [ ] Verify database insertions

### **Week 2: World Spawns**
- [ ] Create spawn locations for 30 world items
- [ ] Add ox_target interactions
- [ ] Test collection mechanics
- [ ] Verify items appear in lore tab

### **Week 3: Drop Systems**
- [ ] Implement heist reward drops
- [ ] Implement random drop system
- [ ] Implement level milestone rewards
- [ ] Test all drop methods

### **Week 4: High Risk & Special**
- [ ] Create high-risk location system
- [ ] Implement wanted level triggers
- [ ] Add Black Market lore items
- [ ] Test police response

### **Week 5: Rewards & Polish**
- [ ] Implement milestone rewards
- [ ] Create collection tracking UI
- [ ] Add notifications
- [ ] Final testing

---

## 📊 TESTING GUIDE:

### **Test Each Type:**

**USB Drives:**
```lua
-- Give test USB
/giveLore usb 1

-- Should:
- Add item to inventory
- Mark as collected in database
- Show in lore tab
- Display full content
```

**Physical Notes:**
```lua
-- Spawn test note
/spawnLore note burnt 1

-- Should:
- Create world pickup
- Allow interaction
- Give item on collect
- Show content
```

**Classified Documents:**
```lua
-- Test high-risk document
/getLore document 1

-- Should:
- Give item
- Trigger wanted level
- Alert police
- Mark as collected
```

**Legendary Artifacts:**
```lua
-- Award test artifact
/giveLore artifact 1

-- Should:
- Give item
- Apply buff
- Show display effects
- Mark as collected
```

---

## 🔥 SUCCESS CRITERIA:

**Lore system is DONE when:**
- [ ] All 88 items implemented
- [ ] All spawn methods working
- [ ] Collection tracking functional
- [ ] Rewards awarding correctly
- [ ] UI displaying all lore
- [ ] No database errors
- [ ] Items deletable/droppable
- [ ] Progress persists across sessions

---

## 💎 FINAL NOTES:

**This is THE MOST COMPLETE lore system on FiveM!**

**88 unique items** with full content
**5 collection methods** (varied gameplay)
**11 legendary artifacts** (endgame goals)
**Multiple reward tiers** (progression incentives)

**Players will spend MONTHS collecting everything!**

---

**YOU HAVE EVERYTHING YOU NEED!** 🔥📚💎

**Time to build the most epic lore system ever!** 🚀
