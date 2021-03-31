
tiempo = 800
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(tiempo)
	tiempo = 800
		
		local ped = PlayerPedId()
        local pco = GetEntityCoords(ped)
        local vehicle = GetClosestVehicle(pco, 5.0, 0, 71)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) or DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 then
		tiempo = 10
			local bldoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "window_lr"))
			local brdoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "window_rr"))
			local frdoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "window_rf"))
			local playerpos = GetEntityCoords(GetPlayerPed(-1), 1)
			local distanceToBrdoor = GetDistanceBetweenCoords(brdoor, playerpos, 1)
			local distanceToBldoor = GetDistanceBetweenCoords(bldoor, playerpos, 1)
			local distanceToFrdoor = GetDistanceBetweenCoords(frdoor, playerpos, 1)
				--print(distanceToBrdoor, distanceToBldoor, distanceToFrdoor)
		    if distanceToBrdoor < 0.9 and DoesVehicleHaveDoor(vehicle, 3) and not DoesEntityExist(GetPedInVehicleSeat(vehicle, 2)) and GetVehicleDoorLockStatus(vehicle) ~= 2 then
                DrawText3D(brdoor.x, brdoor.y, brdoor.z + 0.3, "⬆️")
				if (IsControlJustPressed(1, 49)) then
                 TaskEnterVehicle(PlayerPedId(), vehicle, 10000, 2, 1.0, 1, 0)
                end
			elseif distanceToBldoor < 0.9 and DoesVehicleHaveDoor(vehicle, 2) and not DoesEntityExist(GetPedInVehicleSeat(vehicle, 1)) and GetVehicleDoorLockStatus(vehicle) ~= 2 then
                DrawText3D(bldoor.x, bldoor.y, bldoor.z + 0.3, "⬆️")
				if (IsControlJustPressed(1, 49)) then
                 TaskEnterVehicle(PlayerPedId(), vehicle, 10000, 1, 1.0, 1, 0)
                end
			elseif distanceToFrdoor < 0.9 and DoesVehicleHaveDoor(vehicle, 1) and not DoesEntityExist(GetPedInVehicleSeat(vehicle, 0)) and GetVehicleDoorLockStatus(vehicle) ~= 2 then
                DrawText3D(frdoor.x, frdoor.y, frdoor.z + 0.3, "⬆️")
                if (IsControlJustPressed(1, 49)) then
                 TaskEnterVehicle(PlayerPedId(), vehicle, 10000, 0, 1.0, 1, 0)
                end				
			end
		end
		
		
		
	end
end)



function DrawText3D(x,y,z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z - 0.5)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
		SetTextScale(0.45, 0.45)
		SetTextFont(6)
		SetTextProportional(1)
		SetTextColour(0, 255, 0, 255)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
    end
end
