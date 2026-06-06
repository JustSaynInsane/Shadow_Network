-- =============================================
-- SHADOW ELITES - LEGENDARY ARTIFACTS (11 TOTAL)
-- 4 Horsemen Artifacts + 7 Sin Artifacts
-- Ultra-rare endgame collectibles
-- FLATTENED CONFIG STRUCTURE
-- =============================================

Config = Config or {}

Config.LoreArtifacts = {
    
    -- =============================================
    -- HORSEMEN ARTIFACTS (1-4)
    -- =============================================
    
    {
        id = 1,
        horseman = "WAR",
        name = "WAR's Challenge Coin",
        title = "WAR's Challenge Coin",
        item_name = "shadow_artifact_war_coin",
        description = [[
A military-style challenge coin forged from blood-red steel.

Front Side:
- Crossed swords emblem
- Inscription: "VICTORY OR DEATH"
- Roman numeral "I" (The First Horseman)

Back Side:
- Shadow Network symbol (green)
- List of major heists (engraved)
- "WAR - The Architect"

The coin is warm to the touch, as if heated by battle.
Legend says WAR personally gives these to elite heist crews.

Those who possess it gain respect in the criminal underworld.
"The bearer has earned WAR's approval."
        ]],
        lore = "Forged after first successful Pacific Standard heist (2019). Symbol of elite heist status. Only 7 exist in Los Santos.",
        acquisition = "Complete Pacific Standard heist flawlessly - Zero casualties, zero witnesses, zero mistakes",
        game_effect = "+10% heist payout (permanent)",
        coords = vector3(255.3, 225.2, -58.9),
        drop_method = "heist_reward",
        rarity = "legendary"
    },
    
    {
        id = 2,
        horseman = "FAMINE",
        name = "FAMINE's Ancient Scale",
        title = "FAMINE's Ancient Scale",
        item_name = "shadow_artifact_famine_scale",
        description = [[
An antique merchant's scale made of tarnished brass.

Left Pan:
- Never in balance
- Always tips toward greed
- Inscription: "NEVER ENOUGH"

Right Pan:
- Weighs the worth of souls
- Metaphorical, not literal
- Inscription: "THE COST"

The scale represents FAMINE's philosophy:
"Supply and demand. Everyone has a price."

Those who control distribution control everything.
This scale has weighed fortunes in drugs and blood.

FAMINE uses it to decide who lives and who starves.
        ]],
        lore = "Recovered from 1920s prohibition-era drug lord. Symbol of narcotics empire. Unique - only one exists.",
        acquisition = "Reach Level 10 Narcotics skill tree + Complete 100 drug deliveries",
        game_effect = "+15% drug sale prices (permanent)",
        coords = vector3(1395.2, 1142.3, 114.3),
        drop_method = "progression_reward",
        rarity = "legendary"
    },
    
    {
        id = 3,
        horseman = "CONQUEST",
        name = "CONQUEST's White Trophy",
        title = "CONQUEST's White Trophy",
        item_name = "shadow_artifact_conquest_trophy",
        description = [[
A white marble horse figurine mounted on obsidian base.

The Horse:
- Pure white marble
- Rearing on hind legs
- Eyes inlaid with emeralds
- Mane flowing like victory banner

The Base:
- Black obsidian
- Engraved: "CONQUEST - The Victor"
- List of legendary vehicles stolen
- "I came, I saw, I drove away"

The trophy represents CONQUEST's domain:
Speed. Power. Dominance of the streets.

Every legendary car thief dreams of earning this.
To possess it means you've conquered Los Santos roads.

"The streets bow to the white horse."
        ]],
        lore = "Commissioned after first S-Class vehicle theft. Symbol of auto theft mastery. Unique - only one exists.",
        acquisition = "Reach Level 10 Auto Theft skill tree + Steal 50 S-Class vehicles",
        game_effect = "+20% vehicle sale prices (permanent)",
        coords = vector3(-1155.7, -2007.3, 13.2),
        drop_method = "progression_reward",
        rarity = "legendary"
    },
    
    {
        id = 4,
        horseman = "DEATH",
        name = "DEATH's Obsidian Mask",
        title = "DEATH's Obsidian Mask",
        item_name = "shadow_artifact_death_mask",
        description = [[
A sleek black tactical mask with glowing green eyes.

The Mask:
- Pure obsidian black material
- Seamless, no visible seams
- Green LED eyes (always on)
- Breathing filter (functional)

Special Features:
- Eyes glow brighter in darkness
- Slight green mist effect
- Temperature always cold to touch
- Weightless despite solid construction

The mask is DEATH's signature.
Every execution. Every elimination. Every purge.

Those who see the green eyes rarely survive.
"The fourth rider claims another."

Only one has ever been found.
The rest remain with DEATH... whoever that is.

"You don't find DEATH. DEATH finds you."
        ]],
        lore = "Origin unknown - predates Shadow Network. Symbol of ultimate fear. Possibly multiple exist (unconfirmed).",
        acquisition = "Complete The Purge storyline (admin event) + Survive DEATH's trial",
        game_effect = "+25% intimidation (NPCs fear you) + Wearable cosmetic mask",
        coords = vector3(0.0, 0.0, 0.0),
        drop_method = "admin_granted",
        rarity = "mythic"
    },
    
    -- =============================================
    -- SIN ARTIFACTS (5-11)
    -- =============================================
    
    {
        id = 5,
        sin = "GREED",
        name = "GREED's Golden Ring",
        title = "GREED's Golden Ring",
        item_name = "shadow_artifact_greed_ring",
        description = [[
A massive gold ring with flawless emerald.

The Ring:
- 24K gold band (thick, heavy)
- 5-carat emerald center stone
- Engraving inside: "GREED - Never Enough"
- Perfectly sized for any finger (magical?)

The Emerald:
- Flawless clarity
- Deep green color
- Catches light impossibly
- Worth $500,000 alone

Inscription (inside band):
"The first sin. The greatest sin.
Money is power. Power is everything."

GREED wears this as a symbol of wealth.
Every major financial decision bears this ring's mark.

To possess it means you control the money.
And whoever controls the money controls Shadow Network.
        ]],
        lore = "Crafted from first million dollars earned. Symbol of Shadow Network wealth. Unique - GREED's personal ring.",
        acquisition = "Earn $10 million total through Shadow Network + Reach Level 10 in all three skill trees",
        game_effect = "+10% all payouts (permanent, stacks with other bonuses)",
        coords = vector3(-1898.7, -572.5, 11.8),
        drop_method = "progression_reward",
        rarity = "legendary"
    },
    
    {
        id = 6,
        sin = "WRATH",
        name = "WRATH's Obsidian Blade",
        title = "WRATH's Obsidian Blade",
        item_name = "shadow_artifact_wrath_blade",
        description = [[
A ceremonial dagger made from pure obsidian.

The Blade:
- Volcanic glass (impossibly sharp)
- 12-inch blade length
- Never dulls, never chips
- Blood slides off (never stains)

The Handle:
- Wrapped in black leather
- Gold pommel with red ruby
- Inscription: "WRATH - Swift Justice"
- Perfectly balanced for throwing

This blade has ended more lives than any gun.
Silent. Efficient. Personal.

WRATH uses it for enforcement.
For executions. For sending messages.

The Purge victims all bore this blade's mark.
"Seven cuts. Seven deaths. Seven betrayers."

To wield it is to become WRATH's hand.
        ]],
        lore = "Forged from volcanic glass after The Purge. Symbol of enforcement and fear. Unique - WRATH's personal weapon.",
        acquisition = "Complete 50 'enforcement' contracts + High violence score",
        game_effect = "+50% melee damage (permanent) + Usable weapon",
        coords = vector3(1120.8, -3152.3, -40.4),
        drop_method = "contract_reward",
        rarity = "legendary"
    },
    
    {
        id = 7,
        sin = "ENVY",
        name = "ENVY's Emerald Vial",
        title = "ENVY's Emerald Vial",
        item_name = "shadow_artifact_envy_vial",
        description = [[
A small glass vial filled with green liquid.

The Vial:
- Crystal glass (unbreakable)
- Green liquid (never stops swirling)
- Cork stopper with wax seal
- Glows faintly in darkness

The Liquid:
- Pure emerald green
- Swirls constantly
- Never evaporates
- Purpose unknown (poison? drug? magic?)

Cork Seal:
- Green wax
- Impression: "ENVY"
- Never opens (or hasn't yet)

Legend says this vial contains the essence of ENVY.
The desire for what others have.
The poison of jealousy made manifest.

ENVY carries it as a reminder:
"Want what they have. Take what they have."

Nobody knows what happens if it's opened.
        ]],
        lore = "Created during ENVY's initiation to Inner Circle. Symbol of desire and ambition. Unique - ENVY's personal talisman.",
        acquisition = "Steal from rival crews 100 times + Never get caught",
        game_effect = "+15% theft success rate (permanent) + Unknown effect if opened",
        coords = vector3(1395.7, 1143.2, 114.3),
        drop_method = "progression_reward",
        rarity = "legendary"
    },
    
    {
        id = 8,
        sin = "PRIDE",
        name = "PRIDE's Golden Crown",
        title = "PRIDE's Golden Crown",
        item_name = "shadow_artifact_pride_crown",
        description = [[
A small ornamental crown, worn as a pin.

The Crown:
- Miniature king's crown (2 inches)
- Solid gold construction
- Seven points (for Seven Sins)
- Diamond at each point

The Diamonds:
- Seven perfect diamonds
- Each represents a Sin
- Center stone largest (PRIDE)
- Rainbow light reflection

Pin Back:
- Worn on lapel or collar
- Inscription: "PRIDE - First Among Equals"
- "I stand above all"

PRIDE wears this as a declaration.
The leader of the Seven Sins.
The first. The greatest. The most important.

To wear this crown is to declare supremacy.
"I am better than you. I always will be."
        ]],
        lore = "Self-commissioned by PRIDE upon joining Inner Circle. Symbol of superiority and leadership. Unique - PRIDE's personal symbol.",
        acquisition = "Become crew leader with 10+ members + Maintain leadership for 30 days",
        game_effect = "+20% crew member loyalty + Wearable cosmetic pin",
        coords = vector3(-1898.3, -598.7, 11.8),
        drop_method = "progression_reward",
        rarity = "legendary"
    },
    
    {
        id = 9,
        sin = "LUST",
        name = "LUST's Ruby Pendant",
        title = "LUST's Ruby Pendant",
        item_name = "shadow_artifact_lust_pendant",
        description = [[
An exquisite pendant with blood-red ruby heart.

The Pendant:
- Heart-shaped ruby (3 carats)
- Platinum chain (18 inches)
- Flawless stone clarity
- Warm to the touch

The Ruby:
- Deep blood red color
- Perfectly heart-shaped
- Seems to pulse like heartbeat
- Hypnotic to look at

Chain:
- Platinum links
- Delicate but unbreakable
- Clasp: "LUST - Desire Incarnate"
- Never tarnishes

LUST uses this to seduce, manipulate, control.
Beauty. Desire. Temptation. Power.

Those who see it are drawn to it.
"Want what you cannot have."

To possess it is to master desire itself.
        ]],
        lore = "Gift from unknown admirer to LUST. Symbol of seduction and control. Unique - LUST's personal jewelry.",
        acquisition = "Complete 25 'social manipulation' contracts + Seduce/manipulate key targets",
        game_effect = "+25% NPC persuasion success + Wearable cosmetic necklace",
        coords = vector3(127.5, -1283.7, 29.3),
        drop_method = "contract_reward",
        rarity = "legendary"
    },
    
    {
        id = 10,
        sin = "GLUTTONY",
        name = "GLUTTONY's Gold Chalice",
        title = "GLUTTONY's Gold Chalice",
        item_name = "shadow_artifact_gluttony_chalice",
        description = [[
An ornate golden chalice, always full.

The Chalice:
- Pure gold construction
- 8 inches tall
- Jewel-encrusted rim
- Never empties (magical?)

The Liquid:
- Always full of amber liquid
- Smells like expensive whiskey
- Never spills, even when tipped
- Tastes different to each drinker

Engravings:
- "GLUTTONY - Never Satisfied"
- Scenes of feasting and excess
- "More is never enough"

GLUTTONY drinks from this at every meeting.
Every celebration. Every victory.

The chalice represents endless appetite.
For wealth. For power. For everything.

To drink from it is to never be satisfied again.
"Always wanting more."
        ]],
        lore = "Looted from first casino heist. Symbol of excess and appetite. Unique - GLUTTONY's drinking vessel.",
        acquisition = "Spend $5 million on Black Market items + Show excessive consumption",
        game_effect = "+10% to all consumable effects + Usable for temporary buffs",
        coords = vector3(1118.7, 266.2, -51.0),
        drop_method = "progression_reward",
        rarity = "legendary"
    },
    
    {
        id = 11,
        sin = "SLOTH",
        name = "SLOTH's Silver Pocket Watch",
        title = "SLOTH's Silver Pocket Watch",
        item_name = "shadow_artifact_sloth_watch",
        description = [[
An antique silver pocket watch that runs backwards.

The Watch:
- Sterling silver case
- Intricate engravings
- Hands move counter-clockwise
- Always shows wrong time

The Face:
- White porcelain
- Roman numerals
- Green-tinted hands
- Cracks in the glass (decorative)

The Chain:
- Silver chain (12 inches)
- Inscription: "SLOTH - Time Means Nothing"
- "Why rush? Death comes for us all."

The watch represents SLOTH's philosophy:
Patience. Planning. Never rushing.
"Let others hurry to their graves."

Time moves differently for SLOTH.
Backwards. Sideways. Not at all.

To carry this watch is to master patience.
        ]],
        lore = "Inherited from infamous criminal ancestor. Symbol of patience and planning. Unique - SLOTH's family heirloom.",
        acquisition = "Wait 365 real-world days in Shadow Network + Active participation entire year",
        game_effect = "+30% planning time for heists (see more info) + Wearable cosmetic pocket watch",
        coords = vector3(-108.5, -8.3, 70.5),
        drop_method = "time_based_reward",
        rarity = "mythic"
    }
}

return Config