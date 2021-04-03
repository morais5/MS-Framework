MSCore = nil

TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
    ["managegroup"] = "admin"
}

RegisterServerEvent('ms-admin:server:togglePlayerNoclip')
AddEventHandler('ms-admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("ms-admin:client:toggleNoclip", playerId)
    end
end)

RegisterServerEvent('ms-admin:server:killPlayer')
AddEventHandler('ms-admin:server:killPlayer', function(playerId)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["kickall"]) then
        TriggerClientEvent('hospital:client:KillPlayer', playerId)
    end
end)

RegisterServerEvent('ms-admin:server:kickPlayer')
AddEventHandler('ms-admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "You've been kicked from the server:\n"..reason.."\n\n🔸 Join our Discord for more information: https://discord.io/moraisscripts")
    end
end)

RegisterServerEvent('ms-admin:server:Freeze')
AddEventHandler('ms-admin:server:Freeze', function(playerId, toggle)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["kickall"]) then
        TriggerClientEvent('ms-admin:client:Freeze', playerId, toggle)
    end
end)

RegisterServerEvent('ms-admin:server:serverKick')
AddEventHandler('ms-admin:server:serverKick', function(reason)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(MSCore.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "You've been kicked from the server:\n"..reason.."\n\n🔸 Join our Discord for more information: https://discord.io/moraisscripts")
            end
        end
    end
end)

local suffix = {
    "hihi",
    "#yolo",
    "hmm slurpie",
    "yeet terug naar esx",
}

RegisterServerEvent('ms-admin:server:banPlayer')
AddEventHandler('ms-admin:server:banPlayer', function(playerId, time, reason)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(playerId).." foi banido por: "..reason.." "..suffix[math.random(1, #suffix)])
        MSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
        DropPlayer(playerId, "Você foi banido do servidor:\n"..reason.."\n\nAcaba "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Check our discord for more information: https://discord.gg/wByd87RErg")
    end
end)
RegisterServerEvent('ms-admin:server:revivePlayer')
AddEventHandler('ms-admin:server:revivePlayer', function(target)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["kickall"]) then
	    TriggerClientEvent('hospital:client:Revive', target)
    end
end)

MSCore.Commands.Add("anuciostaff", "Advertise a message to all", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

MSCore.Commands.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = MSCore.Functions.GetPermission(source)
    local dealers = exports['ms-drugs']:GetDealers()
    TriggerClientEvent('ms-admin:client:openMenu', source, group, dealers)
end, "admin")

MSCore.Commands.Add("report", "Send a report to administrators (only when needed, do not abuse this!)", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent('ms-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "Report sent.", "normal", msg)
    TriggerEvent("ms-log:server:CreateLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("ms-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

MSCore.Commands.Add("staffchat", "Send a message to all team members", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('ms-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

MSCore.Commands.Add("givenuifocus", "Give nui focus", {{name="id", help="Player id"}, {name="focus", help="Set focus on/off"}, {name="mouse", help="Set mouse on/off"}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]

    TriggerClientEvent('ms-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, "admin")

MSCore.Commands.Add("s", "Send a message to all team members", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('ms-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

MSCore.Commands.Add("avisos", "Warn a player", {{name="ID", help="Player"}, {name="Reason", help="Mention a reason"}}, true, function(source, args)
    local targetPlayer = MSCore.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = MSCore.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "NOTICE-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SYSTEM", "error", "You were warned by:: "..GetPlayerName(source)..", Reason: "..msg)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You have warned "..GetPlayerName(targetPlayer.PlayerData.source).." for: "..msg)
        MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('MSCore:Notify', source, 'This player is not online', 'error')
    end 
end, "admin")

MSCore.Commands.Add("veravisos", "See Staff Notices for a Player", {{name="ID", help="Player"}, {name="Warning", help="Notice number, (1, 2 or 3 etc.)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = MSCore.Functions.GetPlayer(tonumber(args[1]))
        MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            print(json.encode(result))
            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." have "..tablelength(result).." NOTICE/S!")
        end)
    else
        local targetPlayer = MSCore.Functions.GetPlayer(tonumber(args[1]))

        MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = MSCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." was warned by "..sender.PlayerData.name..", Reason: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "admin")

MSCore.Commands.Add("apagaraviso", "Delete notices from a person", {{name="ID", help="Player"}, {name="Warning", help="Notice number, (1, 2 or 3 etc.)"}}, true, function(source, args)
    local targetPlayer = MSCore.Functions.GetPlayer(tonumber(args[1]))

    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = MSCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "You deleted warning ("..selectedWarning..") , Reason: "..warnings[selectedWarning].reason)
            MSCore.Functions.ExecuteSql(false, "DELETE FROM `player_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "admin")

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

MSCore.Commands.Add("reportr", "Reply to a report", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = MSCore.Functions.GetPlayer(playerId)
    local Player = MSCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
        TriggerClientEvent('MSCore:Notify', source, "Reply sent")
        TriggerEvent("ms-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(MSCore.Functions.GetPlayers()) do
            if MSCore.Functions.HasPermission(v, "admin") then
                if MSCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "warning", msg)
                    TriggerEvent("ms-log:server:CreateLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** responded to the: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Message:** " ..msg, false)
                end
            end
        end
    else
        TriggerClientEvent('MSCore:Notify', source, "Is not online", "error")
    end
end, "admin")

MSCore.Commands.Add("setmodel", "Change to a model that you like..", {{name="model", help="Name of the model"}, {name="id", help="Id of the Player (empty for yourself)"}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])

    if model ~= nil or model ~= "" then
        if target == nil then
            TriggerClientEvent('ms-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = MSCore.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('ms-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('MSCore:Notify', source, "This person is not online..", "error")
            end
        end
    else
        TriggerClientEvent('MSCore:Notify', source, "You did not set a model..", "error")
    end
end, "admin")

MSCore.Commands.Add("setspeed", "Change to a speed you like..", {}, false, function(source, args)
    local speed = args[1]

    if speed ~= nil then
        TriggerClientEvent('ms-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('MSCore:Notify', source, "You did not set a speed.. (`fast` for super-run, `normal` for normal)", "error")
    end
end, "admin")


MSCore.Commands.Add("admincar", "Save the vehicle in your garage", {}, false, function(source, args)
    local ply = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent('ms-admin:client:SaveCar', source)
end, "admin")

RegisterServerEvent('ms-admin:server:SaveCar')
AddEventHandler('ms-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('MSCore:Notify', src, 'The vehicle is now yours!', 'success', 5000)
        else
            TriggerClientEvent('MSCore:Notify', src, 'This vehicle is already yours..', 'error', 3000)
        end
    end)
end)

MSCore.Commands.Add("verreports", "Switching Receive Reports", {}, false, function(source, args)
    MSCore.Functions.ToggleOptin(source)
    if MSCore.Functions.IsOptin(source) then
        TriggerClientEvent('MSCore:Notify', source, "You are receiving reports", "success")
    else
        TriggerClientEvent('MSCore:Notify', source, "You are not receiving reports", "error")
    end
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = MSCore.Functions.GetPlayer(src)

        if MSCore.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(MSCore.Functions.GetPlayers()) do
                    local Player = MSCore.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Mention a reason..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'You can not do that..')
        end
    else
        for k, v in pairs(MSCore.Functions.GetPlayers()) do
            local Player = MSCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Hello Ananás Head 🍍 - We are resicting the server, check your Discord for more information! (https://discord.io/moraisscripts)")
            end
        end
    end
end, false)

RegisterServerEvent('ms-admin:server:bringTp')
AddEventHandler('ms-admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('ms-admin:client:bringTp', targetId, coords)
end)

MSCore.Functions.CreateCallback('ms-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if MSCore.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('ms-admin:server:setPermissions')
AddEventHandler('ms-admin:server:setPermissions', function(targetId, group)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["managegroup"]) then
        MSCore.Functions.AddPermission(targetId, group.rank)
        TriggerClientEvent('MSCore:Notify', targetId, 'Added Permission '..group.label)
    end
end)

RegisterServerEvent('ms-admin:server:OpenSkinMenu')
AddEventHandler('ms-admin:server:OpenSkinMenu', function(targetId)
    local src = source
    if MSCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("ms-clothing:client:openMenu", targetId)
    end
end)

RegisterServerEvent('ms-admin:server:SendReport')
AddEventHandler('ms-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = MSCore.Functions.GetPlayers()

    if MSCore.Functions.HasPermission(src, "admin") then
        if MSCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('ms-admin:server:StaffChatMessage')
AddEventHandler('ms-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = MSCore.Functions.GetPlayers()

    if MSCore.Functions.HasPermission(src, "admin") then
        if MSCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)

MSCore.Commands.Add("setammo", "Staff: define munição manual para uma arma.", {{name="amount", help="Amount of bullets, for example: 20"}, {name="weapon", help="Name of the weapen, for example: WEAPON_VINTAGEPISTOL"}}, false, function(source, args)
    local src = source
    local weapon = args[2]
    local amount = tonumber(args[1])

    if weapon ~= nil then
        TriggerClientEvent('ms-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
    else
        TriggerClientEvent('ms-weapons:client:SetWeaponAmmoManual', src, "current", amount)
    end
end, 'admin')