QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("radar", "Alternar radar de velocidade :)", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Este comando é para serviços de emergência!")
    end
end)