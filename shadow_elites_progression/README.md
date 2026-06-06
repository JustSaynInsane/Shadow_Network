# Shadow Elites - Criminal Progression System

Complete criminal progression system with Shadow Network integration for QBX Framework.

## 🎯 Features

### ✅ Week 1 - Foundation (COMPLETE)
- **3 Skill Trees**: Narcotics, Organized Crime, Auto Theft
- **10 Levels per tree** with XP-based progression
- **Shadow Network unlocks at Level 5**
- **4 Money Laundering methods**:
  - Washing Machines (85% return, slow)
  - Front Businesses (90% return, requires purchase)
  - Offshore Accounts (80% return, fast, police alert risk)
  - Bulk Drop (70% return, instant, 24hr cooldown)
- **Cryptic Shadow Network messages**
- **Mysterious NPC meetings**
- **Drug system integration** (qbx_drugs, qbx_weed)

### 🔜 Week 2 - Heists & Crews (Coming Soon)
- Crew system with 5-member max
- Heist progression gates (Fleeca → Jewelry → Pacific)
- 15-minute time limits (anti-gatekeeping)
- Manual money distribution
- Level-based XP scaling for crew members

---

## 📦 Installation

### 1. Database Setup
Run the SQL file in your database:
```sql
source install.sql
```

### 2. Resource Installation
1. Copy `shadow_elites_progression` folder to your `resources` directory
2. Add to your `server.cfg`:
```cfg
ensure shadow_elites_progression
```

### 3. Dependencies
Make sure you have these resources:
- `qbx_core`
- `ox_lib`
- `ox_inventory`
- `oxmysql`
- `npwd` (for Shadow Network app)

### 4. Permissions
Add admin permissions in `permissions.cfg` or your admin system:
```
add_ace group.admin command.addcrimxp allow
add_ace group.admin command.completeheist allow
add_ace group.admin command.crimstats allow
add_ace group.admin command.shadowmessage allow
add_ace group.admin command.shadowcustom allow
add_ace group.admin command.spawnshadownpc allow
add_ace group.admin command.unlockshadowheist allow
```

---

## 🎮 How It Works

### Player Progression
1. **Start at Level 0** in all three trees
2. **Complete activities** to gain XP:
   - Drug sales → Narcotics XP
   - Heists → Organized Crime XP
   - Car boosting → Auto Theft XP
3. **Level up** to unlock new activities
4. **Hit Level 5** in any tree → Shadow Network unlocks

### Shadow Network
- Mysterious criminal organization
- Sends cryptic messages after achievements
- Unlocks high-tier heists through in-person meetings
- Admin can play the Shadow character for RP

### Money Laundering
Four methods with different rates/speeds:
1. **Washing Machines** - Slowest, decent return
2. **Front Businesses** - Better return, need to purchase
3. **Offshore** - Faster, risky (police alerts)
4. **Bulk Drop** - Emergency instant conversion

---

## 🛠️ Admin Commands

### XP Management
```
/addcrimxp [player_id] [tree] [amount]
Example: /addcrimxp 1 organized 500
```

### Heist Testing
```
/completeheist [player_id] [heist_type]
Example: /completeheist 1 fleeca_bank
```

### Player Stats
```
/crimstats [player_id]
Shows all progression stats in console
```

### Shadow Network
```
/shadowmessage [player_id] [message_type]
Types: level5_welcome, first_fleeca, jewelry_unlocked, jewelry_completed, pacific_completed

/shadowcustom [player_id] "Subject" "Your message here"

/spawnshadownpc [location]
Locations: jewelry_unlocked, pacific_unlocked

/unlockshadowheist [player_id] [heist_type]
```

---

## 📊 XP Rewards

### Narcotics Tree
- Corner sale: 5 XP
- Delivery: 15 XP
- Bulk sale: 50 XP
- Weed harvest: 8 XP
- Weed sale: 3 XP

### Organized Crime Tree
- House robbery: 10 XP
- Store robbery: 20 XP
- Fleeca Bank: 50 XP
- Jewelry Store: 75 XP
- Pacific Standard: 150 XP
- Money laundered: 1 XP per $10K

### Auto Theft Tree
- D-class boost: 5 XP
- C-class boost: 8 XP
- B-class boost: 15 XP
- A-class boost: 25 XP
- S-class boost: 40 XP
- Chop shop: 10 XP
- VIN scratch: 25 XP

---

## 🔌 Integration with Existing Scripts

### Drug Systems (qbx_drugs, qbx_weed)
Automatically integrated! XP is awarded when:
- Drug corner sales complete
- Weed plants are harvested
- No changes to existing scripts needed

### House Robbery (qbx_houserobbery)
Event hook: `qbx_houserobbery:server:completeRobbery`
Automatically awards 10 XP to Organized Crime

### Store Robbery
Event hook: `qbx_storerobbery:server:completeRobbery`
Automatically awards 20 XP to Organized Crime

### Custom Integration
Add XP from your own scripts:
```lua
-- Server-side
exports['shadow_elites_progression']:AddXP(source, 'narcotics', 50)

-- Or via event
TriggerEvent('shadow_elites:server:addXP', source, 'organized', 100)
```

---

## 🎭 Roleplay Features

### Shadow Network Character
Admins can play as the mysterious Shadow Network contact:
1. Spawn NPC at meeting location
2. Players receive cryptic messages
3. Players meet NPC for dialogue
4. Admin can speak through NPC (hybrid mode)
5. Unlocks high-tier heists

### Cryptic Message Flow
```
Level 5 → "You've caught our attention..."
         ↓
Do 3 Fleecas → "Time to step up..."
              ↓
Do Jewelry Store → "We need to meet. Tonight."
                  ↓
Meet Shadow NPC → Pacific Standard unlocked
                 ↓
Complete Pacific → "You're legends..."
```

---

## ⚙️ Configuration

Edit `config/shared.lua` to customize:
- XP requirements per level
- XP rewards per activity
- Laundering rates and times
- Shadow Network unlock level
- Level 10 bonuses
- Notification settings

---

## 🐛 Debugging

Enable debug mode in `config/shared.lua`:
```lua
Config.Debug = true
```

This will print:
- Player progression loading
- XP gains and level ups
- Heist completions
- NPC spawns
- Laundering operations

---

## 📝 Support & Credits

**Created for Shadow Elites RP**
- Framework: QBX Core
- Criminal progression system with Shadow Network integration
- Week 1: Foundation (XP, Laundering, Shadow Network)
- Week 2: Coming Soon (Crews, Heists, Time Limits)

---

## 🚀 Coming in Week 2

- [ ] Full crew system
- [ ] Heist progression gates
- [ ] 15-minute time limits
- [ ] Anti-gatekeeping cooldowns
- [ ] Item requirement checks
- [ ] Jewelry store economics
- [ ] Manual money distribution
- [ ] Crew XP scaling system

---

**Version:** 1.0.0 - Week 1 Foundation
**Status:** ✅ Ready for Testing
