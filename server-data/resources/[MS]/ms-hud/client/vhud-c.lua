-- VARIABLES
local waittime = 500
--local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,15,16,17,18,19,20};
local toghud = true
--seatbelt locals
local seatbeltEjectSpeed = 65
local seatbeltEjectAccel = 80
local seatbeltIsOn = false
local inVehicle = false
local currSpeed = 0.0

--EJECTION
-----------------------------
local carsEnabled = {}
local airtime = 0
local offroadTimer = 0
local veloc = GetEntityVelocity(veh)
local offroadVehicle = false
--local seatbelt = false

local harnessOn = false
local harnessHp = 20
harnessData = {}
-----------------------------

--location
local zones = { ['AIRP'] = "Airport LS", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "Klub Golfowy", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port LS", ['ZQ_UAR'] = "Davis Quartz" }
local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }

-- time
local curTime = ''
--nitro
local nitro = 0
local watchon = false
-- START


local copCars = {
    "police", -- K9 Vehicle
    "police2", -- police / sheriff charger
    "police3", -- police SUV
    "police4", -- uc cv
    "policeb", -- police bike
    "sheriff", -- sheriff cvsi
    "sheriff2", -- sheriff SUV
    "2015polstang", -- mustang pursuit
    "fbi", -- uc charger
    "fbi2", -- uc cadi
    "pbus", -- prison bus
    "polmav", -- chopper
    "romero", -- hearse
    "predator"
}

local offroadVehicles = {
    "bifta",
    "blazer",
    "brawler",
    "dubsta3",
    "dune",
    "rebel2",
    "sandking",
    "trophytruck",
    "sanchez",
    "sanchez2",
    "blazer",
    "enduro",
    "pol9",
    "police3", -- police SUV
    "sheriff2", -- sheriff SUV
    "hwaycar", -- trooper suv   
    "fbi2",
    "bf400" 
}

local offroadbikes = {
    "ENDURO",
    "sanchez",
    "sanchez2"
}

Citizen.CreateThread(function()
	while true do
		--GLOBAL_PEDINVEH = IsPedInAnyVehicle(GLOBAL_PED, false)
		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			GLOBAL_PEDVEH = GetVehiclePedIsIn(GLOBAL_PED, false)
		end
		Wait(500)
	end
end)

RegisterNetEvent('ms-hud:nitro')
AddEventHandler('ms-hud:nitro', function(percent)
  nitro = percent
end)

RegisterNetEvent('ms-hud:client:useSeatbelt')
AddEventHandler('ms-hud:client:useSeatbelt', function(status)
    seatbeltIsOn = status
    SendNUIMessage({action = "seatbelt", status = seatbeltIsOn})
end)

RegisterNetEvent('ms-hud:client:toggleui')
AddEventHandler('ms-hud:client:toggleui', function(show)
    if show then
		toghud = true
		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			DisplayRadar(true)
		end
    else
		toghud = false
		DisplayRadar(false)
    end
end)

RegisterNetEvent('hud:toggleWatch')
AddEventHandler('hud:toggleWatch', function()
	watchon = not watchon

	local armor = GetPedArmour(GLOBAL_PED)
	local hasArmor = false
	if armor > 0 then
		hasArmor = true
	else
		hasArmor = false
	end

	if watchon then
		SendNUIMessage({action = "toggleWatch", show = true, hasArmor = hasArmor})
	else
		SendNUIMessage({action = "toggleWatch", show = false, hasArmor = hasArmor})
	end
end)

RegisterNetEvent('ms-hud:client:toggleHarness')
AddEventHandler('ms-hud:client:toggleHarness', function(toggle)
    SendNUIMessage({
        action = "harness",
        status = toggle
    })
end)

-- HUD
Citizen.CreateThread(function()
	while true do
		Wait(waittime)

		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			waittime = 150
			if not inVehicle then
				inVehicle = true
				SendNUIMessage({action = "toggleCar", show = true})
				if toghud then
					DisplayRadar(true)
					--[[ if IsBigmapActive() then 
						SetRadarBigmapEnabled(false, false)
					end ]]
				end
			end

			if nitro ~= 0 then
				SendNUIMessage({action = "updateNitro", key = "nitro", value = nitro, show = true})
			else
				SendNUIMessage({action = "updateNitro", show = false})
			end
			
		else
			if seatbeltIsOn or IsRadarEnabled() or not toghud then 
				waittime = 500
				TriggerEvent("ms-hud:client:useSeatbelt", false)
				if inVehicle then
					inVehicle = false
					SendNUIMessage({action = "toggleCar", show = false})
				end
				DisplayRadar(false)
			end
			if watchon then
				local armor = GetPedArmour(GLOBAL_PED)
				local hasArmor = false
				if armor > 0 then
					hasArmor = true
				else
					hasArmor = false
				end
				SendNUIMessage({action = "toggleWatch", show = true, hasArmor = hasArmor})
			end
		end
	end
end)

-- HEADLIGHTS
Citizen.CreateThread(function()
	while true do
		Wait(500)

		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(GetVehiclePedIsIn(GLOBAL_PED, false))
			local vehicleIsLightsOn

			if vehicleLights == 1 and vehicleHighlights == 0 then
				vehicleIsLightsOn = 'normal'
			elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
				vehicleIsLightsOn = 'high'
			else
				vehicleIsLightsOn = 'off'
			end
			SendNUIMessage({action = "lights", status = vehicleIsLightsOn})
		end
	end
end)

--[[ Citizen.CreateThread(function()
	while true do
		-- SEATBELT
		local sleep = 1500
		if GLOBAL_PEDINVEH then
			sleep = 5
			if seatbeltIsOn then 
				local vehIsMovingFwd = GetEntitySpeedVector(GLOBAL_PEDVEH, true).y > 1.0
				if vehIsMovingFwd then
					DisableControlAction(27, 75, true)
					DisableControlAction(0, 75, true)
				end
			end

			if IsControlJustReleased(0, 29) and (has_value(vehiclesCars, GLOBAL_PEDVEHCLASS) == true and GLOBAL_PEDVEHCLASS ~= 8) then
				if not seatbeltIsOn then
					TriggerEvent('InteractSound_CL:PlayOnOne','carbuckle',0.3)
					MSCore.Functions.Notify('Seatbelt Buckled.', 'success', 10000)
					TriggerEvent("veh:seatbelt", true)
				else
					TriggerEvent('InteractSound_CL:PlayOnOne','carunbuckle',0.3)
					MSCore.Functions.Notify('Seatbelt Unbuckled.', 'error', 10000)
					TriggerEvent("veh:seatbelt", false)
				end
			end
		end
		Wait(sleep)
	end
end) ]]

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        if IsPedInAnyVehicle(GLOBAL_PED, false) then
			sleep = 5
            if seatbeltIsOn then 
                local vehIsMovingFwd = GetEntitySpeedVector(GetVehiclePedIsIn(GLOBAL_PED, false), true).y > 1.0
                if vehIsMovingFwd then
					DisableControlAction(27, 75, true)
					DisableControlAction(0, 75, true)
				end
			end
        
            if IsControlJustReleased(0, Keys["B"]) then 
                if not harnessOn then
                    if IsPedInAnyVehicle(GetPlayerPed(-1)) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 14 then
                        if not seatbeltIsOn then
                            TriggerServerEvent("InteractSound_SV:PlayOnSource", "carunbuckle", 0.25)
                            TriggerEvent("DoShortHudText", 'Seatbelt Buckled')
                            TriggerEvent("ms-hud:client:useSeatbelt", true)
                        else
                            TriggerServerEvent("InteractSound_SV:PlayOnSource", "carbuckle", 0.25)
                            TriggerEvent("DoShortHudText", 'Seatbelt Unbuckled', 2)
                            TriggerEvent("ms-hud:client:useSeatbelt", false)
                        end
                    end
                else
                    MSCore.Functions.Progressbar("harness_equip", "Racing harness off..", 5000, false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        ToggleHarness(false)
                    end)
                end
            end

            if IsPedInAnyVehicle(GLOBAL_PED, false) then
                if harnessOn then
                    DisableControlAction(0, 75, true)
                    DisableControlAction(27, 75, true)
                end
            end
        end
		Wait(sleep)
    end
end)

-- SPEEDO
Citizen.CreateThread(function()
	while true do
		Wait(300)
		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			PedCar = GetVehiclePedIsIn(GLOBAL_PED, false)
			if not GetVehiclePedIsIn(GLOBAL_PED, false) or GetVehiclePedIsIn(GLOBAL_PED, false) == 0 then
				PedCar = GetVehiclePedIsIn(GLOBAL_PED, true)
			end
            carSpeed = math.ceil(GetEntitySpeed(PedCar) * 1.23)

			SendNUIMessage({action = "updateSpeed", speed = carSpeed})
		end
	end
end)

-- LOCATION
Citizen.CreateThread(function()
	while true do
		Wait(1000)

		if watchon or IsPedInAnyVehicle(GLOBAL_PED, false) then

			local pos = GetEntityCoords(GLOBAL_PED)
			local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
			local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

			cardinalDirection = GetEntityHeading(GLOBAL_PED)
			for k,v in pairs(directions)do
				if (math.abs(cardinalDirection - k) < 22.5) then
					cardinalDirection = v
					break;
				end
			end

			if GetStreetNameFromHashKey(var2) ~= '' then
				locationMessage = cardinalDirection .. " on " .. GetStreetNameFromHashKey(var1) .. ' - ' .. GetStreetNameFromHashKey(var2) .. ', ' .. current_zone
			else 
				locationMessage = cardinalDirection .. " on " .. GetStreetNameFromHashKey(var1) .. ', ' .. current_zone
			end

			SendNUIMessage({
				showhud = toghud,
				speed = carSpeed,
				showlocation = true,
				location = locationMessage,
				clock = true,
				showclock = curTime
			})
		end
	end
end)

-- COMPASS
--[[ Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if watchon or GLOBAL_PEDINVEH then
			sleep = 60
			SendNUIMessage({
				showcompass = true,
				direction = math.floor(calcHeading(-GetEntityHeading(GLOBAL_PED) % 360)),
			})
		end
		Wait(sleep)
	end
end) ]]

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(hrs,mins)

	if hrs < 10 then
		hrs = "0"..hrs
	end
	if mins < 10 then
		mins = "0"..mins
	end
	curhrs = hrs
	curmins = mins

	local AmPm = ''
	if tonumber(curhrs) >= 12 and tonumber(curhrs) <= 24 then
		AmPm = 'PM'
	else
		AmPm = 'AM'
	end

	curTime = curhrs .. ":" .. curmins..' '..AmPm
end)

--[[ RegisterNetEvent("veh:seatbelt")
AddEventHandler("veh:seatbelt", function(toggle)
    seatbelt = toggle
end) ]]

function EjectFromVehicle()
    local veh = GetVehiclePedIsIn(GLOBAL_PED,false)
    local coords = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 1.0)
    SetEntityCoords(GLOBAL_PED,coords)
    Citizen.Wait(1)
    SetPedToRagdoll(GLOBAL_PED, 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(GLOBAL_PED, veloc.x*4,veloc.y*4,veloc.z*4)
    local ejectspeed = math.ceil(GetEntitySpeed(GLOBAL_PED) * 8)
    SetEntityHealth( GLOBAL_PED, (GetEntityHealth(GLOBAL_PED) - ejectspeed) )
end

RegisterNetEvent("ms-hud:client:ejection")
AddEventHandler("ms-hud:client:ejection",function(plate)
    local curplate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GLOBAL_PED, false))
    if curplate == plate then -- why does it pass through the server?
        EjectFromVehicle()
    end
end)

local handbrake = 0
RegisterNetEvent('ms-hud:client:resetHandbrake')
AddEventHandler('ms-hud:client:resetHandbrake', function()
    while handbrake > 0 do
        handbrake = handbrake - 1
        Citizen.Wait(30)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local firstDrop = GetEntityVelocity(GLOBAL_PED)
    local lastentSpeed = 0
    local newvehicleBodyHealth = 0
    local newvehicleEngineHealth = 0
    local currentvehicleEngineHealth = 0
    local currentvehicleBodyHealth = 0
    local frameBodyChange = 0
    local frameEngineChange = 0
    local lastFrameVehiclespeed = 0
    local lastFrameVehiclespeed2 = 0
    local thisFrameVehicleSpeed = 0
    local tick = 0
    local damagedone = false
    while true do
        Citizen.Wait(5)
        --local playerPed = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(GLOBAL_PED, false)
        local driverPed = GetPedInVehicleSeat(currentVehicle, -1)

        if currentVehicle ~= nil and currentVehicle ~= false and currentVehicle ~= 0 then
            
            SetPedHelmet(GLOBAL_PED, false)
            lastVehicle = GetVehiclePedIsIn(GLOBAL_PED, false)
            if driverPed == GLOBAL_PED then
                if (GetVehicleHandbrake(currentVehicle) or (GetVehicleSteeringAngle(currentVehicle)) > 25.0 or (GetVehicleSteeringAngle(currentVehicle)) < -25.0) then
                    if handbrake == 0 then
                        handbrake = 100
                        TriggerEvent("ms-hud:client:resetHandbrake")
                    else
                        handbrake = 100
                    end
                end

                thisFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 2.236936

                currentvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)
                --print(currentvehicleBodyHealth)
                if currentvehicleBodyHealth == 1000 and frameBodyChange ~= 0 then
                    frameBodyChange = 0
                end
                if frameBodyChange ~= 0 then
                    if frameBodyChange > 25.0 then
                        if lastFrameVehiclespeed > 60 and thisFrameVehicleSpeed < (lastFrameVehiclespeed * 0.75) and not damagedone then
                            --[[ if not IsThisModelABike(currentVehicle) then
                                TriggerServerEvent("carhud:ejection:server",GetVehicleNumberPlateText(currentVehicle))
                            end ]]
                            if not seatbeltIsOn and not IsThisModelABike(currentVehicle) then
                                --if math.random(math.ceil(lastFrameVehiclespeed)) > 68 then --I dont like this
                                    if not harnessOn then
                                        EjectFromVehicle()
                                    else
                                        harnessHp = harnessHp - 1
                                        TriggerServerEvent('ms-hud:server:DoHarnessDamage', harnessHp, harnessData)
                                    end
                                --end
                            elseif seatbeltIsOn and not IsThisModelABike(currentVehicle) then
                                if lastFrameVehiclespeed > 125 then
                                    --if math.random(math.ceil(lastFrameVehiclespeed)) > 61 then --I dont like this
                                        if not harnessOn then
                                            EjectFromVehicle()
                                        else
                                            harnessHp = harnessHp - 1
                                            TriggerServerEvent('ms-hud:server:DoHarnessDamage', harnessHp, harnessData)
                                        end  
                                    --end
                                end
                            end
                        end
                        damagedone = true
                        local wheels = {0,1,4,5}
                        for i=1, math.random(4) do
                            local wheel = math.random(#wheels)
                            table.remove(wheels, wheel)
                        end
                        SetVehicleEngineOn(currentVehicle, true, true, true)
                        Citizen.Wait(1000)
                    end

                    if currentvehicleBodyHealth < 350.0 and not damagedone then
                        damagedone = true
                        local wheels = {0,1,4,5}
                        for i=1, math.random(4) do
                            local wheel = math.random(#wheels)
                            table.remove(wheels, wheel)
                        end
                        SetVehicleEngineOn(currentVehicle, true, true, true)
                        Citizen.Wait(1000)
                    end
                end

                if lastFrameVehiclespeed < 68 then
                    Wait(100)
                    tick = 0
                end

                frameBodyChange = newvehicleBodyHealth - currentvehicleBodyHealth

                if tick > 0 then
                    tick = tick - 1
                    if tick == 1 then
                        lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 2.236936
                    end
                else
                    lastFrameVehiclespeed2 = lastFrameVehiclespeed
                    if damagedone then
                        damagedone = false
                        frameBodyChange = 0
                        lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 2.236936
                    end

                    if thisFrameVehicleSpeed > lastFrameVehiclespeed2 then
                        lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 2.236936
                    end

                    if thisFrameVehicleSpeed < lastFrameVehiclespeed2 then
                        tick = 25
                    end
                end

                vels = GetEntityVelocity(currentVehicle)

                if tick < 0 then
                    tick = 0
                end

                newvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)
            else
                vels = GetEntityVelocity(currentVehicle)
                Wait(1000)
            end
            veloc = GetEntityVelocity(currentVehicle)
        else
            if lastVehicle ~= nil then
                SetPedHelmet(GLOBAL_PED, true)
                Citizen.Wait(200)
                newvehicleBodyHealth = GetVehicleBodyHealth(lastVehicle)
                if not damagedone and newvehicleBodyHealth < currentvehicleBodyHealth then
                    damagedone = true                   
                    SetVehicleEngineOn(lastVehicle, true, true, true)
                    Citizen.Wait(1000)
                end
                lastVehicle = nil
            end

            lastFrameVehiclespeed = 0
            lastFrameVehiclespeed2 = 0
            newvehicleBodyHealth = 0
            currentvehicleBodyHealth = 0
            frameBodyChange = 0
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		DisablePlayerVehicleRewards(GLOBAL_PLYID)	
	end
end)

RegisterNetEvent('ms-hud:client:useHarness')
AddEventHandler('ms-hud:client:useHarness', function(ItemData)
    local ped = GetPlayerPed(-1)
    local inveh = IsPedInAnyVehicle(GetPlayerPed(-1))
    if inveh and not IsThisModelABike(GetEntityModel(GetVehiclePedIsIn(ped))) then
        if not harnessOn then
            MSCore.Functions.Progressbar("harness_equip", "Racing harness on..", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ToggleHarness(true)
                TriggerServerEvent('ms-hud:server:equipHarness', ItemData)
            end)
            harnessHp = ItemData.info.uses
            harnessData = ItemData
        end
    else
        TriggerEvent("DoLongHudText", 'You are not in a car.', 2)
    end
end)

function ToggleHarness(toggle)
    harnessOn = toggle
    TriggerEvent("ms-hud:client:useSeatbelt", true)
    TriggerEvent('ms-hud:client:toggleHarness', toggle)
end