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

local HasKey = false
local LastVehicle = nil
local IsHotwiring = false
local IsRobbing = false
local isLoggedIn = false
local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local AlertSend = false

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
        Citizen.Wait(5)

        if QBCore ~= nil then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), true), -1) == GetPlayerPed(-1) then
                local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
                if LastVehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false) then
                    QBCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
                        if result then
                            HasKey = true
                            SetVehicleEngineOn(veh, true, false, true)
                        else
                            HasKey = false
                            SetVehicleEngineOn(veh, false, false, true)
                        end
                        LastVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    end, plate)
                end
            else
                if SucceededAttempts ~= 0 then
                    SucceededAttempts = 0
                end
                if NeededAttempts ~= 0 then
                    NeededAttempts = 0
                end
                if FailedAttemps ~= 0 then
                    FailedAttemps = 0
                end
            end
        end

        if not HasKey and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) and QBCore ~= nil and not IsHotwiring then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleEngineOn(veh, false, false, true)
            --[[local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local vehpos = GetOffsetFromEntityInWorldCoords(veh, 0, 1.5, 0.5)
            QBCore.Functions.DrawText3D(vehpos.x, vehpos.y, vehpos.z, "~g~H~w~ - Hotwire")
            SetVehicleEngineOn(veh, false, false, true)

            if IsControlJustPressed(0, Keys["H"]) then
                Hotwire()
            end]]--
        end

        if IsControlJustPressed(1, Keys["L"]) then
            LockVehicle()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if not IsRobbing and isLoggedIn and QBCore ~= nil then
            if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil and GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= 0 then
                local vehicle = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
                local driver = GetPedInVehicleSeat(vehicle, -1)
                if driver ~= 0 and not IsPedAPlayer(driver) then
                    if IsEntityDead(driver) then
                        IsRobbing = true
                        QBCore.Functions.Progressbar("rob_keys", "A pegar nas chaves do veiculo..", 3000, false, true, {}, {}, {}, {}, function() -- Done
                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                            HasKey = true
                            IsRobbing = false
                        end)
                    end
                end
            end

            --[[if QBCore.Functions.GetPlayerData().job.name ~= "police" then
                local aiming, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if aiming and (target ~= nil and target ~= 0) then
                    if DoesEntityExist(target) and not IsPedAPlayer(target) then
                        if IsPedInAnyVehicle(target, false) and not IsPedInAnyVehicle(GetPlayerPed(-1), false ) then
                            if not IsBlacklistedWeapon() then
                                local pos = GetEntityCoords(GetPlayerPed(-1), true)
                                local targetpos = GetEntityCoords(target, true)
                                local vehicle = GetVehiclePedIsIn(target, true)
                                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, targetpos.x, targetpos.y, targetpos.z, true) < 13.0 then
                                    RobVehicle(target)
                                end
                            end
                        end
                    end
                end
            end]]--
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('vehiclekeys:client:SetOwner')
AddEventHandler('vehiclekeys:client:SetOwner', function(plate)
    local VehPlate = plate
    if VehPlate == nil then
        VehPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
    end
    TriggerServerEvent('vehiclekeys:server:SetVehicleOwner', VehPlate)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) and plate == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true)) then
        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), true), true, false, true)
    end
    HasKey = true
    --QBCore.Functions.Notify('You picked the keys of the vehicle', 'success', 3500)
end)

RegisterNetEvent('vehiclekeys:client:GiveKeys')
AddEventHandler('vehiclekeys:client:GiveKeys', function(target)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
    TriggerServerEvent('vehiclekeys:server:GiveVehicleKeys', plate, target)
end)

RegisterNetEvent('vehiclekeys:client:ToggleEngine')
AddEventHandler('vehiclekeys:client:ToggleEngine', function()
    local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if HasKey then
        if EngineOn then
            SetVehicleEngineOn(veh, false, false, true)
        else
            SetVehicleEngineOn(veh, true, false, true)
        end
    end
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    if (IsPedInAnyVehicle(GetPlayerPed(-1))) then
        if not HasKey then
            LockpickIgnition(isAdvanced)
        end
    else
        LockpickDoor(isAdvanced)
    end
end)

function RobVehicle(target)
    IsRobbing = true
    Citizen.CreateThread(function()
        while IsRobbing do
            local RandWait = math.random(10000, 15000)
            loadAnimDict("random@mugging3")

            TaskLeaveVehicle(target, GetVehiclePedIsIn(target, true), 256)
            Citizen.Wait(1000)
            ClearPedTasksImmediately(target)

            TaskStandStill(target, RandWait)
            TaskHandsUp(target, RandWait, GetPlayerPed(-1), 0, false)

            Citizen.Wait(RandWait)

            --TaskReactAndFleePed(target, GetPlayerPed(-1))
            IsRobbing = false
        end
    end)
end

function LockVehicle()
    local veh = QBCore.Functions.GetClosestVehicle()
    local coordA = GetEntityCoords(GetPlayerPed(-1), true)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 255.0, 0.0)
    local veh = GetClosestVehicleInDirection(coordA, coordB)
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    end
    local plate = GetVehicleNumberPlateText(veh)
    local vehpos = GetEntityCoords(veh, false)
    if veh ~= nil and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 7.5 then
        QBCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
            if result then
                if HasKey then
                    local vehLockStatus = GetVehicleDoorLockStatus(veh)
                    loadAnimDict("anim@mp_player_intmenu@key_fob@")
                    TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
        
                    if vehLockStatus == 1 then
                        Citizen.Wait(750)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                        SetVehicleDoorsLocked(veh, 2)
                        if(GetVehicleDoorLockStatus(veh) == 2)then
                            QBCore.Functions.Notify("Trancaste o veiculo!")
                        else
                            QBCore.Functions.Notify("Ocorreu um erro com o sistema de tranque!")
                        end
                    else
                        Citizen.Wait(750)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                        SetVehicleDoorsLocked(veh, 1)
                        if(GetVehicleDoorLockStatus(veh) == 1)then
                            QBCore.Functions.Notify("Destrancaste o veiculo!")
                        else
                            QBCore.Functions.Notify("Ocorreu um erro com o sistema de tranque!")
                        end
                    end
        
                    if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        SetVehicleInteriorlight(veh, true)
                        SetVehicleIndicatorLights(veh, 0, true)
                        SetVehicleIndicatorLights(veh, 1, true)
                        Citizen.Wait(450)
                        SetVehicleIndicatorLights(veh, 0, false)
                        SetVehicleIndicatorLights(veh, 1, false)
                        Citizen.Wait(450)
                        SetVehicleInteriorlight(veh, true)
                        SetVehicleIndicatorLights(veh, 0, true)
                        SetVehicleIndicatorLights(veh, 1, true)
                        Citizen.Wait(450)
                        SetVehicleInteriorlight(veh, false)
                        SetVehicleIndicatorLights(veh, 0, false)
                        SetVehicleIndicatorLights(veh, 1, false)
                    end
                end
            else
                QBCore.Functions.Notify('Não tens as chaves deste veiculo..', 'error')
            end
        end, plate)
    else
    	print("TRANCAR: NENHUM VEICULO À TUA FRENTE")
    end
end

local openingDoor = false
function LockpickDoor(isAdvanced)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    if vehicle ~= nil and vehicle ~= 0 then
        local vehpos = GetEntityCoords(vehicle)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 1.5 then
            local vehLockStatus = GetVehicleDoorLockStatus(vehicle)
            if (vehLockStatus > 1) then
                local lockpickTime = math.random(15000, 30000)
                if isAdvanced then
                    lockpickTime = math.ceil(lockpickTime*0.5)
                end
                LockpickDoorAnim(lockpickTime)
                PoliceCall()
                IsHotwiring = true
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, lockpickTime)
                QBCore.Functions.Progressbar("lockpick_vehicledoor", "A arrombar a porta..", lockpickTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    openingDoor = false
                    StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                    IsHotwiring = false
                    if math.random(1, 100) <= 90 then
                        QBCore.Functions.Notify("Conseguiste abrir a porta!")
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                        SetVehicleDoorsLocked(vehicle, 0)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    else
                        QBCore.Functions.Notify("Falhou!", "error")
                    end
                end, function() -- Cancel
                    openingDoor = false
                    StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                    QBCore.Functions.Notify("Falhou!", "error")
                    IsHotwiring = false
                end)
            end
        end
    end
end

function LockpickDoorAnim(time)
    time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end

function LockpickIgnition(isAdvanced)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(2, 4)
    end
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        if vehicle ~= nil and vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
                IsHotwiring = true
                SucceededAttempts = 0
                PoliceCall()

                if isAdvanced then
                    local maxwidth = 10
                    local maxduration = 1750
                    if FailedAttemps == 1 then
                        maxwidth = 10
                        maxduration = 1500
                    elseif FailedAttemps == 2 then
                        maxwidth = 9
                        maxduration = 1250
                    elseif FailedAttemps >= 3 then
                        maxwidth = 8
                        maxduration = 1000
                    end
                    widthAmount = math.random(5, maxwidth)
                    durationAmount = math.random(500, maxduration)
                else        
                    local maxwidth = 10
                    local maxduration = 1500
                    if FailedAttemps == 1 then
                        maxwidth = 9
                        maxduration = 1250
                    elseif FailedAttemps == 2 then
                        maxwidth = 8
                        maxduration = 1000
                    elseif FailedAttemps >= 3 then
                        maxwidth = 7
                        maxduration = 800
                    end
                    widthAmount = math.random(5, maxwidth)
                    durationAmount = math.random(500, maxduration)
                end

                local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                local anim = "machinic_loop_mechandplayer"

                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    RequestAnimDict(dict)
                    Citizen.Wait(100)
                end

                Skillbar.Start({
                    duration = math.random(5000, 10000),
                    pos = math.random(10, 30),
                    width = math.random(10, 20),
                }, function()
                    if IsHotwiring then
                        if SucceededAttempts + 1 >= NeededAttempts then
                            StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                            QBCore.Functions.Notify("Fizeste o lockpick com sucesso!")
                            HasKey = true
                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                            IsHotwiring = false
                            FailedAttemps = 0
                            SucceededAttempts = 0
                            NeededAttempts = 0
                            TriggerServerEvent('qb-hud:Server:GainStress', math.random(2, 4))
                        else
                            if vehicle ~= nil and vehicle ~= 0 then
                                TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 8.0, -1, 16, -1, false, false, false)
                                if isAdvanced then
                                    local maxwidth = 10
                                    local maxduration = 1750
                                    if FailedAttemps == 1 then
                                        maxwidth = 10
                                        maxduration = 1500
                                    elseif FailedAttemps == 2 then
                                        maxwidth = 9
                                        maxduration = 1250
                                    elseif FailedAttemps >= 3 then
                                        maxwidth = 8
                                        maxduration = 1000
                                    end
                                    widthAmount = math.random(5, maxwidth)
                                    durationAmount = math.random(400, maxduration)
                                else        
                                    local maxwidth = 10
                                    local maxduration = 1300
                                    if FailedAttemps == 1 then
                                        maxwidth = 9
                                        maxduration = 1150
                                    elseif FailedAttemps == 2 then
                                        maxwidth = 8
                                        maxduration = 900
                                    elseif FailedAttemps >= 3 then
                                        maxwidth = 7
                                        maxduration = 750
                                    end
                                    widthAmount = math.random(5, maxwidth)
                                    durationAmount = math.random(300, maxduration)
                                end

                                SucceededAttempts = SucceededAttempts + 1
                                Skillbar.Repeat({
                                    duration = durationAmount,
                                    pos = math.random(10, 50),
                                    width = widthAmount,
                                })
                            else
                                ClearPedTasksImmediately(GetPlayerPed(-1))
                                HasKey = false
                                SetVehicleEngineOn(vehicle, false, false, true)
                                QBCore.Functions.Notify("Tens que estar dentro de um veiculo", "error")
                                IsHotwiring = false
                                FailedAttemps = FailedAttemps + 1
                                local c = math.random(2)
                                local o = math.random(2)
                                if c == o then
                                    TriggerServerEvent('qb-hud:Server:GainStress', math.random(1, 4))
                                end
                            end
                        end
                    end
                end, function()
                    if IsHotwiring then
                        StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                        HasKey = false
                        SetVehicleEngineOn(vehicle, false, false, true)
                        QBCore.Functions.Notify("Não conseguiste fazer o lockpick!", "error")
                        IsHotwiring = false
                        FailedAttemps = FailedAttemps + 1
                        local c = math.random(2)
                        local o = math.random(2)
                        if c == o then
                            TriggerServerEvent('qb-hud:Server:GainStress', math.random(1, 4))
                        end
                    end
                end)
            end
        end
    end
end

function Hotwire()
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        IsHotwiring = true
        local hotwireTime = math.random(20000, 40000)
        SetVehicleAlarm(vehicle, true)
        SetVehicleAlarmTimeLeft(vehicle, hotwireTime)
        PoliceCall()
        QBCore.Functions.Progressbar("hotwire_vehicle", "A fazer ligação direta", hotwireTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            if (math.random(0, 100) < 10) then
                HasKey = true
                QBCore.Functions.Notify("Conseguiste fazer ligação direta!")
            else
                HasKey = false
                SetVehicleEngineOn(veh, false, false, true)
                QBCore.Functions.Notify("Não conseguiste fazer ligação direta!", "error")
            end
            IsHotwiring = false
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            HasKey = false
            SetVehicleEngineOn(veh, false, false, true)
            QBCore.Functions.Notify("Falhaste a ligação direta!", "error")
            IsHotwiring = false
        end)
    end
end

function PoliceCall()
    if not AlertSend then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local chance = 20
        if GetClockHours() >= 1 and GetClockHours() <= 6 then
            chance = 10
        end
        if math.random(1, 100) <= chance then
            local closestPed = GetNearbyPed()
            if closestPed ~= nil then
                local msg = ""
                local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                local streetLabel = GetStreetNameFromHashKey(s1)
                local street2 = GetStreetNameFromHashKey(s2)
                if street2 ~= nil and street2 ~= "" then 
                    streetLabel = streetLabel .. " " .. street2
                end
                local alertTitle = ""
                if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local modelName = GetEntityModel(vehicle)
                    if QBCore.Shared.VehicleModels[modelName] ~= nil then
                        Name = QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["brand"] .. ' ' .. QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["name"]
                    else
                        Name = "Desconhecido"
                    end
                    local modelPlate = GetVehicleNumberPlateText(vehicle)
                    local msg = "Tentativa de roubo a veiculo em " ..streetLabel.. ". Veiculo: " .. Name .. ", Matricula: " .. modelPlate
                    local alertTitle = "Roubo a veiculo em"
                    TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
                else
                    local vehicle = QBCore.Functions.GetClosestVehicle()
                    local modelName = GetEntityModel(vehicle)
                    local modelPlate = GetVehicleNumberPlateText(vehicle)
                    if QBCore.Shared.VehicleModels[modelName] ~= nil then
                        Name = QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["brand"] .. ' ' .. QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["name"]
                    else
                        Name = "Desconhecido"
                    end
                    local msg = "Tentativa de roubo a veiculo em  " ..streetLabel.. ". Veiculo: " .. Name .. ", Matricula: " .. modelPlate
                    local alertTitle = "Roubo a veiculo em"
                    TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
                end
            end
        end
        AlertSend = true
        SetTimeout(2 * (60 * 1000), function()
            AlertSend = false
        end)
    end
end

function GetClosestVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GetPlayerPed(-1), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 250 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function GetNearbyPed()
	local retval = nil
	local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
	local closestPed, closestDistance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)
	if not IsEntityDead(closestPed) and closestDistance < 30.0 then
		retval = closestPed
	end
	return retval
end

function IsBlacklistedWeapon()
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if weapon ~= nil then
        for _, v in pairs(Config.NoRobWeapons) do
            if weapon == GetHashKey(v) then
                return true
            end
        end
    end
    return false
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end