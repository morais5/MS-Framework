local CurrentDivingArea = math.random(1, #MSCoreDiving.Locations)

MSCore.Functions.CreateCallback('ms-diving:server:GetDivingConfig', function(source, cb)
    cb(MSCoreDiving.Locations, CurrentDivingArea)
end)

RegisterServerEvent('ms-diving:server:TakeCoral')
AddEventHandler('ms-diving:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local CoralType = math.random(1, #MSCoreDiving.CoralTypes)
    local Amount = math.random(1, MSCoreDiving.CoralTypes[CoralType].maxAmount)
    local ItemData = MSCore.Shared.Items[MSCoreDiving.CoralTypes[CoralType].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
            Citizen.Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
    end

    if (MSCoreDiving.Locations[Area].TotalCoral - 1) == 0 then
        for k, v in pairs(MSCoreDiving.Locations[CurrentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        MSCoreDiving.Locations[CurrentDivingArea].TotalCoral = MSCoreDiving.Locations[CurrentDivingArea].DefaultCoral

        local newLocation = math.random(1, #MSCoreDiving.Locations)
        while (newLocation == CurrentDivingArea) do
            Citizen.Wait(3)
            newLocation = math.random(1, #MSCoreDiving.Locations)
        end
        CurrentDivingArea = newLocation
        
        TriggerClientEvent('ms-diving:client:NewLocations', -1)
    else
        MSCoreDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
        MSCoreDiving.Locations[Area].TotalCoral = MSCoreDiving.Locations[Area].TotalCoral - 1
    end

    TriggerClientEvent('ms-diving:server:UpdateCoral', -1, Area, Coral, Bool)
end)

RegisterServerEvent('ms-diving:server:RemoveGear')
AddEventHandler('ms-diving:server:RemoveGear', function()
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items["diving_gear"], "remove")
end)

RegisterServerEvent('ms-diving:server:GiveBackGear')
AddEventHandler('ms-diving:server:GiveBackGear', function()
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items["diving_gear"], "add")
end)