local ui = require('openmw.ui')
local core = require('openmw.core')
local self = require('openmw.self')
local types = require('openmw.types')
local storage = require('openmw.storage')
local settings = storage.playerSection("SettingsLevelsAndLimits")
local settingsXP = storage.playerSection("SettingsLevelsAndLimitsXP")
local settingsY = storage.playerSection("SettingsLevelsAndLimitsY")

local L = core.l10n("LevelsAndLimits")

local favoredAttributes = types.NPC.classes.records[types.NPC.record(self).class].attributes

local racialSkills = {}
local playerRace = types.NPC.races.records[types.NPC.record(self).race]

local playerClass = types.NPC.classes.records[types.NPC.record(self).class]
local playerSkills = playerClass.skills

local majorSkills = {}
local minorSkills = {}

for _, skill in ipairs(playerClass.majorSkills) do 
    majorSkills[skill] = true
end

for _, skill in ipairs(playerClass.minorSkills) do 
    minorSkills[skill] = true
end

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

local function getXPGlobalMultiplier()
    return settingsXP:get("lalXPGlobalMultiplier")
end

local function getXPDiminishingToggle()
    return settingsXP:get("lalXPDiminishingToggle")
end

local function getXPDiminishingMultiplier()
    return settingsXP:get("lalXPDiminishingMultiplier")
end

local function getXPDisableToggle()
    return settingsXP:get("lalXPDisableToggle")
end

--

local function getLevelProgressLimitToggle()
    return settingsY:get("lalLevelProgressLimitToggle")
end

local function getLevelProgressLimit()
    return settingsY:get("lalLevelProgressLimit")
end

local function getDisableTrainingToggle()
    return settings:get("lalDisableTrainingToggle")
end

local function getDisableBooksToggle()
    return settings:get("lalDisableBooksToggle")
end

local function getDebugInfoToggle()
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

local function isLevelUpProgressLimitReached(progress)
    return progress >= getLevelProgressLimit()
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
        if ( isLevelUpProgressLimitReached(types.Actor.stats.level(self).progress) ) then
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

local function getSkillMaximum(skillid)

    if majorSkills[skillid] then
        return getSettingMajorSkillLimit()
    end
    
    if minorSkills[skillid] then
        return getSettingMinorSkillLimit()
    end
    
    return getSettingMiscSkillLimit()

end

local function getSkillGainMultiplier(skillid)
    local globalMultiplier = getXPGlobalMultiplier()
    local finalMultiplier = globalMultiplier
    
    if getXPDiminishingToggle() then
        local skillLevel = types.NPC.stats.skills[skillid](self).base
        print(skillid .. ' ' .. (skillLevel / 10) * getXPDiminishingMultiplier())
        local diminishMultiplier = 1 / math.max(1, (skillLevel / 10) * getXPDiminishingMultiplier()) 
        finalMultiplier = globalMultiplier * diminishMultiplier
    end

    return finalMultiplier
end

local function getModifiedSkillGain(skillid, skillGain)
    
    print('-----------------------------------------')
    print(skillid .. ': Initital Skillgain ' .. skillGain )
    
    skillGain = skillGain * getSkillGainMultiplier(skillid)
    
    print('Calculated Skillgain (Skill Gain * Global Multiplier) / Diminishing returns Divisor: ' .. skillGain)
    print('-----------------------------------------')
    print('')

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

local function printDebugInfo()
 
    local printout = '\n--- DEBUG INFO---'

    for i, skill in ipairs(core.stats.Skill.records) do
    
        local multiplier = tonumber(string.format("%.3f", getSkillGainMultiplier(skill.id)))
        
        printout = printout .. '\n ' .. skill.id .. ', maximum skill level: ' .. getModifiedSkillMaximum(skill.id, getSkillMaximum(skill.id) ) .. ', experience gain multiplier: ' .. multiplier .. 'x'
        
    end
    
    printout = printout .. '\n--- DEBUG END ---'
    
    print(printout);

end

return {
    interfaceName = "lalUtil",
    interface = {
        getLaLToggle = getLaLToggle,
        resetSkillExperience = resetSkillExperience,
        showFailedSkillLevelUpMessage = showFailedSkillLevelUpMessage,
        getXPToggle = getXPToggle,
        getModifiedSkillGain = getModifiedSkillGain,
        isSkillLevelUpPossible = isSkillLevelUpPossible,
        isSkillGainPossible = isSkillGainPossible,
        printDebugInfo = printDebugInfo
        
    }
}
