QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local hiddenprocess = vector3(-331.7995, -2444.753, 7.358099) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords
local hiddenstart = vector3(2122.41, 4784.58, 40.93469) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords


RegisterNetEvent('coke:updateTable')
AddEventHandler('coke:updateTable', function(bool)
    TriggerClientEvent('coke:syncTable', -1, bool)
end)

-- Hidden Coords to prevent cheaters from finding hidden locations

QBCore.Functions.CreateCallback('coke:processcoords', function(source, cb)
    cb(hiddenprocess)
end)

QBCore.Functions.CreateCallback('coke:startcoords', function(source, cb)
    cb(hiddenstart)
end)


QBCore.Functions.CreateCallback('coke:process', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("coke_brick")

    if Item ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('coke:jerrycheck', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("jerrycan")

    if Item ~= nil then
        cb(true)
    else
        cb(false)
    end
end)


QBCore.Functions.CreateCallback('coke:pay', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local price = Config.price
	local check = Player.PlayerData.money.cash
	if check >= price then
		Player.Functions.RemoveMoney('cash', price, "cash-removed"..Player.PlayerData.citizenid)
    	cb(true)
    else
    	cb(false)
    end
end)

QBCore.Functions.CreateUseableItem("coke_small_brick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        Player.Functions.AddItem("cokebaggy", math.random(20, 30))
    end
end)

RegisterServerEvent("coke:processed")
AddEventHandler("coke:processed", function(x,y,z)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem("coke_small_brick", math.random(8, 11))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["coke_small_brick"], 'add')
end)


-- Gives item upon delivery

RegisterServerEvent("coke:GiveItem")
AddEventHandler("coke:GiveItem", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
      Player.Functions.AddItem('coke_brick', 2)
end)

-- Removes coke brick after processing

RegisterServerEvent("coke:RemoveItem")
AddEventHandler("coke:RemoveItem", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
      Player.Functions.RemoveItem('coke_brick', 1)
end)

--Gives jerry after completing the task

RegisterServerEvent("coke:GiveJerry")
AddEventHandler("coke:GiveJerry", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
      Player.Functions.AddItem('jerrycan', 1)
end)

--Removes Jerry Can after fueling the plane

RegisterServerEvent("coke:RemoveJerry")
AddEventHandler("coke:RemoveJerry", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
      Player.Functions.RemoveItem('jerrycan', 1)
end)
