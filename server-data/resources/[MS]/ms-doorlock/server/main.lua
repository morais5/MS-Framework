MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

local doorInfo = {}

RegisterServerEvent('ms-doorlock:server:setupDoors')
AddEventHandler('ms-doorlock:server:setupDoors', function()
	local src = source
	TriggerClientEvent("ms-doorlock:client:setDoors", ms.Doors)
end)

RegisterServerEvent('ms-doorlock:server:updateState')
AddEventHandler('ms-doorlock:server:updateState', function(doorID, state)
	local src = source
	local Player = MSCore.Functions.GetPlayer(src)
	
	ms.Doors[doorID].locked = state

	TriggerClientEvent('ms-doorlock:client:setState', -1, doorID, state)
end)


MSCore.Functions.CreateCallback('ms-doorlock:server:GetItem', function(source, cb, item)
  local src = source
  local Player = MSCore.Functions.GetPlayer(src)
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