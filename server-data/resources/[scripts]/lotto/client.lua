QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('lotto:usar')
AddEventHandler('lotto:usar', function()
	SetNuiFocus( true, true )
	SendNUIMessage({
		showPlayerMenu = true
	})
end)

RegisterNetEvent('lotto:showprice')
AddEventHandler('lotto:showprice', function(money)
	SetNuiFocus( true, true )
	SendNUIMessage({
		showPlayerMenu = nil,
		prize = money
	})
end)

RegisterCommand("helpnui", function(source, args, rawCommand)
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = false
	})

end)




RegisterNetEvent('lotto:addcalc')
AddEventHandler('lotto:addcalc', function()
	item = true
end)

RegisterNetEvent('lotto:removecalc')
AddEventHandler('lotto:removecalc', function()
	item = false
end)
