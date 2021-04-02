MSCore = nil

TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

RegisterServerEvent("KickForAFK")
AddEventHandler("KickForAFK", function()
	DropPlayer(source, "You got kicked, you were AFK too long.")
end)

MSCore.Functions.CreateCallback('ms-afkkick:server:GetPermissions', function(source, cb)
    local group = MSCore.Functions.GetPermission(source)
    cb(group)
end)