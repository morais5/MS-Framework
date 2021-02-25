QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Functions.CreateCallback('qb-tattooshop:GetPlayerTattoos', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

	if Player then
		 exports['ghmattimysql']:execute('SELECT tattoos FROM playerskins WHERE citizenid = @citizenid', {
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

QBCore.Functions.CreateCallback('qb-tattooshop:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local Player = QBCore.Functions.GetPlayer(source)


	if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price)

		table.insert(tattooList, tattoo)

		 exports['ghmattimysql']:execute('UPDATE playerskins SET tattoos = @tattoos WHERE citizenid = @citizenid', {
			['@tattoos'] = json.encode(tattooList),
			['@citizenid'] = Player.PlayerData.citizenid
		})

		TriggerClientEvent('QBCore:Notify', source, "You have bought the " .. tattooName .. " tattoo for $" .. price, 'success')
		cb(true)
	else
		TriggerClientEvent('QBCore:Notify', source, "You do not have enough money for this tattoo", 'success')

		cb(false)
	end
end)

RegisterServerEvent('qb-tattooshop:server:RemoveTattoo')
AddEventHandler('qb-tattooshop:server:RemoveTattoo', function (tattooList)
	local Player = QBCore.Functions.GetPlayer(source)

	exports['ghmattimysql']:execute('UPDATE playerskins SET tattoos = @tattoos WHERE citizenid = @citizenid', {
		['@tattoos'] = json.encode(tattooList),
		['@citizenid'] = Player.PlayerData.citizenid
	})
end)
