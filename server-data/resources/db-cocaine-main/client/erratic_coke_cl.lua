QBCore = nil

-- Setup ESX Core
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)
-- Take Player Data After Player Loadout
local isLoggedIn = false 

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

local inUse = false
local process 
local coord 
local location = nil
local enroute
local fueling
local dodo
local delivering
local hangar
local jerrycan
local checkPlane
local flying
local landing
local hasLanded
local pilot
local airplane
local planehash
local driveHangar
local blip
local isProcessing = false
local player
local started = false

-- Gets coords

Citizen.CreateThread(function()
	while QBCore == nil do TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)   Wait(0) end
    QBCore.Functions.TriggerCallback('coke:processcoords', function(servercoords)
        process = servercoords
	end)
end)

Citizen.CreateThread(function()
	while QBCore == nil do TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end) Wait(0) end
    QBCore.Functions.TriggerCallback('coke:startcoords', function(servercoords)
        coord = servercoords
	end)
end)

-- Starting coke run

Citizen.CreateThread(function()
	local sleep
	while not coord do
		Citizen.Wait(0)
	end
	while true do
		sleep = 5
		local player = GetPlayerPed(-1)
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x, playercoords.y, playercoords.z)-vector3(coord.x, coord.y, coord.z))
		if not started then
			if dist <= 1 then
				sleep = 5
				DrawText3Ds(coord.x, coord.y, coord.z, '[~g~E~w~] - Start Coke Run [~r~$1,000~w~]')		
				if IsControlJustPressed(1, 51) then
					QBCore.Functions.TriggerCallback('coke:pay', function(success)
						if success then
							main()
							starter = true
						else
							TriggerEvent('QBCore:Notify', "Not enough money")
						end
					end)
				end
			else
				sleep = 2000
			end
		elseif dist <= 3 and inUse then
			sleep = 5
			DrawText3Ds(coord.x, coord.y, coord.z '[~r~Unavailable~w~]')	
		else
			sleep = 3000
		end
		Citizen.Wait(sleep)
	end
end)

RegisterNetEvent('coke:syncTable')
AddEventHandler('coke:syncTable', function(bool)
    inUse = bool
end)


function main()
	TriggerServerEvent('coke:updateTable', true)
	player = GetPlayerPed(-1)
	FreezeEntityPosition(player, true)
	SetEntityCoords(player, coord.x-0.1,coord.y-0.1,coord.z-1, 0.0,0.0,0.0, false)
	SetEntityHeading(player, Config.doorHeading)
	playAnim("mp_common", "givetake2_a", 3000)
	Citizen.Wait(3000)
	FreezeEntityPosition(player, false)
	QBCore.Functions.Notify("Head to the airfield!", "primary")
	rand = math.random(1,#Config.locations)
	location = Config.locations[rand]
	blip = AddBlipForCoord(location.fuel.x,location.fuel.y,location.fuel.z)
	SetBlipRoute(blip, true)
	enroute = true
	Citizen.CreateThread(function()
		while enroute do
			sleep = 5	
			local player = GetPlayerPed(-1)
			playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(location.fuel.x,location.fuel.y,location.fuel.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if disttocoord <= 100 and not Config.landPlane then
				planeGround()
				enroute = false
			elseif disttocoord <= 300 and Config.landPlane then
				planeFly()
				enroute = false
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
end

function planeGround()
	local planehash = GetHashKey("dodo")
	RequestModel(planehash)
	while not HasModelLoaded(planehash) do
		Citizen.Wait(0)
	end
	airplane = CreateVehicle(planehash, location.stationary.x,location.stationary.y,location.stationary.z, location.stationary.h, true, true)
	FreezeEntityPosition(airplane, true)
	SetVehicleDoorsLocked(airplane, 2)
	QBCore.Functions.Notify("You need fuel..", "error")
	fuel(location.fuel.x,location.fuel.y,location.fuel.z)
end

function planeFly()
	local pilothash = GetHashKey(Config.pilotPed)
    RequestModel(pilothash)
    while not HasModelLoaded(pilothash) do
        Citizen.Wait(0)
    end
    local planehash = GetHashKey("dodo")
	RequestModel(planehash)
	while not HasModelLoaded(planehash) do
		Citizen.Wait(0)
	end
	QBCore.Functions.Notify("Wait for the plane..", "primary")
	airplane = CreateVehicle(planehash, location.plane.x,location.plane.y,location.plane.z, location.plane.h, true, true)

    SetEntityDynamic(airplane, true)
    ActivatePhysics(airplane)
    SetVehicleForwardSpeed(airplane, 100.0)
    SetHeliBladesFullSpeed(airplane) 
    SetVehicleEngineOn(airplane, true, true, false)
    ControlLandingGear(airplane, 0) 
    SetEntityProofs(airplane, true, false, true, false, false, false, false, false)
    SetPlaneTurbulenceMultiplier(airplane, 0.0)

    pilot = CreatePedInsideVehicle(airplane, 1, pilothash, -1, true, true)
    SetBlockingOfNonTemporaryEvents(pilot, true) 
    SetPedRandomComponentVariation(pilot, false)
    SetPedKeepTask(pilot, true)
    SetTaskVehicleGotoPlaneMinHeightAboveTerrain(airplane, 93.0) 
    Citizen.CreateThread(function()
        flying = true
        local planecoords
        while flying do
            Citizen.Wait(100)
            planecoords = GetEntityCoords(airplane)
            local disttocoord = #(vector3(location.plane.x,location.plane.y,location.plane.z)-vector3(planecoords.x,planecoords.y,planecoords.z))
            if disttocoord < 100 then
                flying = false
                taskLand()       
                return
            else
                TaskVehicleDriveToCoord(pilot, airplane, location.plane.x,location.plane.y,location.plane.z, 100.0, 0, planehash, 262144, 15.0, -1.0)
                Citizen.Wait(1000)
            end
        end
    end)
end

function taskLand()
	landing = true 
	if landing then
		TaskPlaneLand(pilot, airplane, location.runwayEnd.x,location.runwayEnd.y,location.runwayEnd.z, location.runwayStart.x,location.runwayStart.y,location.runwayStart.z)
	end
	 Citizen.CreateThread(function()
        local planecoords
        while landing do
            sleep = 1000
            planecoords = GetEntityCoords(airplane)
            local disttocoord = #(vector3(location.runwayStart.x,location.runwayStart.y,location.runwayStart.z)-vector3(planecoords.x,planecoords.y,planecoords.z))
            if disttocoord <= 30 then
            	landing = false
            	landed()
            else
                sleep = 1500
            end
            Citizen.Wait(sleep)
        end
    end)
end

function landed()
	hasLanded = true
	local sleep
	RemoveBlip(blip)
	SetBlipRoute(blip, false)
	while hasLanded do
		sleep = 500
		planecoords = GetEntityCoords(airplane)
        local disttocoord = #(vector3(location.landingLoc.x, location.landingLoc.y, location.landingLoc.z)-vector3(planecoords.x,planecoords.y,planecoords.z))
        SetDriveTaskDrivingStyle(pilot, 2883621)
		TaskVehicleDriveToCoord(pilot, airplane, location.landingLoc.x, location.landingLoc.y, location.landingLoc.z, 10.0, 156, planehash, 786603, 1.0, true)
		if disttocoord <= 10 then
			hasLanded = false
			parkHangar()
		end
		Citizen.Wait(sleep)
	end
end

function parkHangar()
	driveHangar = true
	local player = GetPlayerPed(-1)
	local sleep
	while driveHangar do
		sleep = 500
		planecoords = GetEntityCoords(airplane)
        local disttocoord = #(vector3(location.parking.x, location.parking.y, location.parking.z)-vector3(planecoords.x,planecoords.y,planecoords.z))
        SetDriveTaskDrivingStyle(pilot, 2883621)
		TaskVehicleDriveToCoord(pilot, airplane, location.parking.x, location.parking.y, location.parking.z, 10.0, 156, planehash, 786603, 1.0, true)
        if disttocoord <= 2 then
        	FreezeEntityPosition(airplane, true) 	
        	Citizen.Wait(1000)
        	TaskLeaveVehicle(pilot, airplane, 0)
        	Citizen.Wait(2000)
        	TaskTurnPedToFaceEntity(pilot, player, 5000)
        	fuel(location.fuel.x,location.fuel.y,location.fuel.z)
        	playAnimPed("anim@mp_player_intincarsalutestd@ds@", "idle_a", 5000)
        	Citizen.Wait(5000)
        	SetEntityAsNoLongerNeeded(pilot)
        	driveHangar = false
        end
        Citizen.Wait(sleep)
	end
end

function fuel(x,y,z)
	local prop = GetHashKey("prop_ld_jerrycan_01")
	RequestModel(prop)
	while not HasModelLoaded(prop) do
		Citizen.Wait(0)
	end
	RemoveBlip(blip)
	SetBlipRoute(blip, false)
	jerrycan = GetHashKey("WEAPON_PETROLCAN")
	local fuelSpawn = CreateObject(prop, x,y,z-1, true, true, false)
	local player = GetPlayerPed(-1)
	local fuelCoords = GetEntityCoords(fuelSpawn)
	FreezeEntityPosition(fuelSpawn, true)
	fueling = true
	Citizen.CreateThread(function()
		while fueling do
			sleep = 5	
			local playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(fuelCoords.x,fuelCoords.y,fuelCoords.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if disttocoord <= 3 then
				DrawText3Ds(fuelCoords.x,fuelCoords.y,fuelCoords.z, '[~g~E~w~] - Pick up jerry can')	
				if IsControlJustPressed(1, 51) then
					QBCore.Functions.Progressbar("jerry_pickup", "Picking up jerry can..", math.random(5000, 10000), false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = "random@mugging4",
						anim = "struggle_loop_b_thief",
						flags = 16,
					}, {}, {}, function() -- Done
						DeleteEntity(fuelSpawn)
						TriggerServerEvent('coke:GiveJerry')
						TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items['jerry_can'], "add")
						FreezeEntityPosition(player, false)
						TriggerEvent('QBCore:Notify', "Fuel the plane!")
						plane(fuel)
						fueling = false
						dodo = true
					end, function() -- Cancel
						StopAnimTask(GetPlayerPed(-1), "random@mugging4", "struggle_loop_b_thief", 1.0)
						QBCore.Functions.Notify("Canceled..", "error")
					end)
				end
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
end

function plane(fuel)
	local player = GetPlayerPed(-1)
	Citizen.CreateThread(function()
		while dodo do
			sleep = 5	
			local playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(location.parking.x,location.parking.y,location.parking.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if disttocoord <= 5 then
				DrawText3Ds(location.parking.x,location.parking.y,location.parking.z, '[~g~E~w~] Refuel the plane')
				DrawMarker(27, location.parking.x,location.parking.y,location.parking.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 3, 252, 152, 100, false, true, 2, false, false, false, false)
				if IsControlJustPressed(1, 51) then
					QBCore.Functions.TriggerCallback('coke:jerrycheck', function(success)
						if success then
							TriggerServerEvent('coke:RemoveJerry')
							QBCore.Functions.Progressbar("plane_refuel", "You are fueling the plane..", math.random(5000, 10000), false, true, {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}, {
								animDict = "timetable@gardener@filling_can",
								anim = "gar_ig_5_filling_can",
								flags = 16,
							}, {}, {}, function() -- Done
								dodo = false
								delivering = true
								QBCore.Functions.Notify("Finished refueling!", "success")
								TriggerServerEvent('coke:updateTable', false)
								TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items['jerry_can'], "remove")
								FreezeEntityPosition(airplane, false)
								TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(airplane))
								SetVehicleDoorsLocked(airplane, 0)
								FreezeEntityPosition(player, false)
								ClearPedTasksImmediately(player)
								delivery()
								starter = false
							end, function() -- Cancel
								StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can", "gar_ig_5_filling_can", 1.0)
								QBCore.Functions.Notify("Canceled..", "error")
							end)					
						else
							isProcessing = false
							QBCore.Functions.Notify("You need a jerry can..", "error")
						end
					end)
				end
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
end


Citizen.CreateThread(function()
	checkPlane = true
	while checkPlane do
		sleep = 100 
		if DoesEntityExist(airplane) then
			if GetVehicleEngineHealth(airplane) < 0 then
				QBCore.Functions.Notify("The vehicle was damaged.. You failed the run", "error")
				TriggerServerEvent('coke:updateTable', false)
				checkPlane = false
				inUse = false
				RemoveBlip(blip)
				SetBlipRoute(blip, false)
			end
		else
			sleep = 3000
		end
		Citizen.Wait(sleep)
	end
end)

function delivery()
	local pickup = GetHashKey("prop_drop_armscrate_01")
	blip = AddBlipForCoord(location.delivery.x,location.delivery.y,location.delivery.z)
	SetBlipRoute(blip, true)
	RequestModel(pickup)
	while not HasModelLoaded(pickup) do
		Citizen.Wait(0)
	end
	local pickupSpawn = CreateObject(pickup, location.delivery.x,location.delivery.y,location.delivery.z, true, true, true)
	local player = GetPlayerPed(-1)
	Citizen.CreateThread(function()
		while delivering do
			sleep = 5	
			local playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(location.delivery.x,location.delivery.y,location.delivery.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if disttocoord <= 20 then
				RemoveBlip(blip)
				SetBlipRoute(blip, false)
				DrawText3Ds(location.delivery.x,location.delivery.y,location.delivery.z-1, '[~g~E~w~] - Pickup delivery')	
				if IsControlJustPressed(1, 51) then
					QBCore.Functions.Progressbar("package_pickup", "Picking up package..", math.random(5000, 10000), false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = "weapon@w_sp_jerrycanr",
						anim = "fire",
						flags = 16,
					}, {}, {}, function() -- Done
						delivering = false
						QBCore.Functions.Notify("You picked up a delivery!", "success")
						DeleteEntity(pickupSpawn)
						final()
					end, function() -- Cancel
						StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 1.0)
						QBCore.Functions.Notify("Canceled..", "error")
					end)
				end
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
end

function final()
	QBCore.Functions.Notify("Deliver the plane back to the airfield!", "success")
	blip = AddBlipForCoord(location.hangar.x,location.hangar.y,location.hangar.z)
	SetBlipRoute(blip, true)
	hangar = true
	local player = GetPlayerPed(-1)
	Citizen.CreateThread(function()
		while hangar do
			sleep = 5	
			local playerpos = GetEntityCoords(player)
			local disttocoord = #(vector3(location.hangar.x,location.hangar.y,location.hangar.z)-vector3(playerpos.x,playerpos.y,playerpos.z))
			if disttocoord <= 5 then
				RemoveBlip(blip)
				SetBlipRoute(blip, false)
				DrawText3Ds(location.hangar.x,location.hangar.y,location.hangar.z-1, '[~g~E~w~] - Park Plane')	
				DrawMarker(27, location.hangar.x,location.hangar.y,location.hangar.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 3, 252, 152, 100, false, true, 2, false, false, false, false)
				if IsControlJustPressed(1, 51) then
					hangar = false
					FreezeEntityPosition(airplane, true)
					QBCore.Functions.Progressbar("park_plane", "Storing the plane..", math.random(5000, 10000), false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = "weapon@w_sp_jerrycanr",
						anim = "fire",
						flags = 16,
					}, {}, {}, function() -- Done
						TriggerServerEvent('coke:GiveItem')
						TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items['coke_brick'], "add")
						TaskLeaveVehicle(player, airplane, 0)
						SetVehicleDoorsLocked(airplane, 2)
						DeleteEntity(airplane)	
						if Config.useCD then		
							cooldown()
						else
							TriggerServerEvent('coke:updateTable', false)
						end
					end, function() -- Cancel
						StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 1.0)
						QBCore.Functions.Notify("Canceled..", "error")
					end)
				end
			else
				sleep = 1500
			end
			Citizen.Wait(sleep)
		end
	end)
end

Citizen.CreateThread(function()
	local sleep
	while not process do
		Citizen.Wait(0)
	end
	while true do
		sleep = 5
		local player = GetPlayerPed(-1)
		local playercoords = GetEntityCoords(player)
		local dist = #(vector3(playercoords.x,playercoords.y,playercoords.z)-vector3(process.x,process.y,process.z))
		if dist <= 3 and not isProcessing then
			sleep = 5
			DrawText3Ds(process.x, process.y, process.z, '[~g~E~w~] - Break Coke')				
			if IsControlJustPressed(1, 51) then		
				isProcessing = true
				QBCore.Functions.TriggerCallback('coke:process', function(success)
					if success then
						SetEntityHeading(player, 232.84)
						TriggerServerEvent('coke:RemoveItem')
						QBCore.Functions.Progressbar("coke_breakdown", "Breaking down the coke brick..", 20000, false, true, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {
							animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
							anim = "machinic_loop_mechandplayer",
							flags = 16,
						}, {}, {}, function() -- Done
							TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items['coke_brick'], "remove")
							TriggerServerEvent('coke:processed')
							isProcessing = false
						end, function() -- Cancel
							StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
							QBCore.Functions.Notify("Canceled..", "error")
						end)					
					else
						TriggerEvent('QBCore:Notify', "You need a coke brick!")
					end
				end)
			end
		else
			sleep = 1500
		end
		Citizen.Wait(sleep)
	end
end)

function cooldown()
	Citizen.Wait(Config.cdTime)
	TriggerServerEvent('coke:updateTable', false)
end

function playAnimPed(animDict, animName, duration, buyer, x,y,z)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do 
      Citizen.Wait(0) 
    end
    TaskPlayAnim(pilot, animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do 
      Citizen.Wait(0) 
    end
    TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


-- (Optional) Shows your coords, useful if you want to add new locations.

if Config.getCoords then
	RegisterCommand("mycoords", function()
		local player = GetPlayerPed(-1)
	    local x,y,z = table.unpack(GetEntityCoords(player))
	    print("X: "..x.." Y: "..y.." Z: "..z)
	end)
end