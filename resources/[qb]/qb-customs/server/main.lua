QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('qb-customs:server:UpdateBusyState')
AddEventHandler('qb-customs:server:UpdateBusyState', function(k, bool)
    QBCustoms.Locations[k]["busy"] = bool
    TriggerClientEvent('qb-customs:client:UpdateBusyState', -1, k, bool)
end)

RegisterServerEvent('qb-customs:print')
AddEventHandler('qb-customs:print', function(data)
    print(data)
end)

QBCore.Functions.CreateCallback('qb-customs:server:CanPurchase', function(source, cb, price)
    local Player = QBCore.Functions.GetPlayer(source)
    local CanBuy = false

    if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price)
        CanBuy = true
    elseif Player.PlayerData.money.bank >= price then
        Player.Functions.RemoveMoney('bank', price)
        CanBuy = true
    else
        CanBuy = false
    end

    cb(CanBuy)
end)

RegisterServerEvent("qb-customs:server:SaveVehicleProps")
AddEventHandler("qb-customs:server:SaveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)


function IsVehicleOwned(plate)
    local retval = false
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end