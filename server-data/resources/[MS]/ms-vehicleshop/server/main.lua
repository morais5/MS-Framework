MSCore = nil

TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code

RegisterNetEvent('ms-vehicleshop:server:buyVehicle')
AddEventHandler('ms-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = MSCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = MSCore.Shared.Vehicles[vehicleData["model"]]
    local balance = pData.PlayerData.money["bank"]
    
    if (balance - vData["price"]) >= 0 then
        local plate = GeneratePlate()
        MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData["model"].."', '"..GetHashKey(vData["model"]).."', '{}', '"..plate.."', '"..garage.."')")
        TriggerClientEvent("MSCore:Notify", src, "Well done! Your vehicle has been delivered "..ms.GarageLabel[garage], "success", 5000)
        pData.Functions.RemoveMoney('bank', vData["price"], "vehicle-bought-in-shop")
        TriggerEvent("ms-log:server:sendLog", cid, "vehiclebought", {model=vData["model"], name=vData["name"], from="garage", location=ms.GarageLabel[garage], moneyType="bank", price=vData["price"], plate=plate})
        TriggerEvent("ms-log:server:CreateLog", "vehicleshop", "Purchased vehicle (Garage)", "green", "**"..GetPlayerName(src) .. "** You bought one " .. vData["name"] .. " for $" .. vData["price"])
    else
		TriggerClientEvent("MSCore:Notify", src, "You don't have enough money, you lack $"..format_thousand(vData["price"] - balance), "error", 5000)
    end
end)

RegisterNetEvent('ms-vehicleshop:server:buyShowroomVehicle')
AddEventHandler('ms-vehicleshop:server:buyShowroomVehicle', function(vehicle, class)
    local src = source
    local pData = MSCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = MSCore.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (balance - vehiclePrice) >= 0 then
        MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vehicle.."', '"..GetHashKey(vehicle).."', '{}', '"..plate.."', 0)")
        TriggerClientEvent("MSCore:Notify", src, "Well done! Your vehicle is waiting for you outside.", "success", 5000)
        TriggerClientEvent('ms-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
        TriggerEvent("ms-log:server:sendLog", cid, "vehiclebought", {model=vehicle, name=MSCore.Shared.Vehicles[vehicle]["name"], from="showroom", moneyType="bank", price=MSCore.Shared.Vehicles[vehicle]["price"], plate=plate})
        TriggerEvent("ms-log:server:CreateLog", "vehicleshop", "Purchased vehicle (Stand)", "green", "**"..GetPlayerName(src) .. "** You bought one  " .. MSCore.Shared.Vehicles[vehicle]["name"] .. " por $" .. MSCore.Shared.Vehicles[vehicle]["price"])
    else
        TriggerClientEvent("MSCore:Notify", src, "You don't have enough money, you lack $"..format_thousand(vehiclePrice - balance), "error", 5000)
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    MSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterServerEvent('ms-vehicleshop:server:setShowroomCarInUse')
AddEventHandler('ms-vehicleshop:server:setShowroomCarInUse', function(showroomVehicle, bool)
    ms.ShowroomVehicles[showroomVehicle].inUse = bool
    TriggerClientEvent('ms-vehicleshop:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('ms-vehicleshop:server:setShowroomVehicle')
AddEventHandler('ms-vehicleshop:server:setShowroomVehicle', function(vData, k)
    ms.ShowroomVehicles[k].chosenVehicle = vData
    TriggerClientEvent('ms-vehicleshop:client:setShowroomVehicle', -1, vData, k)
end)

RegisterServerEvent('ms-vehicleshop:server:SetCustomShowroomVeh')
AddEventHandler('ms-vehicleshop:server:SetCustomShowroomVeh', function(vData, k)
    ms.ShowroomVehicles[k].vehicle = vData
    TriggerClientEvent('ms-vehicleshop:client:SetCustomShowroomVeh', -1, vData, k)
end)

MSCore.Commands.Add("sellvehicle", "Sell the vehicle at a custom car dealership", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        if TargetId ~= nil then
            TriggerClientEvent('ms-vehicleshop:client:SellCustomVehicle', source, TargetId)
        else
            TriggerClientEvent('MSCore:Notify', source, 'You need to give the player ID', 'error')
        end
    else
        TriggerClientEvent('MSCore:Notify', source, 'You are not a car dealer', 'error')
    end
end)

MSCore.Commands.Add("testdrive", "Take a test drive", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        TriggerClientEvent('ms-vehicleshop:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('MSCore:Notify', source, 'You arrive at a car dealership', 'error')
    end
end)

RegisterServerEvent('ms-vehicleshop:server:SellCustomVehicle')
AddEventHandler('ms-vehicleshop:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('ms-vehicleshop:client:SetVehicleBuying', TargetId, ShowroomSlot)
end)

RegisterServerEvent('ms-vehicleshop:server:ConfirmVehicle')
AddEventHandler('ms-vehicleshop:server:ConfirmVehicle', function(ShowroomVehicle)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local VehPrice = MSCore.Shared.Vehicles[ShowroomVehicle.vehicle].price
    local plate = GeneratePlate()

    if Player.PlayerData.money.cash >= VehPrice then
        Player.Functions.RemoveMoney('cash', VehPrice)
        TriggerClientEvent('ms-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    elseif Player.PlayerData.money.bank >= VehPrice then
        Player.Functions.RemoveMoney('bank', VehPrice)
        TriggerClientEvent('ms-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    else
        if Player.PlayerData.money.cash > Player.PlayerData.money.bank then
            TriggerClientEvent('MSCore:Notify', src, 'You dont have enough money .. missing $ ('..(Player.PlayerData.money.cash - VehPrice)..',-)')
        else
            TriggerClientEvent('MSCore:Notify', src, 'You dont have enough money .. missing $ ('..(Player.PlayerData.money.bank - VehPrice)..',-)')
        end
    end
end)

MSCore.Functions.CreateCallback('ms-vehicleshop:server:SellVehicle', function(source, cb, vehicle, plate)
    local VehicleData = MSCore.Shared.VehicleModels[vehicle]
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Player.Functions.AddMoney('bank', math.ceil(VehicleData["price"] / 100 * 60))
            MSCore.Functions.ExecuteSql(false, "DELETE FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'")
            cb(true)
        else
            cb(false)
        end
    end)
end)