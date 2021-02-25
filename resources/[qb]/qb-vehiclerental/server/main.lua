QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local RentedVehicles = {}

RegisterServerEvent('qb-vehiclerental:server:SetVehicleRented')
AddEventHandler('qb-vehiclerental:server:SetVehicleRented', function(plate, bool, vehicleData)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local plyCid = ply.PlayerData.citizenid

    if bool then
        if ply.PlayerData.money.cash >= vehicleData.price then
            ply.Functions.RemoveMoney('cash', vehicleData.price, "vehicle-rentail-bail") 
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt de borg van €'..vehicleData.price..' cash betaald.', 'success', 3500)
            TriggerClientEvent('qb-vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        elseif ply.PlayerData.money.bank >= vehicleData.price then 
            ply.Functions.RemoveMoney('bank', vehicleData.price, "vehicle-rentail-bail") 
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt de borg van €'..vehicleData.price..' via de bank betaald.', 'success', 3500)
            TriggerClientEvent('qb-vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        else
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet genoeg geld.', 'error', 3500)
        end
        return
    end
    TriggerClientEvent('QBCore:Notify', src, 'Je hebt je borg van €'..vehicleData.price..' terug gekregen.', 'success', 3500)
    ply.Functions.AddMoney('cash', vehicleData.price, "vehicle-rentail-bail")
    RentedVehicles[plyCid] = nil
end)




