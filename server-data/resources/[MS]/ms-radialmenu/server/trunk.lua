MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

local trunkBusy = {}

RegisterServerEvent('ms-trunk:server:setTrunkBusy')
AddEventHandler('ms-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

MSCore.Functions.CreateCallback('ms-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)

RegisterServerEvent('ms-trunk:server:KidnapTrunk')
AddEventHandler('ms-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('ms-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

MSCore.Commands.Add("getintrunk", "Enter the trunk", {}, false, function(source, args)
    TriggerClientEvent('ms-trunk:client:GetIn', source)
end)

MSCore.Commands.Add("kidnaptrunk", "Enter the trunk", {}, false, function(source, args)
    TriggerClientEvent('ms-trunk:server:KidnapTrunk', source)
end)