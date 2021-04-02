RegisterServerEvent('json:dataStructure')
AddEventHandler('json:dataStructure', function(data)
    print(json.encode(data))
end)

RegisterServerEvent('ms-radialmenu:trunk:server:Door')
AddEventHandler('ms-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('ms-radialmenu:trunk:client:Door', -1, plate, door, open)
end)