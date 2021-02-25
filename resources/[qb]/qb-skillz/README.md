# qb-skillz converted from gamz-skillsystem 

### [ What is this? ]
- A skillsystem based on GTA's existing skills.
- Very easy to configure, just check the config.
- You can for example add this to your gym script to get stronger.

### [ Functions ]
- Skills displays in ESC -> Stats -> Skills
- All the skills that is added by default have a unique "function", for example if you run your stamina will increase by the time.
- Depending on the skill level your character will perform the skill better, for example if your stamina is high you can run longer without getting exhausted.
- Every ``Config.UpdateFrequency`` (seconds) it will remove the current ``RemoveAmount`` for that skill.

### [ Installation ]
- Download the resource and drop it to your resource folder.
- Add ``start qb-skillz`` to your server.cfg

### [ How do I use it? ]
- To open the menu you trigger following:

```lua
    exports["qb-skillz"]:SkillMenu()
```
- To Update a skill you do following:
```lua
    exports["qb-skillz"]:UpdateSkill(skill, amount)
```
  so if you were to add 2% to Stamina you do
```lua
    exports["qb-skillz"]:UpdateSkill("Stamina", 2)
```
- There is also an export to get the current skill if you were to do something from another script
```lua
    exports["qb-skillz"]:GetCurrentSkill(skill)
```
