QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("am", "Toggle animation menu", {}, false, function(source, args)
	TriggerClientEvent('animations:client:ToggleMenu', source)
end)

QBCore.Commands.Add("e", "fazer animações /am para ver lista", {{name = "name", help = "Emote name"}}, true, function(source, args)
	TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
end)

QBCore.Functions.CreateUseableItem("walkstick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("animations:UseWandelStok", source)
end)
