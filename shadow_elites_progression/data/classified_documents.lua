-- =============================================
-- SHADOW ELITES - CLASSIFIED DOCUMENTS (15 TOTAL)
-- High-risk items from government/corporate sources
-- CONVERTED TO CONFIG STRUCTURE WITH GTA 5 AGENCY NAMES
-- =============================================

Config = Config or {}

Config.LoreDocuments = {
    
    -- =============================================
    -- LSPD FILES (1-5)
    -- Police investigation reports, case files
    -- Risk: HIGH - 4 star wanted on acquisition
    -- =============================================
    
    {
        id = 1,
        title = "LSPD Internal Memo - Operation Shadow Hunt",
        item_name = "shadow_doc_lspd_01",
        content = [[
[CLASSIFIED - EYES ONLY]

MEMORANDUM
TO: All Detectives
FROM: Captain Rodriguez
RE: Operation Shadow Hunt

We have credible intelligence regarding a criminal organization 
operating under the name "Shadow Network." Initial investigations 
suggest involvement in:
- Bank robberies (6 confirmed)
- Drug trafficking (estimated $2M/month)
- Auto theft ring (100+ vehicles)

Three suspects identified:
1. ████████████ (Narcotics)
2. ████████████ (Heists)
3. ████████████ (Auto Theft)

CRITICAL: Four unidentified leaders known as "The Horsemen"
- WAR (Organized Crime)
- FAMINE (Narcotics)
- CONQUEST (Auto Theft)
- DEATH (Unknown - possibly myth)

Task Force established. All information classified.

[STAMP: TOP SECRET]
        ]],
        location = "City Hall, Records Department",
        coords = vector3(-551.3, -191.5, 38.2),
        drop_method = "high_risk",
        wanted_stars = 4,
        risk_level = "HIGH",
        rarity = "legendary"
    },
    
    {
        id = 2,
        title = "Police Report #4782 - Unsolved Homicide",
        item_name = "shadow_doc_lspd_02",
        content = [[
[CASE FILE - OPEN INVESTIGATION]

CASE #4782
DATE: 2023-06-15
VICTIM: Marcus Johnson (aka "The Rat")
CAUSE OF DEATH: Multiple gunshot wounds
LOCATION: Cypress Flats warehouse

EVIDENCE:
- No witnesses
- Security cameras disabled
- Professional execution
- Message left at scene: "DEATH was here"

SUSPECT DESCRIPTION:
Unknown. No forensic evidence.
Possibly connected to "Shadow Network" investigation.

NOTES FROM DETECTIVE:
"This wasn't random. This was a message. 
Victim was known informant. Execution-style killing.
Someone is silencing witnesses."

STATUS: UNSOLVED - ACTIVE
        ]],
        location = "Police Station, Detective's Office",
        coords = vector3(442.5, -982.7, 30.7),
        drop_method = "high_risk",
        wanted_stars = 4,
        risk_level = "HIGH",
        rarity = "legendary"
    },
    
    {
        id = 3,
        title = "Confidential Witness Protection File",
        item_name = "shadow_doc_lspd_03",
        content = [[
[WITNESS PROTECTION - CLASSIFIED]

WITNESS ID: WP-2024-0158
NAME: █████████████ (REDACTED)
CASE: Shadow Network Investigation

TESTIMONY SUMMARY:
Witness claims knowledge of:
- Shadow Network leadership structure
- Four Horsemen identities
- "The Purge" incident (2019)
- Seven Sins Inner Circle

PROTECTION STATUS: ACTIVE
LOCATION: ████████████████
HANDLER: Agent ████████

RISK ASSESSMENT: EXTREME
"Witness claims 'They have people everywhere. 
Police, government, business. I'm already dead.'"

[STAMP: CONFIDENTIAL - DESTROY AFTER READING]
        ]],
        location = "Federal Building, Records Room",
        coords = vector3(134.3, -761.8, 242.2),
        drop_method = "high_risk",
        wanted_stars = 5,
        risk_level = "EXTREME",
        rarity = "legendary"
    },
    
    {
        id = 4,
        title = "Detective's Personal Notes - Shadow Network",
        item_name = "shadow_doc_lspd_04",
        content = [[
[DETECTIVE'S PRIVATE NOTES]

SHADOW NETWORK INVESTIGATION
Detective James Chen - Lead Investigator

SUSPECTS (Confirmed):
- 15+ mid-level operators
- 4 "Horsemen" (leaders)
- 7 "Sins" (inner circle)

PATTERN ANALYSIS:
Every major heist in past 3 years shows same pattern:
- No witnesses left alive
- Security footage destroyed
- Inside information used
- Professional execution

THE PURGE (2019):
Something happened. Mass killings. 7 bodies found.
All connected to Shadow Network.
Message left: "LOYALTY OR DEATH"

No arrests. No convictions. Perfect crime.

MY THEORY:
This isn't a gang. This is a corporation.
Leadership hidden behind proxies.
Operations planned like military missions.
We're not fighting criminals.
We're fighting an invisible empire.

[PERSONAL NOTE - DESTROY IF DISCOVERED]
        ]],
        location = "Detective's Home Office",
        coords = vector3(-1392.5, -589.2, 30.3),
        drop_method = "world_spawn",
        wanted_stars = 3,
        risk_level = "MEDIUM",
        rarity = "rare"
    },
    
    {
        id = 5,
        title = "The Purge Investigation - Closed Case",
        item_name = "shadow_doc_lspd_05",
        content = [[
[CASE FILE - CLOSED]

CASE: "The Purge" Mass Homicide
DATE: October 2019
VICTIMS: 7 (unidentified)
LOCATION: Los Santos River

EVIDENCE:
- All bodies dumped in river
- IDs removed
- Dental records filed
- Fingerprints destroyed (acid)
- DNA contaminated

MESSAGE FOUND:
Carved in driftwood: "LOYALTY OR DEATH"

INVESTIGATION CONCLUSION:
Internal dispute within criminal organization.
Shadow Network eliminated internal threats.
No arrests made.
No suspects identified.

STATUS: CLOSED - UNSOLVED

[STAMP: DO NOT REOPEN WITHOUT AUTHORIZATION]
        ]],
        location = "Police Archives, Basement",
        coords = vector3(445.7, -978.5, 25.7),
        drop_method = "high_risk",
        wanted_stars = 5,
        risk_level = "EXTREME",
        rarity = "legendary"
    },
    
    -- =============================================
    -- GOVERNMENT FILES (6-10)
    -- FIB, DOA, San Andreas Revenue investigations
    -- Risk: EXTREME - 5 star wanted
    -- =============================================
    
    {
        id = 6,
        title = "FIB Investigation Report - Organized Crime",
        item_name = "shadow_doc_gov_06",
        content = [[
[FEDERAL INVESTIGATION BUREAU]
[TOP SECRET - CLASSIFIED]

INVESTIGATION: Shadow Network Criminal Enterprise
CASE NUMBER: FIB-LS-2024-1847
AGENT IN CHARGE: Special Agent Rodriguez

OVERVIEW:
Multi-jurisdictional criminal organization operating in Los Santos.
Estimated annual revenue: $50-100 million
Operations: Narcotics, robbery, theft, money laundering

STRUCTURE:
Top Level: "The Four Horsemen" (4 leaders)
- WAR: Bank robberies, organized heists
- FAMINE: Drug distribution network
- CONQUEST: Auto theft operations  
- DEATH: Enforcement/elimination (unconfirmed)

Mid Level: "The Seven Sins" (7 elite members)
- GREED: Financial operations
- WRATH: Enforcement
- ENVY: Narcotics lieutenant
- [4 MORE UNIDENTIFIED]

Lower Level: 100+ operators

INVESTIGATION STATUS:
- 3 years active investigation
- 0 arrests (witnesses disappear/killed)
- 0 cooperation from local PD (possible corruption)

RECOMMENDATION: Federal takeover of investigation

[STAMP: ABOVE TOP SECRET - DESTROY AFTER READING]
        ]],
        location = "FIB Building, Evidence Room",
        coords = vector3(136.2, -749.5, 242.2),
        drop_method = "high_risk",
        wanted_stars = 5,
        risk_level = "EXTREME",
        rarity = "legendary"
    },
    
    {
        id = 7,
        title = "San Andreas Revenue Audit - Financial Crimes",
        item_name = "shadow_doc_gov_07",
        content = [[
[SAN ANDREAS DEPARTMENT OF REVENUE]
[CONFIDENTIAL TAX INVESTIGATION]

SUBJECT: Suspicious Financial Activity
CASE: SAR-LS-2024-4721
INVESTIGATOR: Revenue Agent Martinez

FINDINGS:
Multiple shell companies linked to same network:
- "Green Logistics LLC" - $2.5M/year
- "Shadow Consulting Inc" - $3.8M/year
- "Four Corners Trading" - $5.2M/year
- [12 MORE COMPANIES]

TOTAL UNREPORTED INCOME: $47 million (estimated)

RED FLAGS:
- Cryptocurrency transactions (untraceable)
- Offshore accounts (Cayman Islands)
- Cash-heavy businesses (laundering front)
- No legitimate business activity

COMMON DENOMINATORS:
All companies registered to:
████████████████
Address: ████████████████

CRIMINAL REFERRAL:
Case forwarded to FIB for criminal investigation.
Potential charges: Tax evasion, money laundering, RICO

[STAMP: CONFIDENTIAL - DO NOT DISTRIBUTE]
        ]],
        location = "Revenue Office, Downtown",
        coords = vector3(-525.7, -183.2, 37.9),
        drop_method = "high_risk",
        wanted_stars = 5,
        risk_level = "EXTREME",
        rarity = "legendary"
    },
    
    {
        id = 8,
        title = "DOA Operations Memo - Drug Trafficking",
        item_name = "shadow_doc_gov_08",
        content = [[
[DRUG OBSERVATION AGENCY]
[OPERATIONAL SECURITY - CLASSIFIED]

OPERATION: Green Wave
TARGET: Shadow Network narcotics distribution
LEAD AGENT: Special Agent Thompson

INTELLIGENCE SUMMARY:
Sophisticated drug trafficking operation:
- Source: ████████████ (international)
- Distribution: Los Santos network
- Volume: 500+ kg/month (estimated)
- Revenue: $2-5 million/month

DISTRIBUTION STRUCTURE:
Top: "FAMINE" (unidentified leader)
Mid: "ENVY" (lieutenant)
Low: 30+ street dealers

METHODS:
- Corner selling (street level)
- Delivery service (encrypted phones)
- Lab operations (meth production)
- Weed farms (cultivation)

INVESTIGATION CHALLENGES:
- No cooperation from street dealers
- Encrypted communications
- Cash-only transactions
- Violent enforcement (2 informants killed)

UNDERCOVER OPERATIONS:
Attempt #1: Agent exposed, fled city
Attempt #2: Agent disappeared (presumed dead)
Attempt #3: CANCELLED - too dangerous

RECOMMENDATION:
Federal task force required.
Local resources insufficient.

[STAMP: OPERATIONAL SECURITY - BURN AFTER READING]
        ]],
        location = "DOA Field Office, Industrial District",
        coords = vector3(2436.7, 4968.3, 42.3),
        drop_method = "high_risk",
        wanted_stars = 5,
        risk_level = "EXTREME",
        rarity = "legendary"
    },
    
    {
        id = 9,
        title = "Department of Justice - Prosecution Failures",
        item_name = "shadow_doc_gov_09",
        content = [[
[DEPARTMENT OF JUSTICE]
[INTERNAL REVIEW - CONFIDENTIAL]

SUBJECT: Shadow Network Prosecution Record
PREPARED BY: Deputy Attorney General Williams

PROSECUTION HISTORY (2020-2024):
Total arrests: 47
Successful prosecutions: 2 (4.2%)
Dismissed cases: 45 (95.8%)

DISMISSAL REASONS:
- Evidence mishandling: 23 cases
- Procedural errors: 15 cases
- Witness recantation: 7 cases

SUSPICIOUS PATTERNS:
Same evidence clerk involved in 18 dismissals
Same prosecutor "made mistakes" in 12 cases
Same judge presided over 15 dismissals

CORRUPTION INVESTIGATION:
Suspected bribery of:
- 2 evidence clerks
- 1 prosecutor
- 1 Superior Court judge

Estimated payroll: $340,000/month

CONCLUSION:
Shadow Network has infiltrated our justice system.
We cannot prosecute what we cannot prove.
They own the people who decide guilt.

[STAMP: INTERNAL AFFAIRS - DO NOT LEAK]
        ]],
        location = "Department of Justice, Downtown",
        coords = vector3(240.4, -410.7, 47.9),
        drop_method = "high_risk",
        wanted_stars = 5,
        risk_level = "EXTREME",
        rarity = "legendary"
    },
    
    {
        id = 10,
        title = "FIB Corruption Report - Internal Investigation",
        item_name = "shadow_doc_gov_10",
        content = [[
[FEDERAL INVESTIGATION BUREAU]
[INTERNAL AFFAIRS DIVISION]
[EYES ONLY - MAXIMUM CLASSIFICATION]

INVESTIGATION: Law Enforcement Corruption
CASE: FIB-IA-2024-9847
LEAD: Internal Affairs Director Mitchell

SUSPECTED CORRUPT OFFICIALS:
LSPD: 4 officers, 1 captain, 2 evidence clerks
COURTS: 2 Superior judges, 1 prosecutor
FIB: [REDACTED - ONGOING INVESTIGATION]

EVIDENCE:
Unexplained deposits totaling $340,000/month
Offshore cryptocurrency accounts
Shell company payments
Pattern of case dismissals

SHADOW NETWORK PAYROLL (Estimated):
Monthly: $340,000
Annual: $4.08 million

INVESTIGATION STATUS:
Cannot arrest without compromising operation.
Building RICO case (2-3 years minimum).
Any leak = suspects flee = case destroyed.

CRITICAL:
We suspect Shadow Network has infiltrated
multiple levels of government.

Trust no one.

[STAMP: DESTROY AFTER READING - LEAK = TREASON]
        ]],
        location = "FIB Building, Internal Affairs Office",
        coords = vector3(136.2, -761.8, 242.2),
        drop_method = "high_risk",
        wanted_stars = 5,
        risk_level = "EXTREME",
        rarity = "legendary"
    },
    
    -- =============================================
    -- CORPORATE FILES (11-13)
    -- Bank, casino, port authority
    -- Risk: MEDIUM - 3 star wanted
    -- =============================================
    
    {
        id = 11,
        title = "Pacific Standard Bank - Security Breach Report",
        item_name = "shadow_doc_corp_11",
        content = [[
[PACIFIC STANDARD BANK]
[INTERNAL SECURITY AUDIT]

AUDIT DATE: January 2024
PREPARED BY: Chief Security Officer Walsh

SECURITY BREACHES (2023):
- Fleeca Bank (Great Ocean): $247,000 stolen
- Fleeca Bank (Legion Square): $318,000 stolen
- Pacific Standard (Main Vault): $2.1M stolen

TOTAL LOSSES: $2.665 million

PATTERN ANALYSIS:
All three heists show:
- Inside knowledge of procedures
- Shift change exploitation
- Camera blind spot awareness
- Guard schedule knowledge

INSIDER THREAT ASSESSMENT:
High probability of employee involvement.
Investigated 47 employees.
Found: Nothing.

Either employees are clean,
or insider is too smart to catch.

RECOMMENDATIONS:
- Randomize all schedules
- Unpredictable maintenance
- Monthly protocol changes
- Quarterly employee rotation

COST: $1.2M annually
VALUE: Preventing future $2M+ losses

[CONFIDENTIAL - INTERNAL USE ONLY]
        ]],
        location = "Pacific Standard Bank, Executive Office",
        coords = vector3(241.7, 227.5, 106.3),
        drop_method = "high_risk",
        wanted_stars = 3,
        risk_level = "MEDIUM",
        rarity = "rare"
    },
    
    {
        id = 12,
        title = "Diamond Casino - High Roller Monitoring",
        item_name = "shadow_doc_corp_12",
        content = [[
[DIAMOND CASINO & RESORT]
[SECURITY LOG - CONFIDENTIAL]

SUBJECT: Suspicious High Roller Activity
PERIOD: October 2023 - October 2024

PLAYER #1 (Anonymous):
- Visits: 47 times
- Average spend: $50,000/visit
- Win rate: 52% (statistically unusual)
- Cashout: Cryptocurrency

PLAYER #2 (Anonymous):
- Visits: 34 times
- Average spend: $75,000/visit
- Win rate: 49% (above average)
- Cashout: Offshore wire

PLAYER #3 (Anonymous):
- Visits: 28 times
- Average spend: $100,000/visit
- Win rate: 54% (highly suspicious)
- Cashout: Cash (large bills)

INVESTIGATION:
All three players:
- Use sophisticated fake IDs
- Arrive in different vehicles each time
- Avoid cameras deliberately
- Pay in untraceable cash

ASSESSMENT:
These aren't gamblers.
These are money launderers.

Estimated laundered: $4.2M (past year)
Our profit from "losses": $420,000

RECOMMENDATION:
Continue allowing their play.
We profit from their laundering.

If they're Shadow Network (suspected),
we don't want the attention.

- Marcus Thompson, Director of Security

[CONFIDENTIAL - MANAGEMENT ONLY]
        ]],
        location = "Diamond Casino, Security Office",
        coords = vector3(1089.9, 206.3, -49.0),
        drop_method = "high_risk",
        wanted_stars = 3,
        risk_level = "MEDIUM",
        rarity = "rare"
    },
    
    {
        id = 13,
        title = "Port Authority - Smuggling Investigation",
        item_name = "shadow_doc_corp_13",
        content = [[
[PORT OF LOS SANTOS]
[INVESTIGATION REPORT - CONFIDENTIAL]

INVESTIGATION: Suspicious Cargo Patterns
LEAD: Harbor Master Rodriguez
DATE: August 2024

SUSPICIOUS CONTAINERS (47 total):
Pattern: All arrive on specific vessels,
assigned to specific inspectors,
bypass normal inspection,
cleared within 2 hours.

SAMPLE CONTAINERS:
Container #LS-2024-8841:
- Declared: Auto parts
- Actual: Stolen vehicles
- Inspection: Waived

Container #LS-2024-9127:
- Declared: Agricultural equipment
- Actual: Unknown (never inspected)
- Inspection: Waived

ESTIMATED VALUE:
$2-5M per container
2-3 containers per month
Annual smuggling: $50-100M

CORRUPTION EVIDENCE:
4 customs inspectors receive:
$10,000 per container
Annual bribes: $300,000+

RECOMMENDATION:
This requires FIB investigation.

However...
If we expose this operation:
- 4 inspectors arrested
- Port loses major client
- Revenue drops significantly

My recommendation:
Document, but don't act.
Let FIB discover independently.
Maintain plausible deniability.

- David Rodriguez, Harbor Master

[CONFIDENTIAL - DO NOT DISTRIBUTE]
        ]],
        location = "Port of Los Santos, Admin Building",
        coords = vector3(1244.5, -3138.2, 5.5),
        drop_method = "high_risk",
        wanted_stars = 3,
        risk_level = "MEDIUM",
        rarity = "rare"
    },
    
    -- =============================================
    -- PERSONAL FILES (14-15)
    -- Diary & resignation letter
    -- Risk: LOW - no wanted level
    -- =============================================
    
    {
        id = 14,
        title = "Personal Diary - Inner Circle Member",
        item_name = "shadow_doc_personal_14",
        content = [[
[PERSONAL DIARY - FOUND IN EVIDENCE]

Entry: October 15, 2023

I passed the trial.

I'm one of The Seven now.

They gave me a name: [REDACTED]

The money is incredible.
The power is intoxicating.

But the isolation...

I work next to people every day
who will never know what I am.

I rob banks with crews who think
I'm just another criminal.

I take orders from voices I'll never meet faces.

Is this what I wanted?

Yes.

Because I'm not just a criminal anymore.

I'm a legend.

And legends don't need friends.
They need fear. Respect.

I have both now.

[Entry ends]

[Found during warehouse raid]
[Owner: Unknown]
[Classified as evidence]
        ]],
        location = "Random heist drop",
        coords = vector3(0, 0, 0),  -- Random spawn
        drop_method = "random_drop",
        wanted_stars = 0,
        risk_level = "LOW",
        rarity = "legendary"
    },
    
    {
        id = 15,
        title = "Resignation Letter - Horseman Departure",
        item_name = "shadow_doc_personal_15",
        content = [[
[HANDWRITTEN LETTER - NO FINGERPRINTS]
[FOUND IN MAZE BANK ARCHIVES]

To the remaining Three,

After 8 years, it's time.

I've built my empire.
I've secured my legacy.
I've earned my retirement.

Don't look for me.
Don't contact me.
I'm gone.

My operations continue under [REDACTED].
My networks remain intact.
My identity remains secret.

The Shadow Network doesn't need me anymore.
And I don't need it.

We built something incredible.
We changed Los Santos forever.

We proved criminals can operate like corporations.
That shadows can control the light.

But I'm tired.

Tired of looking over my shoulder.
Tired of encrypted messages.
Tired of hiding.

I'm going somewhere warm.
Somewhere quiet.
Somewhere no one knows my name.

Because here? Everyone knows my name.
They just don't know my face.

Thank you for 8 years of perfection.

Don't mourn my departure.
Celebrate our success.

I'll be watching from afar.

Stay in the shadows.

- [SIGNATURE REDACTED]

[Letter dated: 2023]
[Authenticity: Unconfirmed]
[Investigation: Ongoing]
        ]],
        location = "Maze Bank archives",
        coords = vector3(-75.8, -818.5, 243.4),
        drop_method = "world_spawn",
        wanted_stars = 0,
        risk_level = "LOW",
        rarity = "legendary"
    },
}

return Config