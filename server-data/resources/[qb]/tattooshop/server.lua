QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-----------------Callback to ensure that the tattoos remain visible throughout the playtime starts on player load in
QBCore.Functions.CreateCallback('SmallTattoos:GetPlayerTattoos', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player then
		MySQL.Async.fetchAll('SELECT tattoos FROM character_current WHERE citizenid = @citizenid', {
			['@citizenid'] = Player.PlayerData.citizenid
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)
-----------------callback for purchasing the tattoos
QBCore.Functions.CreateCallback('SmallTattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player.PlayerData.money.cash >= price then
		Player.Functions.RemoveMoney('cash', price)
		
		table.insert(tattooList, tattoo)

		MySQL.Async.fetchAll( 'UPDATE character_current SET tattoos = @tattoos WHERE citizenid = @citizenid', {
			['@tattoos'] = json.encode(tattooList),
			['@citizenid'] = Player.PlayerData.citizenid
		})
		----------nice to see this prints server sided in the console when a tattoo is bought
		print("You have bought the ~y~" .. tattooName .. "~s~ tattoo for ~g~$" .. price)
		cb(true)


		TriggerClientEvent('Apply:Tattoo', source, tattoo, tattooList)
    end
end)
-----------------removes tattoos from the ped
RegisterServerEvent('SmallTattoos:RemoveTattoo')
AddEventHandler('SmallTattoos:RemoveTattoo', function (tattooList)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	MySQL.Async.fetchAll( 'UPDATE character_current SET tattoos = @tattoos WHERE citizenid = @citizenid', {
		['@tattoos'] = json.encode(tattooList),
		['@citizenid'] = Player.PlayerData.citizenid
	})
end)

----------place this event wherever you change your clothing so it auto readds the tattoos to your player in example the clothing store when exiting or outfits
RegisterServerEvent('Select:Tattoos')
AddEventHandler('Select:Tattoos', function() 

	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	MySQL.Async.fetchAll( 'SELECT tattoos FROM character_current WHERE citizenid = @citizenid', {
		['@citizenid'] = Player.PlayerData.citizenid
	}, function(result)
		if result[1].tattoos ~= nil then
		if result[1].tattoos then
			tats = result[1].tattoos
			TriggerClientEvent('Apply:Tattoo', src, tats)
		else
			TriggerEvent('remover:all')
			TriggerClientEvent('remover:tudo', src)
		end
		Citizen.Wait(1000)
		print("doesnt have tattoos")
		end
	end)

end)
------------Removes tattoos when you dont want them anymore
RegisterServerEvent('remover:all')
AddEventHandler('remover:all', function() 
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player then
		MySQL.Async.execute( 'UPDATE character_current SET tattoos = @tattoos WHERE citizenid = @citizenid', {
			['@tattoos'] = 0,
			['@citizenid'] = Player.PlayerData.citizenid
		})
	end
end)

