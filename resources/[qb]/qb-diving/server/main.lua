QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('qb-diving:server:SetBerthVehicle')
AddEventHandler('qb-diving:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('qb-diving:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    
    QBBoatshop.Locations["berths"][BerthId]["boatModel"] = boatModel
end)

RegisterServerEvent('qb-diving:server:SetDockInUse')
AddEventHandler('qb-diving:server:SetDockInUse', function(BerthId, InUse)
    QBBoatshop.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('qb-diving:client:SetDockInUse', -1, BerthId, InUse)
end)

QBCore.Functions.CreateCallback('qb-diving:server:GetBusyDocks', function(source, cb)
    cb(QBBoatshop.Locations["berths"])
end)

RegisterServerEvent('qb-diving:server:BuyBoat')
AddEventHandler('qb-diving:server:BuyBoat', function(boatModel, BerthId)
    local BoatPrice = QBBoatshop.ShopBoats[boatModel]["price"]
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }
    local missingMoney = 0
    local plate = "LUAL"..math.random(1111, 9999)

    if PlayerMoney.cash >= BoatPrice then
        Player.Functions.RemoveMoney('cash', BoatPrice, "bought-boat")
        TriggerClientEvent('qb-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    elseif PlayerMoney.bank >= BoatPrice then
        Player.Functions.RemoveMoney('bank', BoatPrice, "bought-boat")
        TriggerClientEvent('qb-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (BoatPrice - PlayerMoney.bank)
        else
            missingMoney = (BoatPrice - PlayerMoney.cash)
        end
        TriggerClientEvent('QBCore:Notify', src, 'Você não tem dinheiro suficiente, está faltando €'..missingMoney, 'error', 4000)
    end
end)

function InsertBoat(boatModel, Player, plate)
    QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_boats` (`citizenid`, `model`, `plate`) VALUES ('"..Player.PlayerData.citizenid.."', '"..boatModel.."', '"..plate.."')")
end

QBCore.Functions.CreateUseableItem("jerry_can", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

    TriggerClientEvent("qb-diving:client:UseJerrycan", source)
end)

QBCore.Functions.CreateUseableItem("diving_gear", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

    TriggerClientEvent("qb-diving:client:UseGear", source, true)
end)

RegisterServerEvent('qb-diving:server:RemoveItem')
AddEventHandler('qb-diving:server:RemoveItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
end)

QBCore.Functions.CreateCallback('qb-diving:server:GetMyBoats', function(source, cb, dock)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_boats` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `boathouse` = '"..dock.."'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback('qb-diving:server:GetDepotBoats', function(source, cb, dock)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_boats` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `state` = '0'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('qb-diving:server:SetBoatState')
AddEventHandler('qb-diving:server:SetBoatState', function(plate, state, boathouse)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_boats` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            QBCore.Functions.ExecuteSql(false, "UPDATE `player_boats` SET `state` = '"..state.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
    
            if state == 1 then
                QBCore.Functions.ExecuteSql(false, "UPDATE `player_boats` SET `boathouse` = '"..boathouse.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end
    end)
end)

RegisterServerEvent('qb-diving:server:CallCops')
AddEventHandler('qb-diving:server:CallCops', function(Coords)
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                local msg = "alguem esta roubando coral!"
                TriggerClientEvent('qb-diving:client:CallCops', Player.PlayerData.source, Coords, msg)
                local alertData = {
                    title = "Mergulho ilegal",
                    coords = {x = Coords.x, y = Coords.y, z = Coords.z},
                    description = msg,
                }
                TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
            end
        end
	end
end)

local AvailableCoral = {}

QBCore.Commands.Add("tirarroupademergulho", "Tire sua roupa de neoprene", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("qb-diving:client:UseGear", source, false)
end)

RegisterServerEvent('qb-diving:server:SellCoral')
AddEventHandler('qb-diving:server:SellCoral', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if HasCoral(src) then
        for k, v in pairs(AvailableCoral) do
            local Item = Player.Functions.GetItemByName(v.item)
            local price = (Item.amount * v.price)
            local Reward = math.ceil(GetItemPrice(Item, price))

            if Item.amount > 1 then
                for i = 1, Item.amount, 1 do
                    Player.Functions.RemoveItem(Item.name, 1)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Item.name], "remove")
                    Player.Functions.AddMoney('cash', math.ceil((Reward / Item.amount)), "sold-coral")
                    Citizen.Wait(250)
                end
            else
                Player.Functions.RemoveItem(Item.name, 1)
                Player.Functions.AddMoney('cash', Reward, "sold-coral")
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Item.name], "remove")
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Você não tem nenhum coral para vender..', 'error')
    end
end)

function GetItemPrice(Item, price)
    if Item.amount > 5 then
        price = price / 100 * 80
    elseif Item.amount > 10 then
        price = price / 100 * 70
    elseif Item.amount > 15 then
        price = price / 100 * 50
    end
    return price
end

function HasCoral(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local retval = false
    AvailableCoral = {}

    for k, v in pairs(QBDiving.CoralTypes) do
        local Item = Player.Functions.GetItemByName(v.item)
        if Item ~= nil then
            table.insert(AvailableCoral, v)
            retval = true
        end
    end
    return retval
end