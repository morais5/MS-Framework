MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

RegisterServerEvent('ms-multicharacter:server:disconnect')
AddEventHandler('ms-multicharacter:server:disconnect', function()
    local src = source

    DropPlayer(src, "Você se desconectou do Morais Scripts Roleplay")
end)

RegisterServerEvent('ms-multicharacter:server:loadUserData')
AddEventHandler('ms-multicharacter:server:loadUserData', function(cData)
    local src = source
    if MSCore.Player.Login(src, cData.citizenid) then
        print('^2[ms-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') was successful!')
        MSCore.Commands.Refresh(src)
        loadHouseData()
		--TriggerEvent('MSCore:Server:OnPlayerLoaded')-
        --TriggerClientEvent('MSCore:Client:OnPlayerLoaded', src)
        
        TriggerClientEvent('apartments:client:setupSpawnUI', src, cData)
        TriggerEvent("ms-log:server:sendLog", cData.citizenid, "characterloaded", {})
        TriggerEvent("ms-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..cData.citizenid.." | "..src..") loaded..")
	end
end)

RegisterServerEvent('ms-multicharacter:server:createCharacter')
AddEventHandler('ms-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    --MSCore.Player.CreateCharacter(src, data)
    if MSCore.Player.Login(src, false, newData) then
        print('^2[ms-core]^7 '..GetPlayerName(src)..' was successful!')
        MSCore.Commands.Refresh(src)
        loadHouseData()

        TriggerClientEvent("ms-multicharacter:client:closeNUI", src)
        TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
        GiveStarterItems(src)
	end
end)

function GiveStarterItems(source)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    for k, v in pairs(MSCore.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "A1-A2-A | AM-B | C1-C-CE"
        end
        Player.Functions.AddItem(v.item, 1, false, info)
    end
end

RegisterServerEvent('ms-multicharacter:server:deleteCharacter')
AddEventHandler('ms-multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    MSCore.Player.DeleteCharacter(src, citizenid)
end)

MSCore.Functions.CreateCallback("ms-multicharacter:server:GetUserCharacters", function(source, cb)
    local steamId = GetPlayerIdentifier(source, 0)

    exports['ghmattimysql']:execute('SELECT * FROM players WHERE steam = @steam', {['@steam'] = steamId}, function(result)
        cb(result)
    end)
end)

MSCore.Functions.CreateCallback("ms-multicharacter:server:GetServerLogs", function(source, cb)
    exports['ghmattimysql']:execute('SELECT * FROM server_logs', function(result)
        cb(result)
    end)
end)

MSCore.Functions.CreateCallback("test:yeet", function(source, cb)
    local steamId = GetPlayerIdentifiers(source)[1]
    local plyChars = {}
    
    exports['ghmattimysql']:execute('SELECT * FROM players WHERE steam = @steam', {['@steam'] = steamId}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)

            table.insert(plyChars, result[i])
        end
        cb(plyChars)
    end)
end)

MSCore.Commands.Add("char", "Give item to a player", {{name="id", help="Player ID"},{name="item", help="Name of the item (not a label)"}, {name="amount", help="Amount of items"}}, false, function(source, args)
    MSCore.Player.Logout(source)
    TriggerClientEvent('ms-multicharacter:client:chooseChar', source)
end, "admin")

MSCore.Commands.Add("closeNUI", "Give item to a player", {{name="id", help="Player ID"},{name="item", help="Name of the item (not a label)"}, {name="amount", help="Amount of items"}}, false, function(source, args)
    TriggerClientEvent('ms-multicharacter:client:closeNUI', source)
end)

MSCore.Functions.CreateCallback("ms-multicharacter:server:getSkin", function(source, cb, cid)
    local src = source

    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `playerskins` WHERE `citizenid` = '"..cid.."' AND `active` = 1", function(result)
        if result[1] ~= nil then
            cb(result[1].model, result[1].skin)
        else
            cb(nil)
        end
    end)
end)

function loadHouseData()
    local HouseGarages = {}
    local Houses = {}
	MSCore.Functions.ExecuteSql(false, "SELECT * FROM `houselocations`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Houses[v.name] = {
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
		TriggerClientEvent("ms-houses:client:setHouseConfig", -1, Houses)
	end)
end