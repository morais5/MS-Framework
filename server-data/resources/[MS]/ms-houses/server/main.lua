
MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

Citizen.CreateThread(function()
	local HouseGarages = {}
	MSCore.Functions.ExecuteSql(false, "SELECT * FROM `houselocations`", function(result)
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
		TriggerClientEvent("ms-garages:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("ms-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}

RegisterServerEvent('ms-houses:server:setHouses')
AddEventHandler('ms-houses:server:setHouses', function()
	local src = source
	TriggerClientEvent("ms-houses:client:setHouseConfig", src, Config.Houses)
end)

RegisterServerEvent('ms-houses:server:addNewHouse')
AddEventHandler('ms-houses:server:addNewHouse', function(street, coords, price, tier)
	local src = source
	local street = street:gsub("%'", "")
	local price = tonumber(price)
	local tier = tonumber(tier)
	local houseCount = GetHouseStreetCount(street)
	local name = street:lower() .. tostring(houseCount)
	local label = street .. " " .. tostring(houseCount)
	MSCore.Functions.ExecuteSql(false, "INSERT INTO `houselocations` (`name`, `label`, `coords`, `owned`, `price`, `tier`) VALUES ('"..name.."', '"..label.."', '"..json.encode(coords).."', 0,"..price..", "..tier..")")
	Config.Houses[name] = {
		coords = coords,
		owned = false,
		price = price,
		locked = true,
		adress = label, 
		tier = tier,
		garage = {},
		decorations = {},
	}
	TriggerClientEvent("ms-houses:client:setHouseConfig", -1, Config.Houses)
	TriggerClientEvent('MSCore:Notify', src, "You have added a house: "..label)
end)

RegisterServerEvent('ms-houses:server:addGarage')
AddEventHandler('ms-houses:server:addGarage', function(house, coords)
	local src = source
	MSCore.Functions.ExecuteSql(false, "UPDATE `houselocations` SET `garage` = '"..json.encode(coords).."' WHERE `name` = '"..house.."'")
	local garageInfo = {
		label = Config.Houses[house].adress,
		takeVehicle = coords,
	}
	TriggerClientEvent("ms-garages:client:addHouseGarage", -1, house, garageInfo)
	TriggerClientEvent('MSCore:Notify', src, "You have added a garage: "..garageInfo.label)
end)

RegisterServerEvent('ms-houses:server:viewHouse')
AddEventHandler('ms-houses:server:viewHouse', function(house)
	local src     		= source
	local pData 		= MSCore.Functions.GetPlayer(src)

	local houseprice   	= Config.Houses[house].price
	local brokerfee 	= (houseprice / 100 * 5)
	local bankfee 		= (houseprice / 100 * 10) 
	local taxes 		= (houseprice / 100 * 6)

	TriggerClientEvent('ms-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('ms-houses:server:buyHouse')
AddEventHandler('ms-houses:server:buyHouse', function(house)
	local src     	= source
	local pData 	= MSCore.Functions.GetPlayer(src)
	local price   	= Config.Houses[house].price
	local HousePrice = math.ceil(price * 1.21)
	local bankBalance = pData.PlayerData.money["bank"]

	if (bankBalance >= HousePrice) then
		MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_houses` (`house`, `identifier`, `citizenid`, `keyholders`) VALUES ('"..house.."', '"..pData.PlayerData.steam.."', '"..pData.PlayerData.citizenid.."', '"..json.encode(keyyeet).."')")
		houseowneridentifier[house] = pData.PlayerData.steam
		houseownercid[house] = pData.PlayerData.citizenid
		housekeyholders[house] = {
			[1] = pData.PlayerData.citizenid
		}
		MSCore.Functions.ExecuteSql(true, "UPDATE `houselocations` SET `owned` = 1 WHERE `name` = '"..house.."'")
		TriggerClientEvent('ms-houses:client:SetClosestHouse', src)
		pData.Functions.RemoveMoney('bank', HousePrice, "bought-house") -- 21% Extra house costs
	else
		TriggerClientEvent('MSCore:Notify', source, "You dont have enough money..", "error")
	end
end)

RegisterServerEvent('ms-houses:server:lockHouse')
AddEventHandler('ms-houses:server:lockHouse', function(bool, house)
	TriggerClientEvent('ms-houses:client:lockHouse', -1, bool, house)
end)

RegisterServerEvent('ms-houses:server:SetRamState')
AddEventHandler('ms-houses:server:SetRamState', function(bool, house)
	Config.Houses[house].IsRaming = bool
	TriggerClientEvent('ms-houses:server:SetRamState', -1, bool, house)
end)

--------------------------------------------------------------

--------------------------------------------------------------

MSCore.Functions.CreateCallback('ms-houses:server:hasKey', function(source, cb, house)
	local src = source
	local Player = MSCore.Functions.GetPlayer(src)
	local retval = false
	if Player ~= nil then 
		local identifier = Player.PlayerData.steam
		local CharId = Player.PlayerData.citizenid
		if hasKey(identifier, CharId, house) then
			retval = true
		elseif Player.PlayerData.job.name == "realestate" then
			retval = true
		else
			retval = false
		end
	end
	
	cb(retval)
end)

MSCore.Functions.CreateCallback('ms-houses:server:isOwned', function(source, cb, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		cb(true)
	else
		cb(false)
	end
end)

MSCore.Functions.CreateCallback('ms-houses:server:getHouseOwner', function(source, cb, house)
	cb(houseownercid[house])
end)

MSCore.Functions.CreateCallback('ms-houses:server:getHouseKeyHolders', function(source, cb, house)
	local retval = {}
	local Player = MSCore.Functions.GetPlayer(source)
	if housekeyholders[house] ~= nil then 
		for i = 1, #housekeyholders[house], 1 do
			if Player.PlayerData.citizenid ~= housekeyholders[house][i] then
				MSCore.Functions.ExecuteSql(false, "SELECT `charinfo` FROM `players` WHERE `citizenid` = '"..housekeyholders[house][i].."'", function(result)
					if result[1] ~= nil then 
						local charinfo = json.decode(result[1].charinfo)
						table.insert(retval, {
							firstname = charinfo.firstname,
							lastname = charinfo.lastname,
							citizenid = housekeyholders[house][i],
						})
					end
					cb(retval)
				end)
			end
		end
	else
		cb(nil)
	end
end)

function hasKey(identifier, cid, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
			return true
		else
			if housekeyholders[house] ~= nil then 
				for i = 1, #housekeyholders[house], 1 do
					if housekeyholders[house][i] == cid then
						return true
					end
				end
			end
		end
	end
	return false
end

function getOfflinePlayerData(citizenid)
	exports['ghmattimysql']:execute("SELECT `charinfo` FROM `players` WHERE `citizenid` = '"..citizenid.."'", function(result)
		Citizen.Wait(100)
		if result[1] ~= nil then 
			local charinfo = json.decode(result[1].charinfo)
			return charinfo
		else
			return nil
		end
	end)
end

RegisterServerEvent('ms-houses:server:giveKey')
AddEventHandler('ms-houses:server:giveKey', function(house, target)
	local pData = MSCore.Functions.GetPlayer(target)

	table.insert(housekeyholders[house], pData.PlayerData.citizenid)
	MSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
end)

RegisterServerEvent('ms-houses:server:removeHouseKey')
AddEventHandler('ms-houses:server:removeHouseKey', function(house, citizenData)
	local src = source
	local newHolders = {}
	if housekeyholders[house] ~= nil then 
		for k, v in pairs(housekeyholders[house]) do
			if housekeyholders[house][k] ~= citizenData.citizenid then
				table.insert(newHolders, housekeyholders[house][k])
			end
		end
	end
	housekeyholders[house] = newHolders
	TriggerClientEvent('MSCore:Notify', src, citizenData.firstname .. " " .. citizenData.lastname .. "'S keys have been removed..", 'error', 3500)
	MSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
end)

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

local housesLoaded = false

Citizen.CreateThread(function()
	while true do
		if not housesLoaded then
			exports['ghmattimysql']:execute('SELECT * FROM player_houses', function(houses)
				if houses ~= nil then
					for _,house in pairs(houses) do
						houseowneridentifier[house.house] = house.identifier
						houseownercid[house.house] = house.citizenid
						housekeyholders[house.house] = json.decode(house.keyholders)
					end
				end
			end)
			housesLoaded = true
		end
		Citizen.Wait(7)
	end
end)

RegisterServerEvent('ms-houses:server:OpenDoor')
AddEventHandler('ms-houses:server:OpenDoor', function(target, house)
    local src = source
    local OtherPlayer = MSCore.Functions.GetPlayer(target)
    if OtherPlayer ~= nil then
        TriggerClientEvent('ms-houses:client:SpawnInApartment', OtherPlayer.PlayerData.source, house)
    end
end)

RegisterServerEvent('ms-houses:server:RingDoor')
AddEventHandler('ms-houses:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('ms-houses:client:RingDoor', -1, src, house)
end)

RegisterServerEvent('ms-houses:server:savedecorations')
AddEventHandler('ms-houses:server:savedecorations', function(house, decorations)
	local src = source
	MSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `decorations` = '"..json.encode(decorations).."' WHERE `house` = '"..house.."'")
	TriggerClientEvent("ms-houses:server:sethousedecorations", -1, house, decorations)
end)

MSCore.Functions.CreateCallback('ms-houses:server:getHouseDecorations', function(source, cb, house)
	local retval = nil
	MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			if result[1].decorations ~= nil then
				retval = json.decode(result[1].decorations)
			end
		end
		cb(retval)
	end)
end)

MSCore.Functions.CreateCallback('ms-houses:server:getHouseLocations', function(source, cb, house)
	local retval = nil
	MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
		cb(retval)
	end)
end)

MSCore.Functions.CreateCallback('ms-houses:server:getHouseKeys', function(source, cb)
	local src = source
	local pData = MSCore.Functions.GetPlayer(src)
	local cid = pData.PlayerData.citizenid
end)

function mysplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

MSCore.Functions.CreateCallback('ms-houses:server:getOwnedHouses', function(source, cb)
	local src = source
	local pData = MSCore.Functions.GetPlayer(src)

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_houses WHERE identifier = @identifier AND citizenid = @citizenid', {['@identifier'] = pData.PlayerData.steam, ['@citizenid'] = pData.PlayerData.citizenid}, function(houses)
			local ownedHouses = {}

			for i=1, #houses, 1 do
				table.insert(ownedHouses, houses[i].house)
			end

			if houses ~= nil then
				cb(ownedHouses)
			else
				cb(nil)
			end
		end)
	end
end)

MSCore.Functions.CreateCallback('ms-houses:server:getSavedOutfits', function(source, cb)
	local src = source
	local pData = MSCore.Functions.GetPlayer(src)

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_outfits WHERE citizenid = @citizenid', {['@citizenid'] = pData.PlayerData.citizenid}, function(result)
			if result[1] ~= nil then
				cb(result)
			else
				cb(nil)
			end
		end)
	end
end)

MSCore.Commands.Add("decorate", "Decoreer je huisie :)", {}, false, function(source, args)
	TriggerClientEvent("ms-houses:client:decorate", source)
end)

function GetHouseStreetCount(street)
	local count = 1
	MSCore.Functions.ExecuteSql(true, "SELECT * FROM `houselocations` WHERE `name` LIKE '%"..street.."%'", function(result)
		if result[1] ~= nil then 
			for i = 1, #result, 1 do
				count = count + 1
			end
		end
		return count
	end)
	return count
end

RegisterServerEvent('ms-houses:server:LogoutLocation')
AddEventHandler('ms-houses:server:LogoutLocation', function()
	local src = source
	local Player = MSCore.Functions.GetPlayer(src)
	local MyItems = Player.PlayerData.items
	MSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `inventory` = '"..MSCore.EscapeSqli(json.encode(MyItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
	MSCore.Player.Logout(src)
    TriggerClientEvent('ms-multicharacter:client:chooseChar', src)
end)

RegisterServerEvent('ms-houses:server:giveHouseKey')
AddEventHandler('ms-houses:server:giveHouseKey', function(target, house)
	local src = source
	local tPlayer = MSCore.Functions.GetPlayer(target)
	
	if tPlayer ~= nil then
		if housekeyholders[house] ~= nil then
			for _, cid in pairs(housekeyholders[house]) do
				if cid == tPlayer.PlayerData.citizenid then
					TriggerClientEvent('MSCore:Notify', src, 'This person already has the keys of the house!', 'error', 3500)
					return
				end
			end		
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
			MSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
			TriggerClientEvent('ms-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('MSCore:Notify', tPlayer.PlayerData.source, 'You have the keys of '..Config.Houses[house].adress..' recieved!', 'success', 2500)
		else
			local sourceTarget = MSCore.Functions.GetPlayer(src)
			housekeyholders[house] = {
				[1] = sourceTarget.PlayerData.citizenid
			}
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
			MSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
			TriggerClientEvent('ms-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('MSCore:Notify', tPlayer.PlayerData.source, 'You have the keys of '..Config.Houses[house].adress..' recieved!', 'success', 2500)
		end
	else
		TriggerClientEvent('MSCore:Notify', src, 'Something went wrond try again!', 'error', 2500)
	end
end)

RegisterServerEvent('test:test')
AddEventHandler('test:test', function(msg)
	print(msg)
end)

RegisterServerEvent('ms-houses:server:setLocation')
AddEventHandler('ms-houses:server:setLocation', function(coords, house, type)
	local src = source
	local Player = MSCore.Functions.GetPlayer(src)

	if type == 1 then
		MSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `stash` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 2 then
		MSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `outfit` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 3 then
		MSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `logout` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	end

	TriggerClientEvent('ms-houses:client:refreshLocations', -1, house, json.encode(coords), type)
end)

MSCore.Commands.Add("createhouse", "Create a house as a real estate agent", {{name="price", help="Price of the house"},{name="tier", help="Name of the item(no label)"}}, true, function(source, args)
	local Player = MSCore.Functions.GetPlayer(source)
	local price = tonumber(args[1])
	local tier = tonumber(args[2])
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("ms-houses:client:createHouses", source, price, tier)
	end
end)

MSCore.Commands.Add("addgarage", "Add garage to the closest house", {}, false, function(source, args)
	local Player = MSCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("ms-houses:client:addGarage", source)
	end
end)

RegisterServerEvent('ms-houses:server:SetInsideMeta')
AddEventHandler('ms-houses:server:SetInsideMeta', function(insideId, bool)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local insideMeta = Player.PlayerData.metadata["inside"]

    if bool then
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = insideId

        Player.Functions.SetMetaData("inside", insideMeta)
    else
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = nil

        Player.Functions.SetMetaData("inside", insideMeta)
    end
end)

MSCore.Functions.CreateCallback('ms-phone:server:GetPlayerHouses', function(source, cb)
	local src = source
	local Player = MSCore.Functions.GetPlayer(src)
	local MyHouses = {}
	local keyholders = {}

	MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				v.keyholders = json.decode(v.keyholders)
				if v.keyholders ~= nil and next(v.keyholders) then
					for f, data in pairs(v.keyholders) do
						MSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..data.."'", function(keyholderdata)
							if keyholderdata[1] ~= nil then
								keyholders[f] = keyholderdata[1]
							end
						end)
					end
				else
					keyholders[1] = Player.PlayerData
				end

				table.insert(MyHouses, {
					name = v.house,
					keyholders = keyholders,
					owner = v.citizenid,
					price = Config.Houses[v.house].price,
					label = Config.Houses[v.house].adress,
					tier = Config.Houses[v.house].tier,
					garage = Config.Houses[v.house].garage,
				})
			end
				
			cb(MyHouses)
		end
	end)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

MSCore.Functions.CreateCallback('ms-phone:server:MeosGetPlayerHouses', function(source, cb, input)
	local src = source
	if input ~= nil then
		local search = escape_sqli(input)
		local searchData = {}

		MSCore.Functions.ExecuteSql(false, 'SELECT * FROM `players` WHERE `citizenid` = "'..search..'" OR `charinfo` LIKE "%'..search..'%"', function(result)
			if result[1] ~= nil then
				MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..result[1].citizenid.."'", function(houses)
					if houses[1] ~= nil then
						for k, v in pairs(houses) do
							table.insert(searchData, {
								name = v.house,
								keyholders = keyholders,
								owner = v.citizenid,
								price = Config.Houses[v.house].price,
								label = Config.Houses[v.house].adress,
								tier = Config.Houses[v.house].tier,
								garage = Config.Houses[v.house].garage,
								charinfo = json.decode(result[1].charinfo),
								coords = {
									x = Config.Houses[v.house].coords.enter.x,
									y = Config.Houses[v.house].coords.enter.y,
									z = Config.Houses[v.house].coords.enter.z,
								}
							})
						end

						cb(searchData)
					end
				end)
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)

MSCore.Functions.CreateUseableItem("police_stormram", function(source, item)
	local Player = MSCore.Functions.GetPlayer(source)

	if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
		TriggerClientEvent("ms-houses:client:HomeInvasion", source)
	else
		TriggerClientEvent('MSCore:Notify', source, "This is only possible for emergency services!", "error")
	end
end)

RegisterServerEvent('ms-houses:server:SetHouseRammed')
AddEventHandler('ms-houses:server:SetHouseRammed', function(bool, house)
	Config.Houses[house].IsRammed = bool
	TriggerClientEvent('ms-houses:client:SetHouseRammed', -1, bool, house)
end)

MSCore.Commands.Add("enter", "Betreed huis", {}, false, function(source, args)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
 
    TriggerClientEvent('ms-houses:client:EnterHouse', src)
end)

MSCore.Commands.Add("ring", "Ring the doorbell at home", {}, false, function(source, args)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
 
    TriggerClientEvent('ms-houses:client:RequestRing', src)
end)