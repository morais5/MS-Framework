MSCore.Commands = {}
MSCore.Commands.List = {}

MSCore.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	MSCore.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

MSCore.Commands.Refresh = function(source)
	local Player = MSCore.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(MSCore.Commands.List) do
			if MSCore.Functions.HasPermission(source, "god") or MSCore.Functions.HasPermission(source, MSCore.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

MSCore.Commands.Add("tp", "Teleport to a player or location", {{name="id/x", help="ID of a player or X position"}, {name="y", help="Y position"}, {name="z", help="Z position"}}, false, function(source, args)
    if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
        -- tp to player
        local Player = MSCore.Functions.GetPlayer(tonumber(args[1]))
        if Player ~= nil then
            TriggerClientEvent('MSCore:Command:TeleportToPlayer', source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
        end
    else
        -- tp to location
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            TriggerClientEvent('MSCore:Command:TeleportToCoords', source, x, y, z)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Not every argument is filled in (x, y, z)")
        end
    end
end, "admin") 

MSCore.Commands.Add("giveperms", "Grant permissions to someone (god/admin)", {{name="id", help="ID of player"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = MSCore.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		MSCore.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The player is not online!")	
	end
end, "god")

MSCore.Commands.Add("removeperms", "Remove someone's permissions", {{name="id", help="ID of player"}}, true, function(source, args)
	local Player = MSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		MSCore.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The player is not online!")	
	end
end, "god")

MSCore.Commands.Add("car", "Spawn a car", {{name="model", help="Car model"}}, true, function(source, args)
	TriggerClientEvent('MSCore:Command:SpawnVehicle', source, args[1])
end, "admin")

MSCore.Commands.Add("debug", "Enable / disable debug mode", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

MSCore.Commands.Add("dv", "Despawn a vehicle", {}, false, function(source, args)
	TriggerClientEvent('MSCore:Command:DeleteVehicle', source)
end, "admin")

MSCore.Commands.Add("tpm", "Teleport to marker", {}, false, function(source, args)
	TriggerClientEvent('MSCore:Command:GoToMarker', source)
end, "admin")

MSCore.Commands.Add("givemoney", "Give money to a player", {{name="id", help="Player ID"},{name="moneytype", help="Type of money (cash, bank, crypto)"}, {name="amount", help="Amount of money"}}, true, function(source, args)
	local Player = MSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The player is not online!")
	end
end, "admin")

MSCore.Commands.Add("setmoney", "set a players money amount", {{name="id", help="Player ID"},{name="moneytype", help="Type of money (cash, bank, crypto)"}, {name="amount", help="Amount of money"}}, true, function(source, args)
	local Player = MSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

MSCore.Commands.Add("setjob", "Assign a job to a player", {{name="id", help="Speler ID"}, {name="job", help="Job name"}}, true, function(source, args)
	local Player = MSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetJob(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

MSCore.Commands.Add("work", "See what work do you have", {}, false, function(source, args)
	local Player = MSCore.Functions.GetPlayer(source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Work: "..Player.PlayerData.job.label)
end)

MSCore.Commands.Add("setgang", "Assign a player to a gang", {{name="id", help="Player ID"}, {name="job", help="Name of a gang"}}, true, function(source, args)
	local Player = MSCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetGang(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

MSCore.Commands.Add("gang", "See in which gang you are", {}, false, function(source, args)
	local Player = MSCore.Functions.GetPlayer(source)

	if Player.PlayerData.gang.name ~= "geen" then
		TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Gang: "..Player.PlayerData.gang.label)
	else
		TriggerClientEvent('MSCore:Notify', source, "You're not in a gang!", "error")
	end
end)

MSCore.Commands.Add("testnotify", "test notify", {{name="text", help="Tekst enzo"}}, true, function(source, args)
	TriggerClientEvent('MSCore:Notify', source, table.concat(args, " "), "success")
end, "god")

MSCore.Commands.Add("clearinv", "Clean a player's inventory", {{name="id", help="Player ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = MSCore.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

MSCore.Commands.Add("ooc", "Message Out Of Character", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("MSCore:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message)
	local Players = MSCore.Functions.GetPlayers()
	local Player = MSCore.Functions.GetPlayer(source)

	for k, v in pairs(MSCore.Functions.GetPlayers()) do
		if MSCore.Functions.HasPermission(v, "admin") then
			if MSCore.Functions.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC " .. GetPlayerName(source), "normal", message)
				TriggerEvent("ms-log:server:CreateLog", "ooc", "OOC", "white", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Message:** " ..message, false)
			end
		end
	end
end)