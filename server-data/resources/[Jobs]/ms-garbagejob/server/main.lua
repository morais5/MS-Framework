MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local Bail = {}

MSCore.Functions.CreateCallback('ms-garbagejob:server:HasMoney', function(source, cb)
    local Player = MSCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Player.PlayerData.money.cash >= Config.BailPrice then
        Bail[CitizenId] = "cash"
        Player.Functions.RemoveMoney('cash', Config.BailPrice)
        cb(true)
    elseif Player.PlayerData.money.bank >= Config.BailPrice then
        Bail[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', Config.BailPrice)
        cb(true)
    else
        cb(false)
    end
end)

MSCore.Functions.CreateCallback('ms-garbagejob:server:CheckBail', function(source, cb)
    local Player = MSCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Bail[CitizenId] ~= nil then
        Player.Functions.AddMoney(Bail[CitizenId], Config.BailPrice)
        Bail[CitizenId] = nil
        cb(true)
    else
        cb(false)
    end
end)

local Materials = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
}

RegisterServerEvent('ms-garbagejob:server:PayShit')
AddEventHandler('ms-garbagejob:server:PayShit', function(amount, location)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    if amount > 0 then
        Player.Functions.AddMoney('bank', amount)

        if location == #Config.Locations["vuilnisbakken"] then
            for i = 1, math.random(3, 5), 1 do
                local item = Materials[math.random(1, #Materials)]
                Player.Functions.AddItem(item, math.random(40, 70))
                TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items[item], 'add')
                Citizen.Wait(500)
            end
        end

        TriggerClientEvent('MSCore:Notify', src, "You have been paid $"..amount..",- for yout work", "success")
    else
        TriggerClientEvent('MSCore:Notify', src, "You didn't get paid anything..", "error")
    end
end)