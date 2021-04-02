MSCore.Functions.CreateCallback('ms-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = MSCore.Shared.Items[item.name]["label"]
            })
        end
    end

    if next(AvailableDrugs) ~= nil then
        cb(AvailableDrugs)
    else
        cb(nil)
    end
end)

RegisterServerEvent('ms-drugs:server:sellCornerDrugs')
AddEventHandler('ms-drugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)
    Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")

    TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = MSCore.Shared.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('ms-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)

RegisterServerEvent('ms-drugs:server:robCornerDrugs')
AddEventHandler('ms-drugs:server:robCornerDrugs', function(item, amount, price)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)

    TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = MSCore.Shared.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('ms-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)