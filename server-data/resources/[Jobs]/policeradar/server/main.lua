MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

MSCore.Commands.Add("radar", "Alternar radar de velocidade :)", {}, false, function(source, args)
	local Player = MSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Este comando é para serviços de emergência!")
    end
end)