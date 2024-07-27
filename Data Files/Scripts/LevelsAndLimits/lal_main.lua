local self = require('openmw.self')
local types = require('openmw.types')
local core = require('openmw.core')
local I = require('openmw.interfaces')
--local f = require('scripts.levelsandlimits.lal_func')

local majorSkills = {}
local minorSkills = {}

local playerClass = types.NPC.classes.records[types.NPC.record(self).class]

for _, skill in ipairs(playerClass.majorSkills) do 
    majorSkills[skill] = true
end

for _, skill in ipairs(playerClass.minorSkills) do 
    minorSkills[skill] = true
end

local function skillLevelUpHandler(skillid, options)

    if not I.lalUtil.getLaLToggle() then
        return  -- If disabled, allow normal skill progression
    end

    local skillStat = types.NPC.stats.skills[skillid](self)
    local skillLevel = skillStat.base
    local skillLevelUpFailed = false

    if majorSkills[skillid] and skillLevel >= I.lalUtil.getModifiedSkillMaximum(skillid, I.lalUtil.getSettingMajorSkillLimit()) then
        skillLevelUpFailed = true
        --print("major: " .. I.lalUtil.getModifiedSkillMaximum(skillid, I.lalUtil.getSettingMajorSkillLimit()))
    elseif minorSkills[skillid] and skillLevel >= I.lalUtil.getModifiedSkillMaximum(skillid, I.lalUtil.getSettingMinorSkillLimit()) then
        skillLevelUpFailed = true
        --print("minor: " .. I.lalUtil.getModifiedSkillMaximum(skillid, I.lalUtil.getSettingMinorSkillLimit()))
    elseif not majorSkills[skillid] and not minorSkills[skillid] and skillLevel >= I.lalUtil.getModifiedSkillMaximum(skillid, I.lalUtil.getSettingMiscSkillLimit()) then
        skillLevelUpFailed = true
        --print("misc: " .. I.lalUtil.getModifiedSkillMaximum(skillid, I.lalUtil.getSettingMiscSkillLimit()))
    end
    
    if skillLevelUpFailed then
        I.lalUtil.resetSkillExperience(skillid)
        I.lalUtil.showFailedSkillLevelUpMessage(options)
        return false
    end
end

I.SkillProgression.addSkillLevelUpHandler(skillLevelUpHandler)
