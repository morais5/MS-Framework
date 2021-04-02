MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

RegisterServerEvent('ms-carwash:server:washCar')
AddEventHandler('ms-carwash:server:washCar', function()
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('ms-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('ms-carwash:client:washCar', src)
    else
        TriggerClientEvent('MSCore:Notify', src, 'You have no money to wash the car..', 'error')
    end
end)