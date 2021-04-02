MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local VehicleStatus = {}
local VehicleDrivingDistance = {}

MSCore.Functions.CreateCallback('ms-food:server:GetDrivingDistances', function(source, cb)
    cb(VehicleDrivingDistance)
end)

RegisterServerEvent("vehiclemod:server:setupVehicleStatus")
AddEventHandler("vehiclemod:server:setupVehicleStatus", function(plate, engineHealth, bodyHealth)
    local src = source
    local engineHealth = engineHealth ~= nil and engineHealth or 1000.0
    local bodyHealth = bodyHealth ~= nil and bodyHealth or 1000.0
    if VehicleStatus[plate] == nil then 
        if IsVehicleOwned(plate) then
            local statusInfo = GetVehicleStatus(plate)
            if statusInfo == nil then 
                statusInfo =  {
                    ["food"] = engineHealth,
                }
            end
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        else
            local statusInfo = {
                ["food"] = engineHealth,
            }
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        end
    else
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('ms-food:server:UpdateDrivingDistance')
AddEventHandler('ms-food:server:UpdateDrivingDistance', function(amount, plate)
    VehicleDrivingDistance[plate] = amount

    TriggerClientEvent('ms-food:client:UpdateDrivingDistance', -1, VehicleDrivingDistance[plate], plate)

    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            MSCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `drivingdistance` = '"..amount.."' WHERE `plate` = '"..plate.."'")
        end
    end)
end)

MSCore.Functions.CreateCallback('ms-food:server:IsVehicleOwned', function(source, cb, plate)
    local retval = false
    MSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
        cb(retval)
    end)
end)

RegisterServerEvent('ms-food:server:LoadStatus')
AddEventHandler('ms-food:server:LoadStatus', function(veh, plate)
    VehicleStatus[plate] = veh
    TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, veh)
end)

RegisterServerEvent("vehiclemod:server:updatePart")
AddEventHandler("vehiclemod:server:updatePart", function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        if part == "engine" or part == "body" then
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 1000 then
                VehicleStatus[plate][part] = 1000.0
            end
        else
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 100 then
                VehicleStatus[plate][part] = 100
            end
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('ms-food:server:SetPartLevel')
AddEventHandler('ms-food:server:SetPartLevel', function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        VehicleStatus[plate][part] = level
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

-- RegisterServerEvent("vehiclemod:server:fixEverything")
-- AddEventHandler("vehiclemod:server:fixEverything", function(plate)
    -- if VehicleStatus[plate] ~= nil then 
        -- for k, v in pairs(Config.MaxStatusValues) do
            -- VehicleStatus[plate][k] = v
        -- end
        -- TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    -- end
-- end)

RegisterServerEvent("vehiclemod:server:saveStatus")
AddEventHandler("vehiclemod:server:saveStatus", function(plate)
    if VehicleStatus[plate] ~= nil then
        exports['ghmattimysql']:execute('UPDATE player_vehicles SET status = @status WHERE plate = @plate', {['@status'] = json.encode(VehicleStatus[plate]), ['@plate'] = plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    MSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end

function GetVehicleStatus(plate)
    local retval = nil
    MSCore.Functions.ExecuteSql(true, "SELECT `status` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = result[1].status ~= nil and json.decode(result[1].status) or nil
        end
    end)
    return retval
end

MSCore.Commands.Add("setvehiclestatus", "Zet vehicle status", {{name="part", help="Type status dat je wilt bewerken"}, {name="amount", help="Level van de status"}}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    TriggerClientEvent("vehiclemod:client:setPartLevel", source, part, level)
end, "god")

MSCore.Commands.Add("repair", "Repair Vehicle", {{name="part", help="Part you want to repair"}, {name="Number", help="Number Levels"}}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    local needAmount = level
    if part == "body" then
        needAmount = tonumber(level / 10)
        if needAmount <= 0 then needAmount = 1 end
    end
    local Player = MSCore.Functions.GetPlayer(source)

    if Player.PlayerData.job.name == "food" or Player.PlayerData.job.name == "food1" or Player.PlayerData.job.name == "food2" then
        local neededItem = Player.Functions.GetItemByName(Config.RepairCost[part])
        if neededItem ~= nil and neededItem.amount >= needAmount then 
            TriggerClientEvent("vehiclemod:client:repairPart", source, part, level, needAmount)
        else
            if neededItem == nil then 
                TriggerClientEvent('MSCore:Notify', source, "You are missing " .. level .. " " .. MSCore.Shared.Items[Config.RepairCost[part]]["label"] , "error", 5000)
            else
                TriggerClientEvent('MSCore:Notify', source, "You are missing " .. (level - neededItem.amount) .. " " .. MSCore.Shared.Items[Config.RepairCost[part]]["label"] , "error", 5000)
            end
        end
    else
        TriggerClientEvent('MSCore:Notify', source, "You are not a food!", "error", 5000)
    end
end)

MSCore.Commands.Add("vehstatus", "Krijg vehicle status", {}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)

    if Player.PlayerData.job.name == "food" or Player.PlayerData.job.name == "food1" or Player.PlayerData.job.name == "food2" then
        TriggerClientEvent("vehiclemod:client:getVehicleStatus", source)
    end
end)

MSCore.Functions.CreateCallback('ms-food:server:GetAttachedVehicle', function(source, cb)
    cb(Config.Plates)
end)

MSCore.Functions.CreateCallback('ms-food:server:IsfoodAvailable', function(source, cb)
	local amount = 0
	for k, v in pairs(MSCore.Functions.GetPlayers()) do
        local Player = MSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "food" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

RegisterServerEvent('ms-food:server:SetAttachedVehicle')
AddEventHandler('ms-food:server:SetAttachedVehicle', function(veh, k)
    if veh ~= false then
        Config.Plates[k].AttachedVehicle = veh
        TriggerClientEvent('ms-food:client:SetAttachedVehicle', -1, veh, k)
    else
        Config.Plates[k].AttachedVehicle = nil
        TriggerClientEvent('ms-food:client:SetAttachedVehicle', -1, false, k)
    end
end)

RegisterServerEvent('ms-food:server:CheckForItems')
AddEventHandler('ms-food:server:CheckForItems', function(part)
    local src = source
    local Player = MSCore.Functions.GetPlayer(src)
    local RepairPart = Player.Functions.GetItemByName(Config.RepairCostAmount[part].item)

    if RepairPart ~= nil then
        if RepairPart.amount >= Config.RepairCostAmount[part].costs then
            TriggerClientEvent('ms-food:client:RepaireeePart', src, part)
            Player.Functions.RemoveItem(Config.RepairCostAmount[part].item, Config.RepairCostAmount[part].costs)

            for i = 1, Config.RepairCostAmount[part].costs, 1 do
                TriggerClientEvent('inventory:client:ItemBox', src, MSCore.Shared.Items[Config.RepairCostAmount[part].item], "remove")
                Citizen.Wait(500)
            end
        else
            TriggerClientEvent('MSCore:Notify', src, "You don't have enough "..MSCore.Shared.Items[Config.RepairCostAmount[part].item]["label"].." (min. "..Config.RepairCostAmount[part].costs.."x)", "error")
        end
    else
        TriggerClientEvent('MSCore:Notify', src, "You do not have "..MSCore.Shared.Items[Config.RepairCostAmount[part].item]["label"].." bij je!", "error")
    end
end)

function IsAuthorized(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AuthorizedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

MSCore.Commands.Add("setfood", "Give someone a food job", {{name="id", help="ID of a player"}}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = MSCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                TargetData.Functions.SetJob("food")
                TriggerClientEvent('MSCore:Notify', TargetData.PlayerData.source, "You are hired as food")
                TriggerClientEvent('MSCore:Notify', source, "You Have ("..TargetData.PlayerData.charinfo.firstname..") hired as food employee!")
            end
        else
            TriggerClientEvent('MSCore:Notify', source, "You must provide a Player ID!")
        end
    else
        TriggerClientEvent('MSCore:Notify', source, "You can't do this!", "error") 
    end
end)

MSCore.Commands.Add("takefood", "Take someone's food job", {{name="id", help="ID of a player"}}, false, function(source, args)
    local Player = MSCore.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = MSCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                if TargetData.PlayerData.job.name == "food" then
                    TargetData.Functions.SetJob("unemployed")
                    TriggerClientEvent('MSCore:Notify', TargetData.PlayerData.source, "You have been fired from the job")
                    TriggerClientEvent('MSCore:Notify', source, "("..TargetData.PlayerData.charinfo.firstname..") You have been fired from the job")
                else
                    TriggerClientEvent('MSCore:Notify', source, "he/she is not a food", "error")
                end
            end
        else
            TriggerClientEvent('MSCore:Notify', source, "You must provide a Player ID!", "error")
        end
    else
        TriggerClientEvent('MSCore:Notify', source, "You can't do this!", "error")
    end
end)

MSCore.Functions.CreateCallback('ms-food:server:GetStatus', function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)