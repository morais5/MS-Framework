MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

MSCore.Functions.CreateUseableItem("printerdocument", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent('ms-printer:client:UseDocument', source, item)
end)