MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

RegisterNetEvent('ms-policealerts:server:AddPoliceAlert')
AddEventHandler('ms-policealerts:server:AddPoliceAlert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('ms-policealerts:client:AddPoliceAlert', -1, data, forBoth)
end)