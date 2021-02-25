QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

QBCore.Functions.CreateCallback('qb-weed:server:getBuildingPlants', function(source, cb, building)
    local buildingPlants = {}

    exports['ghmattimysql']:execute('SELECT * FROM house_plants WHERE building = @building', {['@building'] = building}, function(plants)
        for i = 1, #plants, 1 do
            table.insert(buildingPlants, plants[i])
        end

        if buildingPlants ~= nil then
            cb(buildingPlants)
        else    
            cb(nil)
        end
    end)
end)

QBCore.Commands.Add("plaatsplant", "", {}, false, function(source, args)
    local src           = source
    local player        = QBCore.Functions.GetPlayer(src)
    local type          = args[1]

    if QBWeed.Plants[type] ~= nil then
        TriggerClientEvent('qb-weed:client:placePlant', src, type)
    end
end)

RegisterServerEvent('qb-weed:server:placePlant')
AddEventHandler('qb-weed:server:placePlant', function(currentHouse, coords, sort)
    local random = math.random(1, 2)
    local gender
    if random == 1 then gender = "man" else gender = "woman" end

    QBCore.Functions.ExecuteSql(true, "INSERT INTO `house_plants` (`building`, `coords`, `gender`, `sort`, `plantid`) VALUES ('"..currentHouse.."', '"..coords.."', '"..gender.."', '"..sort.."', '"..math.random(111111,999999).."')")
    TriggerClientEvent('qb-weed:client:refreshHousePlants', -1, currentHouse)
end)

RegisterServerEvent('qb-weed:server:removeDeathPlant')
AddEventHandler('qb-weed:server:removeDeathPlant', function(building, plantId)
    QBCore.Functions.ExecuteSql(true, "DELETE FROM `house_plants` WHERE plantid = '"..plantId.."' AND building = '"..building.."'")
    TriggerClientEvent('qb-weed:client:refreshHousePlants', -1, building)
end)

Citizen.CreateThread(function()
    while true do
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `house_plants`", function(housePlants)
            for k, v in pairs(housePlants) do
                if housePlants[k].food >= 50 then
                    QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '"..(housePlants[k].food - 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    if housePlants[k].health + 1 < 100 then
                        QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `health` = '"..(housePlants[k].health + 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    end
                end

                if housePlants[k].food < 50 then
                    if housePlants[k].food - 1 >= 0 then
                        QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '"..(housePlants[k].food - 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    end
                    if housePlants[k].health - 1 >= 0 then
                        QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `health` = '"..(housePlants[k].health - 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    end
                end
            end

            TriggerClientEvent('qb-weed:client:refreshPlantStats', -1)
        end)

        Citizen.Wait((60 * 1000) * 19.2)
    end
end)

Citizen.CreateThread(function()
    while true do
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `house_plants`", function(housePlants)
            for k, v in pairs(housePlants) do
                if housePlants[k].health > 50 then
                    local Grow = math.random(1, 3)
                    if housePlants[k].progress + Grow < 100 then
                        QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `progress` = '"..(housePlants[k].progress + 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    elseif housePlants[k].progress + Grow >= 100 then
                        if housePlants[k].stage ~= QBWeed.Plants[housePlants[k].sort]["highestStage"] then
                            if housePlants[k].stage == "stage-a" then
                                QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-b' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-b" then
                                QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-c' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-c" then
                                QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-d' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-d" then
                                QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-e' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-e" then
                                QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-f' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-f" then
                                QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-g' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            end
                            QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `progress` = '0' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                        end
                    end
                end
            end

            TriggerClientEvent('qb-weed:client:refreshPlantStats', -1)
        end)

        Citizen.Wait((60 * 1000) * 9.6)
    end
end)

QBCore.Functions.CreateUseableItem("weed_white-widow_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-weed:client:placePlant', source, 'white-widow', item)
end)

QBCore.Functions.CreateUseableItem("weed_skunk_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-weed:client:placePlant', source, 'skunk', item)
end)

QBCore.Functions.CreateUseableItem("weed_purple-haze_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-weed:client:placePlant', source, 'purple-haze', item)
end)

QBCore.Functions.CreateUseableItem("weed_og-kush_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-weed:client:placePlant', source, 'og-kush', item)
end)

QBCore.Functions.CreateUseableItem("weed_amnesia_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-weed:client:placePlant', source, 'amnesia', item)
end)

QBCore.Functions.CreateUseableItem("weed_ak47_seed", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-weed:client:placePlant', source, 'ak47', item)
end)

QBCore.Functions.CreateUseableItem("weed_nutrition", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-weed:client:foodPlant', source, item)
end)

RegisterServerEvent('qb-weed:server:removeSeed')
AddEventHandler('qb-weed:server:removeSeed', function(itemslot, seed)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(seed, 1, itemslot)
end)

RegisterServerEvent('qb-weed:server:harvestPlant')
AddEventHandler('qb-weed:server:harvestPlant', function(house, amount, plantName, plantId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local weedBag = Player.Functions.GetItemByName('empty_weed_bag')
    local sndAmount = math.random(12, 16)

    if weedBag ~= nil then
        if weedBag.amount >= sndAmount then
            if house ~= nil then 
                QBCore.Functions.ExecuteSql(false, "SELECT * FROM `house_plants` WHERE plantid = '"..plantId.."' AND building = '"..house.."'", function(result)
                    if result[1] ~= nil then
                        Player.Functions.AddItem('weed_'..plantName..'_seed', amount)
                        Player.Functions.AddItem('weed_'..plantName, sndAmount)
                        Player.Functions.RemoveItem('empty_weed_bag', 1)
                        QBCore.Functions.ExecuteSql(true, "DELETE FROM `house_plants` WHERE plantid = '"..plantId.."' AND building = '"..house.."'")
                        TriggerClientEvent('QBCore:Notify', src, 'A planta é colhida', 'success', 3500)
                        TriggerClientEvent('qb-weed:client:refreshHousePlants', -1, house)
                    else
                        TriggerClientEvent('QBCore:Notify', src, 'Esta planta não existe mais', 'error', 3500)
                    end
                end)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Casa não encontrada', 'error', 3500)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Você não tem sacolas suficientes', 'error', 3500)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Você não tem bolsas', 'error', 3500)
    end
end)

RegisterServerEvent('qb-weed:server:foodPlant')
AddEventHandler('qb-weed:server:foodPlant', function(house, amount, plantName, plantId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, 'SELECT * FROM `house_plants` WHERE `building` = "'..house..'" AND `sort` = "'..plantName..'" AND `plantid` = "'..tostring(plantId)..'"', function(plantStats)
        TriggerClientEvent('QBCore:Notify', src, QBWeed.Plants[plantName]["label"]..' | Nutrition: '..plantStats[1].food..'% + '..amount..'% ('..(plantStats[1].food + amount)..'%)', 'success', 3500)
        if plantStats[1].food + amount > 100 then
            QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '100' WHERE `building` = '"..house.."' AND `plantid` = '"..plantId.."'")
        else
            QBCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '"..(plantStats[1].food + amount).."' WHERE `building` = '"..house.."' AND `plantid` = '"..plantId.."'")
        end
        Player.Functions.RemoveItem('weed_nutrition', 1)
        TriggerClientEvent('qb-weed:client:refreshHousePlants', -1, house)
    end)
end)