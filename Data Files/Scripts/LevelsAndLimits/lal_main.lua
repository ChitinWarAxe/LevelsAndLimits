local self = require('openmw.self')
local types = require('openmw.types')
local I = require('openmw.interfaces')
local sasUtil = require('scripts.levelsandlimits.lal_func')

local majorSkills = {}
local minorSkills = {}

for _, skill in pairs(types.NPC.classes.records[types.NPC.record(self).class].majorSkills) do 
    majorSkills[skill] = true
end

for _, skill in pairs(types.NPC.classes.records[types.NPC.record(self).class].minorSkills) do 
    minorSkills[skill] = true
end

I.SkillProgression.addSkillLevelUpHandler(function(skillid, options)

    local skillStat = types.NPC.stats.skills[skillid](self)
    local skillLevel = skillStat.base
    local skillLevelUpFailed = false

    if majorSkills[skillid] and skillLevel >= getModifiedSkillMaximum(skillid, getSettingMajorSkillLimit()) then
        skillLevelUpFailed = true
    elseif minorSkills[skillid] and skillLevel >= getModifiedSkillMaximum(skillid, getSettingMinorSkillLimit()) then
        skillLevelUpFailed = true
    elseif not majorSkills[skillid] and not minorSkills[skillid] and skillLevel >= getModifiedSkillMaximum(skillid, getSettingMiscSkillLimit()) then
        skillLevelUpFailed = true
    end
    
    if skillLevelUpFailed then
        resetSkillExperience(skillid)
        showFailedSkillLevelUpMessage(options)
        return false
    end

end)

