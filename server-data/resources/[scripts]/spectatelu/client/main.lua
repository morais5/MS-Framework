QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)


local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
local cam 				= nil
local PlayerDate		= {}
local ShowInfos			= false
local group

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end

function spectate(target)

	QBCore.Functions.TriggerCallback('spectatelu:getPlayerData', function(player)
		if not InSpectatorMode then
			LastPosition = GetEntityCoords(GetPlayerPed(-1))
		end

		local playerPed = GetPlayerPed(-1)

		SetEntityCollision(playerPed, false, false)
		SetEntityVisible(playerPed, false)

		PlayerData = player
		if ShowInfos then
			SendNUIMessage({
				type = 'infos',
				data = PlayerData
			})	
		end

		Citizen.CreateThread(function()

			if not DoesCamExist(cam) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			end

			SetCamActive(cam, true)
			RenderScriptCams(true, false, 0, true, true)

			InSpectatorMode = true
			TargetSpectate  = target

		end)
	end, target)

end

function resetNormalCamera()
	InSpectatorMode = false
	TargetSpectate  = nil
	local playerPed = GetPlayerPed(-1)

	SetCamActive(cam,  false)
	RenderScriptCams(false, false, 0, true, true)

	SetEntityCollision(playerPed, true, true)
	SetEntityVisible(playerPed, true)
	SetEntityCoords(playerPed, LastPosition.x, LastPosition.y, LastPosition.z)
end

function getPlayersList()

	local players = QBCore.Functions.GetPlayers()
	local data = {}

	for i=1, #players, 1 do

		local _data = {
			id = GetPlayerServerId(players[i]),
			name = GetPlayerName(players[i])
		}
		table.insert(data, _data)
	end

	return data
end



RegisterNetEvent('spectatelu:spectate')
AddEventHandler('spectatelu:spectate', function(secured)
	local secured = tostring(secured)
	print(secured)
		SetNuiFocus(true, true)

		SendNUIMessage({
			type = 'show',
			data = getPlayersList(),
			player = GetPlayerServerId(PlayerId())
		})
end)

RegisterNUICallback('select', function(data, cb)
	print("select UI " .. json.encode(data))
	spectate(data.id)
	SetNuiFocus(false)
end)

RegisterNUICallback('close', function(data, cb)
	print("closing UI")
	SetNuiFocus(false)
end)

RegisterNUICallback('quit', function(data, cb)
	SetNuiFocus(false)
	resetNormalCamera()
end)

RegisterNUICallback('kick', function(data, cb)
	SetNuiFocus(false)
	TriggerServerEvent('spectatelu:kick', data.id, data.reason)
	TriggerEvent('spectatelu:spectate')
end)



Citizen.CreateThread(function()

  	while true do

		Wait(0)

		if InSpectatorMode then

			local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
			local playerPed	  = GetPlayerPed(-1)
			local targetPed	  = GetPlayerPed(targetPlayerId)
			local coords	 = GetEntityCoords(targetPed)

			for i=0, 32, 1 do
				if i ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(i)
					SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
					SetEntityVisible(playerPed, false)
				end
			end

			if IsControlPressed(2, 241) then
				radius = radius + 2.0;
			end

			if IsControlPressed(2, 242) then
				radius = radius - 2.0;
			end

			if radius > -1 then
				radius = -1
			end

			local xMagnitude = GetDisabledControlNormal(0, 1);
			local yMagnitude = GetDisabledControlNormal(0, 2);

			polarAngleDeg = polarAngleDeg + xMagnitude * 10;

			if polarAngleDeg >= 360 then
				polarAngleDeg = 0
			end

			azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;

			if azimuthAngleDeg >= 360 then
				azimuthAngleDeg = 0;
			end

			local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

			SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
			PointCamAtEntity(cam,  targetPed)
			SetEntityCoords(playerPed,  coords.x, coords.y, coords.z + 10)

			if IsControlPressed(2, 47) then
			OpenAdminActionMenu(targetPlayerId)
			end
			
			local text = {}
			local targetGod = GetPlayerInvincible(targetPlayerId)
			if targetGod then
				table.insert(text,"Godmode: ~r~Found~w~")
			else
				table.insert(text,"Godmode: ~g~Not Found~w~")
			end
			if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
				table.insert(text,"~r~Anti-Ragdoll~w~")
			end

			table.insert(text,"Health"..": "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
			table.insert(text,"Armor"..": "..GetPedArmour(targetPed))

			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
		end

  	end
end)

