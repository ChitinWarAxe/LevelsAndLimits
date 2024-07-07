local ui = require('openmw.ui')
local self = require('openmw.self')
local types = require('openmw.types')
local I = require('openmw.interfaces')
local sasUtil = require('scripts.levelsandlimits.lal_func')

print('Major skill level limit: ' .. getSettingMajorSkillLimit())
print('Minor skill level limit: ' .. getSettingMinorSkillLimit())
print('Misc skill level limit: ' .. getSettingMiscSkillLimit())
print('Specialization toggle: ' .. tostring(getSpecializationToggle()))
print('Specialization malus: ' .. getSpecializationMalus())
print('Favored attributes toggle: ' .. tostring(getFavoredAttributesToggle()))
print('Favored attributes malus: ' .. getFavoredAttributesMalus())

local majorSkills = {}
local minorSkills = {}

for _, skill in pairs(types.NPC.classes.records[types.NPC.record(self).class].majorSkills) do 
    majorSkills[skill] = true
end

for _, skill in pairs(types.NPC.classes.records[types.NPC.record(self).class].minorSkills) do 
    minorSkills[skill] = true
end

local function resetSkillExperience(skillid)
    local skillStat = types.NPC.stats.skills[skillid](self)
    if skillStat.progress > 1 then
        skillStat.progress = 1
    end
end

local function showFailedSkillLevelUpMessage(method)
    if method == 'trainer' then
        ui.showMessage('Despite your efforts, the training yields no progress.')
    elseif method == 'book' then
        ui.showMessage('The knowledge in this book is beyond your grasp.')
    end
end

I.SkillProgression.addSkillLevelUpHandler(function(skillid, options)

    local majorMax = getSettingMajorSkillLimit()
    local minorMax = getSettingMinorSkillLimit()
    local miscMax = getSettingMiscSkillLimit()

    local skillStat = types.NPC.stats.skills[skillid](self)
    local skillLevel = skillStat.base
    local skillLevelUpFailed = false
    
    local classSpecialization = types.NPC.classes.records[types.NPC.record(self).class].specialization
    --local skillSpecialization = types.Skill.skill(skillid).specialization
    
    --print('specialization: ' .. classSpecialization .. ', ' .. skillSpecialization)
    
    --print("Leveling up skill: " .. skillid .. " to level " .. skillLevel)

    if majorSkills[skillid] and skillLevel >= majorMax then
        skillLevelUpFailed = true
    elseif minorSkills[skillid] and skillLevel >= minorMax then
        skillLevelUpFailed = true
    elseif skillLevel >= miscMax then
        skillLevelUpFailed = true
    end
    
    if skillLevelUpFailed then
        resetSkillExperience(skillid)
        showFailedSkillLevelUpMessage(options)
        return false
    end

end)

