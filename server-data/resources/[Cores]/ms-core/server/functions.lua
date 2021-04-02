MSCore.Functions = {}

MSCore.Functions.ExecuteSql = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['ghmattimysql']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

MSCore.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or MSConfig.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

MSCore.Functions.GetSource = function(identifier)
	for src, player in pairs(MSCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

MSCore.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return MSCore.Players[source]
	else
		return MSCore.Players[MSCore.Functions.GetSource(source)]
	end
end

MSCore.Functions.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(MSCore.Players) do
		local cid = citizenid
		if MSCore.Players[src].PlayerData.citizenid == cid then
			return MSCore.Players[src]
		end
	end
	return nil
end

MSCore.Functions.GetPlayerByPhone = function(number)
	for src, player in pairs(MSCore.Players) do
		local cid = citizenid
		if MSCore.Players[src].PlayerData.charinfo.phone == number then
			return MSCore.Players[src]
		end
	end
	return nil
end

MSCore.Functions.GetPlayers = function()
	local sources = {}
	for k, v in pairs(MSCore.Players) do
		table.insert(sources, k)
	end
	return sources
end

MSCore.Functions.CreateCallback = function(name, cb)
	MSCore.ServerCallbacks[name] = cb
end

MSCore.Functions.TriggerCallback = function(name, source, cb, ...)
	if MSCore.ServerCallbacks[name] ~= nil then
		MSCore.ServerCallbacks[name](source, cb, ...)
	end
end

MSCore.Functions.CreateUseableItem = function(item, cb)
	MSCore.UseableItems[item] = cb
end

MSCore.Functions.CanUseItem = function(item)
	return MSCore.UseableItems[item] ~= nil
end

MSCore.Functions.UseItem = function(source, item)
	MSCore.UseableItems[item.name](source, item)
end

MSCore.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Check our Discord for more information: "..MSCore.Config.Server.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

MSCore.Functions.IsWhitelisted = function(source)
	local identifiers = GetPlayerIdentifiers(source)
	local rtn = false
	if (MSCore.Config.Server.whitelist) then
		MSCore.Functions.ExecuteSql(true, "SELECT * FROM `whitelist` WHERE `"..MSCore.Config.IdentifierType.."` = '".. MSCore.Functions.GetIdentifier(source).."'", function(result)
			local data = result[1]
			if data ~= nil then
				for _, id in pairs(identifiers) do
					if data.steam == id or data.license == id then
						rtn = true
					end
				end
			end
		end)
	else
		rtn = true
	end
	return rtn
end

MSCore.Functions.AddPermission = function(source, permission)
	local Player = MSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		MSCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = {
			steam = GetPlayerIdentifiers(source)[1],
			license = GetPlayerIdentifiers(source)[2],
			permission = permission:lower(),
		}
		MSCore.Functions.ExecuteSql(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		MSCore.Functions.ExecuteSql(true, "INSERT INTO `permissions` (`name`, `steam`, `license`, `permission`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..permission:lower().."')")
		Player.Functions.UpdatePlayerData()
		TriggerClientEvent('MSCore:Client:OnPermissionUpdate', source, permission)
	end
end

MSCore.Functions.RemovePermission = function(source)
	local Player = MSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		MSCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = nil	
		MSCore.Functions.ExecuteSql(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

MSCore.Functions.HasPermission = function(source, permission)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if MSCore.Config.Server.PermissionList[steamid] ~= nil then 
			if MSCore.Config.Server.PermissionList[steamid].steam == steamid and MSCore.Config.Server.PermissionList[steamid].license == licenseid then
				if MSCore.Config.Server.PermissionList[steamid].permission == permission or MSCore.Config.Server.PermissionList[steamid].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

MSCore.Functions.GetPermission = function(source)
	local retval = "user"
	Player = MSCore.Functions.GetPlayer(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	if Player ~= nil then
		if MSCore.Config.Server.PermissionList[Player.PlayerData.steam] ~= nil then 
			if MSCore.Config.Server.PermissionList[Player.PlayerData.steam].steam == steamid and MSCore.Config.Server.PermissionList[Player.PlayerData.steam].license == licenseid then
				retval = MSCore.Config.Server.PermissionList[Player.PlayerData.steam].permission
			end
		end
	end
	return retval
end

MSCore.Functions.IsOptin = function(source)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	if MSCore.Functions.HasPermission(source, "admin") then
		retval = MSCore.Config.Server.PermissionList[steamid].optin
	end
	return retval
end

MSCore.Functions.ToggleOptin = function(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	if MSCore.Functions.HasPermission(source, "admin") then
		MSCore.Config.Server.PermissionList[steamid].optin = not MSCore.Config.Server.PermissionList[steamid].optin
	end
end

MSCore.Functions.IsPlayerBanned = function (source)
	local retval = false
	local message = ""
	MSCore.Functions.ExecuteSql(true, "SELECT * FROM `bans` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."' OR `license` = '"..GetPlayerIdentifiers(source)[2].."' OR `ip` = '"..GetPlayerIdentifiers(source)[3].."'", function(result)
		if result[1] ~= nil then 
			if os.time() < result[1].expire then
				retval = true
				local timeTable = os.date("*t", tonumber(result[1].expire))
				message = "You were banned from the server:\n"..result[1].reason.."\nFalta : "..timeTable.day.. "/" .. timeTable.month .. "/" .. timeTable.year .. " " .. timeTable.hour.. ":" .. timeTable.min .. "\n"
			else
				MSCore.Functions.ExecuteSql(true, "DELETE FROM `bans` WHERE `id` = "..result[1].id)
			end
		end
	end)
	return retval, message
end

