local storage = require('openmw.storage')
local settings = storage.playerSection("SettingsLevelsAndLimits")

function getSettingMajorSkillLimit()
    return settings:get("lalLimitMajor")
end

function getSettingMinorSkillLimit()
    return settings:get("lalLimitMinor")
end

function getSettingMiscSkillLimit()
    return settings:get("lalLimitMisc")
end

function getSpecializationToggle()
    return settings:get("lalSpecializationToggle")
end

function getSpecializationMalus()
    return settings:get("lalSpecializationMalus")
end

function getFavoredAttributesToggle()
    return settings:get("lalFavoredAttributesToggle")
end

function getFavoredAttributesMalus()
    return settings:get("lalFavoredAttributesMalus")
end
