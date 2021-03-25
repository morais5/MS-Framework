QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Commands.Add("eventmovie", "", {{name="toggle", help="Yes or No"}}, true, function(source, args)
	if args[1] == "Yes" then
		TriggerClientEvent("qb-event:client:EventMovie", -1)
		Wait(5000)
		TriggerEvent('qb-weathersync:server:setTime', 01, 00)
		TriggerEvent('qb-weathersync:server:setWeather', "thunder")
		exports['qb-weathersync']:ToggleBlackout()
		exports['qb-weathersync']:FreezeElement('time')
	elseif args[1] == "No" then
		TriggerEvent('qb-weathersync:server:setTime', 12, 00)
		TriggerEvent('qb-weathersync:server:setWeather', "extrasunny")
		exports['qb-weathersync']:ToggleBlackout()
		exports['qb-weathersync']:FreezeElement('time')
	end
end, 'admin')