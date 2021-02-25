QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)



QBCore.Commands.Add("spec", "emm1", {}, false, function(source, args)
	TriggerClientEvent('spectatelu:spectate', source, target)
end, "admin")

QBCore.Functions.CreateCallback('spectatelu:getPlayerData', function(source, cb, id)
    local Player = QBCore.Functions.GetPlayers()
    if Player ~= nil then
        cb(Player)
    end
end)






