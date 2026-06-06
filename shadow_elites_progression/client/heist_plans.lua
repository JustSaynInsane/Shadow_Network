RegisterNetEvent('shadow_elites:client:showHeistPlan', function(planType)
    local planDetails = {
        jewelry_heist_plan = {
            title = '💎 Vangelico Jewelry Store - Classified Intel',
            content = [[
█████████████████████████████████████████
█  SHADOW NETWORK - OPERATION DIAMOND  █
█████████████████████████████████████████

TARGET: Vangelico Jewelry Store
LOCATION: Rockford Hills, Downtown LS
DIFFICULTY: ████████░░ (8/10)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 REQUIRED CREW: 2-4 Members
⏰ ESTIMATED TIME: 8-12 Minutes
💰 ESTIMATED TAKE: $600,000 - $1,000,000

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 EQUIPMENT NEEDED:
├─ Gatecrack Device (Entrance)
├─ Thermite x2 (Display Cases)
└─ Drill (Safety Boxes)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 PHASE 1: ENTRY
├─ Use Gatecrack on front gate
├─ 60 second hack window
└─ Alarm triggers on failure

📍 PHASE 2: SMASH & GRAB
├─ Thermite on display cases
├─ Grab jewelry from cases
├─ Time limit: 4 minutes
└─ Police response: 2-3 minutes

📍 PHASE 3: VAULT (Optional)
├─ Drill safety deposit boxes
├─ High value items
├─ +3 minutes to job
└─ Increased police presence

📍 PHASE 4: ESCAPE
├─ Exit through back alley
├─ Lose 3-star wanted level
└─ Rendezvous at safe house

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ SECURITY NOTES:
├─ 6 cameras (can be disabled)
├─ 2 armed guards
├─ Silent alarm to LSPD
├─ Backup arrives in 2-3 min
└─ High-speed chase expected

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 INSIDER TIPS:
"The guards change shift at 3 AM. That's your
best window. Smash the cases fast and get out.
Don't get greedy with the vault - most crews
that do end up in cuffs."

- Shadow Network Intelligence

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Good luck. You'll need it.

This document will self-destruct... just kidding.
But seriously, burn this after you memorize it.
            ]],
        },
        
        pacific_heist_plan = {
            title = '🏛️ Pacific Standard Bank - Top Secret',
            content = [[
█████████████████████████████████████████
█   SHADOW NETWORK - OPERATION TITAN   █
█████████████████████████████████████████

TARGET: Pacific Standard Public Deposit Bank
LOCATION: Downtown Los Santos
DIFFICULTY: ██████████ (10/10)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 REQUIRED CREW: 3-5 Members (MANDATORY)
⏰ ESTIMATED TIME: 15-20 Minutes
💰 ESTIMATED TAKE: $800,000 - $1,200,000

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 EQUIPMENT NEEDED:
├─ High-Level Security Cards x2
├─ Thermite x4 (Vault Doors)
├─ Drill x2 (Multiple Boxes)
└─ Trojan USB x2 (Computer Systems)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 PHASE 1: INFILTRATION
├─ Security cards for entry
├─ Trojan USB on front desk
├─ Disable external cameras
└─ Alarm WILL trigger eventually

📍 PHASE 2: LOBBY CONTROL
├─ Control all hostages (CRITICAL)
├─ Police negotiation: 4-5 min
├─ Block all entrances
└─ Assign crew positions

📍 PHASE 3: VAULT BREACH
├─ Thermite on outer vault door
├─ 90 second wait time
├─ Thermite on inner vault gate
├─ Police assault begins
└─ Hold position

📍 PHASE 4: THE SCORE
├─ Drill safety deposit boxes
├─ Grab cash from vault
├─ Fill bags (weight limits)
└─ Time limit: 6 minutes

📍 PHASE 5: ESCAPE
├─ Exit strategy CRITICAL
├─ 4-star wanted level
├─ Helicopter support expected
├─ Multiple roadblocks
└─ SWAT team deployment

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ SECURITY NOTES:
├─ 8 armed security guards
├─ Panic button in manager's office
├─ Bank-wide lockdown capable
├─ Direct line to LSPD HQ
├─ Reinforced vault (titanium)
└─ Dye packs in some cash bundles

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 INSIDER TIPS:
"This isn't Fleeca. This is the big leagues.
One mistake and you're looking at 20 years.

Communication is KEY. One person on hostages.
One on vault. One on lookout. One on getaway.

The vault has TWO doors - don't forget the
second thermite charge.

And for the love of god, don't try to be
a hero. Get in. Get paid. Get out.

Half the city's cops will be on you in 5
minutes. Plan your escape route BEFORE you
even step inside."

- Shadow Network Intelligence

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This is it. The score of a lifetime.

Don't fuck it up.
            ]],
        },
    }
    
    local plan = planDetails[planType]
    if not plan then return end
    
    -- Show the plan in a text UI
    lib.alertDialog({
        header = plan.title,
        content = plan.content,
        centered = true,
        cancel = true,
        size = 'xl',
    })
end)