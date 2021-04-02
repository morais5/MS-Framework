MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

MSCore.Commands.Add("am", "Toggle animation menu", {}, false, function(source, args)
	TriggerClientEvent('animations:client:ToggleMenu', source)
end)

MSCore.Commands.Add("e", "fazer animações /am para ver lista", {{name = "name", help = "Emote name"}}, true, function(source, args)
	TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
end)

MSCore.Functions.CreateUseableItem("walkstick", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("animations:UseWandelStok", source)
end)
