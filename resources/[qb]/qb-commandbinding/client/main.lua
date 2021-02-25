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

local keyPressed = false
local isLoggedIn = false

local inKeyBinding = false
local availableKeys = {
    "F5",
    "F6",
    "F7",
    "F9",
    "F10",
}

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
end)

function openBindingMenu()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local keyMeta = PlayerData.metadata["commandbinds"]
    SendNUIMessage({
        action = "openBinding",
        keyData = keyMeta
    })
    inKeyBinding = true
    SetNuiFocus(true, true)
    SetCursorLocation(0.5, 0.5)
end

function closeBindingMenu()
    inKeyBinding = false
    SetNuiFocus(false, false)
end

RegisterNUICallback('close', closeBindingMenu)

RegisterNetEvent('qb-commandbinding:client:openUI')
AddEventHandler('qb-commandbinding:client:openUI', function()
    openBindingMenu()
end)

Citizen.CreateThread(function()
    while true do

        if isLoggedIn then
            for k, v in pairs(availableKeys) do
                if IsControlJustPressed(0, Keys[v]) or IsDisabledControlJustPressed(0, Keys[v]) then
                    local keyMeta = QBCore.Functions.GetPlayerData().metadata["commandbinds"]
                    local args = {}
                    if next(keyMeta) ~= nil then
                        if keyMeta[v]["command"] ~= "" then
                            if keyMeta[v]["argument"] ~= "" then args = {[1] = keyMeta[v]["argument"]} else args = {[1] = nil} end
                            TriggerServerEvent('QBCore:CallCommand', keyMeta[v]["command"], args)
                            keyPressed = true
                        else
                            QBCore.Functions.Notify('Ainda não tens nada bindado ao ['..v..'] , /binds para bindares um comando', 'primary', 4000)
                        end
                    else
                        QBCore.Functions.Notify('Indica um comando, /binds para bindares', 'primary', 4000)
                    end
                end
            end

            if keyPressed then
                Citizen.Wait(1000)
                keyPressed = false
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNUICallback('save', function(data)
    local keyData = {
        ["F2"]  = {["command"] = data.keyData["F2"][1],  ["argument"] = data.keyData["F2"][2]},
        ["F3"]  = {["command"] = data.keyData["F3"][1],  ["argument"] = data.keyData["F3"][2]},
        ["F5"]  = {["command"] = data.keyData["F5"][1],  ["argument"] = data.keyData["F5"][2]},
        ["F6"]  = {["command"] = data.keyData["F6"][1],  ["argument"] = data.keyData["F6"][2]},
        ["F7"]  = {["command"] = data.keyData["F7"][1],  ["argument"] = data.keyData["F7"][2]},
        ["F9"]  = {["command"] = data.keyData["F9"][1],  ["argument"] = data.keyData["F9"][2]},
        ["F10"] = {["command"] = data.keyData["F10"][1], ["argument"] = data.keyData["F10"][2]},
    }

    QBCore.Functions.Notify('Salvaste as tuas binds!', 'success')

    TriggerServerEvent('qb-commandbinding:server:setKeyMeta', keyData)
end)