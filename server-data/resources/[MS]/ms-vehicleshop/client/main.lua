Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

MSCore = nil
isLoggedIn = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if MSCore == nil then
            TriggerEvent("MSCore:GetObject", function(obj) MSCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)
PlayerJob = {}

--- CODE

local inVehicleShop = false

vehicleCategorys = {
    ["abarth"] = {
        label = "Abarth",
        vehicles = {}
    },
    ["alfaromeo"] = {
        label = "Alfa Romeo",
        vehicles = {}
    },
    ["astonmartin"] = {
        label = "Aston Martin",
        vehicles = {}
    },
    ["audi"] = {
        label = "Audi",
        vehicles = {}
    },
    ["bentley"] = {
        label = "Bentley",
        vehicles = {}
    },
    ["bmw"] = {
        label = "Bmw",
        vehicles = {}
    },
    ["citroen"] = {
        label = "Citroen",
        vehicles = {}
    },
    ["dacia"] = {
        label = "Dacia",
        vehicles = {}
    },
    ["dodge"] = {
        label = "Dodge",
        vehicles = {}
    },
    ["ferrari"] = {
        label = "Ferrari",
        vehicles = {}
    },
    ["fiat"] = {
        label = "Fiat",
        vehicles = {}
    },
    ["ford"] = {
        label = "Ford",
        vehicles = {}
    },
    ["gmc"] = {
        label = "Gmc",
        vehicles = {}
    },
    ["honda"] = {
        label = "Honda",
        vehicles = {}
    },
    ["hyundai"] = {
        label = "Hyundai",
        vehicles = {}
    },
    ["jaguar"] = {
        label = "Jaguar",
        vehicles = {}
    },
    ["jeep"] = {
        label = "Jeep",
        vehicles = {}
    },
    ["kia"] = {
        label = "Kia",
        vehicles = {}
    },
    ["lamborghini"] = {
        label = "Lamborghini",
        vehicles = {}
    },
    ["mclaren"] = {
        label = "McLaren",
        vehicles = {}
    },
    ["mercedes"] = {
        label = "Mercedes",
        vehicles = {}
    },
    ["motas"] = {
        label = "Motas",
        vehicles = {}
    },
    ["porsche"] = {
        label = "Porsche",
        vehicles = {}
    },
    ["rolls"] = {
        label = "Rolls",
        vehicles = {}
    },
    ["nissan"] = {
        label = "Nissan",
        vehicles = {}
    },
    ["tesla"] = {
        label = "Tesla",
        vehicles = {}
    },
}

RegisterNetEvent('MSCore:Client:OnPlayerLoaded')
AddEventHandler('MSCore:Client:OnPlayerLoaded', function()
    MSCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
    isLoggedIn = true
end)

RegisterNetEvent('MSCore:Client:OnJobUpdate')
AddEventHandler('MSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(MSCore.Shared.Vehicles) do
        if v["shop"] == "pdm" then
            for cat,_ in pairs(vehicleCategorys) do
                if MSCore.Shared.Vehicles[k]["category"] == cat then
                    table.insert(vehicleCategorys[cat].vehicles, MSCore.Shared.Vehicles[k])
                end
            end
        end
    end
end)

function openVehicleShop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        ui = bool
    })
end

function setupVehicles(vehs)
    SendNUIMessage({
        action = "setupVehicles",
        vehicles = vehs
    })
end

RegisterNUICallback('GetCategoryVehicles', function(data)
    setupVehicles(shopVehicles[data.selectedCategory])
end)

RegisterNUICallback('exit', function()
    openVehicleShop(false)
end)

RegisterNUICallback('buyVehicle', function(data)
    local vehicleData = data.vehicleData
    local garage = data.garage

    TriggerServerEvent('ms-vehicleshop:server:buyVehicle', vehicleData, garage)
    openVehicleShop(false)
end)

RegisterNetEvent('ms-vehicleshop:client:spawnBoughtVehicle')
AddEventHandler('ms-vehicleshop:client:spawnBoughtVehicle', function(vehicle)
    MSCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetEntityHeading(veh, ms.SpawnPoint.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    end, ms.SpawnPoint, true)
end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(100)
--     while true do
--         local ped = GetPlayerPed(-1)
--         local pos = GetEntityCoords(ped)

--         if isLoggedIn then
--             for k, v in pairs(ms.VehicleShops) do
--                 local dist = GetDistanceBetweenCoords(pos, ms.VehicleShops[k].x, ms.VehicleShops[k].y, ms.VehicleShops[k].z)
--                 if dist <= 15 then
--                     DrawMarker(2, ms.VehicleShops[k].x, ms.VehicleShops[k].y, ms.VehicleShops[k].z + 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
--                     if dist <= 1.5 then
--                         MSCore.Functions.DrawText3D(ms.VehicleShops[k].x, ms.VehicleShops[k].y, ms.VehicleShops[k].z + 1.3, '~g~E~w~ - Premium Deluxe Motorsports')
--                         if IsControlJustPressed(0, 51) then
--                             openVehicleShop(true)
--                         end
--                     end
--                 end
--             end
--         end

--         Citizen.Wait(0)
--     end
-- end)

Citizen.CreateThread(function()
    for k, v in pairs(ms.VehicleShops) do
        Dealer = AddBlipForCoord(ms.VehicleShops[k].x, ms.VehicleShops[k].y, ms.VehicleShops[k].z)

        SetBlipSprite (Dealer, 326)
        SetBlipDisplay(Dealer, 4)
        SetBlipScale  (Dealer, 0.75)
        SetBlipAsShortRange(Dealer, true)
        SetBlipColour(Dealer, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Vehicle Stand")
        EndTextCommandSetBlipName(Dealer)
    end
end)

Citizen.CreateThread(function()
    QuickSell = AddBlipForCoord(ms.QuickSell.x, ms.QuickSell.y, ms.QuickSell.z)

    SetBlipSprite (QuickSell, 108)
    SetBlipDisplay(QuickSell, 4)
    SetBlipScale  (QuickSell, 0.55)
    SetBlipAsShortRange(QuickSell, true)
    SetBlipColour(QuickSell, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Quick Sale of Vehicles")
    EndTextCommandSetBlipName(QuickSell)
end)