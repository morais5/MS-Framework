QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local doorInfo = {}

RegisterServerEvent('qb-doorlock:server:setupDoors')
AddEventHandler('qb-doorlock:server:setupDoors', function()
	local src = source
	TriggerClientEvent("qb-doorlock:client:setDoors", QB.Doors)
end)

RegisterServerEvent('qb-doorlock:server:updateState')
AddEventHandler('qb-doorlock:server:updateState', function(doorID, state)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	
	QB.Doors[doorID].locked = state

	TriggerClientEvent('qb-doorlock:client:setState', -1, doorID, state)
end)


QBCore.Functions.CreateCallback('qb-doorlock:server:GetItem', function(source, cb, item)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if Player ~= nil then 
    local RadioItem = Player.Functions.GetItemByName(item)
    if RadioItem ~= nil then
      cb(true)
    else
      cb(false)
    end
  else
    cb(false)
  end
end)