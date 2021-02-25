QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
Citizen.CreateThread(function()
	local HouseGarages = {}
	QBCore.Functions.ExecuteSql(false, "SELECT * FROM `houselocations`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Config.Houses[v.name] = {
					coords = json.decode(v.coords),
					owned = v.owned,
					price = v.price,
					locked = true,
					adress = v.label, 
					tier = v.tier,
					garage = garage,
					decorations = {},
				}
				HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("qb-garages:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

QBCore.Functions.CreateCallback('qb-spawn:server:getOwnedHouses', function(source, cb, cid)
	if cid ~= nil then
		QBCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_houses` WHERE `citizenid` = "'..cid..'"', function(houses)
			if houses[1] ~= nil then
				cb(houses)
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)

-- QBCore.Commands.Add("testloc", "Een race stoppen als creator.", {}, false, function(source, args)
-- 	local src = source
-- 	local Player = QBCore.Functions.GetPlayer(src)
-- 	TriggerClientEvent('qb-spawn:client:setupSpawns', src, Player, false, {})
-- 	TriggerClientEvent('qb-spawn:client:openUI', src, true)
-- end)