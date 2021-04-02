MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local DrivingSchools = {
    "PAE31194",
    "TRB56419",
    "UNA59325",
    "LWR55470",
    "APJ79416",
    "FUN28030",
}

RegisterServerEvent('ms-cityhall:server:requestId')
AddEventHandler('ms-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    local licenses = {
        ["driver"] = true,
        ["business"] = false
    }

    local info = {}
    if identityData.item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "A1-A2-A | AM-B | C1-C-CE"
    end

    Player.Functions.AddItem(identityData.item, 1, nil, info)

    TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items[identityData.item], 'add')
end)

RegisterServerEvent('ms-cityhall:server:sendDriverTest')
AddEventHandler('ms-cityhall:server:sendDriverTest', function()
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    for k, v in pairs(DrivingSchools) do 
        local SchoolPlayer = MSCore.Functions.GetPlayerByCitizenId(v)
        if SchoolPlayer ~= nil then 
            TriggerClientEvent("ms-cityhall:client:sendDriverEmail", SchoolPlayer.PlayerData.source, Player.PlayerData.charinfo)
        else
            local mailData = {
                sender = "City Hall",
                subject = "Request driving lessons",
                message = "Dear,<br /><br />We just received a message that someone wants to take driving lessons.<br />If you are willing to teach, please contact us:<br />Name: <strong>".. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "<br />Phone number: <strong>"..Player.PlayerData.charinfo.phone.."</strong><br/><br/>Kind regards,<br />City Hall Los Santos",
                button = {}
            }
            TriggerEvent("ms-phone:server:sendNewEventMail", v, mailData)
        end
    end
    TriggerClientEvent('MSCore:Notify', src, 'An email has been sent to driving schools, you will be contacted when they can', "success", 5000)
end)

RegisterServerEvent('ms-cityhall:server:ApplyJob')
AddEventHandler('ms-cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local JobInfo = MSCore.Shared.Jobs[job]

    Player.Functions.SetJob(job)

    TriggerClientEvent('MSCore:Notify', src, 'Congratulations, you have a new job! ('..JobInfo.label..')')
end)

MSCore.Commands.Add("darcartadeconducao", "Driving license", {{"id", "ID Of the player"}}, true, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    if IsWhitelistedSchool(Player.PlayerData.citizenid) then
        local SearchedPlayer = MSCore.Functions.GetPlayer(tonumber(args[1]))
        if SearchedPlayer ~= nil then
            local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
            if not driverLicense then
                local licenses = {
                    ["driver"] = true,
                    ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]
                }
                SearchedPlayer.Functions.SetMetaData("licences", licenses)
                TriggerClientEvent('MSCore:Notify', SearchedPlayer.PlayerData.source, "You passed! Get your license at cityhall", "success", 5000)
            else
                TriggerClientEvent('MSCore:Notify', src, "We cant give your license..", "error")
            end
        end
    end
end)

function IsWhitelistedSchool(citizenid)
    local retval = false
    for k, v in pairs(DrivingSchools) do 
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

RegisterServerEvent('ms-cityhall:server:banPlayer')
AddEventHandler('ms-cityhall:server:banPlayer', function()
    local src = source
    TriggerClientEvent('chatMessage', -1, "ms Anti-Cheat", "error", GetPlayerName(src).." banned")
    MSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', 'Abuse localhost:13172 for POST requests', 2145913200, '"..GetPlayerName(src).."')")
    DropPlayer(src, "This is not how things work right? ;). For more information go to our discord: ")
end)