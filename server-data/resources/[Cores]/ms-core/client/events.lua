-- MSCore Command Events
RegisterNetEvent('MSCore:Command:TeleportToPlayer')
AddEventHandler('MSCore:Command:TeleportToPlayer', function(othersource)
    local coords = MSCore.Functions.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
    local entity = GetPlayerPed(-1)
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, coords.a)
end) 

RegisterNetEvent('MSCore:Command:TeleportToCoords')
AddEventHandler('MSCore:Command:TeleportToCoords', function(x, y, z)
    local entity = GetPlayerPed(-1)
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    SetEntityCoords(entity, x, y, z)
end) 

RegisterNetEvent('MSCore:Command:SpawnVehicle')
AddEventHandler('MSCore:Command:SpawnVehicle', function(model)
	MSCore.Functions.SpawnVehicle(model, function(vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
	end)
end)

RegisterNetEvent('MSCore:Command:DeleteVehicle')
AddEventHandler('MSCore:Command:DeleteVehicle', function()
	local vehicle = MSCore.Functions.GetClosestVehicle()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false) else vehicle = MSCore.Functions.GetClosestVehicle() end
	-- TriggerServerEvent('MSCore:Command:CheckOwnedVehicle', GetVehicleNumberPlateText(vehicle))
	MSCore.Functions.DeleteVehicle(vehicle)
end)

RegisterNetEvent('MSCore:Command:Revive')
AddEventHandler('MSCore:Command:Revive', function()
	local coords = MSCore.Functions.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)

RegisterNetEvent('MSCore:Command:GoToMarker')
AddEventHandler('MSCore:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			--HideLoadingPromt()
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('MSCore:Player:SetPlayerData')
AddEventHandler('MSCore:Player:SetPlayerData', function(val)
	MSCore.PlayerData = val
end)

RegisterNetEvent('MSCore:Player:UpdatePlayerData')
AddEventHandler('MSCore:Player:UpdatePlayerData', function()
	local data = {}
	data.position = MSCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('MSCore:UpdatePlayer', data)
end)

RegisterNetEvent('MSCore:Player:UpdatePlayerPosition')
AddEventHandler('MSCore:Player:UpdatePlayerPosition', function()
	local position = MSCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('MSCore:UpdatePlayerPosition', position)
end)

RegisterNetEvent('MSCore:Client:LocalOutOfCharacter')
AddEventHandler('MSCore:Client:LocalOutOfCharacter', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 20.0) then
		TriggerEvent("chatMessage", "OOC " .. playerName, "normal", message)
    end
end)

RegisterNetEvent('MSCore:Notify')
AddEventHandler('MSCore:Notify', function(text, type, length)
	MSCore.Functions.Notify(text, type, length)
end)

RegisterNetEvent('MSCore:Client:TriggerCallback')
AddEventHandler('MSCore:Client:TriggerCallback', function(name, ...)
	if MSCore.ServerCallbacks[name] ~= nil then
		MSCore.ServerCallbacks[name](...)
		MSCore.ServerCallbacks[name] = nil
	end
end)

RegisterNetEvent("MSCore:Client:UseItem")
AddEventHandler('MSCore:Client:UseItem', function(item)
	TriggerServerEvent("MSCore:Server:UseItem", item)
end)