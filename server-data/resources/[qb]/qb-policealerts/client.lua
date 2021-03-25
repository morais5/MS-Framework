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

local isLoggedIn = false
local AlertActive = false
PlayerData = {}
PlayerJob = {}

-- Code

Citizen.CreateThread(function()
    Wait(100)
    if QBCore.Functions.GetPlayerData() ~= nil then
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if JobInfo.name == "police" then
        if PlayerJob.onduty then
            PlayerJob.onduty = false
        end
    end
    PlayerJob.onduty = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData =  QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('qb-policealerts:ToggleDuty')
AddEventHandler('qb-policealerts:ToggleDuty', function(Duty)
    PlayerJob.onduty = Duty
end)

RegisterNetEvent('qb-policealerts:client:AddPoliceAlert')
AddEventHandler('qb-policealerts:client:AddPoliceAlert', function(data, forBoth)
    if forBoth then
        if (PlayerJob.name == "police" or PlayerJob.name == "doctor" or PlayerJob.name == "ambulance") and PlayerJob.onduty then
            if data.alertTitle == "Assistance collegue" or data.alertTitle == "Assistence ambulance" or data.alertTitle == "Assistence Doctor" then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "emergency", 0.7)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            data.callSign = data.callSign ~= nil and data.callSign or PlayerData.metadata["callsign"]
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
        end
    else
        if (PlayerJob.name == "police" and PlayerJob.onduty) then
            if data.alertTitle == "Assistance collegue" or data.alertTitle == "Assistence ambulance" or data.alertTitle == "Assistence Doctor" then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "emergency", 0.7)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            data.callSign = data.callSign ~= nil and data.callSign or PlayerData.metadata["callsign"]
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
        end 
    end

    AlertActive = true
    SetTimeout(data.timeOut, function()
        AlertActive = false
    end)
end)

Citizen.CreateThread(function()
    while true do
        if AlertActive then
            if IsControlJustPressed(0, Keys["LEFTALT"]) then
                SetNuiFocus(true, true)
                SetNuiFocusKeepInput(true, false)
                SetCursorLocation(0.965, 0.12)
                MouseActive = true
            end
        end

        if MouseActive then
            if IsControlJustReleased(0, Keys["LEFTALT"]) then
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false, false)
                MouseActive = false
            end
        end

        Citizen.Wait(6)
    end
end)

RegisterNUICallback('SetWaypoint', function(data)
    local coords = data.coords

    SetNewWaypoint(coords.x, coords.y)
    QBCore.Functions.Notify('GPS ingesteld!')
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false, false)
    MouseActive = false
end)

-- Citizen.CreateThread(function()
--     Wait(500)
--     local ped = GetPlayerPed(-1)
--     local veh = GetVehiclePedIsIn(ped)

--     exports["vstancer"]:SetVstancerPreset(veh, -0.8, 0.0, -0.8, 0.0)
-- end)


-- #The max value you can increase or decrease the front Track Width
-- frontMaxOffset=0.25

-- #The max value you can increase or decrease the front Camber
-- frontMaxCamber=0.20

-- #The max value you can increase or decrease the rear Track Width
-- rearMaxOffset=0.25

-- #The max value you can increase or decrease the rear Camber
-- rearMaxCamber=0.20