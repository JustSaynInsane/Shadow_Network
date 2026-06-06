# Shadow_Network
I created these for my own server I am running. It is a work in progress still, I have put 3 months of scripting, creating images and the UI. 

# Shadow Network Ecosystem: Modular Framework for Roleplay Servers
A highly customized, modular backend infrastructure built on top of the Qbox open-source framework. This project demonstrates framework engineering, legacy code modification, database serialization, and interactive UI integration using JavaScript, Lua, and custom data schemas.

## 🛠️ Core Engineering Highlights
* **Framework Adaptation:** Audited and refactored multiple boilerplate Qbox resource dependencies to enforce strict, centralized integration with a proprietary core control system.
* **Modular Infrastructure:** Engineered a 10-file decoupled architecture where specialized child directories (`blackmarket`, `boosting`, `progression`) dynamically extend and "piggyback" off the central tablet controller.
* **Data Serialization & Persistent State:** Designed interactive game-world objects (Encrypted USBs, Burned Documents) that pass raw states across independent client/server loops to decrypt lore data and dynamically render complex UI elements.

## 🗂️ Architectural Directory Structure
* `shadow_tablet/` - The foundational core system controller and UI router.
* `shadow_elites_progression/` - Logic engine tracking state persistence and unlock states.
* `shadow_elites_blackmarket/` & `shadow_elites_boosting/` - Modular endpoints handling inventory transactions and specific network events.
* `shadow_shops/` - Secure database transaction gateways validating system currency and player inventory states.

## 💻 Tech Stack & Methodologies Used
* **Languages:** Lua (Game Loops & Server Events), JavaScript/HTML/CSS (NUI Frontend Architecture), PowerShell (Administrative Backend Tooling).
* **AI-Augmented Development:** Utilized advanced LLM prompt workflows to perform deep-dive code reviews, trace unexpected runtime exceptions, and optimize multi-file execution paths.
* **Security & Optimization:** Focused heavily on mitigating unauthorized event execution (Network Event Hardening) and minimizing performance overhead across server-side scripts.
