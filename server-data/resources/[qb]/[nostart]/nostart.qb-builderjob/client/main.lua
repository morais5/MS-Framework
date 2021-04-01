QBCore = nil
isLoggedIn = false
PlayerData = {}

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

local BuilderData = {
    ShowDetails = false,
    CurrentTask = nil,
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    GetCurrentProject()
end)

Citizen.CreateThread(function()
    Wait(1000)
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    GetCurrentProject()
end)

function GetCurrentProject()
    QBCore.Functions.TriggerCallback('qb-builderjob:server:GetCurrentProject', function(BuilderConfig)
        Config = BuilderConfig
    end)
end

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

function GetCompletedTasks()
    local retval = {
        completed = 0,
        total = #Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]
    }
    for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
        if v.completed then
            retval.completed = retval.completed + 1
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false
        local OffsetZ = 0.2
        
        if Config.CurrentProject ~= 0 then
            local data = Config.Projects[Config.CurrentProject].ProjectLocations["main"]
            local MainDistance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z, true)

            if MainDistance < 10 then
                inRange = true
                DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 55, 155, 255, 255, 0, 0, 0, 1, 0, 0, 0)

                if MainDistance < 2 then
                    local TaskData = GetCompletedTasks()
                    if TaskData ~= nil then
                        if not BuilderData.ShowDetails then
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Show details')
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + 0.2, 'Tasks: '..TaskData.completed..' / '..TaskData.total)
                        else
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Hide details')
                            for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
                                if v.completed then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, v.label..': Completed')
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, v.label..': Not completed')
                                end
                                OffsetZ = OffsetZ + 0.2
                            end
                        end

                        if TaskData.completed == TaskData.total then
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.2, '[G] End the project')
                            if IsControlJustPressed(0, Keys["G"]) then
                                print("Project ended")
                                TriggerServerEvent('qb-builderjob:server:FinishProject')
                            end
                        end

                        if IsControlJustPressed(0, Keys["E"]) then
                            BuilderData.ShowDetails = not BuilderData.ShowDetails
                        end
                    end
                end
            end

            for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
                if not v.completed or not v.IsBusy then
                    local TaskDistance = GetDistanceBetweenCoords(pos, v.coords.x, v.coords.y, v.coords.z, true)
                    if TaskDistance < 10 then
                        inRange = true
                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 55, 155, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        if TaskDistance < 1.5 then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.25, '[E] Complete task')
                            if IsControlJustPressed(0, Keys["E"]) then
                                BuilderData.CurrentTask = k
                                DoTask()
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

function DoTask()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local TaskData = Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][BuilderData.CurrentTask]
    local CountDown = 5
    TriggerServerEvent('qb-builderjob:server:SetTaskState', BuilderData.CurrentTask, true, false)

    if TaskData.type == "hammer" then
        while CountDown ~= 0 do
            CountDown = CountDown - 1
            print('Test: '..CountDown..'s')
            Citizen.Wait(1000)
        end
        print('Test..')
        TriggerServerEvent('qb-builderjob:server:SetTaskState', BuilderData.CurrentTask, true, true)
    end
end

RegisterNetEvent('qb-builderjob:client:SetTaskState')
AddEventHandler('qb-builderjob:client:SetTaskState', function(Task, IsBusy, IsCompleted)
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
    if IsCompleted then
        print(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].label.." is competed!")
    end
end)

RegisterNetEvent('qb-builderjob:client:FinishProject')
AddEventHandler('qb-builderjob:client:FinishProject', function(BuilderConfig)
    Config = BuilderConfig
    print('Test')
end)