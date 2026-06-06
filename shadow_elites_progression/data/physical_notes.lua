-- =============================================
-- SHADOW ELITES - PHYSICAL NOTES (40 TOTAL)
-- Complete catalog with content and locations
-- FLATTENED CONFIG STRUCTURE
-- =============================================

Config = Config or {}

Config.LoreNotes = {
    
    -- =============================================
    -- BURNT PAPERS (1-10)
    -- =============================================
    
    {
        id = 1,
        title = "Burnt Bank Truck Note",
        item_name = "shadow_note_burnt_01",
        content = [[
[PARTIALLY BURNT - EDGES CHARRED]

...shift change 2:15 PM...
...north route through Vinewood...
...two guards, minimal security...
...signal when clear...

[REST BURNED AWAY]
        ]],
        location = "Fire barrel near Legion Square",
        coords = vector3(195.5, -934.2, 30.7),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 2,
        title = "Charred Heist Plans",
        item_name = "shadow_note_burnt_02",
        content = [[
[SMOKE DAMAGED - BARELY LEGIBLE]

PLAN A: Legion Square → Vespucci
PLAN B: Vinewood → ████████
ESCAPE: ████████████████

"Trust no one. Burn after reading."

[SIGNATURE BURNED OFF]
        ]],
        location = "Alley dumpster fire, Downtown",
        coords = vector3(-56.3, -786.5, 44.2),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 3,
        title = "Scorched Contact Info",
        item_name = "shadow_note_burnt_03",
        content = [[
[FIRE DAMAGED]

CONTACTS:
Burner Phone: [█████████]
Meeting Spot: Pier, 3 AM
Passphrase: "The shadow knows"

DO NOT CALL FROM PERSONAL PHONE
DESTROY THIS IMMEDIATELY

[BOTTOM HALF INCINERATED]
        ]],
        location = "Homeless camp fire, La Mesa",
        coords = vector3(817.2, -1320.5, 26.1),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 4,
        title = "Singed Meeting Note",
        item_name = "shadow_note_burnt_04",
        content = [[
[HEAT DAMAGED - INK FADED]

Meet at the pier. 3 AM. Come alone.
They're watching the usual spots.
Use the old signal if compromised.

The Purge survivors know too much.
We need to ████████████

[REST UNREADABLE]
        ]],
        location = "Docks, near shipping containers",
        coords = vector3(1246.8, -3138.2, 5.5),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 5,
        title = "Burned Evidence Log",
        item_name = "shadow_note_burnt_05",
        content = [[
[ATTEMPTED DESTRUCTION - PARTIAL SUCCESS]

EVIDENCE DISPOSAL LOG:
Item 07: 7 bodies, Los Santos River
Item 08: Security footage (destroyed)
Item 09: ████████████████
Item 10: Witness statements (missing)

"Some secrets stay buried."

[FIRE CONSUMED THE REST]
        ]],
        location = "River edge, near Cypress Flats",
        coords = vector3(895.2, -2135.7, 30.5),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 6,
        title = "Ashed VIN Instructions",
        item_name = "shadow_note_burnt_06",
        content = [[
[SEVERELY FIRE DAMAGED]

VIN SCRATCH LOCATION:
████████ Chop Shop
Midnight only
Knock 3 times
Password: "Horseman"

PAYMENT: 60% on delivery
NO QUESTIONS ASKED

[BURNED BEYOND RECOVERY]
        ]],
        location = "Auto repair shop trash fire",
        coords = vector3(-362.5, -134.8, 38.7),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 7,
        title = "Blackened Route Map",
        item_name = "shadow_note_burnt_07",
        content = [[
[FIRE STAINED - MAP PARTIALLY VISIBLE]

ESCAPE ROUTES:
Route 1: Vinewood → Sandy Shores
Route 2: Downtown → Paleto Bay
Route 3: ████████████████

X MARKS: Safe house locations
"Never use same route twice"

[MAP MOSTLY DESTROYED]
        ]],
        location = "Abandoned warehouse, La Puerta",
        coords = vector3(-1156.3, -2006.8, 13.2),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 8,
        title = "Smoldering Warning Letter",
        item_name = "shadow_note_burnt_08",
        content = [[
[FIRE DAMAGE - URGENT MESSAGE]

They know about the shipment.
Location compromised. 
Move everything to backup site.

Trust no one.
Not even ████████

Destroy this immediately.

[SIGNATURE BURNED OFF]
        ]],
        location = "Mail drop fire, Del Perro",
        coords = vector3(-1498.7, -888.5, 10.1),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 9,
        title = "Incinerated Operation Report",
        item_name = "shadow_note_burnt_09",
        content = [[
[ATTEMPTED DESTRUCTION - 70% BURNED]

OPERATION: ████████████
STATUS: Successful
CASUALTIES: Zero
PROFIT: $847,000

"The Shadow Network prevails."

NEXT TARGET: ████████████
DATE: ████████████

[FLAMES CONSUMED THE REST]
        ]],
        location = "Safe house fireplace, Rockford Hills",
        coords = vector3(-1398.2, -598.7, 30.3),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 10,
        title = "Partially Burnt Profit Ledger",
        item_name = "shadow_note_burnt_10",
        content = [[
[ACCOUNTING LEDGER - FIRE DAMAGED]

SHIPMENTS:
Tuesday: 50 units, $125K
Friday: 75 units, $187K
Sunday: ████████████

TOTAL PROFITS: $█████████

"Someone tried to burn the evidence..."

[BOTTOM PAGES INCINERATED]
        ]],
        location = "Port shipping office fire",
        coords = vector3(1214.5, -3212.8, 5.9),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    -- =============================================
    -- TORN/CRUMPLED PAPERS (11-25)
    -- =============================================
    
    {
        id = 11,
        title = "Torn Ledger Page",
        item_name = "shadow_note_torn_11",
        content = [[
[TORN FROM ACCOUNTING BOOK]

MONTHLY PROFITS:
January: $423,000
February: $589,000
March: $847,000

"Business is booming."

[REST OF PAGE TORN OFF]
        ]],
        location = "Office trash can, Mission Row",
        coords = vector3(332.8, -595.2, 43.3),
        drop_method = "world_spawn",
        rarity = "common"
    },
    
    {
        id = 12,
        title = "Crumpled Black Market Receipt",
        item_name = "shadow_note_torn_12",
        content = [[
[RECEIPT - CRUMPLED]

BLACK MARKET PURCHASE:
2x GPS Jammer - $50,000
1x Thermal Drill - $45,000
3x Lockpick Set - $45,000

TOTAL: $140,000 (crypto)

"No refunds. No questions."
        ]],
        location = "Store floor, Little Seoul",
        coords = vector3(-706.5, -912.3, 19.2),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 13,
        title = "Ripped Crew Contract",
        item_name = "shadow_note_torn_13",
        content = [[
[CONTRACT FRAGMENT - TORN]

AGREEMENT:
50% split, no questions asked
Payout on completion
Crew size: Maximum 4
NO OUTSIDERS

Signed: ████████
Date: ████████

[BOTTOM TORN OFF]
        ]],
        location = "Backroom, Vanilla Unicorn",
        coords = vector3(127.5, -1283.7, 29.3),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 14,
        title = "Tattered Heist Checklist",
        item_name = "shadow_note_torn_14",
        content = [[
[HANDWRITTEN LIST - TORN]

TARGETS:
✓ Fleeca Bank x3
✓ Paleto Bay x2
□ Vangelico Jewelry
□ Pacific Standard

"Working our way up..."

[LIST CONTINUES - PAGE TORN]
        ]],
        location = "Desk drawer, abandoned building",
        coords = vector3(-108.5, -8.3, 70.5),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 15,
        title = "Shredded Emergency Warning",
        item_name = "shadow_note_torn_15",
        content = [[
[PARTIALLY SHREDDED - REASSEMBLED]

THEY'RE WATCHING
PHONES TAPPED
LOCATION COMPROMISED

GET OUT NOW

[REST SHREDDED BEYOND RECOVERY]
        ]],
        location = "Paper shredder bin, office building",
        coords = vector3(-141.2, -620.5, 168.8),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 16,
        title = "Torn Shadow Network Envelope",
        item_name = "shadow_note_torn_16",
        content = [[
[ENVELOPE - TORN OPEN]

TO: █████████
FROM: Shadow Network
SUBJECT: Your application

"You've been noticed.
Check your phone for instructions.
This is your only warning."

[SIGNATURE: Green fingerprint]
        ]],
        location = "Mailbox, Rockford Hills",
        coords = vector3(-1564.7, -405.8, 42.4),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 17,
        title = "Wrinkled Escape Route Map",
        item_name = "shadow_note_torn_17",
        content = [[
[MAP - HEAVILY CREASED]

ESCAPE ROUTES MARKED:
Route A: [GREEN LINE]
Route B: [RED LINE - CROSSED OUT]
Route C: [DOTTED LINE]

"Plan C always works."

[MAP TORN - MISSING SECTION]
        ]],
        location = "Car glove box, impound lot",
        coords = vector3(409.3, -1622.7, 29.3),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 18,
        title = "Folded Security Schedule",
        item_name = "shadow_note_torn_18",
        content = [[
[SECURITY SCHEDULE - FOLDED]

SHIFT CHANGES:
6:00 AM - Baker & Miller
2:00 PM - Johnson & Davis
10:00 PM - ████████████

"2-3 PM window. Minimal security."

[SCHEDULE ENDS ABRUPTLY]
        ]],
        location = "Security desk, bank lobby",
        coords = vector3(149.3, -1040.5, 29.4),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 19,
        title = "Crumpled Surveillance Photo",
        item_name = "shadow_note_torn_19",
        content = [[
[PHOTO - HEAVILY CREASED]

[Black and white photo of person in shadows]

Text on back:
"IDENTIFY THIS PERSON
REWARD: $50,000
Contact: ████████"

[PHOTO DAMAGED FROM FOLDING]
        ]],
        location = "Photo lab trash, Vinewood",
        coords = vector3(120.8, -64.2, 67.9),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 20,
        title = "Ripped Payment Invoice",
        item_name = "shadow_note_torn_20",
        content = [[
[INVOICE - TORN]

PAYMENT OVERDUE:
Client: ████████
Service: "Cleanup"
Amount: $75,000

"Final notice before collection."

[OMINOUS IMPLICATION]
        ]],
        location = "Filing cabinet, warehouse",
        coords = vector3(1058.7, -3100.5, 5.9),
        drop_method = "world_spawn",
        rarity = "uncommon"
    },
    
    {
        id = 21,
        title = "Torn Diary Entry",
        item_name = "shadow_note_torn_21",
        content = [[
[DIARY ENTRY - RIP MARK]

"Day 47: I know too much.
They think I haven't noticed.
The same car. Same faces.
I need to disappear before—"

[PAGE TORN - ENTRIES STOP ABRUPTLY]
        ]],
        location = "Personal effects, motel room",
        coords = vector3(327.8, -205.2, 54.1),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 22,
        title = "Wrinkled Anonymous Warning",
        item_name = "shadow_note_torn_22",
        content = [[
[HANDWRITTEN - WRINKLED]

"Leave Los Santos now.
They know who you are.
They know where you live.
This is your only warning.

A friend who wants you alive."

[NO SIGNATURE]
        ]],
        location = "Under apartment door, Integrity Way",
        coords = vector3(-47.8, -585.7, 37.9),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 23,
        title = "Folded Death Threat",
        item_name = "shadow_note_torn_23",
        content = [[
[NOTE - MULTIPLE FOLDS]

"Loyalty or death.
You chose wrong.

The Four Horsemen
do not forgive betrayal."

[BLOODSTAIN ON CORNER]
        ]],
        location = "Car windshield, parking lot",
        coords = vector3(215.7, -809.3, 30.7),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 24,
        title = "Crumpled Final Note",
        item_name = "shadow_note_torn_24",
        content = [[
[HANDWRITTEN - TEAR STAINED]

"I'm sorry. I had to.
They gave me no choice.
Tell my family I loved them.

The Shadow Network always collects."

[NOTE ENDS - SUICIDE SCENE]
        ]],
        location = "Rooftop suicide scene",
        coords = vector3(-1290.7, -1123.8, 6.8),
        drop_method = "world_spawn",
        rarity = "legendary"
    },
    
    {
        id = 25,
        title = "Torn Confession Letter",
        item_name = "shadow_note_torn_25",
        content = [[
[CONFESSION - RIPPED]

"I betrayed them.
I gave the police everything.
Locations. Names. Plans.

Now they're coming for me.
If you find this, I'm already—"

[NOTE ENDS ABRUPTLY]
        ]],
        location = "Police station evidence room",
        coords = vector3(461.5, -982.3, 30.7),
        drop_method = "high_risk",
        rarity = "legendary"
    },
    
    -- =============================================
    -- BLOODSTAINED PAPERS (26-33)
    -- =============================================
    
    {
        id = 26,
        title = "Bloodied Last Words",
        item_name = "shadow_note_blood_26",
        content = [[
[BLOOD SOAKED - BARELY LEGIBLE]

"Tell my crew...
...it wasn't their fault...
...DEATH was here...
...green eyes in the dark..."

[HANDWRITING TRAILS OFF]
[MASSIVE BLOODSTAIN]
        ]],
        location = "Murder scene, Sandy Shores",
        coords = vector3(1985.3, 3815.7, 32.2),
        drop_method = "crime_scene",
        rarity = "legendary"
    },
    
    {
        id = 27,
        title = "Stained Betrayal Confession",
        item_name = "shadow_note_blood_27",
        content = [[
[BLOOD SPLATTERED]

"It was worth it for the money.
I sold out the crew.
Police paid $100,000.

I'm leaving the state tonight.
They'll never find—"

[SENTENCE INCOMPLETE]
[HEAVY BLOODSTAINS]
        ]],
        location = "Hospital morgue",
        coords = vector3(295.8, -1446.9, 29.8),
        drop_method = "crime_scene",
        rarity = "legendary"
    },
    
    {
        id = 28,
        title = "Crimson DEATH Message",
        item_name = "shadow_note_blood_28",
        content = [[
[WRITTEN IN BLOOD]

"DEATH WAS HERE

The fourth rider claims another.
Your crew is next.
Run while you still can.

- D"

[GRUESOME SCENE]
        ]],
        location = "Abandoned warehouse murder scene",
        coords = vector3(1120.8, -3152.3, 5.5),
        drop_method = "crime_scene",
        rarity = "legendary"
    },
    
    {
        id = 29,
        title = "Blood-Soaked Execution List",
        item_name = "shadow_note_blood_29",
        content = [[
[HIT LIST - BLOODSTAINED]

TARGETS:
✓ Marcus "The Rat" Johnson
✓ David Chen
✓ Sarah Williams
□ ████████████
□ ████████████

"Three down. More to go."

[KILLER'S CHECKLIST]
        ]],
        location = "Warehouse floor, La Puerta",
        coords = vector3(982.5, -2157.8, 30.5),
        drop_method = "crime_scene",
        rarity = "legendary"
    },
    
    {
        id = 30,
        title = "Gory Body Disposal Note",
        item_name = "shadow_note_blood_30",
        content = [[
[BLOOD SPATTERED INSTRUCTIONS]

BODY DISPOSAL:
1. Remove identification
2. Dispose at ████████
3. Clean scene thoroughly
4. Report to WRATH

"No witnesses. No mercy."

[CHILLING EFFICIENCY]
        ]],
        location = "Car trunk, chop shop",
        coords = vector3(485.7, -1316.5, 29.2),
        drop_method = "crime_scene",
        rarity = "legendary"
    },
    
    {
        id = 31,
        title = "Stained Purge Evidence",
        item_name = "shadow_note_blood_31",
        content = [[
[POLICE EVIDENCE - BLOODSTAINED]

CASE #2019-0847
"The Purge Incident"

EVIDENCE: ████████████
FINGERPRINTS: Multiple matches
STATUS: Classified

[HEAVY REDACTION]
        ]],
        location = "Police forensics lab",
        coords = vector3(478.2, -989.5, 26.3),
        drop_method = "high_risk",
        rarity = "legendary"
    },
    
    {
        id = 32,
        title = "Crimson Blood Oath Contract",
        item_name = "shadow_note_blood_32",
        content = [[
[CONTRACT SIGNED IN BLOOD]

"I pledge my loyalty to Shadow Network.
I will serve until death.
Betrayal means execution.

Blood oath signed,
████████████"

[DRIED BLOOD SIGNATURE]
        ]],
        location = "Ritual site, Tongva Hills",
        coords = vector3(-2205.8, 4285.3, 49.1),
        drop_method = "world_spawn",
        rarity = "legendary"
    },
    
    {
        id = 33,
        title = "Bloody Mirror Warning",
        item_name = "shadow_note_blood_33",
        content = [[
[WRITTEN ON BATHROOM MIRROR]

"YOU'RE NEXT

- The Four Horsemen"

[VICTIM'S BLOOD USED AS INK]
[SCENE PRESERVED ON PAPER]
        ]],
        location = "Crime scene photo, evidence room",
        coords = vector3(461.8, -985.2, 30.7),
        drop_method = "high_risk",
        rarity = "legendary"
    },
    
    -- =============================================
    -- WATER-DAMAGED PAPERS (34-40)
    -- =============================================
    
    {
        id = 34,
        title = "Soaked Maritime Coordinates",
        item_name = "shadow_note_water_34",
        content = [[
[WATER DAMAGED - INK RUNNING]

PICKUP COORDINATES:
Lat: ██.████
Long: -███.████

"Submarine route.
Midnight only.
Signal with ████████"

[SEVERELY WATER DAMAGED]
        ]],
        location = "Beach, Vespucci",
        coords = vector3(-1498.7, -1017.5, 6.5),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 35,
        title = "Waterlogged Island Map",
        item_name = "shadow_note_water_35",
        content = [[
[MAP - WATER SOAKED]

ISLAND STASH LOCATION:
Cayo P████ coordinates
Access: ████████████
Loot: $██████████

"Our offshore backup."

[MAP MOSTLY ILLEGIBLE]
        ]],
        location = "Pier, Del Perro",
        coords = vector3(-1850.3, -1230.8, 13.0),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 36,
        title = "Damp Smuggling Route",
        item_name = "shadow_note_water_36",
        content = [[
[NAVIGATION CHART - DAMP]

UNDERWATER ROUTE:
Entry: ████████
Depth: ████████
Exit: Los Santos Port

"Undetectable smuggling route."

[WATER DAMAGE OBSCURES DETAILS]
        ]],
        location = "Marina, Puerto Del Sol",
        coords = vector3(-795.8, -1510.2, 1.6),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 37,
        title = "Moldy Buried Cache Note",
        item_name = "shadow_note_water_37",
        content = [[
[OLD PAPER - MOLD STAINS]

BURIED TREASURE:
Location: ████████
Depth: 6 feet
Marked with: X

"Emergency funds for the crew."

[MOLD DAMAGE]
        ]],
        location = "Abandoned beach house, Paleto Bay",
        coords = vector3(-223.5, 6445.7, 31.2),
        drop_method = "world_spawn",
        rarity = "rare"
    },
    
    {
        id = 38,
        title = "Faded Offshore Account Info",
        item_name = "shadow_note_water_38",
        content = [[
[BANK STATEMENT - WATER DAMAGED]

OFFSHORE ACCOUNT:
Balance: $█,███,███
Location: ████████████
Access Code: ████████

"Untraceable wealth."

[INK SEVERELY FADED]
        ]],
        location = "Bank safety deposit room",
        coords = vector3(255.3, 225.2, 101.9),
        drop_method = "heist_reward",
        rarity = "legendary"
    },
    
    {
        id = 39,
        title = "Smudged Rain Warning",
        item_name = "shadow_note_water_39",
        content = [[
[CAUGHT IN RAIN - SMUDGED]

"Meeting cancelled.
Location compromised.
Police presence.

Use emergency protocol ████"

[REST WASHED AWAY]
        ]],
        location = "Rain puddle, street corner",
        coords = vector3(89.5, -1290.7, 29.3),
        drop_method = "world_spawn",
        rarity = "common"
    },
    
    {
        id = 40,
        title = "Aged Purge Telegram",
        item_name = "shadow_note_water_40",
        content = [[
[OLD TELEGRAM - WATER STAINED]

DATE: 2019-██-██

"THE PURGE BEGINS TONIGHT.
ELIMINATE ALL WITNESSES.
SHADOW NETWORK RISES.

-THE FOUR"

[HISTORIC DOCUMENT]
        ]],
        location = "Old post office, abandoned building",
        coords = vector3(-186.3, 85.7, 69.7),
        drop_method = "world_spawn",
        rarity = "legendary"
    }
}

return Config