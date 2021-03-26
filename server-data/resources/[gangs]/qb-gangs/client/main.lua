QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        Citizen.Wait(100) 
    end
end)

isLoggedIn = false
local PlayerGang = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
    isLoggedIn = true
end)

local currentAction = "none"

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isLoggedIn and PlayerGang.name ~= "none" then
            v = Config.Gangs[PlayerGang.name]["Stash"]

            ped = PlayerPedId()
            pos = GetEntityCoords(ped)

            stashdist = #(pos - vector3(v["coords"].x, v["coords"].y, v["coords"].z))
            if stashdist < 5.0 then
                DrawMarker(2, v["coords"].x, v["coords"].y, v["coords"].z - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                if stashdist < 1.5 then
                    QBCore.Functions.DrawText3D(v["coords"].x, v["coords"].y, v["coords"].z, "[~g~E~w~] - Stash")
                    currentAction = "stash"
                elseif stashdist < 2.0 then
                    QBCore.Functions.DrawText3D(v["coords"].x, v["coords"].y, v["coords"].z, "Stash")
                    currentAction = "none"
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isLoggedIn and PlayerGang.name ~= "none" then
            v = Config.Gangs[PlayerGang.name]["VehicleSpawner"]
            ped = PlayerPedId()
            pos = GetEntityCoords(ped)

            vehdist = #(pos - vector3(v["coords"].x, v["coords"].y, v["coords"].z))

            if vehdist < 5.0 then
                DrawMarker(2, v["coords"].x, v["coords"].y, v["coords"].z - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                if vehdist < 1.5 then
                    QBCore.Functions.DrawText3D(v["coords"].x, v["coords"].y, v["coords"].z, "[~g~E~w~] - Garage")
                    currentAction = "garage"
                elseif vehdist < 2.0 then
                    QBCore.Functions.DrawText3D(v["coords"].x, v["coords"].y, v["coords"].z, "Garage")
                    currentAction = "none"
                end
                
                Menu.renderGUI()
            else
                Citizen.Wait(1000)
            end

        else
            Citizen.Wait(2500)
        end
    end
end)

RegisterCommand("+GangInteract", function()
    if currentAction == "stash" then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerGang.name.."stash", {
            maxweight = 4000000,
            slots = 500,
        })
        TriggerEvent("inventory:client:SetCurrentStash", PlayerGang.name.."stash")
    elseif currentAction == "garage" then
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
        else
            GangGarage()
            Menu.hidden = not Menu.hidden
        end
    end
end, false)
RegisterCommand("-GangInteract", function()
end, false)
TriggerEvent("chat:removeSuggestion", "/+GangInteract")
TriggerEvent("chat:removeSuggestion", "/-GangInteract")

RegisterKeyMapping("+GangInteract", "Interaction for gang script", "keyboard", "e")

function GangGarage()
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicle", "VehicleList", nil)
    Menu.addButton("Close menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    MenuTitle = "Vehicle:"
    ClearMenu()
    Vehicles = Config.Gangs[PlayerGang.name]["VehicleSpawner"]["vehicles"]
    for k, v in pairs(Vehicles) do
        Menu.addButton(Vehicles[k], "TakeOutVehicle", k, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Return", "GangGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        local v = Config.Gangs[PlayerGang.name]["VehicleSpawner"]
        local coords = v.coords
        local primary = v["colours"]["primary"]
        local secondary = v["colours"]["secondary"]
        SetVehicleCustomPrimaryColour(veh, primary.r, primary.g, primary.b)
        SetVehicleCustomSecondaryColour(veh, secondary.r, secondary.g, secondary.b)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    ClearMenu()
end