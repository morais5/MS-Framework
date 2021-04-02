MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

RegisterServerEvent('ms-customs:server:UpdateBusyState')
AddEventHandler('ms-customs:server:UpdateBusyState', function(k, bool)
    msCustoms.Locations[k]["busy"] = bool
    TriggerClientEvent('ms-customs:client:UpdateBusyState', -1, k, bool)
end)

RegisterServerEvent('ms-customs:print')
AddEventHandler('ms-customs:print', function(data)
    print(data)
end)

MSCore.Functions.CreateCallback('ms-customs:server:CanPurchase', function(source, cb, price)
    local Player = MSCore.Functions.GetPlayer(source)
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

RegisterServerEvent("ms-customs:server:SaveVehicleProps")
AddEventHandler("ms-customs:server:SaveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        MSCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)


function IsVehicleOwned(plate)
    local retval = false
    MSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end