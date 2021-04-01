QBCore = nil

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

local InstanceList = {}
local CurrentInstance = nil

RegisterNetEvent('instances:client:JoinInstance')
AddEventHandler('instances:client:JoinInstance', function(name, type)
    TriggerServerEvent("instances:server:JoinInstance", name, type)
    CurrentInstance = name
end)

RegisterNetEvent('instances:client:LeaveInstance')
AddEventHandler('instances:client:LeaveInstance', function()
    TriggerServerEvent("instances:server:LeaveInstance", CurrentInstance)
    CurrentInstance = nil
end)

RegisterNetEvent('instances:client:UpdateInstanceList')
AddEventHandler('instances:client:UpdateInstanceList', function(name, val)
    InstanceList[name] = val
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (CurrentInstance ~= nil) then 
            for _, player in ipairs(GetActivePlayers()) do
                if (InstanceList[CurrentInstance] ~= nil and InstanceList[CurrentInstance].players[GetPlayerServerId(player)] == nil) then
                    local ped = GetPlayerPed(player)
                    SetEntityLocallyInvisible(GetPlayerPed(player))
					SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(player), true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if InWorld ~= 0 then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			RemoveVehiclesFromGeneratorsInArea(pos.x - 100.0, pos.y - 100.0, pos.z - 100.0, pos.x + 100.0, pos.y + 100.0, pos.z + 100.0)
		end
	end
end)