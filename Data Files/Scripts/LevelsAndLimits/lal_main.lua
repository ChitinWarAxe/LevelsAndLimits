local self = require('openmw.self')
local types = require('openmw.types')
local core = require('openmw.core')
local I = require('openmw.interfaces')

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

    if I.lalUtil.getLaLToggle() then
    
        local skillLevelUpPossible = I.lalUtil.isSkillLevelUpPossible(skillid, options, majorSkills, minorSkills)
        
        if skillLevelUpPossible == false then
            I.lalUtil.resetSkillExperience(skillid)
            I.lalUtil.showFailedSkillLevelUpMessage(options)
        end
    
        return skillLevelUpPossible
        
    end

end

local function skillUsedHandler(skillid, params)

    if I.lalUtil.getXPToggle() then

        if I.lalUtil.isSkillGainPossible() then
            params.skillGain = I.lalUtil.getModifiedSkillGain(skillid, params.skillGain)
        else
            return false
        end
        
    end
    
end

I.lalUtil.printDebugInfo()

I.SkillProgression.addSkillLevelUpHandler(skillLevelUpHandler)
I.SkillProgression.addSkillUsedHandler(skillUsedHandler)

