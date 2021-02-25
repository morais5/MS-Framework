local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}
QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

local carryPackage = nil
---- MARKERS BINNEN/BUITEN/INKLOKKEN/AUTO
local onDuty = false
Citizen.CreateThread(function ()
    local RecycleBlip = AddBlipForCoord(Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z)
    SetBlipSprite(RecycleBlip, 365)
    SetBlipColour(RecycleBlip, 2)
    SetBlipScale(RecycleBlip, 0.8)
    SetBlipAsShortRange(RecycleBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Centro de Reciclagem")
    EndTextCommandSetBlipName(RecycleBlip)
    while true do
        Citizen.Wait(7)
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        ---- BUITEN
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z, true) < 1.3 then
            DrawText3D(Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z + 1, "~g~E~w~ - Entrar no armazém")
            if IsControlJustReleased(0, Keys["E"]) then
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end
                SetEntityCoords(GetPlayerPed(-1), Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z)
                DoScreenFadeIn(500)
            end
        end
        ---- BINNEN
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z, true) < 15 and not IsPedInAnyVehicle(GetPlayerPed(-1), false) and not onDuty then
            DrawMarker(25, Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 98, 102, 185,100, 0, 0, 0,0)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z, true) < 1.3 then
                DrawText3D(Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z + 1, "~g~E~w~ - Sair do armazém")
                if IsControlJustReleased(0, Keys["E"]) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(GetPlayerPed(-1), Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z + 1)
                    DoScreenFadeIn(500)
                end
            end
        end
        ---- INKLOKKEN
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 15 and not IsPedInAnyVehicle(GetPlayerPed(-1), false) and carryPackage == nil then
            DrawMarker(25, 1049.15,-3100.63,-39.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 255, 0, 0,100, 0, 0, 0,0)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 1.3 then
                if onDuty then
                    DrawText3D(1049.15,-3100.63,-39.95 + 1, "~g~E~w~ - Sair de serviço")
                else
                    DrawText3D(1049.15,-3100.63,-39.95 + 1, "~g~E~w~ - Entrar de serviço")
                end
                if IsControlJustReleased(0, Keys["E"]) then
                    onDuty = not onDuty
                    if onDuty then
                        QBCore.Functions.Notify("Entraste de serviço")
                    else
                        QBCore.Functions.Notify("Saiste de serviço!", "error")
                    end
                end
            end
        end
    end
end)

local packagePos = nil
Citizen.CreateThread(function ()
    for k, pickuploc in pairs(Config['delivery'].pickupLocations) do
        local model = GetHashKey(Config['delivery'].warehouseObjects[math.random(1, #Config['delivery'].warehouseObjects)])
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end
        local obj = CreateObject(model, pickuploc.x, pickuploc.y, pickuploc.z, false, true, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end
    while true do
        Citizen.Wait(7)
        if onDuty then
            if packagePos ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1), true)
                if carryPackage == nil then
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, packagePos.x,packagePos.y,packagePos.z, true) < 2.3 then
                        DrawText3D(packagePos.x,packagePos.y,packagePos.z+ 1, "~g~E~w~ - Pegar na caixa")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_BUM_BIN", 0, true)
                            QBCore.Functions.Progressbar("pickup_reycle_package", "A pegar na caixa..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                                ClearPedTasks(GetPlayerPed(-1))
                                PickupPackage()
                            end)
                        end
                    else
                        DrawText3D(packagePos.x, packagePos.y, packagePos.z + 1, "Caixa")
                    end
                else
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, true) < 2.0 then
                        DrawText3D(Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, "~g~E~w~ - Entregar Caixa")
                        if IsControlJustReleased(0, Keys["E"]) then
                            DropPackage()
                            ScrapAnim()
                            QBCore.Functions.Progressbar("deliver_reycle_package", "A entregar a caixa..", 5000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                TriggerServerEvent('qb-recycle:server:getItem')
                                GetRandomPackage()
                            end)
                        end
                    else
                        DrawText3D(Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, "Entregar")
                    end
                end
            else
                GetRandomPackage()
            end
        end
    end
end)

function ScrapAnim()
    local time = 5
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function GetRandomPackage()
    local randSeed = math.random(1, #Config["delivery"].pickupLocations)
    packagePos = {}
    packagePos.x = Config["delivery"].pickupLocations[randSeed].x
    packagePos.y = Config["delivery"].pickupLocations[randSeed].y
    packagePos.z = Config["delivery"].pickupLocations[randSeed].z
end

function PickupPackage()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_cs_cardbox_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

function DropPackage()
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(carryPackage, true, true)
    DeleteObject(carryPackage)
    carryPackage = nil
end