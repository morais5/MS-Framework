QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterNetEvent('qb-policealerts:server:AddPoliceAlert')
AddEventHandler('qb-policealerts:server:AddPoliceAlert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('qb-policealerts:client:AddPoliceAlert', -1, data, forBoth)
end)