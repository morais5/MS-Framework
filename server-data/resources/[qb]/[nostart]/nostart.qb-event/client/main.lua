QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local EventActive = false
local FrozenVeh = nil

RegisterNetEvent('qb-event:client:EventMovie')
AddEventHandler('qb-event:client:EventMovie', function()
    if not EventActive then
        SetNuiFocus(true, false)
        SendNUIMessage({
            action = "enable"
        })

        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            FrozenVeh = GetVehiclePedIsIn(GetPlayerPed(-1))
            FreezeEntityPosition(FrozenVeh, true)
        end
        EventActive = true
    end
end)

RegisterNUICallback('CloseEvent', function(data, cb)
    SetNuiFocus(false, false)
    EventActive = false
    FreezeEntityPosition(FrozenVeh, false)
    FrozenVeh = nil
end)