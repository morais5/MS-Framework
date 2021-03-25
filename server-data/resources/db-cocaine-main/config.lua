Config = {}
Config.Locale = 'en' -- English, German or Spanish - (en/de/es)

Config.useCD = false -- change this if you want to have a global cooldown or not
Config.cdTime = 1200000 -- global cooldown in ms. Set to 20 minutes by default - (https://www.timecalculator.net/minutes-to-milliseconds)
Config.doorHeading = 126.85 -- change this to the proper heading to look at the door you start the runs with
Config.price = 1000 -- amount you have to pay to start a run 
Config.randBrick = math.random(16,30) -- change the numbers to how much coke you want players to receive after breaking down bricks
Config.takeBrick = 1 -- amount of brick you want to take after processing
Config.getCoords = false -- gets coords with /mycoords
Config.pilotPed = "s_m_m_pilot_02" -- change this to have a different ped as the planes pilot - (lsit of peds: https://wiki.rage.mp/index.php?title=Peds)
Config.landPlane = false -- change this if you want the plane to fly and land or if it should spawn on the ground

Config.locations = {
	[1] = { 
		fuel = {x = 2140.458, y = 4789.831, z = 40.97033},
		landingLoc = {x = 2102.974, y = 4794.949, z = 41.06044},
		plane = {x = 1506.836, y = 4524.545, z = 97.78197, h = 296.68},
		runwayStart = {x = 2082.278, y = 4785.483, z = 41.06053},
		runwayEnd = {x = 1855.845, y = 4673.433, z = 52.04392},
		fuselage = {x = 2137.618, y = 4812.194, z = 41.19522},
		stationary = {x = 2133.73, y = 4782.65, z = 41.78, h = 205.16},  ----start
		delivery = {x = -2632.7, y = 5010.9, z = 0.8857441},
		hangar = {x = 2133.73, y = 4782.65, z = 41.78},  --- last
		parking = {x = 2133.73, y = 4782.194, z = 41.20},															
	},
}




