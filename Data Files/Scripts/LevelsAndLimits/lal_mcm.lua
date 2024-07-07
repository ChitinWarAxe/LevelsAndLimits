local ui = require('openmw.ui')
local self = require('openmw.self')
local types = require('openmw.types')
local time = require('openmw_aux.time')
local ambient = require('openmw.ambient')
local core = require('openmw.core')
local storage = require('openmw.storage')
local I = require('openmw.interfaces')

print('registered Levels & Limits...')

I.Settings.registerPage {
    key = "LevelsAndLimits",
    l10n = "LevelsAndLimits",
    name = 'name',
    description = 'description'
}

I.Settings.registerGroup {
    key = "SettingsLevelsAndLimits",
    l10n = "LevelsAndLimits",
    name = "settingsTitle",
    page = "LevelsAndLimits",
    description = "settingsDesc",
    permanentStorage = false,
    settings = {
        {
            key = "lalLimitMajor",
            name = "Major Skill Level Limit",
            description= "The major skill level limit.",
            default = 100,
            renderer = "number"
        },
        {
            key = "lalLimitMinor",
            name = "Minor Skill Level Limit",
            description= "The minor skill level limit.",
            default = 75,
            renderer = "number"
        },
        {
            key = "lalLimitMisc",
            name = "Misc Skill Level Limit",
            description= "The miscellaneous skill level limit.",
            default = 35,
            renderer = "number"
        },
        {
            key = "lalSpecializationToggle",
            name = "Factor in your specialization",
            description= "If activated, your maximum skill level depends on if your skill is of the same specialization as of your class. Skills not of your specialization have a reduced max level.",
            default = true,
            renderer = "checkbox"
        },
        {
            key = "lalSpecializationMalus",
            name = "Skill not of class specialization malus",
            description= "If your skill is not of the same specialization as of your class, the maximum skill level is reduced by this amount.",
            default = 5,
            renderer = "number"
        },
        {
            key = "lalFavoredAttributesToggle",
            name = "Factor in favored attributes",
            description= "If activated, your maximum skill level depends on if your skill is governed by your favored attribute. Skills not governed by your favored attribute have a reduced max level.",
            default = true,
            renderer = "checkbox"
        },
        {
            key = "lalFavoredAttributesMalus",
            name = "Skill not governed by favored attribute malus",
            description= "If your skill is not governed by your favored attributes, the maximum skill level is reduced by this amount.",
            default = 5,
            renderer = "number"
        }
    }
}


