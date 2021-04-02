MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)



MSCore.Commands.Add("spec", "emm1", {}, false, function(source, args)
	TriggerClientEvent('spectatelu:spectate', source, target)
end, "admin")

MSCore.Functions.CreateCallback('spectatelu:getPlayerData', function(source, cb, id)
    local Player = MSCore.Functions.GetPlayers()
    if Player ~= nil then
        cb(Player)
    end
end)






