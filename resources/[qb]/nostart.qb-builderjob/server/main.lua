QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback('qb-builderjob:server:GetCurrentProject', function(source, cb)
    local CurProject = nil
    for k, v in pairs(Config.Projects) do
        if v.IsActive then
            CurProject = k
            break
        end
    end

    if CurProject == nil then
        CurProject = math.random(1, #Config.Projects)
        Config.Projects[CurProject].IsActive = true
        Config.CurrentProject = CurProject
    end
    cb(Config)
end)

RegisterServerEvent('qb-builderjob:server:SetTaskState')
AddEventHandler('qb-builderjob:server:SetTaskState', function(Task, IsBusy, IsCompleted)
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
    TriggerClientEvent('qb-builderjob:client:SetTaskState', -1, Task, IsBusy, IsCompleted)
end)

RegisterServerEvent('qb-builderjob:server:FinishProject')
AddEventHandler('qb-builderjob:server:FinishProject', function()
    Config.Projects[Config.CurrentProject].IsActive = false
    for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
        v.completed = false
        v.IsBusy = false
    end
    local NewProject = math.random(1, #Config.Projects)
    Config.CurrentProject = NewProject
    Config.Projects[NewProject].IsActive = true
    TriggerClientEvent('qb-builderjob:client:FinishProject', -1, Config)
end)