Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = true

        local PaletoDist = GetDistanceBetweenCoords(pos, Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], true)
        local PacificDist = GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], true)

        if PaletoDist < 15 then
            inRange = true
            if Config.BigBanks["paleto"]["isOpened"] then
                TriggerServerEvent('qb-doorlock:server:updateState', 85, false)
                local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
            
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].open)
                end
            else
                TriggerServerEvent('qb-doorlock:server:updateState', 85, true)
                local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
            
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].closed)
                end
            end
        end

        -- Pacific Check
        if PacificDist < 50 then
            inRange = true
            if Config.BigBanks["pacific"]["isOpened"] then
                local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["pacific"]["heading"].open)
                end
            else
                local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
                if object ~= 0 then
                    SetEntityHeading(object, Config.BigBanks["pacific"]["heading"].closed)
                end
            end
        end

        if not inRange then
            Citizen.Wait(5000)
        end

        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('qb-bankrobbery:client:ClearTimeoutDoors')
AddEventHandler('qb-bankrobbery:client:ClearTimeoutDoors', function()
    TriggerServerEvent('qb-doorlock:server:updateState', 85, true)
    local PaletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
    if PaletoObject ~= 0 then
        SetEntityHeading(PaletoObject, Config.BigBanks["paleto"]["heading"].closed)
    end

    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    if object ~= 0 then
        SetEntityHeading(object, Config.BigBanks["pacific"]["heading"].closed)
    end

    for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
        Config.BigBanks["pacific"]["lockers"][k]["isBusy"] = false
        Config.BigBanks["pacific"]["lockers"][k]["isOpened"] = false
    end

    for k, v in pairs(Config.BigBanks["paleto"]["lockers"]) do
        Config.BigBanks["paleto"]["lockers"][k]["isBusy"] = false
        Config.BigBanks["paleto"]["lockers"][k]["isOpened"] = false
    end

    Config.BigBanks["paleto"]["isOpened"] = false
    Config.BigBanks["pacific"]["isOpened"] = false
end)