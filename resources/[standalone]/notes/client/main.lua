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
local Notes = {}
local NotesNear = {}
local closestNote = 0
local currentNote = 0
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if NotesNear ~= nil then
            for k, v in pairs(NotesNear) do
                if v ~= nil then
                    DrawMarker(25, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.3, 0.3, 0.3, 200, 200, 200, 100, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if closestNote ~= 0 then
            if Notes[closestNote] ~= nil and not Notes[closestNote].active then 
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Notes[closestNote].coords.x, Notes[closestNote].coords.y, Notes[closestNote].coords.z, true) < 1.5 then
                    DrawText3D(Notes[closestNote].coords.x, Notes[closestNote].coords.y, Notes[closestNote].coords.z, "~g~E~w~ - Ler Nota ~g~G~w~ - Rasgar Nota")
                    if IsControlJustReleased(0, Keys["E"]) then
                        TriggerServerEvent("notes:server:OpenNoteData", closestNote)
                    end
                    if IsControlJustReleased(0, Keys["G"]) then
                        TriggerServerEvent("notes:server:RemoveNoteData", closestNote)
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Notes ~= nil and next(Notes) ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                for k, v in pairs(Notes) do
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 and not v.active then
                        NotesNear[k] = v
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 1.5 then
                            closestNote = k
                        end
                    else
                        NotesNear[k] = nil
                    end
                end
            end
        else
            NotesNear = {}
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("notes:client:OpenNotepad")
AddEventHandler("notes:client:OpenNotepad", function(noteId, text)
    if currentNote == 0 then
        TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
        currentNote = noteId
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            text = text,
            noteid = noteId,
        })
    end
end)

RegisterNetEvent("notes:client:SetActiveStatus")
AddEventHandler("notes:client:SetActiveStatus", function(noteId, status)
    Notes[noteId].active = status
end)

RegisterNetEvent("notes:client:AddNoteDrop")
AddEventHandler("notes:client:AddNoteDrop", function(noteId, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(-1))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Notes[noteId] = {
        id = noteId,
        coords = {
            x = x,
            y = y,
            z = z - 0.98,
        },
        active = false,
    }
end)

RegisterNetEvent("notes:client:RemoveNote")
AddEventHandler("notes:client:RemoveNote", function(noteId)
    Notes[noteId] = nil
    NotesNear[noteId] = nil
end)

RegisterNUICallback("DropNote", function(data, cb)
    TriggerServerEvent("notes:server:SaveNoteData", data.text, data.noteid)
end)

RegisterNUICallback("CloseNotepad", function(data, cb)
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    currentNote = 0
    SetNuiFocus(false, false)
    if data ~= nil and data.noteid ~= nil then
        TriggerServerEvent("notes:server:SetActiveStatus", data.noteid, false)
    end
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 600
    DrawRect(0.0, 0.0+0.0105, 0.015+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end