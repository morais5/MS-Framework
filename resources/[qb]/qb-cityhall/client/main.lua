Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local inCityhallPage = false
local qbCityhall = {}

qbCityhall.Open = function()
    SendNUIMessage({
        action = "open"
    })
    SetNuiFocus(true, true)
    inCityhallPage = true
end

qbCityhall.Close = function()
    SendNUIMessage({
        action = "close"
    })
    SetNuiFocus(false, false)
    inCityhallPage = false
end

qbCityhall.DrawText3Ds = function(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    inCityhallPage = false
end)

local inRange = false

Citizen.CreateThread(function()
    CityhallBlip = AddBlipForCoord(Config.Cityhall.coords.x, Config.Cityhall.coords.y, Config.Cityhall.coords.z)

    SetBlipSprite (CityhallBlip, 487)
    SetBlipDisplay(CityhallBlip, 4)
    SetBlipScale  (CityhallBlip, 0.65)
    SetBlipAsShortRange(CityhallBlip, true)
    SetBlipColour(CityhallBlip, 0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Camara Municipal")
    EndTextCommandSetBlipName(CityhallBlip)
end)
local creatingCompany = false
local currentName = nil
Citizen.CreateThread(function()
    while true do

        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        inRange = false

        local dist = GetDistanceBetweenCoords(pos, Config.Cityhall.coords.x, Config.Cityhall.coords.y, Config.Cityhall.coords.z, true)
        --local dist2 = GetDistanceBetweenCoords(pos, Config.DrivingSchool.coords.x, Config.DrivingSchool.coords.y, Config.DrivingSchool.coords.z, true) eu comentei isto

        if dist < 20 then
            inRange = true
            DrawMarker(2, Config.Cityhall.coords.x, Config.Cityhall.coords.y, Config.Cityhall.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 152, 234, 155, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(pos, Config.Cityhall.coords.x, Config.Cityhall.coords.y, Config.Cityhall.coords.z, true) < 1.5 then
                qbCityhall.DrawText3Ds(Config.Cityhall.coords, '~g~E~w~ - Interagir com o sujeito')
                if IsControlJustPressed(0, Keys["E"]) then
                    qbCityhall.Open()
                end
            end
            --DrawMarker(2, Config.DriverTest.coords.x, Config.DriverTest.coords.y, Config.DriverTest.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 155, 152, 234, 155, false, false, false, true, false, false, false)--eu comentei isto
                --if GetDistanceBetweenCoords(pos, Config.DriverTest.coords.x, Config.DriverTest.coords.y, Config.DriverTest.coords.z, true) < 1.5 then--eu comentei isto
                    if creatingCompany then
                        qbCityhall.DrawText3Ds(Config.DriverTest.coords, '~g~E~w~ - Criar empresa (€'..Config.CompanyPrice..') | ~r~G~w~ - Parar')
                        if IsControlJustPressed(0, Keys["E"]) then
                            TriggerServerEvent("qb-companies:server:createCompany", currentName)
                            creatingCompany = false
                        end
                        if IsControlJustPressed(0, Keys["G"]) then
                            creatingCompany = false
                        end
                    else
                    --[[if IsControlJustPressed(0, Keys["G"]) then
                        QBCore.Functions.Notify("Voer een bedrijfsnaam in..", false, 10000)
                        DisplayOnscreenKeyboard(1, "Naam", "", "Naam", "", "", "", 128 + 1)
                        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                            Citizen.Wait(7)
                        end
                        currentName = GetOnscreenKeyboardResult()
                        if currentName ~= nil and currentName ~= "" then
                            creatingCompany = true
                        end
                    end]]--
                --end--eu comentei
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(2)
    end
end)

--[[RegisterNetEvent('qb-cityhall:client:sendDriverEmail')--eu comentei isto
AddEventHandler('qb-cityhall:client:sendDriverEmail', function(charinfo)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "Senhor"
        if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Senhora"
        end
        local charinfo = QBCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Governo",
            subject = "Aulas de Condução",
            message = "Olá " .. gender .. " " .. charinfo.lastname .. ",<br /><br />Recebemos uma mensagem que alguem quer ter aulas de condução.<br />Se estas disposto a ensinar, contactem:<br />Nome: <strong>".. charinfo.firstname .. " " .. charinfo.lastname .. "</strong><br />Nº Telemovel: <strong>"..charinfo.phone.."</strong><br/><br/>Cumprimentos,<br />Governo Los Santos",
            button = {}
        })
    end)
end)--]]

local idTypes = {
    ["id-kaart"] = {
        label = "Cartão de Cidadão",
        item = "id_card"
    },
    ["rijbewijs"] = {
        label = "Carta de condução",
        item = "driver_license"
    }
}

RegisterNUICallback('requestId', function(data)
    if inRange then
        local idType = data.idType

        TriggerServerEvent('qb-cityhall:server:requestId', idTypes[idType])
    else
        QBCore.Functions.Notify('Não é possivel...', 'error')
    end
end)

RegisterNUICallback('requestLicenses', function(data, cb)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local licensesMeta = PlayerData.metadata["licences"]
    local availableLicenses = {}

    for type,_ in pairs(licensesMeta) do
        if licensesMeta[type] then
            local licenseType = nil
            local label = nil

            if type == "driver" then licenseType = "rijbewijs" label = "Carta de Condução" end

            table.insert(availableLicenses, {
                idType = licenseType,
                label = label
            })
        end
    end
    cb(availableLicenses)
end)

local AvailableJobs = {
    "trucker",
    "taxi",
   -- "tow",
    "reporter",
    "garbage",
}

function IsAvailableJob(job)
    local retval = false
    for k, v in pairs(AvailableJobs) do
        if v == job then
            retval = true
        end
    end
    return retval
end

RegisterNUICallback('applyJob', function(data)
    if inRange then
        if IsAvailableJob(data.job) then
            TriggerServerEvent('qb-cityhall:server:ApplyJob', data.job)
        else
            TriggerServerEvent('qb-cityhall:server:banPlayer')
            TriggerServerEvent("qb-log:server:CreateLog", "anticheat", "POST Request (Abuse)", "red", "** @everyone " ..GetPlayerName(player).. "** has been banned from abusing localhost: 13172, sending POST request\'s")         
        end
    else
        QBCore.Functions.Notify('Não é possivel...', 'error')
    end
end)