QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback('qb-occasions:server:getVehicles', function(source, cb)
    QBCore.Functions.ExecuteSql(false, 'SELECT * FROM `occasion_vehicles`', function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:checkVehicleOwner", function(source, cb, plate)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid', {['@plate'] = plate, ['@citizenid'] = pData.PlayerData.citizenid}, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-occasions:server:getSellerInformation", function(source, cb, citizenid)
    local src = source

    exports['ghmattimysql']:execute('SELECT * FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('qb-occasions:server:ReturnVehicle')
AddEventHandler('qb-occasions:server:ReturnVehicle', function(vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionid` = '"..vehicleData["oid"].."'", function(result)
        if result[1] ~= nil then 
            if result[1].seller == Player.PlayerData.citizenid then
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
                QBCore.Functions.ExecuteSql(false, "DELETE FROM `occasion_vehicles` WHERE `occasionid` = '"..vehicleData["oid"].."' and `plate` = '"..vehicleData['plate'].."'")
                TriggerClientEvent("qb-occasions:client:ReturnOwnedVehicle", src, result[1])
                TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Este não é o seu veículo...', 'error', 3500)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Veículo não existe...', 'error', 3500)
        end
    end)
end)

RegisterServerEvent('qb-occasions:server:sellVehicle')
AddEventHandler('qb-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(true, "DELETE FROM `player_vehicles` WHERE `plate` = '"..vehicleData.plate.."' AND `vehicle` = '"..vehicleData.model.."'")
    QBCore.Functions.ExecuteSql(true, "INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionid`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..escapeSqli(vehicleData.desc).."', '"..vehicleData.plate.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")
    
    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclesold", {model=vehicleData.model, vehiclePrice=vehiclePrice})
    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Veículo à venda", "red", "**"..GetPlayerName(src) .. "** tem um " .. vehicleData.model .. " Lista à venda por "..vehiclePrice)

    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('qb-occasions:server:buyVehicle')
AddEventHandler('qb-occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionid` = '"..vehicleData["oid"].."'", function(result)
        if result[1] ~= nil and next(result[1]) ~= nil then
            if Player.PlayerData.money.cash >= result[1].price then
                local SellerCitizenId = result[1].seller
                local SellerData = QBCore.Functions.GetPlayerByCitizenId(SellerCitizenId)
                -- New price calculation minus tax
                local NewPrice = math.ceil((result[1].price / 100) * 77)

                Player.Functions.RemoveMoney('cash', result[1].price)

                -- Insert vehicle for buyer
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..result[1].model.."', '"..GetHashKey(result[1].model).."', '"..result[1].mods.."', '"..result[1].plate.."', '0')")
                
                -- Handle money transfer
                if SellerData ~= nil then
                    -- Add money for online
                    SellerData.Functions.AddMoney('bank', NewPrice)
                else
                    -- Add money for offline
                    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..SellerCitizenId.."'", function(BuyerData)
                        if BuyerData[1] ~= nil then
                            local BuyerMoney = json.decode(BuyerData[1].money)
                            BuyerMoney.bank = BuyerMoney.bank + NewPrice
                            QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(BuyerMoney).."' WHERE `citizenid` = '"..SellerCitizenId.."'")
                        end
                    end)
                end

                TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model = result[1].model, from = SellerCitizenId, moneyType = "cash", vehiclePrice = result[1].price, plate = result[1].plate})
                TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion bought", "green", "**"..GetPlayerName(src) .. "** Bought a occasion for "..result[1].price .. " (" .. result[1].plate .. ") of **"..SellerCitizenId.."**")
                TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
            
                -- Delete vehicle from Occasion
                QBCore.Functions.ExecuteSql(false, "DELETE FROM `occasion_vehicles` WHERE `plate` = '"..result[1].plate.."' and `occasionid` = '"..result[1].occasionid.."'")

                -- Send selling mail to seller
                TriggerEvent('qb-phone:server:sendNewMailToOffline', SellerCitizenId, {
                    sender = "Stand",
                    subject = "Seu carro foi comprado!",
                    message = "Olá sou o Jorge vim cá dizer que seu carro foi vendido por "..QBCore.Shared.Vehicles[result[1].model].name.."€"..result[1].price.."!"
                })
            elseif Player.PlayerData.money.bank >= result[1].price then
                local SellerCitizenId = result[1].seller
                local SellerData = QBCore.Functions.GetPlayerByCitizenId(SellerCitizenId)
                -- New price calculation minus tax
                local NewPrice = math.ceil((result[1].price / 100) * 77)

                Player.Functions.RemoveMoney('bank', result[1].price)

                -- Insert vehicle for buyer
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..result[1].model.."', '"..GetHashKey(result[1].model).."', '"..result[1].mods.."', '"..result[1].plate.."', '0')")
                
                -- Handle money transfer
                if SellerData ~= nil then
                    -- Add money for online
                    SellerData.Functions.AddMoney('bank', NewPrice)
                else
                    -- Add money for offline
                    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..SellerCitizenId.."'", function(BuyerData)
                        if BuyerData[1] ~= nil then
                            local BuyerMoney = json.decode(BuyerData[1].money)
                            BuyerMoney.bank = BuyerMoney.bank + NewPrice
                            QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(BuyerMoney).."' WHERE `citizenid` = '"..SellerCitizenId.."'")
                        end
                    end)
                end

                TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model = result[1].model, from = SellerCitizenId, moneyType = "cash", vehiclePrice = result[1].price, plate = result[1].plate})
                TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion bought", "green", "**"..GetPlayerName(src) .. "** Bought a occasion for "..result[1].price .. " (" .. result[1].plate .. ") of **"..SellerCitizenId.."**")
                TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
            
                -- Delete vehicle from Occasion
                QBCore.Functions.ExecuteSql(false, "DELETE FROM `occasion_vehicles` WHERE `plate` = '"..result[1].plate.."' and `occasionid` = '"..result[1].occasionid.."'")

                -- Send selling mail to seller
                TriggerEvent('qb-phone:server:sendNewMailToOffline', SellerCitizenId, {
                    sender = "Stand De Carros Usados",
                    subject = "Seu carro foi vendido!!",
                    message = "Olá teu carro "..QBCore.Shared.Vehicles[result[1].model].name.." foi vendido por €"..result[1].price..",-!"
                })
            else
                TriggerClientEvent('QBCore:Notify', src, 'Não tens dinheiro suficiente...', 'error', 3500)
            end
        end
    end)
end)

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "OC"..num
end

function round(number)
    return number - (number % 1)
end

function escapeSqli(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end