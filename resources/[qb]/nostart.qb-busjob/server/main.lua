

AllowedIdentifiers = {
    ["steam:110000100da693a"] = true, -- MP - Stefan
	["steam:110000133ae202e"] = true, -- ADMIN - Mark2
	["steam:11000010ba7977c"] = true, -- ADMIN - Quimey :P	
	["steam:110000102fca591"] = true, -- ADMIN - Mark
	["steam:11000010877eef9"] = true, -- ADMIN - Robin
	["steam:11000010774b0a7"] = true,	-- DEV - Onno 
	["steam:1100001096efa6b"] = true, -- DEV - Koen
	["steam:110000105b4cde7"] = true, -- Mod Kevin
}


TriggerEvent('esx_phone:registerNumber', 'bus', "Someone needs a bus", true, true)


RegisterServerEvent('Job_Bus:Givelicense')
AddEventHandler('Job_Bus:Givelicense', function(id)
	
	if (AllowedIdentifiers[tostring(GetPlayerIdentifiers(source)[1])] == true) then
		local xPlayer = JobsClientCore.ESX.GetPlayerFromId(id)
		xPlayer.removeMoney(1000)
		TriggerEvent('esx_license:addLicense', id, 'drive_bus', function() end)
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You gave ~g~"..xPlayer.name.." ~s~a bus driver license!")
		TriggerClientEvent('JobsCoreO:DisplayNotification', id, "You got your ~g~bus driver license ~s~!")
	else
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "~o~What do you think?!")
	end
end)

RegisterServerEvent('Job_Bus:Takelicense')
AddEventHandler('Job_Bus:Takelicense', function(id)
	if (AllowedIdentifiers[tostring(GetPlayerIdentifiers(source)[1])] == true) then
		local xPlayer = JobsClientCore.ESX.GetPlayerFromId(id)
		TriggerEvent('esx_license:removeLicense', id, 'bus', function() end)
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You have took ~g~"..xPlayer.name.." ~s~his bus driver license!")
		TriggerClientEvent('JobsCoreO:DisplayNotification', id, "Your ~g~bus driving license ~s~ has been taken!")
	else
		TriggerClientEvent('JobsCoreO:DisplayNotification', source, "~o~What do you think?!")
	end
end)


RegisterServerEvent('Job_Bus:BetaalBorg')
AddEventHandler('Job_Bus:BetaalBorg', function()
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(1000)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You paid ~g~€ 1000~s~ deposit!")
end)

RegisterServerEvent('Job_Bus:GetBorg')
AddEventHandler('Job_Bus:GetBorg', function()
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	xPlayer.addMoney(1000)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You have gotten your ~g~€ 1000~s~ deposit back!")
end)

RegisterServerEvent('Job_Bus:BetaalPassenger')
AddEventHandler('Job_Bus:BetaalPassenger', function(amount)
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	local GiveMoney = amount
	xPlayer.addMoney(GiveMoney)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "Your passenger has paid ~b~€ "..GiveMoney.." ~s~with their ~g~OV~s~.")
end)

RegisterServerEvent('Job_Bus:eindstop')
AddEventHandler('Job_Bus:eindstop', function(amount)
	local xPlayer = JobsClientCore.ESX.GetPlayerFromId(source)
	local GiveMoney = amount
	xPlayer.addMoney(GiveMoney)
	TriggerClientEvent('JobsCoreO:DisplayNotification', source, "You received a bonus of ~b~€ "..GiveMoney.."~s~.")
end)











