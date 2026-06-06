# 🗑️ Trash Can Search System

A complete trash searching resource for FiveM servers with blueprint drop system integration.

## Features

✅ Search trash cans, dumpsters, and recycling bins  
✅ Blueprint drops (Tier 1 common blueprints)  
✅ Material drops (plastic, rubber, glass, metal)  
✅ Money and random item drops  
✅ Cooldown system (5 minute default)  
✅ ox_target integration  
✅ Fully configurable loot tables  
✅ QBX/QB-Core compatible  
✅ Clean and optimized code  

## Requirements

- **ox_lib** (required)
- **ox_inventory** (required)
- **ox_target** (required)
- **qbx_core** or **qb-core** (for framework integration)

## Installation

### Step 1: Extract Resource
```
resources/
└── [custom]/
    └── trash_search/
        ├── fxmanifest.lua
        ├── config.lua
        ├── client.lua
        └── server.lua
```

### Step 2: Add to server.cfg
```cfg
ensure trash_search
```

### Step 3: Add Blueprint Items
Copy all blueprint items from `BLUEPRINT_ITEMS.lua` to your `ox_inventory/data/items.lua`

### Step 4: Restart Server
```
restart trash_search
restart ox_inventory
```

## Configuration

Edit `config.lua` to customize:

- **Search times** - How long it takes to search
- **Cooldowns** - How often same trash can be searched
- **Loot tables** - What items drop and at what rates
- **Props** - Which trash can models are searchable
- **Notifications** - Customize notification messages

### Loot Table Example

```lua
Config.Loot = {
    trash_can = {
        guaranteed = {
            { item = 'garbage', min = 1, max = 3 },
        },
        items = {
            { item = 'blueprint_lockpick', chance = 8, min = 1, max = 1 },
            { item = 'plastic', chance = 12, min = 1, max = 3 },
            { item = 'money', chance = 10, min = 5, max = 25 },
        },
    },
}
```

## How It Works

1. Player approaches trash can
2. ox_target shows "Search" option
3. Player starts search (progress bar)
4. Server generates loot based on Config.Loot
5. Items given to player
6. Trash can goes on cooldown (default 5 mins)

## Drop Rates (Default Config)

### Trash Cans (Small Bins)
- **Blueprints**: 15% total chance
  - Lockpick (8%)
  - Bandage (4%)
  - Jerry Can (2%)
  - Repair Kit (1%)
- **Materials**: 30% total chance
- **Money**: 10% chance ($5-$25)
- **Random items**: 20% chance

### Dumpsters (Large Bins)
- **Blueprints**: 20% total chance (better than trash cans)
- **Materials**: 40% total chance (more materials)
- **Money**: 15% chance ($10-$50)
- **Random items**: 25% chance

### Recycling Bins
- **Blueprints**: 12% total chance
- **Materials**: 50% total chance (lots of recyclables!)
- **Money**: 8% chance ($5-$30)

## Blueprint System Integration

This script is designed to work with the blueprint crafting system.

Common blueprints found:
- `blueprint_lockpick` - Most common
- `blueprint_bandage` - Common
- `blueprint_repairkit` - Uncommon
- `blueprint_jerrycan` - Uncommon

For higher tier blueprints, players must do house robberies or heists.

## Admin Commands

```
/resettrash - Reset all trash cooldowns (admin only)
```

## Customization Tips

### Change Drop Rates
Edit `config.lua` → `Config.Loot` → adjust `chance` values

### Add New Items
Add to `config.lua` → `Config.Loot.trash_can.items`:
```lua
{ item = 'your_item_name', chance = 10, min = 1, max = 1 },
```

### Change Search Time
Edit `config.lua` → `Config.SearchTime`:
```lua
Config.SearchTime = {
    trash_can = 3000,  -- 3 seconds (faster)
    dumpster = 5000,   -- 5 seconds
}
```

### Add More Trash Props
Edit `config.lua` → `Config.Props.trash_can`:
```lua
Config.Props = {
    trash_can = {
        `your_prop_name_here`,
        -- ... existing props
    },
}
```

## Troubleshooting

### "Cannot find ox_target"
- Make sure ox_target is installed and started before this resource
- Check server.cfg load order

### "Blueprint item doesn't exist"
- Add blueprint items to ox_inventory/data/items.lua
- Restart ox_inventory

### Trash cans not showing search option
- Check if props are correct in config.lua
- Try standing closer to trash can
- Check F8 console for errors

### Items not being given
- Check inventory is not full
- Verify item names match items.lua
- Check server console for errors

## Performance

- Optimized for 0.00ms idle
- Efficient cooldown management
- No entity loops
- Uses ox_target for interactions

## Credits

Created for QBX/QB-Core FiveM servers  
Compatible with ox_inventory and ox_target  
Part of the Blueprint Crafting System  

## License

Free to use and modify for your server  
Credit appreciated but not required  

## Support

For issues or questions:
- Check config.lua settings
- Review integration guides
- Check F8 console for errors
- Enable Config.Debug = true for verbose logging

---

**Version**: 1.0.0  
**Last Updated**: 2026  
**Framework**: QBX/QB-Core  
**Dependencies**: ox_lib, ox_inventory, ox_target
