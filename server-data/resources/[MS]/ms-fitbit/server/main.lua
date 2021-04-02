MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

MSCore.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent('ms-fitbit:use', source)
  end)

RegisterServerEvent('ms-fitbit:server:setValue')
AddEventHandler('ms-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = MSCore.Functions.GetPlayer(src)
    local fitbitData = {}

    if type == "thirst" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = value,
            food = currentMeta.food
        }
    elseif type == "food" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = currentMeta.thirst,
            food = value
        }
    end

    ply.Functions.SetMetaData('fitbit', fitbitData)
end)

MSCore.Functions.CreateCallback('ms-fitbit:server:HasFitbit', function(source, cb)
    local Ply = MSCore.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)