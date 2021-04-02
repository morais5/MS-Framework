MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

RegisterServerEvent('ms-taxi:server:NpcPay')
AddEventHandler('ms-taxi:server:NpcPay', function(Payment)
    local fooikansasah = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)

    if fooikansasah == r1 or fooikansasah == r2 then
        Payment = Payment + math.random(5, 10)
    end

    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', Payment)
end)