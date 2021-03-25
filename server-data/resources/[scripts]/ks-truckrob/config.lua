--------------------------------
------- Edited by Captainrum89 -------
-------------------------------- 

Config = {}

Config.HackerDevice = "hackerDevice"		-- Name in database for hacker device
Config.HackingBlocks = 5					-- Amount of code-blocks, player needs to match per side.
Config.HackingTime = 30						-- Amount of time player has to complete the minigame.


-- Set cooldown timer, which player has to wait before being able to do a mission again, in minutes here:
Config.CooldownTimer = 120

-- Enable or disable player wearing a 'heist money bag' after the robbery:
Config.EnablePlayerMoneyBag = false





-- Mission Blip Settings:
Config.EnableMapBlip = true							-- set between true/false
Config.BlipNameOnMap = "Missão de caminhão blindado"		-- set name of the blip
Config.BlipSprite = 67								-- set blip sprite, lists of sprite ids are here: https://docs.fivem.net/game-references/blips/
Config.BlipDisplay = 4								-- set blip display behaviour, find list of types here: https://runtime.fivem.net/doc/natives/#_0x9029B2F3DA924928
Config.BlipScale = 0.7								-- set blip scale/size on your map
Config.BlipColour = 5								-- set blip color, list of colors available in the bottom of this link: https://docs.fivem.net/game-references/blips/

-- Armored Truck Blip Settings:
Config.BlipNameForTruck = "Caminhão Blindado"			-- set name of the blip
Config.BlipSpriteTruck = 1							-- set blip sprite, lists of sprite ids are here: https://docs.fivem.net/game-references/blips/
Config.BlipColourTruck = 5							-- set blip color, list of colors available in the bottom of this link: https://docs.fivem.net/game-references/blips/
Config.BlipScaleTruck = 0.9							-- set blip scale/size on your map



-- Control Keys
Config.KeyToOpenTruckDoor = 47
Config.KeyToRobFromTruck = 38										





-- ProgressBars text
Config.Progress1 = "RECUPERANDO INFORMAÇÕES DO CAMINHÃO"
Config.Progress2 = "PLANTAR C4"
Config.Progress3 = "TEMPO ATÉ A DETONAÇÃO"
Config.Progress4 = "ROUBANDO O CAMINHÃO"

-- ProgressBar Timers, in seconds:
Config.RetrieveMissionTimer = 7.5	-- time from pressed E to receving location on the truck
Config.DetonateTimer = 10			-- time until bomb is detonated
Config.RobTruckTimer = 10			-- time spent to rob the truck

-- Guards Weapons:
Config.DriverWeapon = "WEAPON_PUMPSHOTGUN"		-- weapon for driver
Config.PassengerWeapon = "WEAPON_SMG" 			-- weapon for passenger

-- Armored Truck Spawn Locations
Config.ArmoredTruck = 
{
	{ 
		Location = vector3(-1327.479736328,-86.045326232910,49.31), 
		InUse = false
	},
	{ 
		Location = vector3(-2075.888183593,-233.73908996580,21.10), 
		InUse = false
	},
	{ 
		Location = vector3(-972.1781616210,-1530.9045410150,4.890), 
		InUse = false
	},
	{ 
		Location = vector3(798.184265136720,-1799.8173828125,29.33), 
		InUse = false
	},
	{ 
		Location = vector3(1247.0718994141,-344.65634155273,69.08), 
		InUse = false
	}
}

