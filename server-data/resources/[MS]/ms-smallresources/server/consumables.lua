MSCore.Functions.CreateUseableItem("joint", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseJoint", source)
    end
end)

MSCore.Functions.CreateUseableItem("armor", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseArmor", source)
end)

MSCore.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseHeavyArmor", source)
end)

-- MSCore.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = MSCore.Functions.GetPlayer(source)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("consumables:client:UseRedSmoke", source)
--     end
-- end)

MSCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", source)
    end
end)

MSCore.Commands.Add("parachuteuit", "Doe je parachute uit", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
        TriggerClientEvent("consumables:client:ResetParachute", source)
end)

RegisterServerEvent("ms-smallpenis:server:AddParachute")
AddEventHandler("ms-smallpenis:server:AddParachute", function()
    local src = source
    local Ply = MSCore.Functions.GetPlayer(src)

    Ply.Functions.AddItem("parachute", 1)
end)

MSCore.Functions.CreateUseableItem("water_bottle", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

MSCore.Functions.CreateUseableItem("vodka", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

MSCore.Functions.CreateUseableItem("beer", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

MSCore.Functions.CreateUseableItem("whiskey", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

MSCore.Functions.CreateUseableItem("coffee", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

MSCore.Functions.CreateUseableItem("kurkakola", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

MSCore.Functions.CreateUseableItem("sandwich", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

MSCore.Functions.CreateUseableItem("twerks_candy", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

MSCore.Functions.CreateUseableItem("snikkel_candy", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

MSCore.Functions.CreateUseableItem("tosti", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

MSCore.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)

MSCore.Functions.CreateUseableItem("cokebaggy", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Cokebaggy", source)
end)

MSCore.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Crackbaggy", source)
end)

MSCore.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:EcstasyBaggy", source)
end)

MSCore.Functions.CreateUseableItem("firework1", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework")
end)

MSCore.Functions.CreateUseableItem("radio", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
	--TriggerClientEvent('Radio.Set', source, true)
    TriggerClientEvent('Radio.Toggle', source)
    --TriggerClientEvent('coderadio:use', source)
end)

MSCore.Functions.CreateUseableItem("firework2", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework_v2")
end)

MSCore.Functions.CreateUseableItem("firework3", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_xmas_firework")
end)

MSCore.Functions.CreateUseableItem("firework4", function(source, item)
    local Player = MSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "scr_indep_fireworks")
end)

MSCore.Commands.Add("vestoff", "Take your vest off", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services!")
    end
end)