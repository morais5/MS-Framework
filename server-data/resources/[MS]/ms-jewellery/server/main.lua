MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

-- Code

local timeOut = false

local alarmTriggered = false

RegisterServerEvent('ms-jewellery:server:setVitrineState')
AddEventHandler('ms-jewellery:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('ms-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterServerEvent('ms-jewellery:server:vitrineReward')
AddEventHandler('ms-jewellery:server:vitrineReward', function()
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('MSCore:Notify', src, 'Youre ..', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("10kgoldchain", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items["10kgoldchain"], 'add')
        else
            TriggerClientEvent('MSCore:Notify', src, 'Youre loading a lot..', 'error')
        end
    end
end)

RegisterServerEvent('ms-jewellery:server:setTimeout')
AddEventHandler('ms-jewellery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('ms-scoreboard:server:SetActivityBusy', "jewellery", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('ms-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('ms-jewellery:client:setAlertState', -1, false)
                TriggerEvent('ms-scoreboard:server:SetActivityBusy', "jewellery", false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

RegisterServerEvent('ms-jewellery:server:PoliceAlertMessage')
AddEventHandler('ms-jewellery:server:PoliceAlertMessage', function(title, coords, blip)
    local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Possible theft occurring at Joalheria Vangelico <br> Cameras available: 31, 32, 33, 34",
    }

    for k, v in pairs(MSCore.Functions.GetPlayers()) do
        local Player = MSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("ms-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("ms-jewellery:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("ms-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("ms-jewellery:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

MSCore.Functions.CreateCallback('ms-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(MSCore.Functions.GetPlayers()) do
        local Player = MSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)