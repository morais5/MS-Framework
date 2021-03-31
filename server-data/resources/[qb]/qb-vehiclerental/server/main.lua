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
            TriggerClientEvent('QBCore:Notify', src, 'You have paid the deposit of $'..vehicleData.price..' with cash.', 'success', 3500)
            TriggerClientEvent('qb-vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        elseif ply.PlayerData.money.bank >= vehicleData.price then 
            ply.Functions.RemoveMoney('bank', vehicleData.price, "vehicle-rentail-bail") 
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('QBCore:Notify', src, 'You have paid the deposit of $'..vehicleData.price..' via your bank', 'success', 3500)
            TriggerClientEvent('qb-vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        else
            TriggerClientEvent('QBCore:Notify', src, 'You do not have enough money.', 'error', 3500)
        end
        return
    end
    TriggerClientEvent('QBCore:Notify', src, 'You got back your deposit of $'..vehicleData.price..' for returning rental.', 'success', 3500)
    ply.Functions.AddMoney('cash', vehicleData.price, "vehicle-rentail-bail")
    RentedVehicles[plyCid] = nil
end)




