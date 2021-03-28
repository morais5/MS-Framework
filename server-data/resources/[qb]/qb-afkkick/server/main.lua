QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("KickForAFK")
AddEventHandler("KickForAFK", function()
	DropPlayer(source, "You got kicked, you were AFK too long.")
end)

QBCore.Functions.CreateCallback('qb-afkkick:server:GetPermissions', function(source, cb)
    local group = QBCore.Functions.GetPermission(source)
    cb(group)
end)