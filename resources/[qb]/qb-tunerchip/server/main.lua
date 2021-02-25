QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local tunedVehicles = {}
local VehicleNitrous = {}

QBCore.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local src = source

    TriggerClientEvent('qb-tunerchip:client:openChip', src)
end)

RegisterServerEvent('qb-tunerchip:server:TuneStatus')
AddEventHandler('qb-tunerchip:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

QBCore.Functions.CreateCallback('qb-tunerchip:server:HasChip', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local Chip = Ply.Functions.GetItemByName('tunerlaptop')

    if Chip ~= nil then
        cb(true)
    else
        DropPlayer(src, 'Isso não é o que você precisa fazer certo?...')
        cb(true)
    end
end)

QBCore.Functions.CreateCallback('qb-tunerchip:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)

QBCore.Functions.CreateUseableItem("nitrous", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

    TriggerClientEvent('smallresource:client:LoadNitrous', source)
end)

RegisterServerEvent('nitrous:server:LoadNitrous')
AddEventHandler('nitrous:server:LoadNitrous', function(Plate)
    VehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    TriggerClientEvent('nitrous:client:LoadNitrous', -1, Plate)
end)

RegisterServerEvent('nitrous:server:SyncFlames')
AddEventHandler('nitrous:server:SyncFlames', function(netId)
    TriggerClientEvent('nitrous:client:SyncFlames', -1, netId, source)
end)

RegisterServerEvent('nitrous:server:UnloadNitrous')
AddEventHandler('nitrous:server:UnloadNitrous', function(Plate)
    VehicleNitrous[Plate] = nil
    TriggerClientEvent('nitrous:client:UnloadNitrous', -1, Plate)
end)
RegisterServerEvent('nitrous:server:UpdateNitroLevel')
AddEventHandler('nitrous:server:UpdateNitroLevel', function(Plate, level)
    VehicleNitrous[Plate].level = level
    TriggerClientEvent('nitrous:client:UpdateNitroLevel', -1, Plate, level)
end)

RegisterServerEvent('nitrous:server:StopSync')
AddEventHandler('nitrous:server:StopSync', function(plate)
    TriggerClientEvent('nitrous:client:StopSync', -1, plate)
end)