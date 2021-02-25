AvailableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'CLEARING', 
    'RAIN', 
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

AvailableTimeTypes = {
    'MORNING',
    'NOON',
    'EVENING',
    'NIGHT',
}

local CurrentWeather = "EXTRASUNNY"
local DynamicWeather = false
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false

QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

RegisterServerEvent('qb-weathersync:server:RequestStateSync')
AddEventHandler('qb-weathersync:server:RequestStateSync', function()
    TriggerClientEvent('qb-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('qb-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

function FreezeElement(element)
    if element == 'weather' then
        DynamicWeather = not DynamicWeather
    else
        freezeTime = not freezeTime
    end
end

RegisterServerEvent('qb-weathersync:server:setWeather')
AddEventHandler('qb-weathersync:server:setWeather', function(type)
    local src = source
    if src ~= nil then
        TriggerEvent("qb-log:server:CreateLog", "weather", "Changed weather", "red", "**".. GetPlayerName(src) .. "**")
    end
    CurrentWeather = string.upper(type)
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end)

RegisterServerEvent('qb-weathersync:server:toggleBlackout')
AddEventHandler('qb-weathersync:server:toggleBlackout', function()
    ToggleBlackout()
end)

RegisterServerEvent('qb-weathersync:server:setTime')
AddEventHandler('qb-weathersync:server:setTime', function(hour, minute)
    SetExactTime(hour, minute)
end)

function SetWeather(type)
    CurrentWeather = string.upper(type)
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end

function SetTime(type)
    if type:upper() == AvailableTimeTypes[1] then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    elseif type:upper() == AvailableTimeTypes[2] then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    elseif type:upper() == AvailableTimeTypes[3] then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    else
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    end
end

function SetExactTime(hour, minute)
    local argh = tonumber(hour)
    local argm = tonumber(minute)
    if argh < 24 then
        ShiftToHour(argh)
    else
        ShiftToHour(0)
    end
    if argm < 60 then
        ShiftToMinute(argm)
    else
        ShiftToMinute(0)
    end
    local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
    local minute = math.floor((baseTime+timeOffset)%60)
    if minute < 10 then
        newtime = newtime .. "0" .. minute
    else
        newtime = newtime .. minute
    end
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end

function ToggleBlackout()
    blackout = not blackout
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("qb-weathersync:server:RequestStateSync")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        TriggerClientEvent('qb-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('qb-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1800000)
        if DynamicWeather then
            NextWeatherStage()
        end
    end
end)

QBCore.Commands.Add("sneeuwbal", "Picking up snowball", {}, false, function(source, args)
    if CurrentWeather == "XMAS" then
        TriggerClientEvent("inventory:client:PickupSnowballs", source)
    else
        TriggerClientEvent('QBCore:Notify', source, "Not the right time of the year :(", "error")
    end
end)