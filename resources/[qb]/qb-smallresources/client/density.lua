Citizen.CreateThread(function()
	while true do
		SetVehicleDensityMultiplierThisFrame(0.0) -- tava a 0.1
		SetPedDensityMultiplierThisFrame(0.0) -- set npc/ai peds density to 0
		SetRandomVehicleDensityMultiplierThisFrame(0.0) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
		SetParkedVehicleDensityMultiplierThisFrame(0.0) -- set random parked vehicles (parked car scenarios) to 0
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- set random npc/ai peds or scenario peds to 0
		--SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		--SetRandomBoats(false) -- Stop random boats from spawning in the water.
		--SetCreateRandomCops(false) -- disable random cops walking/driving around.
		--SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		--SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.

--abaixo é da cena do minimapa codigo postal 
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
--acima é da cena do minimapa codigo postal 

--abaixo é pra desativar os police car rewards
	DisablePlayerVehicleRewards(PlayerId())	
--acima é pra desativar os police car rewards

		Citizen.Wait(3)
	end
end)

--abaixo é da cena do minimapa codigo postal 
Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
end)

