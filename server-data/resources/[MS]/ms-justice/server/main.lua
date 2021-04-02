MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

MSCore.Commands.Add("setlawyer", "Set someone as a lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MSCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
            OtherPlayer.Functions.SetJob("lawyer")
            OtherPlayer.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
            TriggerClientEvent("MSCore:Notify", source, "You was" .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " hired as a lawyer")
            TriggerClientEvent("MSCore:Notify", OtherPlayer.PlayerData.source, "Now you are a lawyer.")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, MSCore.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("MSCore:Notify", source, "This person is not present.", "error")
        end
    else
        TriggerClientEvent("MSCore:Notify", source, "You have no rights ...", "error")
    end
end)

MSCore.Commands.Add("removelawyer", "Remove someone as lawyer", {{name="id", help="id player"}}, true, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = MSCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            --OtherPlayer.Functions.SetJob("unemployed")
            TriggerClientEvent("MSCore:Notify", OtherPlayer.PlayerData.source, "You are now unemployed.")
            TriggerClientEvent("MSCore:Notify", source, "You were ".. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " removed as a lawyer")
        else
            TriggerClientEvent("MSCore:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("MSCore:Notify", source, "You have no rights..", "error")
    end
end)

MSCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("ms-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)