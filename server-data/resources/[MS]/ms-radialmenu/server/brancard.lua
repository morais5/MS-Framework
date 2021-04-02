RegisterServerEvent('ms-radialmenu:server:RemoveBrancard')
AddEventHandler('ms-radialmenu:server:RemoveBrancard', function(PlayerPos, BrancardObject)
    TriggerClientEvent('ms-radialmenu:client:RemoveBrancardFromArea', -1, PlayerPos, BrancardObject)
end)

RegisterServerEvent('ms-radialmenu:Brancard:BusyCheck')
AddEventHandler('ms-radialmenu:Brancard:BusyCheck', function(id, type)
    local MyId = source
    TriggerClientEvent('ms-radialmenu:Brancard:client:BusyCheck', id, MyId, type)
end)

RegisterServerEvent('ms-radialmenu:server:BusyResult')
AddEventHandler('ms-radialmenu:server:BusyResult', function(IsBusy, OtherId, type)
    TriggerClientEvent('ms-radialmenu:client:Result', OtherId, IsBusy, type)
end)