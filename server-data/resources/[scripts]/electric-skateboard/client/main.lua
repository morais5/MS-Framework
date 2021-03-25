

local RCCar = {}
local player = nil

Attached = false
--[[
RegisterCommand("longboard", function()
	RCCar.Start()
end)
--]]

RegisterNetEvent('skateboard:Spawn')
AddEventHandler('skateboard:Spawn', function()
    RCCar.Start()
end)

AddEventHandler('longboard:clear', function()
	RCCar.Clear()
end)

AddEventHandler('longboard:start', function()
	RCCar.Clear()
    RCCar.Start()
end)

RCCar.Start = function()
	player = GetPlayerPed(-1)
	if DoesEntityExist(RCCar.Entity) then return end

	RCCar.Spawn()

	while DoesEntityExist(RCCar.Entity) and DoesEntityExist(RCCar.Driver) do
		Citizen.Wait(5)

		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(RCCar.Entity), true)

		RCCar.HandleKeys(distanceCheck)

		if distanceCheck <= Config.LoseConnectionDistance then
			if not NetworkHasControlOfEntity(RCCar.Driver) then
				NetworkRequestControlOfEntity(RCCar.Driver)
			elseif not NetworkHasControlOfEntity(RCCar.Entity) then
				NetworkRequestControlOfEntity(RCCar.Entity)
			end
		else
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
		end

		Citizen.CreateThread(function()
			Citizen.Wait(50)
			StopCurrentPlayingAmbientSpeech(RCCar.Driver)	
			if Attached then
				TriggerServerEvent('skateboard:get')
				-- Ragdoll system
				local x = GetEntityRotation(RCCar.Entity).x
				local y = GetEntityRotation(RCCar.Entity).y
				
				if (-40.0 < x and x > 40.0) or (-40.0 < y and y > 40.0) then
					RCCar.AttachPlayer(false)
					SetPedToRagdoll(player, 5000, 4000, 0, true, true, false)
				end	
			end           
		end)
	end
end

RCCar.HandleKeys = function(distanceCheck)
	if distanceCheck <= 1.5 then
		if IsControlJustPressed(0, 38) then
			RCCar.Attach("pick")
			TriggerServerEvent('skateboard:pick')	
		end

		if IsControlJustReleased(0, 113) then
			if Attached then
				RCCar.AttachPlayer(false)
			else
				RCCar.AttachPlayer(true)
			end
		end
	end
	
	if distanceCheck < Config.LoseConnectionDistance then
		local overSpeed = (GetEntitySpeed(RCCar.Entity)*3.6) > Config.MaxSpeedKmh
		
		-- prevents ped from driving away
		TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 1, 1)
		ForceVehicleEngineAudio(RCCar.Entity, 0)
		-- Input Control longboard 
		if Attached then
			if IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 9, 1)
			end
		end

		if IsControlPressed(0, 22) and Attached then
			-- Jump system
			if not IsEntityInAir(RCCar.Entity) then	
				local vel = GetEntityVelocity(RCCar.Entity)
				TaskPlayAnim(PlayerPedId(), "move_crouch_proto", "idle_intro", 5.0, 8.0, -1, 0, 0, false, false, false)
				local duration = 0
				local boost = 0
				while IsControlPressed(0, 22) do
					Citizen.Wait(10)
					duration = duration + 10.0
					ForceVehicleEngineAudio(RCCar.Entity, 0)
				end
				boost = Config.maxJumpHeigh * duration / 250.0
				if boost > Config.maxJumpHeigh then boost = Config.maxJumpHeigh end
				StopAnimTask(PlayerPedId(), "move_crouch_proto", "idle_intro", 1.0)
				SetEntityVelocity(RCCar.Entity, vel.x, vel.y, vel.z + boost)
				TaskPlayAnim(player, "move_strafe@stealth", "idle", 8.0, 2.0, -1, 1, 1.0, false, false, false)
			end
		end
		if Attached then
			if IsControlJustReleased(0, 87) or IsControlJustReleased(0, 88) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
			end

			if IsControlPressed(0, 88) and not IsControlPressed(0, 87) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 22, 1)
			end

			if IsControlPressed(0, 89) and IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 13, 1)
			end

			if IsControlPressed(0, 90) and IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 14, 1)
			end

			if IsControlPressed(0, 87) and IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 30, 100)
			end

			if IsControlPressed(0, 89) and IsControlPressed(0, 87) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 7, 1)
			end

			if IsControlPressed(0, 90) and IsControlPressed(0, 87) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 8, 1)
			end

			if IsControlPressed(0, 89) and not IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 4, 1)
			end

			if IsControlPressed(0, 90) and not IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 5, 1)
			end
		end
	end
end


RCCar.Spawn = function()
	-- models to load
	RCCar.LoadModels({ GetHashKey("triBike3"), 68070371, GetHashKey("p_defilied_ragdoll_01_s"), "pickup_object", "move_strafe@stealth", "move_crouch_proto"})

	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())

	RCCar.Entity = CreateVehicle(GetHashKey("triBike3"), spawnCoords, spawnHeading, true)
	RCCar.Skate = CreateObject(GetHashKey("p_defilied_ragdoll_01_s"), 0.0, 0.0, 0.0, true, true, true)
	
	-- load models
	while not DoesEntityExist(RCCar.Entity) do
		Citizen.Wait(5)
	end
	while not DoesEntityExist(RCCar.Skate) do
		Citizen.Wait(5)
	end

	SetHandling() -- Modify hanfling for upgrade the stability
	SetEntityNoCollisionEntity(RCCar.Entity, player, false) -- disable collision between the player and the rc
	SetEntityCollision(RCCar.Entity, true, true)
	SetEntityVisible(RCCar.Entity, false)
	--SetAllVehiclesSpawn(RCCar.Entity, true, true, true, true)
	AttachEntityToEntity(RCCar.Skate, RCCar.Entity, GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

	RCCar.Driver = CreatePed(12	, 68070371, spawnCoords, spawnHeading, true, true)

	-- Driver properties
	SetEnableHandcuffs(RCCar.Driver, true)
	SetEntityInvincible(RCCar.Driver, true)
	SetEntityVisible(RCCar.Driver, false)
	FreezeEntityPosition(RCCar.Driver, true)
	TaskWarpPedIntoVehicle(RCCar.Driver, RCCar.Entity, -1)
	--SetPedAlertness(RCCar.Driver, 0)

	while not IsPedInVehicle(RCCar.Driver, RCCar.Entity) do
		Citizen.Wait(0)
	end

	RCCar.Attach("place")
end

function SetHandling()
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSteeringLock", 9.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fDriveInertia", 0.05)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fMass", 1800.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fPercentSubmerged", 105.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fDriveBiasFront", 0.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fInitialDriveForce", 0.25)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fInitialDriveMaxFlatVel", 135.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fTractionCurveMax", 2.2)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fTractionCurveMin", 2.12)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fTractionCurveLateral", 22.5)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fTractionSpringDeltaMax", 0.1)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fLowSpeedTractionLossMult", 0.7)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fCamberStiffnesss", 0.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fTractionBiasFront", 0.478)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fTractionLossMult", 0.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSuspensionForce", 5.2)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSuspensionForce", 1.2)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSuspensionReboundDamp", 1.7)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSuspensionUpperLimit", 0.1	)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSuspensionLowerLimit", -0.3)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSuspensionRaise", 0.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fSuspensionBiasFront", 0.5)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fAntiRollBarForce", 0.0)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fAntiRollBarBiasFront", 0.65)
	SetVehicleHandlingFloat(RCCar.Entity, "CHandlingData", "fBrakeForce", 0.53)
end

RCCar.Attach = function(param)
	if not DoesEntityExist(RCCar.Entity) then
		return
	end
	
	if param == "place" then
		-- Place longboard
		AttachEntityToEntity(RCCar.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)

		TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)

		Citizen.Wait(800)

		DetachEntity(RCCar.Entity, false, true)

		PlaceObjectOnGroundProperly(RCCar.Entity)
	elseif param == "pick" then
		-- Pick longboard
		Citizen.Wait(100)

		TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)

		Citizen.Wait(600)
	
		AttachEntityToEntity(RCCar.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
		
		Citizen.Wait(900)
		
		-- Clear 
		RCCar.Clear()

	end

end

RCCar.Clear = function(models)
	DetachEntity(RCCar.Entity)
	DeleteEntity(RCCar.Skate)
	DeleteVehicle(RCCar.Entity)
	DeleteEntity(RCCar.Driver)

	RCCar.UnloadModels()
	Attach = false
	Attached  = false
end


RCCar.LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not RCCar.CachedModels then
			RCCar.CachedModels = {}
		end

		table.insert(RCCar.CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
				Citizen.Wait(10)
			end    
		end
	end
end

RCCar.UnloadModels = function()
	for modelIndex = 1, #RCCar.CachedModels do
		local model = RCCar.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end
local vehiclesMuted = {}

RCCar.AttachPlayer = function(toggle)
	if toggle then
		TaskPlayAnim(player, "move_strafe@stealth", "idle", 8.0, 8.0, -1, 1, 1.0, false, false, false)
		AttachEntityToEntity(player, RCCar.Entity, 20, 0.0, 0.15, 0.05, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		SetEntityCollision(player, true, true)
		Attached = true		
		TriggerServerEvent("shareImOnSkate")
	elseif not toggle then
		DetachEntity(player, false, false)
		Attached = false
		StopAnimTask(player, "move_strafe@stealth", "idle", 1.0)	
	end	
end


RegisterNetEvent("shareHeIsOnSkate")
AddEventHandler("shareHeIsOnSkate", function(id) 
		print("MutingEngine!")
		local player = GetPlayerFromServerId(id)
		local vehicle = GetEntityAttachedTo(GetPlayerPed(player))
		if not vehiclesMuted[vehicle] then
			Citizen.CreateThread(function() 
				vehiclesMuted[vehicle] = true
				while vehicle do
					Citizen.Wait(10)
					--print("A callar!: "..vehicleS)
					ForceVehicleEngineAudio(vehicle, 0)
				end
				table.remove(vehiclesMuted, vehicle)
			end)
		end	
end)
