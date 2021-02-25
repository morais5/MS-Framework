local ClosestBerth = 1
local BoatsSpawned = false
local ModelLoaded = true
local SpawnedBoats = {}
local Buying = false

-- Berth's Boatshop Loop

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local BerthDist = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][1]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][1]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][1]["coords"]["boat"]["z"], false)

        if BerthDist < 100 then
            SetClosestBerthBoat()
            if not BoatsSpawned then
                SpawnBerthBoats()
            end
        elseif BerthDist > 110 then
            if BoatsSpawned then
                BoatsSpawned = false
            end
        end

        Citizen.Wait(1000)
    end
end)

function SpawnBerthBoats()
    for loc,_ in pairs(QBBoatshop.Locations["berths"]) do
        if SpawnedBoats[loc] ~= nil then
            QBCore.Functions.DeleteVehicle(SpawnedBoats[loc])
        end
		local model = GetHashKey(QBBoatshop.Locations["berths"][loc]["boatModel"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["z"], false, false)

        SetModelAsNoLongerNoded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, QBBoatshop.Locations["berths"][loc]["coords"]["boat"]["h"])
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)     
        SpawnedBoats[loc] = veh
    end
    BoatsSpawned = true
end

function SetClosestBerthBoat()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(QBBoatshop.Locations["berths"]) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][id]["coords"]["buy"]["x"], QBBoatshop.Locations["berths"][id]["coords"]["buy"]["y"], QBBoatshop.Locations["berths"][id]["coords"]["buy"]["z"], true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][id]["coords"]["buy"]["x"], QBBoatshop.Locations["berths"][id]["coords"]["buy"]["y"], QBBoatshop.Locations["berths"][id]["coords"]["buy"]["z"], true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][id]["coords"]["buy"]["x"], QBBoatshop.Locations["berths"][id]["coords"]["buy"]["y"], QBBoatshop.Locations["berths"][id]["coords"]["buy"]["z"], true)
            current = id
        end
    end
    if current ~= ClosestBerth then
        ClosestBerth = current
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        local inRange = false

        local distance = GetDistanceBetweenCoords(pos, QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["z"], true)

        if distance < 15 then
            local BuyLocation = {
                x = QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["x"],
                y = QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["y"],
                z = QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["z"]
            }

            DrawMarker(2, BuyLocation.x, BuyLocation.y, BuyLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)
            local BuyDistance = GetDistanceBetweenCoords(pos, BuyLocation.x, BuyLocation.y, BuyLocation.z, true)

            if BuyDistance < 2 then                
                local currentBoat = QBBoatshop.Locations["berths"][ClosestBerth]["boatModel"]

                DrawMarker(2, QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["z"] + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)

                if not Buying then
                    DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, '~g~E~w~ - '..QBBoatshop.ShopBoats[currentBoat]["label"]..' comprar por ~b~€'..QBBoatshop.ShopBoats[currentBoat]["price"])
                    if IsControlJustPressed(0, Keys["E"]) then
                        Buying = true
                    end
                else
                    DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, 'Você tem certeza? ~g~7~w~ Sim / ~r~8~w~ Não ~b~(€'..QBBoatshop.ShopBoats[currentBoat]["price"]..',-)')
                    if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustReleased(0, Keys["7"]) then
                        TriggerServerEvent('qb-diving:server:BuyBoat', QBBoatshop.Locations["berths"][ClosestBerth]["boatModel"], ClosestBerth)
                        Buying = false
                    elseif IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustReleased(0, Keys["8"]) then
                        Buying = false
                    end
                end
            elseif BuyDistance > 2.5 then
                if Buying then
                    Buying = false
                end
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('qb-diving:client:BuyBoat')
AddEventHandler('qb-diving:client:BuyBoat', function(boatModel, plate)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    QBCore.Functions.SpawnVehicle(boatModel, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, QBBoatshop.SpawnVehicle.h)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    end, QBBoatshop.SpawnVehicle, false)
    SetTimeout(1000, function()
        DoScreenFadeIn(250)
    end)
end)

Citizen.CreateThread(function()
    BoatShop = AddBlipForCoord(QBBoatshop.Locations["berths"][1]["coords"]["boat"]["x"], QBBoatshop.Locations["berths"][1]["coords"]["boat"]["y"], QBBoatshop.Locations["berths"][1]["coords"]["boat"]["z"])

    SetBlipSprite (BoatShop, 410)
    SetBlipDisplay(BoatShop, 4)
    SetBlipScale  (BoatShop, 0.8)
    SetBlipAsShortRange(BoatShop, true)
    SetBlipColour(BoatShop, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("LSYMC Port")
    EndTextCommandSetBlipName(BoatShop)
end)