QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("fix", "Reparar o carro", {}, false, function(source, args)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

QBCore.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicle", source)
    end
end)

QBCore.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:CleanVehicle", source)
    end
end)

QBCore.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterServerEvent('qb-vehiclefailure:removeItem')
AddEventHandler('qb-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterServerEvent('vehiclefailure:server:removewashingkit')
AddEventHandler('vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
    TriggerClientEvent('vehiclefailure:client:SyncWash', -1, veh)
end)

