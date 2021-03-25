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

local currentGarage = 1
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" then

                for k, v in pairs(Config.Locations["duty"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 5) then
                        if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                            if onDuty then
                                DrawText3D(v.x, v.y, v.z, "~r~E~w~ - Sair em serviço")
                            else
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Entrar de Serviço")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                onDuty = not onDuty
                                if onDuty == true then
                                	exports["rp-radio"]:GivePlayerAccessToFrequencies(6, 7, 8, 9, 10)
                                elseif onDuty == false then
                                	exports["rp-radio"]:RemovePlayerAccessToFrequencies(6, 7, 8, 9, 10)
                                end
                                TriggerServerEvent("QBCore:ToggleDuty")
                                TriggerServerEvent("police:server:UpdateBlips")
                                Wait(500)
                            end
                        elseif (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                            DrawText3D(v.x, v.y, v.z, "Entrar/Sair de serviço")
                        end  
                    end
                end

                for k, v in pairs(Config.Locations["armory"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                        if onDuty then
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Armario")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
                                end
                            elseif (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2.5) then
                                DrawText3D(v.x, v.y, v.z, "Armario")
                            end  
                        end
                    end
                end
        
                for k, v in pairs(Config.Locations["vehicle"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Guardar veiculo")
                            else
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Requisitar veiculo")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    MenuGarage()
                                    currentGarage = k
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end
                    end
                end
        
                for k, v in pairs(Config.Locations["helicopter"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 7.5) then
                        if onDuty then
                            DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Guardar Helicoptero")
                                else
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Requisitar Helicoptero")
                                end
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                    else
                                        local coords = Config.Locations["helicopter"][k]
                                        QBCore.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                                            SetVehicleNumberPlateText(veh, "LIFE"..tostring(math.random(1000, 9999)))
                                            SetEntityHeading(veh, coords.h)
                                            exports['LegacyFuel']:SetFuel(veh, 100.0)
                                            closeMenuFull()
                                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                            TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                            SetVehicleEngineOn(veh, true, true)
                                        end, coords, true)
                                    end
                                end
                            end  
                        end
                    end
                end
            end

            local currentHospital = 1

            for k, v in pairs(Config.Locations["main"]) do
                if (GetDistanceBetweenCoords(pos,v.x,v.y,v.z, true) < 1.5) then
                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Subir para o telhado no elevador")
                    if IsControlJustReleased(0, Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end

                        currentHospital = k

                        local coords = Config.Locations["roof"][currentHospital]
                        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), coords.h)

                        Citizen.Wait(100)

                        DoScreenFadeIn(1000)
                    end
                end
            end

            for k, v in pairs(Config.Locations["roof"]) do
                if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Descer pelo elevador")
                    if IsControlJustReleased(0, Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end

                        currentHospital = k

                        local coords = Config.Locations["main"][currentHospital]
                        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), coords.h)

                        Citizen.Wait(100)

                        DoScreenFadeIn(1000)
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isStatusChecking then
            for k, v in pairs(statusChecks) do
                local x,y,z = table.unpack(GetPedBoneCoords(statusCheckPed, v.bone))
                DrawText3D(x, y, z, v.label)
            end
        end

        if isHealingPerson then
            if not IsEntityPlayingAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3) then
                loadAnimDict(healAnimDict)	
                TaskPlayAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end
    end
end)

RegisterNetEvent('hospital:client:SendAlert')
AddEventHandler('hospital:client:SendAlert', function(msg)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent("chatMessage", "Balcão do Hospital", "error", msg)
end)

RegisterNetEvent('112:client:SendAlert')
AddEventHandler('112:client:SendAlert', function(msg, blipSettings)
    if (PlayerJob.name == "police" or PlayerJob.name == "ambulance" or PlayerJob.name == "doctor") and onDuty then
        if blipSettings ~= nil then
            local transG = 250
            local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
            SetBlipSprite(blip, blipSettings.sprite)
            SetBlipColour(blip, blipSettings.color)
            SetBlipDisplay(blip, 4)
            SetBlipAlpha(blip, transG)
            SetBlipScale(blip, blipSettings.scale)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipSettings.text)
            EndTextCommandSetBlipName(blip)
            while transG ~= 0 do
                Wait(180 * 4)
                transG = transG - 1
                SetBlipAlpha(blip, transG)
                if transG == 0 then
                    SetBlipSprite(blip, 2)
                    RemoveBlip(blip)
                    return
                end
            end
        end
    end
end)

RegisterNetEvent('hospital:client:AiCall')
AddEventHandler('hospital:client:AiCall', function()
    local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local closestPed, closestDistance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)
    local gender = QBCore.Functions.GetPlayerData().gender
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    if closestDistance < 50.0 and closestPed ~= 0 then
        MakeCall(closestPed, gender, street1, street2)
    end
end)

function MakeCall(ped, male, street1, street2)
    local callAnimDict = "cellphone@"
    local callAnim = "cellphone_call_listen_base"
    local rand = (math.random(6,9) / 100) + 0.3
    local rand2 = (math.random(6,9) / 100) + 0.3
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local blipsettings = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        sprite = 280,
        color = 4,
        scale = 0.9,
        text = "Civil Ferido"
    }

    if math.random(10) > 5 then
        rand = 0.0 - rand
    end

    if math.random(10) > 5 then
        rand2 = 0.0 - rand2
    end

    local moveto = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), rand, rand2, 0.0)

    TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
    SetPedKeepTask(ped, true) 

    local dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)

    while dist > 3.5 and isDead do
        TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
        dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)
        Citizen.Wait(100)
    end

    ClearPedTasksImmediately(ped)
    TaskLookAtEntity(ped, GetPlayerPed(-1), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, GetPlayerPed(-1), 5500)

    Citizen.Wait(3000)

    --TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_MOBILE", 0, 1)
    loadAnimDict(callAnimDict)
    TaskPlayAnim(ped, callAnimDict, callAnim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)

    SetPedKeepTask(ped, true) 

    Citizen.Wait(5000)

    TriggerServerEvent("hospital:server:MakeDeadCall", blipsettings, male, street1, street2)

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)
end

RegisterNetEvent('hospital:client:RevivePlayer')
AddEventHandler('hospital:client:RevivePlayer', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "ambulance" then--estava doctor alterei para ambulance
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                QBCore.Functions.Progressbar("hospital_revive", "A reanimar civil..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Reanimaste o civil!")
                    TriggerServerEvent("hospital:server:RevivePlayer", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Falhaste!", "error")
                end)
            end
        end
    end)
end)

RegisterNetEvent('hospital:client:CheckStatus')
AddEventHandler('hospital:client:CheckStatus', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" or PlayerJob.name == "police" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                statusCheckPed = GetPlayerPed(player)
                QBCore.Functions.TriggerCallback('hospital:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            if k ~= "BLEED" and k ~= "WEAPONWOUNDS" then
                                table.insert(statusChecks, {bone = Config.BoneIndexes[k], label = v.label .." (".. Config.WoundStates[v.severity] ..")"})
                            elseif result["WEAPONWOUNDS"] ~= nil then 
                                for k, v in pairs(result["WEAPONWOUNDS"]) do
                                    TriggerEvent("chatMessage", "ESTADO DA VERIFICAÇÃO", "error", WeaponDamageList[v])
                                end
                            elseif result["BLEED"] > 0 then
                                TriggerEvent("chatMessage", "ESTADO DA VERIFICAÇÃO", "error", ": "..Config.BleedingStates[v].label)
                            end
                        end
                        isStatusChecking = true
                        statusCheckTime = Config.CheckTime
                    end
                end, playerId)
            end
        end
    end)
end)

RegisterNetEvent('hospital:client:TreatWounds')
AddEventHandler('hospital:client:TreatWounds', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                QBCore.Functions.Progressbar("hospital_healwounds", "A curar ferimentos..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Ajudas-te o civil!")
                    TriggerServerEvent("hospital:server:TreatWounds", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Falhaste!", "error")
                end)
            end
        end
    end)
end)

function MenuGarage(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleList", isDown)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Veiculos:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", {k, isDown}, "Garagem", " Motor: 100%", " Chassi: 100%", " Comb.: 100%")
    end
        
    Menu.addButton("Voltar", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    QBCore.Functions.SpawnVehicle(vehicleInfo[1], function(veh)
        SetVehicleNumberPlateText(veh, "AMBU"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerEvent('persistent-vehicles/register-vehicle', veh)
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function IsInemWhitelist()
    local retval = false
    local citizenid = QBCore.Functions.GetPlayerData().citizenid
    for k, v in pairs(Config.Whitelist) do
        if v == citizenid then
            retval = true
            break
        end
    end
    return retval
end