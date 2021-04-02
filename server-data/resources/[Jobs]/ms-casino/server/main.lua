MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local ItemList = {
    ["casinochips"] = 1,
}

RegisterServerEvent("ms-casino:sharlock:sell")
AddEventHandler("ms-casino:sharlock:sell", function()
    local src = source
    local price = 0
    local Player = MSCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-casino-chips")
        TriggerClientEvent('MSCore:Notify', src, "Você vendeu suas fichas")
        TriggerEvent("ms-log:server:CreateLog", "casino", "Chips", "blue", "**"..GetPlayerName(src) .. "** got $"..price.." for selling the Chips")
        else
        TriggerClientEvent('MSCore:Notify', src, "Você não tem fichas..")
    end
end)

function SetExports()
exports["ms-blackjack"]:SetGetChipsCallback(function(source)
    local Player = MSCore.Functions.GetPlayer(source)
    local Chips = Player.Functions.GetItemByName("casinochips")

    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        Chips = Chips
    end

    return TriggerClientEvent('MSCore:Notify', src, "Você não tem fichas..")
end)

    exports["ms-blackjack"]:SetTakeChipsCallback(function(source, amount)
        local Player = MSCore.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.RemoveItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, MSCore.Shared.Items['casinochips'], "remove")
            TriggerEvent("ms-log:server:CreateLog", "casino", "Chips", "yellow", "**"..GetPlayerName(source) .. "** put $"..amount.." in table")
        end
    end)

    exports["ms-blackjack"]:SetGiveChipsCallback(function(source, amount)
        local Player = MSCore.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.AddItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, MSCore.Shared.Items['casinochips'], "add")
            TriggerEvent("ms-log:server:CreateLog", "casino", "Chips", "red", "**"..GetPlayerName(source) .. "** got $"..amount.." from table table and he won the double")
        end
    end)
end

AddEventHandler("onResourceStart", function(resourceName)
	if ("ms-blackjack" == resourceName) then
        Citizen.Wait(1000)
        SetExports()
    end
end)

SetExports()
