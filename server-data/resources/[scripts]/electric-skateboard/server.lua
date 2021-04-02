RegisterServerEvent("shareImOnSkate")
AddEventHandler("shareImOnSkate", function() 
--    print("Shareando!")
    local _source = source
    TriggerClientEvent("shareHeIsOnSkate", -1, _source)
end)

MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)


MSCore.Functions.CreateUseableItem("skateboard", function(source, item)
	local Player = MSCore.Functions.GetPlayer(source)
	Player.Functions.RemoveItem("skateboard", 1, item.slot) 
	TriggerClientEvent('skateboard:Spawn', source)
	TriggerClientEvent('inventory:client:ItemBox', source, MSCore.Shared.Items["skateboard"], "remove")
end)

RegisterServerEvent('skateboard:pick')
AddEventHandler('skateboard:pick', function(item, amount)	
	local Player = MSCore.Functions.GetPlayer(source)
	Player.Functions.AddItem("skateboard", 1)
	TriggerClientEvent('inventory:client:ItemBox', source, MSCore.Shared.Items["skateboard"], "add")
end)



