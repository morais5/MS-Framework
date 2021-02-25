QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

Teleports = Teleports or {}
Teleports.Locations = {
    [1] = {--casino elevador
        [1] = {x = 3540.74, y = 3675.59, z = 20.99, h = 167.5, r = 1.0},
        [2] = {x = 3540.74, y = 3675.59, z = 28.11, h = 172.5, r = 1.0},
    },
    [2] = {--bahamas balcao 1
        [1] = {x = -1390.897, y = -598.001, z = 30.319, h = 167.5, r = 1.0},
        [2] = {x = -1390.286, y = -600.545, z = 30.319, h = 172.5, r = 1.0},
    },
    [3] = {--bahamas balcao 2
        [1] = {x = -1380.915, y = -632.762, z = 30.819, h = 167.5, r = 1.0},
        [2] = {x = -1371.121, y = -626.012, z = 30.319, h = 172.5, r = 1.0},
    },
    [4] = {--vanilla balcao
        [1] = {x = 133.170, y = -1293.517, z = 29.269, h = 167.5, r = 1.0},
        [2] = {x = 132.479, y = -1287.399, z = 29.273, h = 172.5, r = 1.0},
    }
}
JustTeleported = false

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local inRange = false
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for loc,_ in pairs(Teleports.Locations) do
            for k, v in pairs(Teleports.Locations[loc]) do
                local dist = GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true)
                if loc == 1 then--elevador casino
	                if dist < 2 then
	                    inRange = true
	                    DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

	                    if dist < 1 then
	                        DrawText3Ds(v.x, v.y, v.z, '[E] Usar')
	                        if IsControlJustReleased(0, 51) then
	                            if k == 1 then
	                                SetEntityCoords(ped, Teleports.Locations[loc][2].x, Teleports.Locations[loc][2].y, Teleports.Locations[loc][2].z)
	                            elseif k == 2 then
	                                SetEntityCoords(ped, Teleports.Locations[loc][1].x, Teleports.Locations[loc][1].y, Teleports.Locations[loc][1].z)
	                            end
	                            ResetTeleport()
	                        end
	                    end
	                end
	            elseif loc == 2 then--balcao bahamas 1
	                if dist < 2 then
	                	QBCore.Functions.GetPlayerData(function(PlayerData)
	                		if PlayerData.gang.name == "orgsujo2" then
			                    inRange = true
			                    DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

			                    if dist < 1 then
			                        DrawText3Ds(v.x, v.y, v.z, '[E] Entrar/Sair Balcão')
			                        if IsControlJustReleased(0, 51) then
			                            if k == 1 then
			                                SetEntityCoords(ped, Teleports.Locations[loc][2].x, Teleports.Locations[loc][2].y, Teleports.Locations[loc][2].z)
			                            elseif k == 2 then
			                                SetEntityCoords(ped, Teleports.Locations[loc][1].x, Teleports.Locations[loc][1].y, Teleports.Locations[loc][1].z)
			                            end
			                            ResetTeleport()
			                        end
			                    end
			                end
		                end)
	                end
	            elseif loc == 3 then--balcao bahamas 2
	                if dist < 2 then
	                	QBCore.Functions.GetPlayerData(function(PlayerData)
	                		if PlayerData.gang.name == "orgsujo2" then
			                    inRange = true
			                    DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

			                    if dist < 1 then
			                        DrawText3Ds(v.x, v.y, v.z, '[E] Entrar/Sair Balcão')
			                        if IsControlJustReleased(0, 51) then
			                            if k == 1 then
			                                SetEntityCoords(ped, Teleports.Locations[loc][2].x, Teleports.Locations[loc][2].y, Teleports.Locations[loc][2].z)
			                            elseif k == 2 then
			                                SetEntityCoords(ped, Teleports.Locations[loc][1].x, Teleports.Locations[loc][1].y, Teleports.Locations[loc][1].z)
			                            end
			                            ResetTeleport()
			                        end
			                    end
			                end
		                end)
	                end
	            elseif loc == 4 then--balcao vanilla 1
	                if dist < 2 then
	                	QBCore.Functions.GetPlayerData(function(PlayerData)
	                		if PlayerData.gang.name == "orgsujo" then
			                    inRange = true
			                    DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

			                    if dist < 1 then
			                        DrawText3Ds(v.x, v.y, v.z, '[E] Entrar/Sair Balcão')
			                        if IsControlJustReleased(0, 51) then
			                            if k == 1 then
			                                SetEntityCoords(ped, Teleports.Locations[loc][2].x, Teleports.Locations[loc][2].y, Teleports.Locations[loc][2].z)
			                            elseif k == 2 then
			                                SetEntityCoords(ped, Teleports.Locations[loc][1].x, Teleports.Locations[loc][1].y, Teleports.Locations[loc][1].z)
			                            end
			                            ResetTeleport()
			                        end
			                    end
			                end
		                end)
	                end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

ResetTeleport = function()
    SetTimeout(1000, function()
        JustTeleported = false
    end)
end