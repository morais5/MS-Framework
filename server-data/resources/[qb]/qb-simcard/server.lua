QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('QBCore-simcard:useSimCard')
AddEventHandler('QBCore-simcard:useSimCard', function(number)
    local src = source
    TriggerClientEvent('QBCore-simcard:startNumChange', src, number)     
end)

RegisterServerEvent('QBCore-simcard:changeNumber')
AddEventHandler('QBCore-simcard:changeNumber', function(newNum)
    TriggerClientEvent('QBCore-simcard:success', source, newNum)
end)

QBCore.Functions.CreateUseableItem("sim_card", function(source, item)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)    
    TriggerClientEvent('QBCore-simcard:changeNumber', source, xPlayer)
end)

RegisterServerEvent('QBCore-simcard:changeNumber')
AddEventHandler('QBCore-simcard:changeNumber', function(MData)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'", function(result)
        local MetaData = json.decode(result[1].metadata)
        local Charinfo = json.decode(result[1].charinfo)
        MetaData.phone = MData
        Charinfo.phone = MData
        QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `metadata` = '"..json.encode(MetaData).."' WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
        QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `charinfo` = '"..json.encode(Charinfo).."' WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
    end)
    xPlayer.Functions.SetMetaData("phone", MData)
end)
