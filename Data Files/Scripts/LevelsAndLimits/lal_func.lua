local ui = require('openmw.ui')
local core = require('openmw.core')
local self = require('openmw.self')
local types = require('openmw.types')
local storage = require('openmw.storage')
local settings = storage.playerSection("SettingsLevelsAndLimits")
local settingsXP = storage.playerSection("SettingsLevelsAndLimitsXP")
local settingsMisc = storage.playerSection("SettingsLevelsAndLimitsY")

local L = core.l10n("LevelsAndLimits")

local favoredAttributes = types.NPC.classes.records[types.NPC.record(self).class].attributes

local racialSkills = {}
local playerRace = types.NPC.races.records[types.NPC.record(self).race]

for skill in pairs(playerRace.skills) do
    racialSkills[skill] = true
end

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

local function getRacialSkillToggle()
    return settings:get("lalRacialSkillToggle")
end

local function getRacialSkillMalus()
    return settings:get("lalRacialSkillMalus")
end

--

local function getXPToggle()
    return settingsXP:get("lalXPToggle")
end

local function getXPGlobalDivisor()
    return settingsXP:get("lalXPGlobalDivisor")
end

local function getXPDiminishingToggle()
    return settingsXP:get("lalXPDiminishingToggle")
end

local function getXPLessImpactfulDRDivisor()
    return settingsXP:get("lalXPLessImpactfulDRDivisor")
end

local function getXPDisableToggle()
    return settingsXP:get("lalXPDisableToggle")
end

--

local function getLevelProgressLimitToggle()
    return settings:get("lalLevelProgressLimitToggle")
end

local function getLevelProgressLimit()
    return settings:get("lalLevelProgressLimit")
end

local function getDisableTrainingToggle()
    return settings:get("lalDisableTrainingToggle")
end

local function getDisableBooksToggle()
    return settings:get("lalDisableBooksToggle")
end

--

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
    
    -- check Specialization
    if getSpecializationToggle() then
        if getSpecializationToggle() and classSpecialization ~= skillSpecialization then
            --print("nope, not a specialization skill")
            skillMaximum = skillMaximum - getSpecializationMalus()
        end
    end
    
    -- check Favored Attributes
    if getFavoredAttributesToggle() then
    -- print('FavoredAttributesToggle true')
    
        local skillAttribute = core.stats.Skill.records[skillid].attribute
        local isFavoredAttribute = false
        
        for _, attr in pairs(favoredAttributes) do
            if attr == skillAttribute then
                isFavoredAttribute = true
                break
            end
        end
        
        if not isFavoredAttribute then
            --print("nop, not favored either!")
            skillMaximum = skillMaximum - getFavoredAttributesMalus()
        end
    end
    
    -- check Racial Skills
    if getRacialSkillToggle() then
        if not racialSkills[skillid] then
            --print("eh, thats not a racial skill.")
            skillMaximum = skillMaximum - getRacialSkillMalus()
        end
    end

    --print("skill maximum: " .. skillMaximum)

    return skillMaximum
    
end

local function isSkillLevelUpPossible(skillid, options, majorSkills, minorSkills)

    if getDisableTrainingToggle() and options == 'trainer' then
        print('training disabled, trainer used!')
        return false
    end
    
    if getDisableBooksToggle() and options == 'book' then
        print('books disabled, book used!')
        return false
    end

    if getLevelProgressLimitToggle() then
        if (types.Actor.stats.level(self).progress >= getLevelProgressLimit()) then
            print('Progress Limit reached, no further skill ups possible until rested!')
            return false
        end
    end
    
    local skillStat = types.NPC.stats.skills[skillid](self)
    local skillLevel = skillStat.base

    if majorSkills[skillid] and skillLevel >= getModifiedSkillMaximum(skillid, getSettingMajorSkillLimit()) then
        print('major skill, skill maximum reached! ' .. getModifiedSkillMaximum(skillid, getSettingMajorSkillLimit() ) )
        return false
    elseif minorSkills[skillid] and skillLevel >= getModifiedSkillMaximum(skillid, getSettingMinorSkillLimit()) then
        print('minor skill, skill maximum reached! ' .. getModifiedSkillMaximum(skillid, getSettingMinorSkillLimit() ) )
        return false
    elseif not majorSkills[skillid] and not minorSkills[skillid] and skillLevel >= getModifiedSkillMaximum(skillid, getSettingMiscSkillLimit()) then
        print('misc skill, skill maximum reached! ' .. getModifiedSkillMaximum(skillid, getSettingMiscSkillLimit() ) )
        return false
    end

    return true
end

local function getModifiedSkillGain(skillid, skillGain)
    
    print(skillid .. ': gain vorher ' .. skillGain )
    
    local globalDivisor = math.max(1, getXPGlobalDivisor() )
    local diminDivisor = 1
    
    if getXPDiminishingToggle() then
        diminDivisor = math.max(1, (types.NPC.stats.skills[skillid](self).base / 10) / getXPLessImpactfulDRDivisor() )
    end
    
    skillGain = ( skillGain / globalDivisor ) / diminDivisor
    
    print('global divisor: ' .. globalDivisor .. ' diminDivisor: ' .. diminDivisor .. ' lessDiminDivisor: ' .. getXPLessImpactfulDRDivisor())
    print(skillid .. ':gain nachher ' .. skillGain)
    print("-----------------------------")
    
    return skillGain
end

local function isSkillGainPossible()

    if getXPDisableToggle() then
        print('skillgain was disabled')
        return false
    end
    
    if getLevelProgressLimitToggle() then
        if (types.Actor.stats.level(self).progress >= getLevelProgressLimit()) then
            print('skillgain was disabled, rest first!')
            return false
        end
    end
    
    print('skillgain possible!')
    
    return true

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
        getLevelProgressLimitToggle = getLevelProgressLimitToggle,
        getLevelProgressLimit = getLevelProgressLimit,
        resetSkillExperience = resetSkillExperience,
        showFailedSkillLevelUpMessage = showFailedSkillLevelUpMessage,
        getModifiedSkillMaximum = getModifiedSkillMaximum,
        getXPToggle = getXPToggle,
        getXPDisableToggle = getXPDisableToggle,
        getModifiedSkillGain = getModifiedSkillGain,
        getDisableTrainingToggle = getDisableTrainingToggle,
        getDisableBooksToggle = getDisableBooksToggle,
        isSkillLevelUpPossible = isSkillLevelUpPossible,
        isSkillGainPossible = isSkillGainPossible
    }
}
