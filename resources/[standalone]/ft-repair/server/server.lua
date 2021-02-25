QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("testrepair", "for testing the script", {}, false, function(source, args)
	local _player = QBCore.Functions.GetPlayer(source)
	if _player.PlayerData.job.name == "mechanic" then 
	TriggerClientEvent('ft-repair:client:triggerMenu', source)
	end
end)