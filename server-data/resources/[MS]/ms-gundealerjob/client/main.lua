MSCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if MSCore == nil then
            TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = false
local PlayerJob = {}

RegisterNetEvent('MSCore:Client:OnPlayerLoaded')
AddEventHandler('MSCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = MSCore.Functions.GetPlayerData().job
    
    RefreshBlip()
end)

RegisterNetEvent('MSCore:Client:OnPlayerUnload')
AddEventHandler('MSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('MSCore:Client:OnJobUpdate')
AddEventHandler('MSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo

    RefreshBlip()
end)

function DrawText3D(x, y, z, text)
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
        Citizen.Wait(1)
        if isLoggedIn and MSCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == "gundealer" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehiclegundealer"].coords.x, Config.Locations["vehiclegundealer"].coords.y, Config.Locations["vehiclegundealer"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["vehiclegundealer"].coords.x, Config.Locations["vehiclegundealer"].coords.y, Config.Locations["vehiclegundealer"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehiclegundealer"].coords.x, Config.Locations["vehiclegundealer"].coords.y, Config.Locations["vehiclegundealer"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["vehiclegundealer"].coords.x, Config.Locations["vehiclegundealer"].coords.y, Config.Locations["vehiclegundealer"].coords.z, "~g~E~w~ - Store The Vehicle")
                        else
                            DrawText3D(Config.Locations["vehiclegundealer"].coords.x, Config.Locations["vehiclegundealer"].coords.y, Config.Locations["vehiclegundealer"].coords.z, "~g~E~w~ - Spawn A Vehicle")
                        end
                        if IsControlJustReleased(0, 38) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                VehicleSpawnDealer()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and MSCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == "gundealer" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashgundealer"].coords.x, Config.Locations["stashgundealer"].coords.y, Config.Locations["stashgundealer"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashgundealer"].coords.x, Config.Locations["stashgundealer"].coords.y, Config.Locations["stashgundealer"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashgundealer"].coords.x, Config.Locations["stashgundealer"].coords.y, Config.Locations["stashgundealer"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashgundealer"].coords.x, Config.Locations["stashgundealer"].coords.y, Config.Locations["stashgundealer"].coords.z, "~g~E~w~ - Use The Stash Here ")
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Gun Dealer", {
                                maxweight = 4000000,
                                slots = 100,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "Gun Dealer")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and MSCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == "gundealer" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["gundealerweapons"].coords.x, Config.Locations["gundealerweapons"].coords.y, Config.Locations["gundealerweapons"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["gundealerweapons"].coords.x, Config.Locations["gundealerweapons"].coords.y, Config.Locations["gundealerweapons"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["gundealerweapons"].coords.x, Config.Locations["gundealerweapons"].coords.y, Config.Locations["gundealerweapons"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["gundealerweapons"].coords.x, Config.Locations["gundealerweapons"].coords.y, Config.Locations["gundealerweapons"].coords.z, "~g~E~w~ - Gun Safe ")
                            if IsControlJustReleased(0, 38) then
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", "gundealer", Config.GunDealer)
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

function VehicleSpawnDealer()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicle", "VehicleListGunDealer", nil)
    Menu.addButton("Close menu", "closeMenuFull", nil) 
end

function VehicleListGunDealer(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Vehicle:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicleGunDealer", k, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Return", "VehicleSpawnDealer",nil)
end

function TakeOutVehicleGunDealer(vehicleInfo)
    local coords = Config.Locations["vehiclegundealer"].coords
    MSCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "GN"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 108,11,184)
        SetVehicleCustomSecondaryColour(veh, 108,11,184)
        SetEntityHeading(veh, coords.h)
        exports['ms-hud']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function RefreshBlip()

	if blip and DoesBlipExist(blip) then
		RemoveBlip(blip)
    end
    
    CreateThread(function()
        if PlayerJob.name == "gundealer" then
            blip = AddBlipForCoord(118.16, -1950.68, 20.75)
    
            SetBlipSprite (blip, 40)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.7)
    
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Gundealer House')
            EndTextCommandSetBlipName(blip)
		end
	end)

end