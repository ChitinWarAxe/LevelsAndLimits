local ui = require('openmw.ui')
local core = require('openmw.core')
local self = require('openmw.self')
local types = require('openmw.types')
local storage = require('openmw.storage')
local settings = storage.playerSection("SettingsLevelsAndLimits")

local L = core.l10n("LevelsAndLimits")

local function getLaLToggle()
    return settings:get("lalToggle")
end

local function getSettingMajorSkillLimit()
    return settings:get("lalLimitMajor")
end

local function getSettingMinorSkillLimit()
    return settings:get("lalLimitMinor")
end

local function getSettingMiscSkillLimit()
    return settings:get("lalLimitMisc")
end

local function getSpecializationToggle()
    return settings:get("lalSpecializationToggle")
end

local function getSpecializationMalus()
    return settings:get("lalSpecializationMalus")
end

local function getFavoredAttributesToggle()
    return settings:get("lalFavoredAttributesToggle")
end

local function getFavoredAttributesMalus()
    return settings:get("lalFavoredAttributesMalus")
end

local function resetSkillExperience(skillid)
    local skillStat = types.NPC.stats.skills[skillid](self)
    if skillStat.progress > 1 then
        skillStat.progress = 1
    end
end

local function showFailedSkillLevelUpMessage(method)
    if method == 'trainer' then
        ui.showMessage(string.format(L("levelUpFailTrainer")))
    elseif method == 'book' then
        ui.showMessage(string.format(L("levelUpFailBook")))
    end
end

local function getModifiedSkillMaximum(skillid, skillMaximum)

    local classSpecialization = types.NPC.classes.records[types.NPC.record(self).class].specialization
    local skillSpecialization = core.stats.Skill.records[skillid].specialization
    
    if getSpecializationToggle() and classSpecialization ~= skillSpecialization then
        skillMaximum = skillMaximum - getSpecializationMalus()
    end
    
    if getFavoredAttributesToggle() then
    
        local favoredAttributes = types.NPC.classes.records[types.NPC.record(self).class].attributes
        local skillAttribute = core.stats.Skill.records[skillid].attribute
        local isFavoredAttribute = false
        
        for _, attr in pairs(favoredAttributes) do
            if attr == skillAttribute then
                isFavoredAttribute = true
                break
            end
        end
        
        if not isFavoredAttribute then
            skillMaximum = skillMaximum - getFavoredAttributesMalus()
        end
    end

    return skillMaximum
    
end

return {
    interfaceName = "lalUtil",
    interface = {
        getLaLToggle = getLaLToggle,
        getSettingMajorSkillLimit = getSettingMajorSkillLimit,
        getSettingMinorSkillLimit = getSettingMinorSkillLimit,
        getSettingMiscSkillLimit = getSettingMiscSkillLimit,
        getSpecializationToggle = getSpecializationToggle,
        getSpecializationMalus = getSpecializationMalus,
        getFavoredAttributesToggle = getFavoredAttributesToggle,
        getFavoredAttributesMalus = getFavoredAttributesMalus,
        resetSkillExperience = resetSkillExperience,
        showFailedSkillLevelUpMessage = showFailedSkillLevelUpMessage,
        getModifiedSkillMaximum = getModifiedSkillMaximum
    }
}
