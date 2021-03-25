--------------------------------
------- Edited by Captainrum89 -------
-------------------------------- 

QBCore = nil

local cooldownTimer = {}

local ItemTable = {
    "markedbills",
    "10kgoldchain",
    "goldbar",
    "rolex",
	"diamond_ring",
}

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- server side for cooldown timer
RegisterServerEvent("ks-TruckRobbery:missionCooldown")
AddEventHandler("ks-TruckRobbery:missionCooldown",function(source)
	table.insert(cooldownTimer,{CoolTimer = GetPlayerIdentifier(source), time = (Config.CooldownTimer * 60000)}) -- cooldown timer for doing missions
end)

-- thread for syncing the cooldown timer
Citizen.CreateThread(function() -- do not touch this thread function!
	while true do
	Citizen.Wait(1000)
		for k,v in pairs(cooldownTimer) do
			if v.time <= 0 then
				RemoveCooldownTimer(v.CoolTimer)
			else
				v.time = v.time - 1000
			end
		end
	end
end)

QBCore.Functions.CreateCallback('ks-TruckRobbery:server:Hasbomb', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("tijdbom")

    if Item ~= nil then
        cb(true)
    else
        cb(false)
    end
end)



QBCore.Functions.CreateUseableItem("sdkaart", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('tablet') ~= nil then
		TriggerClientEvent("ks-TruckRobbery:hackertje",source,0)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
      Player.Functions.RemoveItem('sdkaart', 1)
	else
        TriggerClientEvent('QBCore:Notify', source, "Você precisa de um tablet..", "error")
    end
end)

-- sync mission data
RegisterServerEvent("ks-TruckRobbery:syncMissionData")
AddEventHandler("ks-TruckRobbery:syncMissionData",function(data)
	TriggerClientEvent("ks-TruckRobbery:syncMissionData",-1,data)
end)

QBCore.Functions.CreateUseableItem("tijdbom", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent("ks-TruckRobbery:UsableItem",source)

end)

-- mission reward
RegisterServerEvent('ks-TruckRobbery:missionComplete')
AddEventHandler('ks-TruckRobbery:missionComplete', function()
    local src = source
    local item = {}
    local Player = QBCore.Functions.GetPlayer(src)
    local gotID = {}
    local rolls = math.random(1, 3)

    for i = 1, rolls do
        item = ItemTable[math.random(1, #ItemTable)]
        for i = 1, math.random(3, 4), 1 do
            local randItem = ItemTable[math.random(1, #ItemTable)]
            local amount = math.random(3, 5)
            TriggerClientEvent('QBCore:Notify', src, 'Garimpeiro..', 'success')
            Player.Functions.AddItem(randItem, amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add')
            Citizen.Wait(500)
			local luck = math.random(10, 80)
			if luck <= 10 then
			    Player.Functions.AddItem("bluechip", math.random(1, 2))
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bluechip"], "add")
			end
			
        end
    end
end)

RegisterServerEvent('ks-TruckRobbery:TruckRobberyInProgress')
AddEventHandler('ks-TruckRobbery:TruckRobberyInProgress', function(targetCoords, streetName)
	TriggerClientEvent('ks-TruckRobbery:outlawNotify', -1,string.format(Config.DispatchMessage,streetName))
	TriggerClientEvent('ks-TruckRobbery:TruckRobberyInProgress', -1, targetCoords)
end)

-- DO NOT TOUCH!!
function RemoveCooldownTimer(source)
	for k,v in pairs(cooldownTimer) do
		if v.CoolTimer == source then
			table.remove(cooldownTimer,k)
		end
	end
end
-- DO NOT TOUCH!!
function GetCooldownTimer(source)
	for k,v in pairs(cooldownTimer) do
		if v.CoolTimer == source then
			return math.ceil(v.time/60000)
		end
	end
end
-- DO NOT TOUCH!!
function CheckCooldownTimer(source)
	for k,v in pairs(cooldownTimer) do
		if v.CoolTimer == source then
			return true
		end
	end
	return false
end

