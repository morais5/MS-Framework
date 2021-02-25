QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

RegisterServerEvent('qb-traphouses:server:TakeoverHouse')
AddEventHandler('qb-traphouses:server:TakeoverHouse', function(Traphouse)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if not HasCitizenIdHasKey(CitizenId, Traphouse) then
        if Player.Functions.RemoveMoney('cash', Config.TakeoverPrice) then
            TriggerClientEvent('qb-traphouses:client:TakeoverHouse', src, Traphouse)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You dont have enough cash..', 'error')
        end
    end
end)

RegisterServerEvent('qb-traphouses:server:AddHouseKeyHolder')
AddEventHandler('qb-traphouses:server:AddHouseKeyHolder', function(CitizenId, TraphouseId, IsOwner)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Config.TrapHouses[TraphouseId] ~= nil then
        if IsOwner then
            Config.TrapHouses[TraphouseId].keyholders = {}
            Config.TrapHouses[TraphouseId].pincode = math.random(1111, 4444) 
        end

        if Config.TrapHouses[TraphouseId].keyholders == nil then
            table.insert(Config.TrapHouses[TraphouseId].keyholders, {
                citizenid = CitizenId,
                owner = IsOwner,
            })
            TriggerClientEvent('qb-traphouses:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
        else
            if #Config.TrapHouses[TraphouseId].keyholders + 1 <= 6 then
                if not HasCitizenIdHasKey(CitizenId, TraphouseId) then
                    table.insert(Config.TrapHouses[TraphouseId].keyholders, {
                        citizenid = CitizenId,
                        owner = IsOwner,
                    })
                    TriggerClientEvent('qb-traphouses:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'There arent any slots over..')
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Error has occurred..')
    end
end)

function HasCitizenIdHasKey(CitizenId, Traphouse)
    local retval = false
    if Config.TrapHouses[Traphouse].keyholders ~= nil and next(Config.TrapHouses[Traphouse].keyholders) ~= nil then
        for _, data in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if data.citizenid == CitizenId then
                retval = true
                break
            end
        end
    end
    return retval
end

function AddKeyHolder(CitizenId, Traphouse, IsOwner)
    if IsOwner then
        Config.TrapHouses[Traphouse].keyholders = {}
    end
    if #Config.TrapHouses[Traphouse].keyholders <= 6 then
        if not HasCitizenIdHasKey(CitizenId, Traphouse) then
            table.insert(Config.TrapHouses[Traphouse].keyholders, {
                citizenid = CitizenId,
                owner = IsOwner,
            })
        end
    end
end

function HasTraphouseAndOwner(CitizenId)
    local retval = nil
    for Traphouse,_ in pairs(Config.TrapHouses) do
        for k, v in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if v.citizenid == CitizenId then
                if v.owner then
                    retval = Traphouse
                end
            end
        end
    end
    return retval
end

QBCore.Commands.Add("entertraphouse", "Betreed traphouse", {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
 
    TriggerClientEvent('qb-traphouses:client:EnterTraphouse', src)
end)

QBCore.Commands.Add("givetrapkeys", "Give's the keys of the trap house", {{name = "id", help = "Speler id"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local TargetId = tonumber(args[1])
    local TargetData = QBCore.Functions.GetPlayer(TargetId)
    local IsOwner = false
    local Traphouse = HasTraphouseAndOwner(Player.PlayerData.citizenid)

    if TargetData ~= nil then
        if Traphouse ~= nil then
            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                if Config.TrapHouses[Traphouse] ~= nil then
                    if IsOwner then
                        Config.TrapHouses[Traphouse].keyholders = {}
                        Config.TrapHouses[Traphouse].pincode = math.random(1111, 4444) 
                    end
            
                    if Config.TrapHouses[Traphouse].keyholders == nil then
                        table.insert(Config.TrapHouses[Traphouse].keyholders, {
                            citizenid = TargetData.PlayerData.citizenid,
                            owner = IsOwner,
                        })
                        TriggerClientEvent('qb-traphouses:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                    else
                        if #Config.TrapHouses[Traphouse].keyholders + 1 <= 6 then
                            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                                table.insert(Config.TrapHouses[Traphouse].keyholders, {
                                    citizenid = TargetData.PlayerData.citizenid,
                                    owner = IsOwner,
                                })
                                TriggerClientEvent('qb-traphouses:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                            end
                        else
                            TriggerClientEvent('QBCore:Notify', src, 'there arent any slots left over..')
                        end
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Error has occurred..')
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'This person already owns a key..', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'You dont own the trap house or you dont own one at all..', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'This person is not online..', 'error')
    end
end)

RegisterServerEvent('qb-traphouses:server:TakeMoney')
AddEventHandler('qb-traphouses:server:TakeMoney', function(TraphouseId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.TrapHouses[TraphouseId].money ~= 0 then
        Player.Functions.AddMoney('cash', Config.TrapHouses[TraphouseId].money)
        Config.TrapHouses[TraphouseId].money = 0
        TriggerClientEvent('qb-traphouses:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
    else
        TriggerClientEvent('QBCore:Notify', src, 'There issent any money in the cupboard', 'error')
    end
end)

function SellTimeout(traphouseId, slot, itemName, amount, info)
    Citizen.CreateThread(function()
        if itemName == "markedbills" then
            SetTimeout(math.random(1000, 5000), function()
                if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                    RemoveHouseItem(traphouseId, slot, itemName, 1)
                    Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + math.ceil(info.worth / 100 * 80)
                    TriggerClientEvent('qb-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                end
            end)
        else
            for i = 1, amount, 1 do
                local SellData = Config.AllowedItems[itemName]
                SetTimeout(SellData.wait, function()
                    if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                        RemoveHouseItem(traphouseId, slot, itemName, 1)
                        Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + SellData.reward
                        TriggerClientEvent('qb-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                    end
                end)
                if amount > 1 then
                    Citizen.Wait(SellData.wait)
                end
            end
        end
    end)
end

function AddHouseItem(traphouseId, slot, itemName, amount, info, source)
    local amount = tonumber(amount)
    traphouseId = tonumber(traphouseId)
    if Config.TrapHouses[traphouseId].inventory[slot] ~= nil and Config.TrapHouses[traphouseId].inventory[slot].name == itemName then
        Config.TrapHouses[traphouseId].inventory[slot].amount = Config.TrapHouses[traphouseId].inventory[slot].amount + amount
    else
        local itemInfo = QBCore.Shared.Items[itemName:lower()]
        Config.TrapHouses[traphouseId].inventory[slot] = {
            name = itemInfo["name"],
            amount = amount,
            info = info ~= nil and info or "",
            label = itemInfo["label"],
            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
            weight = itemInfo["weight"], 
            type = itemInfo["type"], 
            unique = itemInfo["unique"], 
            useable = itemInfo["useable"], 
            image = itemInfo["image"],
            slot = slot,
        }
    end
    SellTimeout(traphouseId, slot, itemName, amount, info)
    TriggerClientEvent('qb-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
end

function RemoveHouseItem(traphouseId, slot, itemName, amount)
	local amount = tonumber(amount)
    traphouseId = tonumber(traphouseId)
	if Config.TrapHouses[traphouseId].inventory[slot] ~= nil and Config.TrapHouses[traphouseId].inventory[slot].name == itemName then
		if Config.TrapHouses[traphouseId].inventory[slot].amount > amount then
			Config.TrapHouses[traphouseId].inventory[slot].amount = Config.TrapHouses[traphouseId].inventory[slot].amount - amount
		else
			Config.TrapHouses[traphouseId].inventory[slot] = nil
			if next(Config.TrapHouses[traphouseId].inventory) == nil then
				Config.TrapHouses[traphouseId].inventory = {}
			end
		end
	else
		Config.TrapHouses[traphouseId].inventory[slot] = nil
		if Config.TrapHouses[traphouseId].inventory == nil then
			Config.TrapHouses[traphouseId].inventory[slot] = nil
		end
	end
    TriggerClientEvent('qb-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
end

function GetInventoryData(traphouse, slot)
    traphouse = tonumber(traphouse)
    if Config.TrapHouses[traphouse].inventory[slot] ~= nil then
        return Config.TrapHouses[traphouse].inventory[slot]
    else
        return nil
    end
end

function CanItemBeSaled(item)
    local retval = false
    if Config.AllowedItems[item] ~= nil then
        retval = true
    elseif item == "markedbills" then
        retval = true
    end
    return retval
end

RegisterServerEvent('qb-traphouses:server:RobNpc')
AddEventHandler('qb-traphouses:server:RobNpc', function(Traphouse)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Chance = math.random(1, 10)
    local odd = math.random(1, 10)
    
    if Chance == odd then
        local info = {
            label = "Traphouse Pincode: "..Config.TrapHouses[Traphouse].pincode
        }
        Player.Functions.AddItem("stickynote", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["stickynote"], "add")
    else
        local amount = math.random(1, 80)
        Player.Functions.AddMoney('cash', amount)
    end
end)

QBCore.Functions.CreateCallback('qb-traphouses:server:GetTraphousesData', function(source, cb)
    cb(Config.TrapHouses)
end)