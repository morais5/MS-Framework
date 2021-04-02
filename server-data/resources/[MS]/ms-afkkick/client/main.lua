-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 1800

-- Load MSCore
MSCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if MSCore == nil then
            TriggerEvent("MSCore:GetObject", function(obj) MSCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local group = "user"
local isLoggedIn = false

RegisterNetEvent('MSCore:Client:OnPlayerLoaded')
AddEventHandler('MSCore:Client:OnPlayerLoaded', function()
    MSCore.Functions.TriggerCallback('ms-afkkick:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('MSCore:Client:OnPermissionUpdate')
AddEventHandler('MSCore:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

-- Code
Citizen.CreateThread(function()
	while true do
		Wait(1000)
        playerPed = GetPlayerPed(-1)
        if isLoggedIn then
            if group == "user" then
                currentPos = GetEntityCoords(playerPed, true)
                if prevPos ~= nil then
                    if currentPos == prevPos then
                        if time ~= nil then
                            if time > 0 then
                                if time == (900) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)
                                elseif time == (600) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)
                                elseif time == (300) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)
                                elseif time == (150) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)   
                                elseif time == (60) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000) 
                                elseif time == (30) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. time .. ' seconds kicked!', 'error', 10000)  
                                elseif time == (20) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. time .. ' seconds kicked!', 'error', 10000)    
                                elseif time == (10) then
                                    MSCore.Functions.Notify('You are AFK and you are about to be ' .. time .. ' seconds kicked!', 'error', 10000)                                                                                                             
                                end
                                time = time - 1
                            else
                                TriggerServerEvent("KickForAFK")
                            end
                        else
                            time = secondsUntilKick
                        end
                    else
                        time = secondsUntilKick
                    end
                end
                prevPos = currentPos
            end
        end
    end
end)