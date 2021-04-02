MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

MSCore.Commands.Add("testrepair", "for testing the script", {}, false, function(source, args)
	local _player = MSCore.Functions.GetPlayer(source)
	if _player.PlayerData.job.name == "mechanic" then 
	TriggerClientEvent('ft-repair:client:triggerMenu', source)
	end
end)