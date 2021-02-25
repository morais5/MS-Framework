local isLoggedIn = true
local housePlants = {}
local insideHouse = false
local currentHouse = nil

QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

QBWeed.DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('qb-weed:client:getHousePlants')
AddEventHandler('qb-weed:client:getHousePlants', function(house)    
    QBCore.Functions.TriggerCallback('qb-weed:server:getBuildingPlants', function(plants)
        currentHouse = house
        housePlants[currentHouse] = plants
        insideHouse = true
        spawnHousePlants()
    end, house)
end)

function spawnHousePlants()
    Citizen.CreateThread(function()
        if not plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                    ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                }

                plantProp = CreateObject(plantData["plantProp"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
                FreezeEntityPosition(plantProp, true)
                SetEntityAsMissionEntity(plantProp, false, false)
                PlaceObjectOnGroundProperly(plantProp)
                Citizen.Wait(20)
                PlaceObjectOnGroundProperly(plantProp)
            end
            plantSpawned = true
        end
    end)
end

function despawnHousePlants()
    Citizen.CreateThread(function()
        if plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                }

                for _, stage in pairs(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"]) do
                    local closestPlant = GetClosestObjectOfType(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 3.5, GetHashKey(stage), false, false, false)
                    if closestPlant ~= 0 then                    
                        DeleteObject(closestPlant)
                    end
                end
            end
            plantSpawned = false
        end
    end)
end

local ClosestTarget = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if insideHouse then
            if plantSpawned then
                local ped = GetPlayerPed(-1)
                for k, v in pairs(housePlants[currentHouse]) do
                    local gender = "M"
                    if housePlants[currentHouse][k].gender == "woman" then gender = "V" end

                    local plantData = {
                        ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                        ["plantStage"] = housePlants[currentHouse][k].stage,
                        ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                        ["plantSort"] = {
                            ["name"] = housePlants[currentHouse][k].sort,
                            ["label"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["label"],
                        },
                        ["plantStats"] = {
                            ["food"] = housePlants[currentHouse][k].food,
                            ["health"] = housePlants[currentHouse][k].health,
                            ["progress"] = housePlants[currentHouse][k].progress,
                            ["stage"] = housePlants[currentHouse][k].stage,
                            ["highestStage"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["highestStage"],
                            ["gender"] = gender,
                            ["plantId"] = housePlants[currentHouse][k].plantid,
                        }
                    }

                    local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)

                    if plyDistance < 0.8 then

                        ClosestTarget = k
                        if plantData["plantStats"]["health"] > 0 then
                            if plantData["plantStage"] ~= plantData["plantStats"]["highestStage"] then
                                QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Genero: '..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | INFO: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Saúde: ~b~'..plantData["plantStats"]["health"]..'%')
                            else
                                QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"] + 0.2, 'A planta esta pronta ~g~E~w~ para colher..')
                                QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Genero: ~g~'..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | INFO: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Saúde: ~b~'..plantData["plantStats"]["health"]..'%')
                                if IsControlJustPressed(0, QBWeed.Keys["E"]) then
                                    QBCore.Functions.Progressbar("remove_weed_plant", "A iniciar o cultivo", 8000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = "amb@world_human_gardener_plant@male@base",
                                        anim = "base",
                                        flags = 16,
                                    }, {}, {}, function() -- Done
                                        ClearPedTasks(ped)
                                        if plantData["plantStats"]["gender"] == "M" then
                                            amount = math.random(1, 5)
                                        else
                                            amount = math.random(3, 8)
                                        end
                                        TriggerServerEvent('qb-weed:server:harvestPlant', currentHouse, amount, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                                    end, function() -- Cancel
                                        ClearPedTasks(ped)
                                        QBCore.Functions.Notify("Processo Cancelado", "error")
                                    end)
                                end
                            end
                        elseif plantData["plantStats"]["health"] == 0 then
                            QBWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'A planta secou, ~r~E~w~ - Para remover.')
                            if IsControlJustPressed(0, QBWeed.Keys["E"]) then
                                QBCore.Functions.Progressbar("remove_weed_plant", "Remover planta", 8000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "amb@world_human_gardener_plant@male@base",
                                    anim = "base",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('qb-weed:server:removeDeathPlant', currentHouse, plantData["plantStats"]["plantId"])
                                end, function() -- Cancel
                                    ClearPedTasks(ped)
                                    QBCore.Functions.Notify("Processo cancelado", "error")
                                end)
                            end
                        end
                    end
                end
            end
        end

        if not insideHouse then
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('qb-weed:client:leaveHouse')
AddEventHandler('qb-weed:client:leaveHouse', function()
    despawnHousePlants()
    SetTimeout(1000, function()
        if currentHouse ~= nil then
            insideHouse = false
            housePlants[currentHouse] = nil
            currentHouse = nil
        end
    end)
end)

RegisterNetEvent('qb-weed:client:refreshHousePlants')
AddEventHandler('qb-weed:client:refreshHousePlants', function(house)
    if currentHouse ~= nil and currentHouse == house then
        despawnHousePlants()
        SetTimeout(500, function()
            QBCore.Functions.TriggerCallback('qb-weed:server:getBuildingPlants', function(plants)
                currentHouse = house
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, house)
        end)
    end
end)

RegisterNetEvent('qb-weed:client:refreshPlantStats')
AddEventHandler('qb-weed:client:refreshPlantStats', function()
    if insideHouse then
        despawnHousePlants()
        SetTimeout(500, function()
            QBCore.Functions.TriggerCallback('qb-weed:server:getBuildingPlants', function(plants)
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, currentHouse)
        end)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

RegisterNetEvent('qb-weed:client:placePlant')
AddEventHandler('qb-weed:client:placePlant', function(type, item)
    local ped = GetPlayerPed(-1)
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.75, 0)
    local plantData = {
        ["plantCoords"] = {["x"] = plyCoords.x, ["y"] = plyCoords.y, ["z"] = plyCoords.z},
        ["plantModel"] = QBWeed.Plants[type]["stages"]["stage-a"],
        ["plantLabel"] = QBWeed.Plants[type]["label"]
    }
    local ClosestPlant = 0
    for k, v in pairs(QBWeed.Props) do
        if ClosestPlant == 0 then
            ClosestPlant = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 0.8, GetHashKey(v), false, false, false)
        end
    end

    if currentHouse ~= nil then
        if ClosestPlant == 0 then
            QBCore.Functions.Progressbar("plant_weed_plant", "Planting the plant", 8000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb@world_human_gardener_plant@male@base",
                anim = "base",
                flags = 16,
            }, {}, {}, function() -- Done
                ClearPedTasks(ped)
                plantObject = CreateObject(plantData["plantModel"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
                FreezeEntityPosition(plantObject, true)
                SetEntityAsMissionEntity(plantObject, false, false)
                PlaceObjectOnGroundProperly(plantObject)
            
                TriggerServerEvent('qb-weed:server:placePlant', currentHouse, json.encode(plantData["plantCoords"]), type)
                TriggerServerEvent('qb-weed:server:removeSeed', item.slot, type)
            end, function() -- Cancel
                ClearPedTasks(ped)
                QBCore.Functions.Notify("Processo cancelado.", "error")
            end)
        else
            QBCore.Functions.Notify('Não tens espaço para a planta.', 'error', 3500)
        end
    else
        QBCore.Functions.Notify("Não é seguro fazeres isso aqui.", 'error', 3500)
    end
end)

RegisterNetEvent('qb-weed:client:foodPlant')
AddEventHandler('qb-weed:client:foodPlant', function(item)
    local plantData = {}
    if currentHouse ~= nil then
        if ClosestTarget ~= 0 then
            local ped = GetPlayerPed(-1)
            local gender = "M"
            if housePlants[currentHouse][ClosestTarget].gender == "woman" then 
                gender = "V" 
            end

            plantData = {
                ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).x, ["y"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).y, ["z"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).z},
                ["plantStage"] = housePlants[currentHouse][ClosestTarget].stage,
                ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["stages"][housePlants[currentHouse][ClosestTarget].stage]),
                ["plantSort"] = {
                    ["name"] = housePlants[currentHouse][ClosestTarget].sort,
                    ["label"] = QBWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["label"],
                },
                ["plantStats"] = {
                    ["food"] = housePlants[currentHouse][ClosestTarget].food,
                    ["health"] = housePlants[currentHouse][ClosestTarget].health,
                    ["progress"] = housePlants[currentHouse][ClosestTarget].progress,
                    ["stage"] = housePlants[currentHouse][ClosestTarget].stage,
                    ["highestStage"] = QBWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["highestStage"],
                    ["gender"] = gender,
                    ["plantId"] = housePlants[currentHouse][ClosestTarget].plantid,
                }
            }
            local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)

            if plyDistance < 1.0 then
                if plantData["plantStats"]["food"] == 100 then
                    QBCore.Functions.Notify('A planta não precisa de ser regada.', 'error', 3500)
                else
                    QBCore.Functions.Progressbar("plant_weed_plant", "'A regar a planta.", math.random(4000, 8000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "timetable@gardener@filling_can",
                        anim = "gar_ig_5_filling_can",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        ClearPedTasks(ped)
                        local newFood = math.random(40, 60)
                        TriggerServerEvent('qb-weed:server:foodPlant', currentHouse, newFood, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                    end, function() -- Cancel
                        ClearPedTasks(ped)
                        QBCore.Functions.Notify("Processo cancelado", "error")
                    end)
                end
            else
                QBCore.Functions.Notify("Sem espaço para a planta.", "error")
            end
        else
            QBCore.Functions.Notify("Sem espaço para a planta.", "error")
        end
    end
end)