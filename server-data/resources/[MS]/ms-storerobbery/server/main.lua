MSCore = nil

TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local SafeCodes = {}

Citizen.CreateThread(function()
    while true do 
        SafeCodes = {
            [1] = math.random(1000, 9999),
            [2] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [3] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [4] = math.random(1000, 9999),
            [5] = math.random(1000, 9999),
            [6] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [7] = math.random(1000, 9999),
            [8] = math.random(1000, 9999),
            [9] = math.random(1000, 9999),
            [10] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [11] = math.random(1000, 9999),
            [12] = math.random(1000, 9999),
            [13] = math.random(1000, 9999),
            [14] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [15] = math.random(1000, 9999),
            [16] = math.random(1000, 9999),
            [17] = math.random(1000, 9999),
            [18] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [19] = math.random(1000, 9999),
        }
        Citizen.Wait((1000 * 60) * 40)
    end
end)

RegisterServerEvent('ms-storerobbery:server:takeMoney')
AddEventHandler('ms-storerobbery:server:takeMoney', function(register, isDone)
    local src   = source
    local Player = MSCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', math.random(25, 69), "robbery-store")
    if isDone then
        if math.random(1, 100) <= 17 then
            local code = SafeCodes[Config.Registers[register].safeKey]
            local info = {}
            if Config.Safes[Config.Registers[register].safeKey].type == "keypad" then
                info = {
                    label = "Codigo: "..tostring(code)
                }
            else
                info = {
                    label = "Codigo: "..tostring(math.floor((code[1] % 360) / 3.60)).."-"..tostring(math.floor((code[2] % 360) / 3.60)).."-"..tostring(math.floor((code[3] % 360) / 3.60)).."-"..tostring(math.floor((code[4] % 360) / 3.60)).."-"..tostring(math.floor((code[5] % 360) / 3.60))
                }
            end
            Player.Functions.AddItem("stickynote", 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items["stickynote"], "add")
        end
    end
end)

RegisterServerEvent('ms-storerobbery:server:setRegisterStatus')
AddEventHandler('ms-storerobbery:server:setRegisterStatus', function(register)
    TriggerClientEvent('ms-storerobbery:client:setRegisterStatus', -1, register, true)
    Config.Registers[register].robbed   = true
    Config.Registers[register].time     = Config.resetTime
end)

RegisterServerEvent('ms-storerobbery:server:setSafeStatus')
AddEventHandler('ms-storerobbery:server:setSafeStatus', function(safe)
    TriggerClientEvent('ms-storerobbery:client:setSafeStatus', -1, safe, true)
    Config.Safes[safe].robbed = true

    SetTimeout(math.random(40, 80) * (60 * 1000), function()
        TriggerClientEvent('ms-storerobbery:client:setSafeStatus', -1, safe, false)
        Config.Safes[safe].robbed = false
    end)
end)

RegisterServerEvent('ms-storerobbery:server:SafeReward')
AddEventHandler('ms-storerobbery:server:SafeReward', function(safe)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(1000, 3000), "robbery-safe-reward")
    local luck = math.random(1, 100)
    local odd = math.random(1, 100)
    if luck <= 10 then
        Player.Functions.AddItem("rolex", math.random(3, 7))
        TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items["rolex"], "add")
        if luck == odd then
            Citizen.Wait(500)
            Player.Functions.AddItem("goldbar", math.random(1, 2))
            TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items["goldbar"], "add")
        end
    end
end)

RegisterServerEvent('ms-storerobbery:server:callCops')
AddEventHandler('ms-storerobbery:server:callCops', function(type, safe, streetLabel, coords)
    local cameraId = 4
    if type == "safe" then
        cameraId = Config.Safes[safe].camId
    else
        cameraId = Config.Registers[safe].camId
    end
    local alertData = {
        title = "Shop robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Someone is trying to rob a store at "..streetLabel.." (CAMERA ID: "..cameraId..")"
    }
    TriggerClientEvent("ms-storerobbery:client:robberyCall", -1, type, safe, streetLabel, coords)
    TriggerClientEvent("ms-phone:client:addPoliceAlert", -1, alertData)
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Registers) do
            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                Config.Registers[k].time = 0
                Config.Registers[k].robbed = false
                TriggerClientEvent('ms-storerobbery:client:setRegisterStatus', -1, k, false)
            end
        end
        Citizen.Wait(Config.tickInterval)
    end
end)

MSCore.Functions.CreateCallback('ms-storerobbery:server:isCombinationRight', function(source, cb, safe)
    cb(SafeCodes[safe])
end)

MSCore.Functions.CreateCallback('ms-storerobbery:server:getPadlockCombination', function(source, cb, safe)
    cb(SafeCodes[safe])
end)

MSCore.Functions.CreateCallback('ms-storerobbery:server:getRegisterStatus', function(source, cb)
    cb(Config.Registers)
end)

MSCore.Functions.CreateCallback('ms-storerobbery:server:getSafeStatus', function(source, cb)
    cb(Config.Safes)
end)