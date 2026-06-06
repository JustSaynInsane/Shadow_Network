-- ============================================
-- SHADOW LORE SYSTEM - DATA LOADER
-- Compatible with Config.LoreFragments structure
-- Place in: shadow_elites_progression/data/lore_data.lua
-- ============================================

-- Load all lore data files
local lore_fragments = require 'data.lore_fragments'  -- Your existing file with Config.LoreFragments
local physical_notes = require 'data.physical_notes'
local classified_docs = require 'data.classified_documents'
local legendary_artifacts = require 'data.legendary_artifacts'

-- ============================================
-- DATA STRUCTURE ADAPTER
-- Converts Config tables to indexed tables for easy lookup
-- ============================================

local LoreData = {}

-- Convert USB fragments
LoreData.USB_FRAGMENTS = {}
if lore_fragments and lore_fragments.LoreFragments then
    for _, fragment in ipairs(lore_fragments.LoreFragments) do
        LoreData.USB_FRAGMENTS[fragment.id] = {
            title = fragment.title,
            content = fragment.content,
            item_name = 'shadow_usb_' .. string.format('%02d', fragment.id),
            unlock_condition = fragment.unlock_condition,
            type = 'usb',
            found_location = fragment.unlock_condition
        }
    end
end

-- Convert Physical Notes
LoreData.PHYSICAL_NOTES = {}
if physical_notes and physical_notes.LoreNotes then
    for _, note in ipairs(physical_notes.LoreNotes) do
        LoreData.PHYSICAL_NOTES[note.id] = {
            title = note.title,
            content = note.content,
            item_name = note.item_name,  -- From physical_notes.lua
            location = note.location,
            coords = note.coords,  -- For world spawns
            drop_method = note.drop_method,
            type = 'note',
            found_location = note.location
        }
    end
end

-- Convert Classified Documents
LoreData.CLASSIFIED_DOCS = {}
if classified_docs and classified_docs.LoreDocuments then
    for _, doc in ipairs(classified_docs.LoreDocuments) do
        LoreData.CLASSIFIED_DOCS[doc.id] = {
            title = doc.title,
            content = doc.content,
            item_name = doc.item_name,
            location = doc.location,
            risk_level = doc.risk_level,  -- HIGH or EXTREME
            wanted_stars = doc.wanted_stars,  -- 4 or 5
            type = 'document',
            found_location = doc.location
        }
    end
end

-- Convert Legendary Artifacts
LoreData.LEGENDARY_ARTIFACTS = {}
if legendary_artifacts and legendary_artifacts.LoreArtifacts then
    for _, artifact in ipairs(legendary_artifacts.LoreArtifacts) do
        LoreData.LEGENDARY_ARTIFACTS[artifact.id] = {
            title = artifact.title,
            name = artifact.name,
            description = artifact.description,
            lore = artifact.lore,
            item_name = artifact.item_name,
            game_effect = artifact.game_effect,
            acquisition = artifact.acquisition,
            type = 'artifact',
            found_location = artifact.acquisition
        }
    end
end

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

function LoreData.GetItem(loreType, loreId)
    if loreType == 'usb' then
        return LoreData.USB_FRAGMENTS[loreId]
    elseif loreType == 'note' then
        return LoreData.PHYSICAL_NOTES[loreId]
    elseif loreType == 'document' then
        return LoreData.CLASSIFIED_DOCS[loreId]
    elseif loreType == 'artifact' then
        return LoreData.LEGENDARY_ARTIFACTS[loreId]
    end
    return nil
end

function LoreData.GetItemName(loreType, loreId)
    local item = LoreData.GetItem(loreType, loreId)
    return item and item.item_name or nil
end

function LoreData.GetAllUSBs()
    return LoreData.USB_FRAGMENTS
end

function LoreData.GetAllNotes()
    return LoreData.PHYSICAL_NOTES
end

function LoreData.GetAllDocuments()
    return LoreData.CLASSIFIED_DOCS
end

function LoreData.GetAllArtifacts()
    return LoreData.LEGENDARY_ARTIFACTS
end

-- ============================================
-- EXPORT
-- ============================================

return LoreData