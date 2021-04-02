MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

local Pings = {}

MSCore.Commands.Add("ping", "", {{name = "actie", help="id | accept | deny"}}, true, function(source, args)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local task = args[1]
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if task == "accept" then
            if Pings[src] ~= nil then
                TriggerClientEvent('ms-pings:client:AcceptPing', src, Pings[src], MSCore.Functions.GetPlayer(Pings[src].sender))
                TriggerClientEvent('MSCore:Notify', Pings[src].sender, Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." accepted your ping!")
                Pings[src] = nil
            else
                TriggerClientEvent('MSCore:Notify', src, "You don't have a ping open..", "error")
            end
        elseif task == "deny" then
            if Pings[src] ~= nil then
                TriggerClientEvent('MSCore:Notify', Pings[src].sender, "Your ping has been rejected..", "error")
                TriggerClientEvent('MSCore:Notify', src, "Tiy rejected the ping..", "success")
                Pings[src] = nil
            else
                TriggerClientEvent('MSCore:Notify', src, "You don't have a ping open..", "error")
            end
        else
            TriggerClientEvent('ms-pings:client:DoPing', src, tonumber(args[1]))
        end
    else
        TriggerClientEvent('MSCore:Notify', src, "You don't have a phone..", "error")
    end
end)

RegisterServerEvent('ms-pings:server:SendPing')
AddEventHandler('ms-pings:server:SendPing', function(id, coords)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local Target = MSCore.Functions.GetPlayer(id)
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if Target ~= nil then
            local OtherItem = Target.Functions.GetItemByName("phone")
            if OtherItem ~= nil then
                TriggerClientEvent('MSCore:Notify', src, "You sent a ping to "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
                Pings[id] = {
                    coords = coords,
                    sender = src,
                }
                TriggerClientEvent('MSCore:Notify', id, "You recived a ping from "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname..". /ping 'accept | deny'")
            else
                TriggerClientEvent('MSCore:Notify', src, "Could not send the ping, person may dont have a phone.", "error")
            end
        else
            TriggerClientEvent('MSCore:Notify', src, "This person is not online..", "error")
        end
    else
        TriggerClientEvent('MSCore:Notify', src, "You dont have a phone", "error")
    end
end)

RegisterServerEvent('ms-pings:server:SendLocation')
AddEventHandler('ms-pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('ms-pings:client:SendLocation', PingData.sender, PingData, SenderData)
end)