QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


QBCore.Functions.CreateUseableItem("lotto", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("lotto:usar", source)
    end
end)



RegisterServerEvent('lotto:win')
AddEventHandler('lotto:win', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local array = {750, 640, 510, 0, 50, 300, 600, 1, 2, 10, 25, 90, 60, 65, 3, 290, 345, 691, 81, 329, 70, 20, 4, 5, 465, 470}
	local money = array[math.random(26)]
	Player.Functions.AddMoney('cash',Config.Payment)
end)
