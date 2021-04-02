MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

MSCore.Commands.Add("skin", "Alterar roupa", {}, false, function(source, args)
	TriggerClientEvent("ms-clothing:client:openMenu", source)
end, "admin")

RegisterServerEvent("ms-clothing:saveSkin")
AddEventHandler('ms-clothing:saveSkin', function(model, skin)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    if model ~= nil and skin ~= nil then 
        MSCore.Functions.ExecuteSql(false, "DELETE FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
            MSCore.Functions.ExecuteSql(false, "INSERT INTO `playerskins` (`citizenid`, `model`, `skin`, `active`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."', 1)")
        end)
    end
end)

RegisterServerEvent("ms-clothes:loadPlayerSkin")
AddEventHandler('ms-clothes:loadPlayerSkin', function()
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `active` = 1", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("ms-clothes:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("ms-clothes:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("ms-clothes:saveOutfit")
AddEventHandler("ms-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MSCore.Functions.ExecuteSql(false, "INSERT INTO `player_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('ms-clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('ms-clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("ms-clothing:server:removeOutfit")
AddEventHandler("ms-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)

    MSCore.Functions.ExecuteSql(false, "DELETE FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('ms-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('ms-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

MSCore.Functions.CreateCallback('ms-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local anusVal = {}

    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)

RegisterServerEvent('ms-clothing:print')
AddEventHandler('ms-clothing:print', function(data)
    print(data)
end)

MSCore.Commands.Add("hat", "Put or take the helmet / cap / hat..", {}, false, function(source, args)
    TriggerClientEvent("ms-clothing:client:adjustfacewear", source, 1) -- Hat
end)

MSCore.Commands.Add("glasses", "Put or take off your glasses ..", {}, false, function(source, args)
	TriggerClientEvent("ms-clothing:client:adjustfacewear", source, 2)
end)

MSCore.Commands.Add("mask", "Put or take your mask ..", {}, false, function(source, args)
	TriggerClientEvent("ms-clothing:client:adjustfacewear", source, 4)
end)