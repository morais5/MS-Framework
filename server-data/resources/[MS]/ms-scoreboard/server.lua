MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

MSCore.Functions.CreateCallback('ms-scoreboard:server:GetActivity', function(source, cb)
    local PoliceCount = 0
    local AmbulanceCount = 0
    
    for k, v in pairs(MSCore.Functions.GetPlayers()) do
        local Player = MSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceCount = PoliceCount + 1
            end

            if ((Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") and Player.PlayerData.job.onduty) then
                AmbulanceCount = AmbulanceCount + 1
            end
        end
    end

    cb(PoliceCount, AmbulanceCount)
end)

MSCore.Functions.CreateCallback('ms-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

MSCore.Functions.CreateCallback('ms-scoreboard:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for k, v in pairs(MSCore.Functions.GetPlayers()) do
        local Player = MSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            players[Player.PlayerData.source] = {}
            players[Player.PlayerData.source].permission = MSCore.Functions.IsOptin(Player.PlayerData.source)
        end
    end
    cb(players)
end)

RegisterServerEvent('ms-scoreboard:server:SetActivityBusy')
AddEventHandler('ms-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('ms-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)