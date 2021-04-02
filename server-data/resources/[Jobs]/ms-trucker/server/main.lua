MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local PaymentTax = 15

local Bail = {}

RegisterServerEvent('ms-trucker:server:DoBail')
AddEventHandler('ms-trucker:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('MSCore:Notify', src, 'You paid the deposit of 1000,-  (Cash)', 'success')
            TriggerClientEvent('ms-trucker:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('MSCore:Notify', src, 'You paid the deposit of 1000,- (Bank)', 'success')
            TriggerClientEvent('ms-trucker:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('MSCore:Notify', src, 'You dont have enough cash you need 1000,-', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "trucker-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('MSCore:Notify', src, 'You recived you deposit of 1000,-', 'success')
        end
    end
end)

RegisterNetEvent('ms-trucker:server:01101110')
AddEventHandler('ms-trucker:server:01101110', function(drops)
    local src = source 
    local Player = MSCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(300, 500)
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5) + 100
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7) + 300
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10) + 400
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12) + 500
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddJobReputation(1)
    Player.Functions.AddMoney("bank", payment, "trucker-salary")
    TriggerClientEvent('chatMessage', source, "BAAN", "warning", "You got ur salary of  $"..payment..", bruto: $"..price.." (from what $"..bonus.." bonus) en $"..taxAmount.." tax ("..PaymentTax.."%)")
end)

