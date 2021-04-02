MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

MSCore.Commands.Add("newscam", "Take news camera", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

MSCore.Commands.Add("newsmic", "Take news microphone", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

