# Levels & Limits

Configurable class-based skill level limits.

![Two n'wahs pondering their class choices](images/nwahs.png "Two n'wahs pondering their class choices")

## Features

This mod sets skill level limits based on whether the skills are major, minor, or miscellaneous. By default, the maximum level limits are set to 100 for major skills, 75 for minor skills, and 35 for miscellaneous skills.

Additionally, your class specialization and favored attributes modify the maximum skill level. Skills that do not match your specialization will have a reduced maximum level based on a configurable malus. Similarly, skills not governed by your favored attributes will also have a reduced maximum level according to a configurable malus.

This mod works with both vanilla and custom classes.

## Calculation examples

Here are some examples of how specialization and favored attributes affect the maximum skill level:

* The **Warrior** class uses Combat as specialization and Strength and Endurance as favored attributes. Heavy Armor is a major skill, governed by Endurance, and is from the Combat specialization. The Warrior will be able to reach level 100 in Heavy Armor due to the skill being a perfect match with its class.
* The **Acrobat** class uses Stealth as specialization and Agility and Endurance as favored attributes. Unarmored is a major skill, yet is governed by Speed, and is from the Magic specialization. The maximum skill level for Unarmored is reduced to 90, down from 100, since it doesn’t share a governed attribute (-5) or specialization (-5) with its class.
* The **Witchhunter** class uses Magic as specialization and Intelligence and Agility as favored attributes. Mysticism is a minor skill, yet is governed by Willpower. The maximum skill level for Mysticism is reduced to 70, down from 75, since it doesn’t share a governed attribute (-5).
* The **Thief** class uses Stealth as specialization and Speed and Agility as favored attributes. Axe is a miscellaneous skill, governed by Strength, and is from the Combat specialization. The maximum skill level for Axe is reduced to 25, down from 35, since it doesn’t share a governed attribute (-5) or specialization (-5) with its class.

## Recommendations

I recommend using this mod together with [“Class Restricted Leveling”](https://www.nexusmods.com/morrowind/mods/54832) and [“Skill Uses Scaled”](https://www.nexusmods.com/morrowind/mods/54267).

*I hope you'll enjoy my mod!*
