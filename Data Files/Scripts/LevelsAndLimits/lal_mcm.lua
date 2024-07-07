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
            description = "Sets the maximum level for major skills.",
            default = 100,
            renderer = "number"
        },
        {
            key = "lalLimitMinor",
            name = "Minor Skill Level Limit",
            description = "Sets the maximum level for minor skills.",
            default = 75,
            renderer = "number"
        },
        {
            key = "lalLimitMisc",
            name = "Miscellaneous Skill Level Limit",
            description = "Sets the maximum level for miscellaneous skills.",
            default = 35,
            renderer = "number"
        },
        {
            key = "lalSpecializationToggle",
            name = "Specialization Consideration",
            description = "When enabled, your maximum skill level is influenced by whether the skill matches your class specialization. Skills outside your specialization have a reduced maximum level.",
            default = true,
            renderer = "checkbox"
        },
        {
            key = "lalSpecializationMalus",
            name = "Specialization Malus",
            description = "The amount by which the maximum skill level is reduced for skills that do not match your class specialization.",
            default = 5,
            renderer = "number"
        },
        {
            key = "lalFavoredAttributesToggle",
            name = "Favored Attributes Consideration",
            description = "When enabled, your maximum skill level is influenced by whether the skill is governed by your favored attributes. Skills not governed by your favored attributes have a reduced maximum level.",
            default = true,
            renderer = "checkbox"
        },
        {
            key = "lalFavoredAttributesMalus",
            name = "Favored Attributes Malus",
            description = "The amount by which the maximum skill level is reduced for skills not governed by your favored attributes.",
            default = 5,
            renderer = "number"
        }   
    }
}


