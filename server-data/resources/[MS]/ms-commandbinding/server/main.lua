MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

MSCore.Commands.Add("binds", "Open bind menu", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
	TriggerClientEvent("ms-commandbinding:client:openUI", source)
end)

RegisterServerEvent('ms-commandbinding:server:setKeyMeta')
AddEventHandler('ms-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = MSCore.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)