MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

MSCore.Commands.Add("shuff", "Switch from seats", {}, false, function(source, args)
    TriggerClientEvent('ms-seatshuff:client:Shuff', source)
end)