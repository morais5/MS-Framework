MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local PaymentTax = 15
local Bail = {}

RegisterServerEvent('ms-tow:server:DoBail')
AddEventHandler('ms-tow:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, "tow-paid-bail")
            TriggerClientEvent('MSCore:Notify', src, 'You have paid your deposit of $1000,', 'success')
            TriggerClientEvent('ms-tow:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-paid-bail")
            TriggerClientEvent('MSCore:Notify', src, 'You have paid your deposit of $1000,', 'success')
            TriggerClientEvent('ms-tow:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('MSCore:Notify', src, 'You dont have enough money, the deposit is $1000', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "tow-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('MSCore:Notify', src, 'You have received your deposit of $1000', 'success')
        end
    end
end)

RegisterNetEvent('ms-tow:server:11101110')
AddEventHandler('ms-tow:server:11101110', function(drops)
    local src = source 
    local Player = MSCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(450, 700)
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5)
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7)
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10)
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12)
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount

    Player.Functions.AddJobReputation(1)
    Player.Functions.AddMoney("bank", payment, "tow-salary")
    TriggerClientEvent('chatMessage', source, "JOB", "warning", "You received your salary : $"..payment..", gross: $"..price.." (with a $"..bonus.." bonus) and $"..taxAmount.." tax ("..PaymentTax.."%)")
end)

MSCore.Commands.Add("npc", "Toggle npc job option", {}, false, function(source, args)
	TriggerClientEvent("jobs:client:ToggleNpc", source)
end)

MSCore.Commands.Add("tow", "Place the car in the rear of the tow truck", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "tow" then
        TriggerClientEvent("ms-tow:client:TowVehicle", source)
    end
end)

