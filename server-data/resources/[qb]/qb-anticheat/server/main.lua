-- Load QBCore --

QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Get permissions --

QBCore.Functions.CreateCallback('qb-anticheat:server:GetPermissions', function(source, cb)
    local group = QBCore.Functions.GetPermission(source)
    cb(group)
end)

-- Execute ban --

RegisterServerEvent('qb-anticheat:server:banPlayer')
AddEventHandler('qb-anticheat:server:banPlayer', function(reason)
    local src = source
    TriggerClientEvent('chatMessage', -1, "LUNA Anti-Cheat", "error", GetPlayerName(src).." foste banido por usar cheats: " ..reason )
    QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', '"..reason.."', 2145913200, '"..GetPlayerName(src).."')")
    DropPlayer(src, "Você foi muito sinalizado, para mais informações, junte-se à nosso discord: https://discord.io/criminalrp :)")
end)

-- Fake events --
function NonRegisteredEventCalled(CalledEvent, source)
    TriggerClientEvent("qb-anticheat:client:NonRegisteredEventCalled", source, "Cheating", CalledEvent)
end

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function(source)
    NonRegisteredEventCalled('esx_drugs:sellDrug', source)
end)

RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function(source)
    NonRegisteredEventCalled('esx_drugs:pickedUpCannabis', source)
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function(source)
    NonRegisteredEventCalled('esx_drugs:processCannabis', source)
end)

RegisterServerEvent('esx_drugs:cancelProcessing')
AddEventHandler('esx_drugs:cancelProcessing', function(source)
    NonRegisteredEventCalled('esx_drugs:cancelProcessing', source)
end)

RegisterServerEvent('esx_drugs:startHarvestCoke')
AddEventHandler('esx_drugs:startHarvestCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:startHarvestCoke', source)
end)

RegisterServerEvent('esx_drugs:stopHarvestCoke')
AddEventHandler('esx_drugs:stopHarvestCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarvestCoke', source)
end)

RegisterServerEvent('esx_drugs:startTransformCoke')
AddEventHandler('esx_drugs:startTransformCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:startTransformCoke', source)
end)

RegisterServerEvent('esx_drugs:stopTransformCoke')
AddEventHandler('esx_drugs:stopTransformCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTransformCoke', source)
end)

RegisterServerEvent('esx_drugs:startSellCoke')
AddEventHandler('esx_drugs:startSellCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellCoke', source)
end)

RegisterServerEvent('esx_drugs:stopSellCoke')
AddEventHandler('esx_drugs:stopSellCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellCoke', source)
end)

RegisterServerEvent('esx_drugs:startHarvestMeth')
AddEventHandler('esx_drugs:startHarvestMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:startHarvestMeth', source)
end)

RegisterServerEvent('esx_drugs:stopHarvestMeth')
AddEventHandler('esx_drugs:stopHarvestMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarvestMeth', source)
end)

RegisterServerEvent('esx_drugs:startTransformMeth')
AddEventHandler('esx_drugs:startTransformMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:startTransformMeth', source)
end)

RegisterServerEvent('esx_drugs:stopTransformMeth')
AddEventHandler('esx_drugs:stopTransformMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTransformMeth', source)
end)

RegisterServerEvent('esx_drugs:startSellMeth')
AddEventHandler('esx_drugs:startSellMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellMeth', source)
end)

RegisterServerEvent('esx_drugs:stopSellMeth')
AddEventHandler('esx_drugs:stopSellMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellMeth', source)
end)

RegisterServerEvent('esx_drugs:startHarvestWeed')
AddEventHandler('esx_drugs:startHarvestWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:startHarvestWeed', source)
end)

RegisterServerEvent('esx_drugs:stopHarvestWeed')
AddEventHandler('esx_drugs:stopHarvestWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarvestWeed', source)
end)

RegisterServerEvent('esx_drugs:startTransformWeed')
AddEventHandler('esx_drugs:startTransformWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:startTransformWeed', source)
end)

RegisterServerEvent('esx_drugs:stopTransformWeed')
AddEventHandler('esx_drugs:stopTransformWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTransformWeed', source)
end)

RegisterServerEvent('esx_drugs:startSellWeed')
AddEventHandler('esx_drugs:startSellWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellWeed', source)
end)

RegisterServerEvent('esx_drugs:stopSellWeed')
AddEventHandler('esx_drugs:stopSellWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellWeed', source)
end)

RegisterServerEvent('esx_drugs:startHarvestOpium')
AddEventHandler('esx_drugs:startHarvestOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:startHarvestOpium', source)
end)

RegisterServerEvent('esx_drugs:stopHarvestOpium')
AddEventHandler('esx_drugs:stopHarvestOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarvestOpium', source)
end)

RegisterServerEvent('esx_drugs:startTransformOpium')
AddEventHandler('esx_drugs:startTransformOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:startTransformOpium', source)
end)

RegisterServerEvent('esx_drugs:stopTransformOpium')
AddEventHandler('esx_drugs:stopTransformOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTransformOpium', source)
end)

RegisterServerEvent('esx_drugs:startSellOpium')
AddEventHandler('esx_drugs:startSellOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellOpium', source)
end)

RegisterServerEvent('esx_drugs:stopSellOpium')
AddEventHandler('esx_drugs:stopSellOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellOpium', source)
end)

RegisterServerEvent('esx_drugs:GetUserInventory')
AddEventHandler('esx_drugs:GetUserInventory', function(source)
    NonRegisteredEventCalled('esx_drugs:GetUserInventory', source)
end)

RegisterServerEvent('OG_cuffs:cuffCheckNearest')
AddEventHandler('OG_cuffs:cuffCheckNearest', function(source)
    NonRegisteredEventCalled('OG_cuffs:cuffCheckNearest', source)
end)

RegisterServerEvent('CheckHandcuff')
AddEventHandler('CheckHandcuff', function(source)
    NonRegisteredEventCalled('CheckHandcuff', source)
end)

RegisterServerEvent('cuffServer')
AddEventHandler('cuffServer', function(source)
    NonRegisteredEventCalled('cuffServer', source)
end)

RegisterServerEvent('cuffGranted')
AddEventHandler('cuffGranted', function(source)
    NonRegisteredEventCalled('cuffGranted', source)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(source)
    NonRegisteredEventCalled('police:cuffGranted', source)
end)

RegisterServerEvent('esx_handcuffs:cuffing')
AddEventHandler('esx_handcuffs:cuffing', function(source)
    NonRegisteredEventCalled('esx_handcuffs:cuffing', source)
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(source)
    NonRegisteredEventCalled('esx_policejob:handcuff', source)
end)

RegisterServerEvent('arisonarp:wiezienie')
AddEventHandler('arisonarp:wiezienie', function(source)
    NonRegisteredEventCalled('arisonarp:wiezienie', source)
end)

RegisterServerEvent('esx_jailer:sendToJail')
AddEventHandler('esx_jailer:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jailer:sendToJail', source)
end)

RegisterServerEvent('esx_jail:sendToJail')
AddEventHandler('esx_jail:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jail:sendToJail', source)
end)

RegisterServerEvent('js:jailuser')
AddEventHandler('js:jailuser', function(source)
    NonRegisteredEventCalled('js:jailuser', source)
end)

RegisterServerEvent('esx-qalle-jail:jailPlayer')
AddEventHandler('esx-qalle-jail:jailPlayer', function(source)
    NonRegisteredEventCalled('esx-qalle-jail:jailPlayer', source)
end)

RegisterServerEvent('AdminMenu:giveCash')
AddEventHandler('AdminMenu:giveCash', function(source)
    NonRegisteredEventCalled('AdminMenu:giveCash', source)
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(source)
    NonRegisteredEventCalled('esx:giveInventoryItem', source)
end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(source)
    NonRegisteredEventCalled('esx_billing:sendBill', source)
end)

RegisterServerEvent('esx_jailer:unjailTime')
AddEventHandler('esx_jailer:unjailTime', function(source)
    NonRegisteredEventCalled('esx_jailer:unjailTime', source)
end)

RegisterServerEvent('JailUpdate')
AddEventHandler('JailUpdate', function(source)
    NonRegisteredEventCalled('JailUpdate', source)
end)

RegisterServerEvent('vrp_slotmachine:server:2')
AddEventHandler('vrp_slotmachine:server:2', function(source)
    NonRegisteredEventCalled('vrp_slotmachine:server:2', source)
end)

RegisterServerEvent('lscustoms:payGarage')
AddEventHandler('lscustoms:payGarage', function(source)
    NonRegisteredEventCalled('lscustoms:payGarage', source)
end)

RegisterServerEvent('esx_vehicletrunk:giveDirty')
AddEventHandler('esx_vehicletrunk:giveDirty', function(source)
    NonRegisteredEventCalled('esx_vehicletrunk:giveDirty', source)
end)

RegisterServerEvent('f0ba1292-b68d-4d95-8823-6230cdf282b6')
AddEventHandler('f0ba1292-b68d-4d95-8823-6230cdf282b6', function(source)
    NonRegisteredEventCalled('f0ba1292-b68d-4d95-8823-6230cdf282b6', source)
end)

RegisterServerEvent('gambling:spend')
AddEventHandler('gambling:spend', function(source)
    NonRegisteredEventCalled('gambling:spend', source)
end)

RegisterServerEvent('265df2d8-421b-4727-b01d-b92fd6503f5e')
AddEventHandler('265df2d8-421b-4727-b01d-b92fd6503f5e', function(source)
    NonRegisteredEventCalled('265df2d8-421b-4727-b01d-b92fd6503f5e', source)
end)

RegisterServerEvent('AdminMenu:giveDirtyMoney')
AddEventHandler('AdminMenu:giveDirtyMoney', function(source)
    NonRegisteredEventCalled('AdminMenu:giveDirtyMoney', source)
end)

RegisterServerEvent('AdminMenu:giveBank')
AddEventHandler('AdminMenu:giveBank', function(source)
    NonRegisteredEventCalled('AdminMenu:giveBank', source)
end)

RegisterServerEvent('AdminMenu:giveCash')
AddEventHandler('AdminMenu:giveCash', function(source)
    NonRegisteredEventCalled('AdminMenu:giveCash', source)
end)

RegisterServerEvent('esx_slotmachine:sv:2')
AddEventHandler('esx_slotmachine:sv:2', function(source)
    NonRegisteredEventCalled('esx_slotmachine:sv:2', source)
end)

RegisterServerEvent('esx_moneywash:deposit')
AddEventHandler('esx_moneywash:deposit', function(source)
    NonRegisteredEventCalled('esx_moneywash:deposit', source)
end)

RegisterServerEvent('esx_moneywash:withdraw')
AddEventHandler('esx_moneywash:withdraw', function(source)
    NonRegisteredEventCalled('esx_moneywash:withdraw', source)
end)

RegisterServerEvent('mission:completed')
AddEventHandler('mission:completed', function(source)
    NonRegisteredEventCalled('mission:completed', source)
end)

RegisterServerEvent('truckerJob:success')
AddEventHandler('truckerJob:success', function(source)
    NonRegisteredEventCalled('truckerJob:success', source)
end)

RegisterServerEvent('c65a46c5-5485-4404-bacf-06a106900258')
AddEventHandler('c65a46c5-5485-4404-bacf-06a106900258', function(source)
    NonRegisteredEventCalled('c65a46c5-5485-4404-bacf-06a106900258', source)
end)

RegisterServerEvent('paycheck:salary')
AddEventHandler('paycheck:salary', function(source)
    NonRegisteredEventCalled('paycheck:salary', source)
end)

RegisterServerEvent('DiscordBot:playerDied')
AddEventHandler('DiscordBot:playerDied', function(source)
    NonRegisteredEventCalled('DiscordBot:playerDied', source)
end)

RegisterServerEvent('esx:enterpolicecar')
AddEventHandler('esx:enterpolicecar', function(source)
    NonRegisteredEventCalled('esx:enterpolicecar', source)
end)

RegisterServerEvent('NB:recruterplayer')
AddEventHandler('NB:recruterplayer', function(source)
    NonRegisteredEventCalled('NB:recruterplayer', source)
end)

RegisterServerEvent('Esx-MenuPessoal:Boss_recruterplayer')
AddEventHandler('Esx-MenuPessoal:Boss_recruterplayer', function(source)
    NonRegisteredEventCalled('Esx-MenuPessoal:Boss_recruterplayer', source)
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(source)
    NonRegisteredEventCalled('esx:giveInventoryItem', source)
end)

RegisterServerEvent('mellotrainer:s_adminKill')
AddEventHandler('mellotrainer:s_adminKill', function(source)
    NonRegisteredEventCalled('mellotrainer:s_adminKill', source)
end)

RegisterServerEvent('adminmenu:allowall')
AddEventHandler('adminmenu:allowall', function(source)
    NonRegisteredEventCalled('adminmenu:allowall', source)
end)

RegisterServerEvent('MF_MobileMeth:RewardPlayers')
AddEventHandler('MF_MobileMeth:RewardPlayers', function(source)
    NonRegisteredEventCalled('MF_MobileMeth:RewardPlayers', source)
end)

RegisterServerEvent('esx_blanchisseur:washMoney')
AddEventHandler('esx_blanchisseur:washMoney', function(source)
    NonRegisteredEventCalled('esx_blanchisseur:washMoney', source)
end)

RegisterServerEvent('esx_blackmoney:washMoney')
AddEventHandler('esx_blackmoney:washMoney', function(source)
    NonRegisteredEventCalled('esx_blackmoney:washMoney', source)
end)

RegisterServerEvent('esx_moneywash:withdraw')
AddEventHandler('esx_moneywash:withdraw', function(source)
    NonRegisteredEventCalled('esx_moneywash:withdraw', source)
end)

RegisterServerEvent('laundry:washcash')
AddEventHandler('laundry:washcash', function(source)
    NonRegisteredEventCalled('laundry:washcash', source)
end)

RegisterServerEvent('lscustoms:UpdateVeh')
AddEventHandler('lscustoms:UpdateVeh', function(source)
    NonRegisteredEventCalled('lscustoms:UpdateVeh', source)
end)

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(source)
    NonRegisteredEventCalled('gcPhone:_internalAddMessage', source)
end)

RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(source)
    NonRegisteredEventCalled('gcPhone:tchat_channel', source)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(source)
    NonRegisteredEventCalled('esx_vehicleshop:setVehicleOwnedPlayerId', source)
end)

RegisterServerEvent('tost:zgarnijsiano')
AddEventHandler('tost:zgarnijsiano', function(source)
    NonRegisteredEventCalled('tost:zgarnijsiano', source)
end)

RegisterServerEvent('wojtek_ubereats:napiwek')
AddEventHandler('wojtek_ubereats:napiwek', function(source)
    NonRegisteredEventCalled('wojtek_ubereats:napiwek', source)
end)

RegisterServerEvent('wojtek_ubereats:hajs')
AddEventHandler('wojtek_ubereats:hajs', function(source)
    NonRegisteredEventCalled('wojtek_ubereats:hajs', source)
end)

RegisterServerEvent('xk3ly-barbasz:getfukingmony')
AddEventHandler('xk3ly-barbasz:getfukingmony', function(source)
    NonRegisteredEventCalled('xk3ly-barbasz:getfukingmony', source)
end)

RegisterServerEvent('xk3ly-farmer:paycheck')
AddEventHandler('xk3ly-farmer:paycheck', function(source)
    NonRegisteredEventCalled('xk3ly-farmer:paycheck', source)
end)

RegisterServerEvent('tostzdrapka:wygranko')
AddEventHandler('tostzdrapka:wygranko', function(source)
    NonRegisteredEventCalled('tostzdrapka:wygranko', source)
end)

RegisterServerEvent('esx_blanchisseur:washMoney')
AddEventHandler('esx_blanchisseur:washMoney', function(source)
    NonRegisteredEventCalled('esx_blanchisseur:washMoney', source)
end)

RegisterServerEvent('esx_moneywash:withdraw')
AddEventHandler('esx_moneywash:withdraw', function(source)
    NonRegisteredEventCalled('esx_moneywash:withdraw', source)
end)

RegisterServerEvent('laundry:washcash')
AddEventHandler('laundry:washcash', function(source)
    NonRegisteredEventCalled('laundry:washcash', source)
end)

RegisterServerEvent('esx_blanchisseur:startWhitening')
AddEventHandler('esx_blanchisseur:startWhitening', function(source)
    NonRegisteredEventCalled('esx_blanchisseur:startWhitening', source)
end)

RegisterServerEvent('esx_banksecurity:pay')
AddEventHandler('esx_banksecurity:pay', function(source)
    NonRegisteredEventCalled('esx_banksecurity:pay', source)
end)

RegisterServerEvent('projektsantos:mandathajs')
AddEventHandler('projektsantos:mandathajs', function(source)
    NonRegisteredEventCalled('projektsantos:mandathajs', source)
end)

RegisterServerEvent('program-keycard:hacking')
AddEventHandler('program-keycard:hacking', function(source)
    NonRegisteredEventCalled('program-keycard:hacking', source)
end)

RegisterServerEvent('xk3ly-barbasz:getfukingmony')
AddEventHandler('xk3ly-barbasz:getfukingmony', function(source)
    NonRegisteredEventCalled('xk3ly-barbasz:getfukingmony', source)
end)

RegisterServerEvent('xk3ly-farmer:paycheck')
AddEventHandler('xk3ly-farmer:paycheck', function(source)
    NonRegisteredEventCalled('xk3ly-farmer:paycheck', source)
end)

RegisterServerEvent('6a7af019-2b92-4ec2-9435-8fb9bd031c26')
AddEventHandler('6a7af019-2b92-4ec2-9435-8fb9bd031c26', function(source)
    NonRegisteredEventCalled('6a7af019-2b92-4ec2-9435-8fb9bd031c26', source)
end)

RegisterServerEvent('211ef2f8-f09c-4582-91d8-087ca2130157')
AddEventHandler('211ef2f8-f09c-4582-91d8-087ca2130157', function(source)
    NonRegisteredEventCalled('211ef2f8-f09c-4582-91d8-087ca2130157', source)
end)

RegisterServerEvent('esx_jailler:sendToJail')
AddEventHandler('esx_jailler:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jailler:sendToJail', source)
end)

RegisterServerEvent('esx-qalle-jail:jailPlayer')
AddEventHandler('esx-qalle-jail:jailPlayer', function(source)
    NonRegisteredEventCalled('esx-qalle-jail:jailPlayer', source)
end)

RegisterServerEvent('esx_jail:sendToJail')
AddEventHandler('esx_jail:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jail:sendToJail', source)
end)

RegisterServerEvent('8321hiue89js')
AddEventHandler('8321hiue89js', function(source)
    NonRegisteredEventCalled('8321hiue89js', source)
end)

RegisterServerEvent('esx_jailer:sendToJailCatfrajerze')
AddEventHandler('esx_jailer:sendToJailCatfrajerze', function(source)
    NonRegisteredEventCalled('esx_jailer:sendToJailCatfrajerze', source)
end)

RegisterServerEvent('esx_jail:sendToJail')
AddEventHandler('esx_jail:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jail:sendToJail', source)
end)

RegisterServerEvent('js:jailuser')
AddEventHandler('js:jailuser', function(source)
    NonRegisteredEventCalled('js:jailuser', source)
end)

RegisterServerEvent('wyspa_jail:jailPlayer')
AddEventHandler('wyspa_jail:jailPlayer', function(source)
    NonRegisteredEventCalled('wyspa_jail:jailPlayer', source)
end)

RegisterServerEvent('wyspa_jail:jail')
AddEventHandler('wyspa_jail:jail', function(source)
    NonRegisteredEventCalled('wyspa_jail:jail', source)
end)

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(source)
    NonRegisteredEventCalled('gcPhone:sendMessage', source)
end)

RegisterServerEvent('esx_status:set')
AddEventHandler('esx_status:set', function(source)
    NonRegisteredEventCalled('esx_status:set', source)
end)

RegisterServerEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(source)
    NonRegisteredEventCalled('esx_skin:openRestrictedMenu', source)
end)

RegisterServerEvent('esx_inventoryhud:openPlayerInventory')
AddEventHandler('esx_inventoryhud:openPlayerInventory', function(source)
    NonRegisteredEventCalled('esx_inventoryhud:openPlayerInventory', source)
end)

RegisterServerEvent('advancedFuel:setEssence')
AddEventHandler('advancedFuel:setEssence', function(source)
    NonRegisteredEventCalled('advancedFuel:setEssence', source)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(source)
    NonRegisteredEventCalled('esx_vehicleshop:setVehicleOwnedPlayerId', source)
end)

RegisterServerEvent('esx_jobs:startWork')
AddEventHandler('esx_jobs:startWork', function(source)
    NonRegisteredEventCalled('esx_jobs:startWork', source)
end)

RegisterServerEvent('esx_jobs:stopWork')
AddEventHandler('esx_jobs:stopWork', function(source)
    NonRegisteredEventCalled('esx_jobs:stopWork', source)
end)

RegisterServerEvent('8321hiue89js')
AddEventHandler('8321hiue89js', function(source)
    NonRegisteredEventCalled('8321hiue89js', source)
end)

RegisterServerEvent('adminmenu:allowall')
AddEventHandler('adminmenu:allowall', function(source)
    NonRegisteredEventCalled('adminmenu:allowall', source)
end)

RegisterServerEvent('AdminMenu:giveBank')
AddEventHandler('AdminMenu:giveBank', function(source)
    NonRegisteredEventCalled('AdminMenu:giveBank', source)
end)

RegisterServerEvent('AdminMenu:giveCash')
AddEventHandler('AdminMenu:giveCash', function(source)
    NonRegisteredEventCalled('AdminMenu:giveCash', source)
end)

RegisterServerEvent('AdminMenu:giveDirtyMoney')
AddEventHandler('AdminMenu:giveDirtyMoney', function(source)
    NonRegisteredEventCalled('AdminMenu:giveDirtyMoney', source)
end)

RegisterServerEvent('Tem2LPs5Para5dCyjuHm87y2catFkMpV')
AddEventHandler('Tem2LPs5Para5dCyjuHm87y2catFkMpV', function(source)
    NonRegisteredEventCalled('Tem2LPs5Para5dCyjuHm87y2catFkMpV', source)
end)

RegisterServerEvent('dqd36JWLRC72k8FDttZ5adUKwvwq9n9m')
AddEventHandler('dqd36JWLRC72k8FDttZ5adUKwvwq9n9m', function(source)
    NonRegisteredEventCalled('dqd36JWLRC72k8FDttZ5adUKwvwq9n9m', source)
end)

RegisterServerEvent('antilynx8:anticheat')
AddEventHandler('antilynx8:anticheat', function(source)
    NonRegisteredEventCalled('antilynx8:anticheat', source)
end)

RegisterServerEvent('antilynxr4:detect')
AddEventHandler('antilynxr4:detect', function(source)
    NonRegisteredEventCalled('antilynxr4:detect', source)
end)

RegisterServerEvent('antilynxr6:detection')
AddEventHandler('antilynxr6:detection', function(source)
    NonRegisteredEventCalled('antilynxr6:detection', source)
end)

RegisterServerEvent('ynx8:anticheat')
AddEventHandler('ynx8:anticheat', function(source)
    NonRegisteredEventCalled('ynx8:anticheat', source)
end)

RegisterServerEvent('antilynx8r4a:anticheat')
AddEventHandler('antilynx8r4a:anticheat', function(source)
    NonRegisteredEventCalled('antilynx8r4a:anticheat', source)
end)

RegisterServerEvent('lynx8:anticheat')
AddEventHandler('lynx8:anticheat', function(source)
    NonRegisteredEventCalled('lynx8:anticheat', source)
end)

RegisterServerEvent('AntiLynxR4:kick')
AddEventHandler('AntiLynxR4:kick', function(source)
    NonRegisteredEventCalled('AntiLynxR4:kick', source)
end)

RegisterServerEvent('AntiLynxR4:log')
AddEventHandler('AntiLynxR4:log', function(source)
    NonRegisteredEventCalled('AntiLynxR4:log', source)
end)

RegisterServerEvent('Banca:deposit')
AddEventHandler('Banca:deposit', function(source)
    NonRegisteredEventCalled('Banca:deposit', source)
end)

RegisterServerEvent('Banca:withdraw')
AddEventHandler('Banca:withdraw', function(source)
    NonRegisteredEventCalled('Banca:withdraw', source)
end)

RegisterServerEvent('BsCuff:Cuff696999')
AddEventHandler('BsCuff:Cuff696999', function(source)
    NonRegisteredEventCalled('BsCuff:Cuff696999', source)
end)

RegisterServerEvent('CheckHandcuff')
AddEventHandler('CheckHandcuff', function(source)
    NonRegisteredEventCalled('CheckHandcuff', source)
end)

RegisterServerEvent('cuffServer')
AddEventHandler('cuffServer', function(source)
    NonRegisteredEventCalled('cuffServer', source)
end)

RegisterServerEvent('cuffGranted')
AddEventHandler('cuffGranted', function(source)
    NonRegisteredEventCalled('cuffGranted', source)
end)

RegisterServerEvent('DiscordBot:playerDied')
AddEventHandler('DiscordBot:playerDied', function(source)
    NonRegisteredEventCalled('DiscordBot:playerDied', source)
end)

RegisterServerEvent('DFWM:adminmenuenable')
AddEventHandler('DFWM:adminmenuenable', function(source)
    NonRegisteredEventCalled('DFWM:adminmenuenable', source)
end)

RegisterServerEvent('DFWM:askAwake')
AddEventHandler('DFWM:askAwake', function(source)
    NonRegisteredEventCalled('DFWM:askAwake', source)
end)

RegisterServerEvent('DFWM:checkup')
AddEventHandler('DFWM:checkup', function(source)
    NonRegisteredEventCalled('DFWM:checkup', source)
end)

RegisterServerEvent('DFWM:cleanareaentity')
AddEventHandler('DFWM:cleanareaentity', function(source)
    NonRegisteredEventCalled('DFWM:cleanareaentity', source)
end)

RegisterServerEvent('DFWM:cleanareapeds')
AddEventHandler('DFWM:cleanareapeds', function(source)
    NonRegisteredEventCalled('DFWM:cleanareapeds', source)
end)

RegisterServerEvent('DFWM:cleanareaveh')
AddEventHandler('DFWM:cleanareaveh', function(source)
    NonRegisteredEventCalled('DFWM:cleanareaveh', source)
end)

RegisterServerEvent('DFWM:enable')
AddEventHandler('DFWM:enable', function(source)
    NonRegisteredEventCalled('DFWM:enable', source)
end)

RegisterServerEvent('DFWM:invalid')
AddEventHandler('DFWM:invalid', function(source)
    NonRegisteredEventCalled('DFWM:invalid', source)
end)

RegisterServerEvent('DFWM:log')
AddEventHandler('DFWM:log', function(source)
    NonRegisteredEventCalled('DFWM:log', source)
end)

RegisterServerEvent('DFWM:openmenu')
AddEventHandler('DFWM:openmenu', function(source)
    NonRegisteredEventCalled('DFWM:openmenu', source)
end)

RegisterServerEvent('DFWM:spectate')
AddEventHandler('DFWM:spectate', function(source)
    NonRegisteredEventCalled('DFWM:spectate', source)
end)

RegisterServerEvent('DFWM:ViolationDetected')
AddEventHandler('DFWM:ViolationDetected', function(source)
    NonRegisteredEventCalled('DFWM:ViolationDetected', source)
end)

RegisterServerEvent('dmv:success')
AddEventHandler('dmv:success', function(source)
    NonRegisteredEventCalled('dmv:success', source)
end)

RegisterServerEvent('eden_garage:payhealth')
AddEventHandler('eden_garage:payhealth', function(source)
    NonRegisteredEventCalled('eden_garage:payhealth', source)
end)

RegisterServerEvent('ems:revive')
AddEventHandler('ems:revive', function(source)
    NonRegisteredEventCalled('ems:revive', source)
end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(source)
    NonRegisteredEventCalled('esx_ambulancejob:revive', source)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(source)
    NonRegisteredEventCalled('esx_ambulancejob:setDeathStatus', source)
end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(source)
    NonRegisteredEventCalled('esx_billing:sendBill', source)
end)

RegisterServerEvent('esx_banksecurity:pay')
AddEventHandler('esx_banksecurity:pay', function(source)
    NonRegisteredEventCalled('esx_banksecurity:pay', source)
end)

RegisterServerEvent('esx_blanchisseur:startWhitening')
AddEventHandler('esx_blanchisseur:startWhitening', function(source)
    NonRegisteredEventCalled('esx_blanchisseur:startWhitening', source)
end)

RegisterServerEvent('esx_carthief:alertcops')
AddEventHandler('esx_carthief:alertcops', function(source)
    NonRegisteredEventCalled('esx_carthief:alertcops', source)
end)

RegisterServerEvent('esx_carthief:pay')
AddEventHandler('esx_carthief:pay', function(source)
    NonRegisteredEventCalled('esx_carthief:pay', source)
end)

RegisterServerEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(source)
    NonRegisteredEventCalled('esx_dmvschool:addLicense', source)
end)

RegisterServerEvent('esx_dmvschool:pay')
AddEventHandler('esx_dmvschool:pay', function(source)
    NonRegisteredEventCalled('esx_dmvschool:pay', source)
end)

RegisterServerEvent('esx:enterpolicecar')
AddEventHandler('esx:enterpolicecar', function(source)
    NonRegisteredEventCalled('esx:enterpolicecar', source)
end)

RegisterServerEvent('esx_fueldelivery:pay')
AddEventHandler('esx_fueldelivery:pay', function(source)
    NonRegisteredEventCalled('esx_fueldelivery:pay', source)
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(source)
    NonRegisteredEventCalled('esx:giveInventoryItem', source)
end)

RegisterServerEvent('esx_garbagejob:pay')
AddEventHandler('esx_garbagejob:pay', function(source)
    NonRegisteredEventCalled('esx_garbagejob:pay', source)
end)

RegisterServerEvent('esx_godirtyjob:pay')
AddEventHandler('esx_godirtyjob:pay', function(source)
    NonRegisteredEventCalled('esx_godirtyjob:pay', source)
end)

RegisterServerEvent('esx_gopostaljob:pay')
AddEventHandler('esx_gopostaljob:pay', function(source)
    NonRegisteredEventCalled('esx_gopostaljob:pay', source)
end)

RegisterServerEvent('esx_handcuffs:cuffing')
AddEventHandler('esx_handcuffs:cuffing', function(source)
    NonRegisteredEventCalled('esx_handcuffs:cuffing', source)
end)

RegisterServerEvent('esx_jail:sendToJail')
AddEventHandler('esx_jail:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jail:sendToJail', source)
end)

RegisterServerEvent('esx_jail:unjailQuest')
AddEventHandler('esx_jail:unjailQuest', function(source)
    NonRegisteredEventCalled('esx_jail:unjailQuest', source)
end)

RegisterServerEvent('esx_jailer:sendToJail')
AddEventHandler('esx_jailer:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jailer:sendToJail', source)
end)

RegisterServerEvent('esx_jailer:unjailTime')
AddEventHandler('esx_jailer:unjailTime', function(source)
    NonRegisteredEventCalled('esx_jailer:unjailTime', source)
end)

RegisterServerEvent('esx_jobs:caution')
AddEventHandler('esx_jobs:caution', function(source)
    NonRegisteredEventCalled('esx_jobs:caution', source)
end)

RegisterServerEvent('esx_mecanojob:onNPCJobCompleted')
AddEventHandler('esx_mecanojob:onNPCJobCompleted', function(source)
    NonRegisteredEventCalled('esx_mecanojob:onNPCJobCompleted', source)
end)

RegisterServerEvent('esx_mechanicjob:startHarvest')
AddEventHandler('esx_mechanicjob:startHarvest', function(source)
    NonRegisteredEventCalled('esx_mechanicjob:startHarvest', source)
end)

RegisterServerEvent('esx_mechanicjob:startCraft')
AddEventHandler('esx_mechanicjob:startCraft', function(source)
    NonRegisteredEventCalled('esx_mechanicjob:startCraft', source)
end)

RegisterServerEvent('esx_pizza:pay')
AddEventHandler('esx_pizza:pay', function(source)
    NonRegisteredEventCalled('esx_pizza:pay', source)
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(source)
    NonRegisteredEventCalled('esx_policejob:handcuff', source)
end)

RegisterServerEvent('esx-qalle-jail:jailPlayer')
AddEventHandler('esx-qalle-jail:jailPlayer', function(source)
    NonRegisteredEventCalled('esx-qalle-jail:jailPlayer', source)
end)

RegisterServerEvent('esx-qalle-jail:jailPlayerNew')
AddEventHandler('esx-qalle-jail:jailPlayerNew', function(source)
    NonRegisteredEventCalled('esx-qalle-jail:jailPlayerNew', source)
end)

RegisterServerEvent('esx-qalle-hunting:reward')
AddEventHandler('esx-qalle-hunting:reward', function(source)
    NonRegisteredEventCalled('esx-qalle-hunting:reward', source)
end)

RegisterServerEvent('esx-qalle-hunting:sell')
AddEventHandler('esx-qalle-hunting:sell', function(source)
    NonRegisteredEventCalled('esx-qalle-hunting:sell', source)
end)

RegisterServerEvent('esx_ranger:pay')
AddEventHandler('esx_ranger:pay', function(source)
    NonRegisteredEventCalled('esx_ranger:pay', source)
end)

RegisterServerEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(source)
    NonRegisteredEventCalled('esx:removeInventoryItem', source)
end)

RegisterServerEvent('esx_truckerjob:pay')
AddEventHandler('esx_truckerjob:pay', function(source)
    NonRegisteredEventCalled('esx_truckerjob:pay', source)
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(source)
    NonRegisteredEventCalled('esx_skin:responseSaveSkin', source)
end)

RegisterServerEvent('esx_slotmachine:sv:2')
AddEventHandler('esx_slotmachine:sv:2', function(source)
    NonRegisteredEventCalled('esx_slotmachine:sv:2', source)
end)

RegisterServerEvent('esx_society:getOnlinePlayers')
AddEventHandler('esx_society:getOnlinePlayers', function(source)
    NonRegisteredEventCalled('esx_society:getOnlinePlayers', source)
end)

RegisterServerEvent('esx_society:setJob')
AddEventHandler('esx_society:setJob', function(source)
    NonRegisteredEventCalled('esx_society:setJob', source)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwned')
AddEventHandler('esx_vehicleshop:setVehicleOwned', function(source)
    NonRegisteredEventCalled('esx_vehicleshop:setVehicleOwned', source)
end)

RegisterServerEvent('hentailover:xdlol')
AddEventHandler('hentailover:xdlol', function(source)
    NonRegisteredEventCalled('hentailover:xdlol', source)
end)

RegisterServerEvent('JailUpdate')
AddEventHandler('JailUpdate', function(source)
    NonRegisteredEventCalled('JailUpdate', source)
end)

RegisterServerEvent('js:jailuser')
AddEventHandler('js:jailuser', function(source)
    NonRegisteredEventCalled('js:jailuser', source)
end)

RegisterServerEvent('js:removejailtime')
AddEventHandler('js:removejailtime', function(source)
    NonRegisteredEventCalled('js:removejailtime', source)
end)

RegisterServerEvent('LegacyFuel:PayFuel')
AddEventHandler('LegacyFuel:PayFuel', function(source)
    NonRegisteredEventCalled('LegacyFuel:PayFuel', source)
end)

RegisterServerEvent('ljail:jailplayer')
AddEventHandler('ljail:jailplayer', function(source)
    NonRegisteredEventCalled('ljail:jailplayer', source)
end)

RegisterServerEvent('mellotrainer:adminTempBan')
AddEventHandler('mellotrainer:adminTempBan', function(source)
    NonRegisteredEventCalled('mellotrainer:adminTempBan', source)
end)

RegisterServerEvent('mellotrainer:adminKick')
AddEventHandler('mellotrainer:adminKick', function(source)
    NonRegisteredEventCalled('mellotrainer:adminKick', source)
end)

RegisterServerEvent('mellotrainer:s_adminKill')
AddEventHandler('mellotrainer:s_adminKill', function(source)
    NonRegisteredEventCalled('mellotrainer:s_adminKill', source)
end)

RegisterServerEvent('NB:destituerplayer')
AddEventHandler('NB:destituerplayer', function(source)
    NonRegisteredEventCalled('NB:destituerplayer', source)
end)

RegisterServerEvent('NB:recruterplayer')
AddEventHandler('NB:recruterplayer', function(source)
    NonRegisteredEventCalled('NB:recruterplayer', source)
end)

RegisterServerEvent('OG_cuffs:cuffCheckNearest')
AddEventHandler('OG_cuffs:cuffCheckNearest', function(source)
    NonRegisteredEventCalled('OG_cuffs:cuffCheckNearest', source)
end)

RegisterServerEvent('paramedic:revive')
AddEventHandler('paramedic:revive', function(source)
    NonRegisteredEventCalled('paramedic:revive', source)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(source)
    NonRegisteredEventCalled('police:cuffGranted', source)
end)

RegisterServerEvent('unCuffServer')
AddEventHandler('unCuffServer', function(source)
    NonRegisteredEventCalled('unCuffServer', source)
end)

RegisterServerEvent('uncuffGranted')
AddEventHandler('uncuffGranted', function(source)
    NonRegisteredEventCalled('uncuffGranted', source)
end)

RegisterServerEvent('vrp_slotmachine:server:2')
AddEventHandler('vrp_slotmachine:server:2', function(source)
    NonRegisteredEventCalled('vrp_slotmachine:server:2', source)
end)

RegisterServerEvent('whoapd:revive')
AddEventHandler('whoapd:revive', function(source)
    NonRegisteredEventCalled('whoapd:revive', source)
end)

RegisterServerEvent('gcPhone:_internalAddMessageDFWM')
AddEventHandler('gcPhone:_internalAddMessageDFWM', function(source)
    NonRegisteredEventCalled('gcPhone:_internalAddMessageDFWM', source)
end)

RegisterServerEvent('gcPhone:tchat_channelDFWM')
AddEventHandler('gcPhone:tchat_channelDFWM', function(source)
    NonRegisteredEventCalled('gcPhone:tchat_channelDFWM', source)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedDFWM')
AddEventHandler('esx_vehicleshop:setVehicleOwnedDFWM', function(source)
    NonRegisteredEventCalled('esx_vehicleshop:setVehicleOwnedDFWM', source)
end)

RegisterServerEvent('esx_mafiajob:confiscateDFWMPlayerItem')
AddEventHandler('esx_mafiajob:confiscateDFWMPlayerItem', function(source)
    NonRegisteredEventCalled('esx_mafiajob:confiscateDFWMPlayerItem', source)
end)

RegisterServerEvent('lscustoms:pDFWMayGarage')
AddEventHandler('lscustoms:pDFWMayGarage', function(source)
    NonRegisteredEventCalled('lscustoms:pDFWMayGarage', source)
end)

RegisterServerEvent('vrp_slotmachDFWMine:server:2')
AddEventHandler('vrp_slotmachDFWMine:server:2', function(source)
    NonRegisteredEventCalled('vrp_slotmachDFWMine:server:2', source)
end)

RegisterServerEvent('Banca:dDFWMeposit')
AddEventHandler('Banca:dDFWMeposit', function(source)
    NonRegisteredEventCalled('Banca:dDFWMeposit', source)
end)

RegisterServerEvent('bank:depDFWMosit')
AddEventHandler('bank:depDFWMosit', function(source)
    NonRegisteredEventCalled('bank:depDFWMosit', source)
end)

RegisterServerEvent('esx_jobs:caDFWMution')
AddEventHandler('esx_jobs:caDFWMution', function(source)
    NonRegisteredEventCalled('esx_jobs:caDFWMution', source)
end)

RegisterServerEvent('give_back')
AddEventHandler('give_back', function(source)
   NonRegisteredEventCalled('give_back', source)
end)

RegisterServerEvent('esx_fueldDFWMelivery:pay')
AddEventHandler('esx_fueldDFWMelivery:pay', function(source)
    NonRegisteredEventCalled('esx_fueldDFWMelivery:pay', source)
end)

RegisterServerEvent('esx_carthDFWMief:pay')
AddEventHandler('esx_carthDFWMief:pay', function(source)
    NonRegisteredEventCalled('esx_carthDFWMief:pay', source)
end)

RegisterServerEvent('esx_godiDFWMrtyjob:pay')
AddEventHandler('esx_godiDFWMrtyjob:pay', function(source)
    NonRegisteredEventCalled('esx_godiDFWMrtyjob:pay', source)
end)

RegisterServerEvent('esx_pizza:pDFWMay')
AddEventHandler('esx_pizza:pDFWMay', function(source)
    NonRegisteredEventCalled('esx_pizza:pDFWMay', source)
end)

RegisterServerEvent('esx_ranger:pDFWMay')
AddEventHandler('esx_ranger:pDFWMay', function(source)
    NonRegisteredEventCalled('esx_ranger:pDFWMay', source)
end)

RegisterServerEvent('esx_garbageDFWMjob:pay')
AddEventHandler('esx_garbageDFWMjob:pay', function(source)
    NonRegisteredEventCalled('esx_garbageDFWMjob:pay', source)
end)

RegisterServerEvent('esx_truckDFWMerjob:pay')
AddEventHandler('esx_truckDFWMerjob:pay', function(source)
    NonRegisteredEventCalled('esx_truckDFWMerjob:pay', source)
end)

RegisterServerEvent('AdminMeDFWMnu:giveBank')
AddEventHandler('AdminMeDFWMnu:giveBank', function(source)
    NonRegisteredEventCalled('AdminMeDFWMnu:giveBank', source)
end)

RegisterServerEvent('AdminMDFWMenu:giveCash')
AddEventHandler('AdminMDFWMenu:giveCash', function(source)
    NonRegisteredEventCalled('AdminMDFWMenu:giveCash', source)
end)

RegisterServerEvent('esx_goDFWMpostaljob:pay')
AddEventHandler('esx_goDFWMpostaljob:pay', function(source)
    NonRegisteredEventCalled('esx_goDFWMpostaljob:pay', source)
end)

RegisterServerEvent('esx_baDFWMnksecurity:pay')
AddEventHandler('esx_baDFWMnksecurity:pay', function(source)
    NonRegisteredEventCalled('esx_baDFWMnksecurity:pay', source)
end)

RegisterServerEvent('esx_sloDFWMtmachine:sv:2')
AddEventHandler('esx_sloDFWMtmachine:sv:2', function(source)
    NonRegisteredEventCalled('esx_sloDFWMtmachine:sv:2', source)
end)

RegisterServerEvent('esx:giDFWMveInventoryItem')
AddEventHandler('esx:giDFWMveInventoryItem', function(source)
    NonRegisteredEventCalled('esx:giDFWMveInventoryItem', source)
end)

RegisterServerEvent('NB:recDFWMruterplayer')
AddEventHandler('NB:recDFWMruterplayer', function(source)
    NonRegisteredEventCalled('NB:recDFWMruterplayer', source)
end)

RegisterServerEvent('esx_biDFWMlling:sendBill')
AddEventHandler('esx_biDFWMlling:sendBill', function(source)
    NonRegisteredEventCalled('esx_biDFWMlling:sendBill', source)
end)

RegisterServerEvent('esx_jDFWMailer:sendToJail')
AddEventHandler('esx_jDFWMailer:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jDFWMailer:sendToJail', source)
end)

RegisterServerEvent('esx_jaDFWMil:sendToJail')
AddEventHandler('esx_jaDFWMil:sendToJail', function(source)
    NonRegisteredEventCalled('esx_jaDFWMil:sendToJail', source)
end)

RegisterServerEvent('js:jaDFWMiluser')
AddEventHandler('js:jaDFWMiluser', function(source)
    NonRegisteredEventCalled('js:jaDFWMiluser', source)
end)

RegisterServerEvent('esx-qalle-jail:jailPDFWMlayer')
AddEventHandler('esx-qalle-jail:jailPDFWMlayer', function(source)
    NonRegisteredEventCalled('esx-qalle-jail:jailPDFWMlayer', source)
end)

RegisterServerEvent('esx_dmvschool:pDFWMay')
AddEventHandler('esx_dmvschool:pDFWMay', function(source)
    NonRegisteredEventCalled('esx_dmvschool:pDFWMay', source)
end)

RegisterServerEvent('LegacyFuel:PayFuDFWMel')
AddEventHandler('LegacyFuel:PayFuDFWMel', function(source)
    NonRegisteredEventCalled('LegacyFuel:PayFuDFWMel', source)
end)

RegisterServerEvent('OG_cuffs:cuffCheckNeDFWMarest')
AddEventHandler('OG_cuffs:cuffCheckNeDFWMarest', function(source)
    NonRegisteredEventCalled('OG_cuffs:cuffCheckNeDFWMarest', source)
end)

RegisterServerEvent('CheckHandcDFWMuff')
AddEventHandler('CheckHandcDFWMuff', function(source)
    NonRegisteredEventCalled('CheckHandcDFWMuff', source)
end)

RegisterServerEvent('cuffSeDFWMrver')
AddEventHandler('cuffSeDFWMrver', function(source)
    NonRegisteredEventCalled('cuffSeDFWMrver', source)
end)

RegisterServerEvent('cuffGDFWMranted')
AddEventHandler('cuffGDFWMranted', function(source)
    NonRegisteredEventCalled('cuffGDFWMranted', source)
end)

RegisterServerEvent('police:cuffGDFWMranted')
AddEventHandler('police:cuffGDFWMranted', function(source)
    NonRegisteredEventCalled('police:cuffGDFWMranted', source)
end)

RegisterServerEvent('esx_handcuffs:cufDFWMfing')
AddEventHandler('esx_handcuffs:cufDFWMfing', function(source)
    NonRegisteredEventCalled('esx_handcuffs:cufDFWMfing', source)
end)

RegisterServerEvent('esx_policejob:haDFWMndcuff')
AddEventHandler('esx_policejob:haDFWMndcuff', function(source)
    NonRegisteredEventCalled('esx_policejob:haDFWMndcuff', source)
end)

RegisterServerEvent('bank:withdDFWMraw')
AddEventHandler('bank:withdDFWMraw', function(source)
    NonRegisteredEventCalled('bank:withdDFWMraw', source)
end)

RegisterServerEvent('dmv:succeDFWMss')
AddEventHandler('dmv:succeDFWMss', function(source)
    NonRegisteredEventCalled('dmv:succeDFWMss', source)
end)

RegisterServerEvent('esx_skin:responseSaDFWMveSkin')
AddEventHandler('esx_skin:responseSaDFWMveSkin', function(source)
    NonRegisteredEventCalled('esx_skin:responseSaDFWMveSkin', source)
end)

RegisterServerEvent('esx_dmvschool:addLiceDFWMnse')
AddEventHandler('esx_dmvschool:addLiceDFWMnse', function(source)
    NonRegisteredEventCalled('esx_dmvschool:addLiceDFWMnse', source)
end)

RegisterServerEvent('esx_mechanicjob:starDFWMtCraft')
AddEventHandler('esx_mechanicjob:starDFWMtCraft', function(source)
    NonRegisteredEventCalled('esx_mechanicjob:starDFWMtCraft', source)
end)

RegisterServerEvent('esx_drugs:startHarvestWDFWMeed')
AddEventHandler('esx_drugs:startHarvestWDFWMeed', function(source)
    NonRegisteredEventCalled('esx_drugs:startHarvestWDFWMeed', source)
end)

RegisterServerEvent('esx_drugs:startTransfoDFWMrmWeed')
AddEventHandler('esx_drugs:startTransfoDFWMrmWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:startTransfoDFWMrmWeed', source)
end)

RegisterServerEvent('esx_drugs:startSellWeDFWMed')
AddEventHandler('esx_drugs:startSellWeDFWMed', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellWeDFWMed', source)
end)

RegisterServerEvent('esx_drugs:startHarvestDFWMCoke')
AddEventHandler('esx_drugs:startHarvestDFWMCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:startHarvestDFWMCoke', source)
end)

RegisterServerEvent('esx_drugs:startTransDFWMformCoke')
AddEventHandler('esx_drugs:startTransDFWMformCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:startTransDFWMformCoke', source)
end)

RegisterServerEvent('esx_drugs:startSellCDFWMoke')
AddEventHandler('esx_drugs:startSellCDFWMoke', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellCDFWMoke', source)
end)

RegisterServerEvent('esx_drugs:startHarDFWMvestMeth')
AddEventHandler('esx_drugs:startHarDFWMvestMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:startHarDFWMvestMeth', source)
end)

RegisterServerEvent('esx_drugs:startTDFWMransformMeth')
AddEventHandler('esx_drugs:startTDFWMransformMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:startTDFWMransformMeth', source)
end)

RegisterServerEvent('esx_drugs:startSellMDFWMeth')
AddEventHandler('esx_drugs:startSellMDFWMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellMDFWMeth', source)
end)

RegisterServerEvent('esx_drugs:startHDFWMarvestOpium')
AddEventHandler('esx_drugs:startHDFWMarvestOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:startHDFWMarvestOpium', source)
end)

RegisterServerEvent('esx_drugs:startSellDFWMOpium')
AddEventHandler('esx_drugs:startSellDFWMOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:startSellDFWMOpium', source)
end)

RegisterServerEvent('esx_drugs:starDFWMtTransformOpium')
AddEventHandler('esx_drugs:starDFWMtTransformOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:starDFWMtTransformOpium', source)
end)

RegisterServerEvent('esx_blanchisDFWMseur:startWhitening')
AddEventHandler('esx_blanchisDFWMseur:startWhitening', function(source)
    NonRegisteredEventCalled('esx_blanchisDFWMseur:startWhitening', source)
end)

RegisterServerEvent('esx_drugs:stopHarvDFWMestCoke')
AddEventHandler('esx_drugs:stopHarvDFWMestCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarvDFWMestCoke', source)
end)

RegisterServerEvent('esx_drugs:stopTranDFWMsformCoke')
AddEventHandler('esx_drugs:stopTranDFWMsformCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTranDFWMsformCoke', source)
end)

RegisterServerEvent('esx_drugs:stopSellDFWMCoke')
AddEventHandler('esx_drugs:stopSellDFWMCoke', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellDFWMCoke', source)
end)

RegisterServerEvent('esx_drugs:stopHarvesDFWMtMeth')
AddEventHandler('esx_drugs:stopHarvesDFWMtMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarvesDFWMtMeth', source)
end)

RegisterServerEvent('esx_drugs:stopTranDFWMsformMeth')
AddEventHandler('esx_drugs:stopTranDFWMsformMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTranDFWMsformMeth', source)
end)

RegisterServerEvent('esx_drugs:stopSellMDFWMeth')
AddEventHandler('esx_drugs:stopSellMDFWMeth', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellMDFWMeth', source)
end)

RegisterServerEvent('esx_drugs:stopHarDFWMvestWeed')
AddEventHandler('esx_drugs:stopHarDFWMvestWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarDFWMvestWeed', source)
end)

RegisterServerEvent('esx_drugs:stopTDFWMransformWeed')
AddEventHandler('esx_drugs:stopTDFWMransformWeed', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTDFWMransformWeed', source)
end)

RegisterServerEvent('esx_drugs:stopSellWDFWMeed')
AddEventHandler('esx_drugs:stopSellWDFWMeed', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellWDFWMeed', source)
end)

RegisterServerEvent('esx_drugs:stopHarvestDFWMOpium')
AddEventHandler('esx_drugs:stopHarvestDFWMOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:stopHarvestDFWMOpium', source)
end)

RegisterServerEvent('esx_drugs:stopTransDFWMformOpium')
AddEventHandler('esx_drugs:stopTransDFWMformOpium', function(source)
    NonRegisteredEventCalled('esx_drugs:stopTransDFWMformOpium', source)
end)

RegisterServerEvent('esx_drugs:stopSellOpiuDFWMm')
AddEventHandler('esx_drugs:stopSellOpiuDFWMm', function(source)
    NonRegisteredEventCalled('esx_drugs:stopSellOpiuDFWMm', source)
end)

RegisterServerEvent('esx_society:openBosDFWMsMenu')
AddEventHandler('esx_society:openBosDFWMsMenu', function(source)
    NonRegisteredEventCalled('esx_society:openBosDFWMsMenu', source)
end)

RegisterServerEvent('esx_jobs:caDFWMution')
AddEventHandler('esx_jobs:caDFWMution', function(source)
    NonRegisteredEventCalled('esx_jobs:caDFWMution', source)
end)

RegisterServerEvent('esx_tankerjob:DFWMpay')
AddEventHandler('esx_tankerjob:DFWMpay', function(source)
    NonRegisteredEventCalled('esx_tankerjob:DFWMpay', source)
end)

RegisterServerEvent('esx_vehicletrunk:givDFWMeDirty')
AddEventHandler('esx_vehicletrunk:givDFWMeDirty', function(source)
    NonRegisteredEventCalled('esx_vehicletrunk:givDFWMeDirty', source)
end)

RegisterServerEvent('gambling:speDFWMnd')
AddEventHandler('gambling:speDFWMnd', function(source)
    NonRegisteredEventCalled('gambling:speDFWMnd', source)
end)

RegisterServerEvent('AdminMenu:giveDirtyMDFWMoney')
AddEventHandler('AdminMenu:giveDirtyMDFWMoney', function(source)
    NonRegisteredEventCalled('AdminMenu:giveDirtyMDFWMoney', source)
end)

RegisterServerEvent('esx_moneywash:depoDFWMsit')
AddEventHandler('esx_moneywash:depoDFWMsit', function(source)
    NonRegisteredEventCalled('esx_moneywash:depoDFWMsit', source)
end)

RegisterServerEvent('esx_moneywash:witDFWMhdraw')
AddEventHandler('esx_moneywash:witDFWMhdraw', function(source)
    NonRegisteredEventCalled('esx_moneywash:witDFWMhdraw', source)
end)

RegisterServerEvent('mission:completDFWMed')
AddEventHandler('mission:completDFWMed', function(source)
    NonRegisteredEventCalled('mission:completDFWMed', source)
end)

RegisterServerEvent('truckerJob:succeDFWMss')
AddEventHandler('truckerJob:succeDFWMss', function(source)
    NonRegisteredEventCalled('truckerJob:succeDFWMss', source)
end)

RegisterServerEvent('99kr-burglary:addMDFWMoney')
AddEventHandler('99kr-burglary:addMDFWMoney', function(source)
    NonRegisteredEventCalled('99kr-burglary:addMDFWMoney', source)
end)

RegisterServerEvent('esx_jailer:unjailTiDFWMme')
AddEventHandler('esx_jailer:unjailTiDFWMme', function(source)
    NonRegisteredEventCalled('esx_jailer:unjailTiDFWMme', source)
end)

RegisterServerEvent('esx_ambulancejob:reDFWMvive')
AddEventHandler('esx_ambulancejob:reDFWMvive', function(source)
    NonRegisteredEventCalled('esx_ambulancejob:reDFWMvive', source)
end)

RegisterServerEvent('DiscordBot:plaDFWMyerDied')
AddEventHandler('DiscordBot:plaDFWMyerDied', function(source)
    NonRegisteredEventCalled('DiscordBot:plaDFWMyerDied', source)
end)

RegisterServerEvent('esx:getShDFWMaredObjDFWMect')
AddEventHandler('esx:getShDFWMaredObjDFWMect', function(source)
    NonRegisteredEventCalled('esx:getShDFWMaredObjDFWMect', source)
end)

RegisterServerEvent('esx_society:getOnlDFWMinePlayers')
AddEventHandler('esx_society:getOnlDFWMinePlayers', function(source)
    NonRegisteredEventCalled('esx_society:getOnlDFWMinePlayers', source)
end)

RegisterServerEvent('js:jaDFWMiluser')
AddEventHandler('js:jaDFWMiluser', function(source)
    NonRegisteredEventCalled('js:jaDFWMiluser', source)
end)

RegisterServerEvent('h:xd')
AddEventHandler('h:xd', function(source)
    NNonRegisteredEventCalled('h:xd', source)
end)

RegisterServerEvent('adminmenu:setsalary')
AddEventHandler('adminmenu:setsalary', function(source)
    NonRegisteredEventCalled('adminmenu:setsalary', source)
end)

RegisterServerEvent('adminmenu:cashoutall')
AddEventHandler('adminmenu:cashoutall', function(source)
    NonRegisteredEventCalled('adminmenu:cashoutall', source)
end)

RegisterServerEvent('bank:tranDFWMsfer')
AddEventHandler('bank:tranDFWMsfer', function(source)
    NonRegisteredEventCalled('bank:tranDFWMsfer', source)
end)

RegisterServerEvent('paycheck:bonDFWMus')
AddEventHandler('paycheck:bonDFWMus', function(source)
    NonRegisteredEventCalled('paycheck:bonDFWMus', source)
end)

RegisterServerEvent('paycheck:salDFWMary')
AddEventHandler('paycheck:salDFWMary', function(source)
    NonRegisteredEventCalled('paycheck:salDFWMary', source)
end)

RegisterServerEvent('HCheat:TempDisableDetDFWMection')
AddEventHandler('HCheat:TempDisableDetDFWMection', function(source)
    NonRegisteredEventCalled('HCheat:TempDisableDetDFWMection', source)
end)

RegisterServerEvent('esx_drugs:pickedUpCDFWMannabis')
AddEventHandler('esx_drugs:pickedUpCDFWMannabis', function(source)
    NonRegisteredEventCalled('esx_drugs:pickedUpCDFWMannabis', source)
end)

RegisterServerEvent('esx_drugs:processCDFWMannabis')
AddEventHandler('esx_drugs:processCDFWMannabis', function(source)
    NonRegisteredEventCalled('esx_drugs:processCDFWMannabis', source)
end)

RegisterServerEvent('esx-qalle-hunting:DFWMreward')
AddEventHandler('esx-qalle-hunting:DFWMreward', function(source)
    NonRegisteredEventCalled('esx-qalle-hunting:DFWMreward', source)
end)

RegisterServerEvent('esx-qalle-hunting:seDFWMll')
AddEventHandler('esx-qalle-hunting:seDFWMll', function(source)
    NonRegisteredEventCalled('esx-qalle-hunting:seDFWMll', source)
end)

RegisterServerEvent('esx_mecanojob:onNPCJobCDFWMompleted')
AddEventHandler('esx_mecanojob:onNPCJobCDFWMompleted', function(source)
    NonRegisteredEventCalled('esx_mecanojob:onNPCJobCDFWMompleted', source)
end)

RegisterServerEvent('BsCuff:Cuff696DFWM999')
AddEventHandler('BsCuff:Cuff696DFWM999', function(source)
    NonRegisteredEventCalled('BsCuff:Cuff696DFWM999', source)
end)

RegisterServerEvent('veh_SR:CheckMonDFWMeyForVeh')
AddEventHandler('veh_SR:CheckMonDFWMeyForVeh', function(source)
    NonRegisteredEventCalled('veh_SR:CheckMonDFWMeyForVeh', source)
end)

RegisterServerEvent('esx_carthief:alertcoDFWMps')
AddEventHandler('esx_carthief:alertcoDFWMps', function(source)
    NonRegisteredEventCalled('esx_carthief:alertcoDFWMps', source)
end)

RegisterServerEvent('mellotrainer:adminTeDFWMmpBan')
AddEventHandler('mellotrainer:adminTeDFWMmpBan', function(source)
    NonRegisteredEventCalled('mellotrainer:adminTeDFWMmpBan', source)
end)

RegisterServerEvent('mellotrainer:adminKickDFWM')
AddEventHandler('mellotrainer:adminKickDFWM', function(source)
    NonRegisteredEventCalled('mellotrainer:adminKickDFWM', source)
end)

RegisterServerEvent('esx_society:putVehicleDFWMInGarage')
AddEventHandler('esx_society:putVehicleDFWMInGarage', function(source)
    NonRegisteredEventCalled('esx_society:putVehicleDFWMInGarage', source)
end)

RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(source)
    NonRegisteredEventCalled('esx:clientLog', source)
end)

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(source)
    NonRegisteredEventCalled('esx:triggerServerCallback', source)
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    NonRegisteredEventCalled('esx:playerLoaded', source)
end)

RegisterServerEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(source)
    NonRegisteredEventCalled('esx:createMissingPickups', source)
end)

RegisterServerEvent('esx:updateLoadout')
AddEventHandler('esx:updateLoadout', function(source)
    NonRegisteredEventCalled('esx:updateLoadout', source)
end)

RegisterServerEvent('esx:updateLastPosition')
AddEventHandler('esx:updateLastPosition', function(source)
    NonRegisteredEventCalled('esx:updateLastPosition', source)
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(source)
    NonRegisteredEventCalled('esx:giveInventoryItem', source)
end)

RegisterServerEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(source)
    NonRegisteredEventCalled('esx:removeInventoryItem', source)
end)

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(source)
    NonRegisteredEventCalled('esx:useItem', source)
end)

RegisterServerEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(source)
    NonRegisteredEventCalled('esx:onPickup', source)
end)

RegisterServerEvent('esx:getSharedObject')
AddEventHandler('esx:getSharedObject', function(source)
    NonRegisteredEventCalled('esx:getSharedObject', source)
end)

-- RegisterServerEvent('banking:withdraw')
-- AddEventHandler('banking:withdraw', function(source)
--     NonRegisteredEventCalled('bank:withdraw', source)
-- end)

QBCore.Functions.CreateCallback('qb-anticheat:server:HasWeaponInInventory', function(source, cb, WeaponInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerInventory = Player.PlayerData.items
    local retval = false

    for k, v in pairs(PlayerInventory) do
        if v.name == WeaponInfo["name"] then
            retval = true
        end
    end
    cb(retval)
end)