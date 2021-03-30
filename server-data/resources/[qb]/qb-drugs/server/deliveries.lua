RegisterServerEvent('qb-drugs:server:updateDealerItems')
AddEventHandler('qb-drugs:server:updateDealerItems', function(itemData, amount, dealer)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.Dealers[dealer]["products"][itemData.slot].amount - 1 >= 0 then
        Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
        TriggerClientEvent('qb-drugs:client:setDealerItems', -1, itemData, amount, dealer)
    else
        Player.Functions.RemoveItem(itemData.name, amount)
        Player.Functions.AddMoney('cash', amount * Config.Dealers[dealer]["products"][itemData.slot].price)

        TriggerClientEvent("QBCore:Notify", _src, "This item is not available. You have a refund.", "error")
    end
end)

RegisterServerEvent('qb-drugs:server:giveDeliveryItems')
AddEventHandler('qb-drugs:server:giveDeliveryItems', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem('weed_brick', amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "add")
end)

QBCore.Functions.CreateCallback('qb-drugs:server:RequestConfig', function(source, cb)
    cb(Config.Dealers)
end)

RegisterServerEvent('qb-drugs:server:succesDelivery')
AddEventHandler('qb-drugs:server:succesDelivery', function(deliveryData, inTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local curRep = Player.PlayerData.metadata["dealerrep"]

    if inTime then
        if Player.Functions.GetItemByName('weed_brick') ~= nil and Player.Functions.GetItemByName('weed_brick').amount >= deliveryData["amount"] then
            Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])
            local cops = GetCurrentCops()
            local price = 3000
            if cops == 1 then
                price = 4000
            elseif cops == 2 then
                price = 5000
            elseif cops >= 3 then
                price = 6000
            end
            if curRep < 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 8), "dilvery-drugs")
            elseif curRep >= 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "dilvery-drugs")
            elseif curRep >= 20 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 12), "dilvery-drugs")
            elseif curRep >= 30 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 15), "dilvery-drugs")
            elseif curRep >= 40 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 18), "dilvery-drugs")
            end

            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")
            TriggerClientEvent('QBCore:Notify', src, 'The request was delivered completely', 'success')

            SetTimeout(math.random(5000, 10000), function()
                TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'perfect', deliveryData)

                Player.Functions.SetMetaData('dealerrep', (curRep + 1))
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'This does not answer the request ...', 'error')

            if Player.Functions.GetItemByName('weed_brick').amount >= 0 then
                Player.Functions.RemoveItem('weed_brick', Player.Functions.GetItemByName('weed_brick').amount)
                Player.Functions.AddMoney('cash', (Player.Functions.GetItemByName('weed_brick').amount * 6000 / 100 * 5))
            end

            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")

            SetTimeout(math.random(5000, 10000), function()
                TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'bad', deliveryData)

                if curRep - 1 > 0 then
                    Player.Functions.SetMetaData('dealerrep', (curRep - 1))
                else
                    Player.Functions.SetMetaData('dealerrep', 0)
                end
            end)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are very late...', 'error')

        Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])
        Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 4), "dilvery-drugs-too-late")

        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], "remove")

        SetTimeout(math.random(5000, 10000), function()
            TriggerClientEvent('qb-drugs:client:sendDeliveryMail', src, 'late', deliveryData)

            if curRep - 1 > 0 then
                Player.Functions.SetMetaData('dealerrep', (curRep - 1))
            else
                Player.Functions.SetMetaData('dealerrep', 0)
            end
        end)
    end
end)

RegisterServerEvent('qb-drugs:server:callCops')
AddEventHandler('qb-drugs:server:callCops', function(streetLabel, coords)
    local msg = "A suspected situation was located in "..streetLabel..", possibly drug trafficking."
    local alertData = {
        title = "Drug Dealing",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("qb-drugs:client:robberyCall", Player.PlayerData.source, msg, streetLabel, coords)
                TriggerClientEvent("qb-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end


QBCore.Commands.Add("dealers", "Get an overview of all Dealers", {}, false, function(source, args)
    local DealersText = ""
    if Config.Dealers ~= nil and next(Config.Dealers) ~= nil then
        for k, v in pairs(Config.Dealers) do
            DealersText = DealersText .. "Name: " .. v["name"] .. "<br>"
        end
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>List of all dealers: </strong><br><br> '..DealersText..'</div></div>',
            args = {}
        })
    else
        TriggerClientEvent('QBCore:Notify', source, 'No dealer was placed.', 'error')
    end
end, "admin")

QBCore.Commands.Add("dealergoto", "Teleport for the dealer", {{name = "name", help = "Name of dealer"}}, true, function(source, args)
    local DealerName = tostring(args[1])

    if Config.Dealers[DealerName] ~= nil then
        TriggerClientEvent('qb-drugs:client:GotoDealer', source, Config.Dealers[DealerName])
    else
        TriggerClientEvent('QBCore:Notify', source, 'This dealer does not exist.', 'error')
    end
end, "admin")

Citizen.CreateThread(function()
    Wait(500)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `dealers`", function(dealers)
        if dealers[1] ~= nil then
            for k, v in pairs(dealers) do
                local coords = json.decode(v.coords)
                local time = json.decode(v.time)

                Config.Dealers[v.name] = {
                    ["name"] = v.name,
                    ["coords"] = {
                        ["x"] = coords.x,
                        ["y"] = coords.y,
                        ["z"] = coords.z,
                    },
                    ["time"] = {
                        ["min"] = time.min,
                        ["max"] = time.max,
                    },
                    ["products"] = Config.Products,
                }
            end
        end
        TriggerClientEvent('qb-drugs:client:RefreshDealers', -1, Config.Dealers)
    end)
end)

RegisterServerEvent('qb-drugs:server:CreateDealer')
AddEventHandler('qb-drugs:server:CreateDealer', function(DealerData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `dealers` WHERE `name` = '"..DealerData.name.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent('QBCore:Notify', src, "There is already a dealer with this name..", "error")
        else
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `dealers` (`name`, `coords`, `time`, `createdby`) VALUES ('"..DealerData.name.."', '"..json.encode(DealerData.pos).."', '"..json.encode(DealerData.time).."', '"..Player.PlayerData.citizenid.."')", function()
                Config.Dealers[DealerData.name] = {
                    ["name"] = DealerData.name,
                    ["coords"] = {
                        ["x"] = DealerData.pos.x,
                        ["y"] = DealerData.pos.y,
                        ["z"] = DealerData.pos.z,
                    },
                    ["time"] = {
                        ["min"] = DealerData.time.min,
                        ["max"] = DealerData.time.max,
                    },
                    ["products"] = Config.Products,
                }

                TriggerClientEvent('qb-drugs:client:RefreshDealers', -1, Config.Dealers)
            end)
        end
    end)
end)

--------------------------CODE----------------------------------------------------------------------------------------
QBCore.Commands.Add("createdealer", "Place a dealer", {
    {name = "naam", help = "Name of the dealer"},
    {name = "min", help = "Minimal time"},
    {name = "max", help = "Maximal time"},
}, true, function(source, args)
    local dealername = args[1]
    local mintime = tonumber(args[2])
    local maxtime = tonumber(args[3])

    TriggerClientEvent('qb-drugs:client:CreateDealer', source, dealername, mintime, maxtime)
end, "admin")

QBCore.Commands.Add("removedealer", "Remove a dealer", {
    {name = "naam", help = "Name of the dealer"},
}, true, function(source, args)
    local dealername = args[1]
    
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `dealers` WHERE `name` = '"..dealername.."'", function(result)
        if result[1] ~= nil then
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `dealers` WHERE `name` = '"..dealername.."'")
            Config.Dealers[dealerName] = nil
            TriggerClientEvent('qb-drugs:client:RefreshDealers', -1, Config.Dealers)
            TriggerClientEvent('QBCore:Notify', source, "You have deleted a dealer "..dealername.."!", "success")
        else
            TriggerClientEvent('QBCore:Notify', source, "Dealer "..dealername.." does not exist..", "error")
        end
    end)
end, "admin")

----END code-----------------------------------------------------------------------------------------------


function GetDealers()
    return Config.Dealers
end