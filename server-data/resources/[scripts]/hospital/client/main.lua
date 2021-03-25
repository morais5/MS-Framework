Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

DoScreenFadeIn(100)

inBedDict = "misslamar1dead_body"
inBedAnim = "dead_idle"

getOutDict = 'switch@franklin@bed'
getOutAnim = 'sleep_getup_rubeyes'

isLoggedIn = false

isInHospitalBed = false
canLeaveBed = true

bedOccupying = nil
bedObject = nil
bedOccupyingData = nil
currentTp = nil
usedHiddenRev = false

isBleeding = 0
bleedTickTimer, advanceBleedTimer = 0, 0
fadeOutTimer, blackoutTimer = 0, 0

legCount = 0
armcount = 0
headCount = 0

playerHealth = nil
playerArmour = nil

isDead = false

closestBed = nil

isStatusChecking = false
statusChecks = {}
statusCheckPed = nil
statusCheckTime = 0

isHealingPerson = false
healAnimDict = "mini@cpr@char_a@cpr_str"
healAnim = "cpr_pumpchest"

doctorsSet = false
doctorCount = 0

PlayerJob = {}
onDuty = false

BodyParts = {
    ['HEAD'] = { label = 'cabeça', causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] = { label = 'pescoço', causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] = { label = 'coluna', causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] = { label = 'tronco', causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] = { label = 'pernas', causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] = { label = 'braço esquerdo', causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] = { label = 'mão esquerda', causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] = { label = 'dedos esquerdos', causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] = { label = 'perna esquerda', causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] = { label = 'pé esquerdo', causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] = { label = 'braço direito', causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] = { label = 'mão direita', causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] = { label = 'dedos direitos', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] = { label = 'perna direita', causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] = { label = 'pé direito', causeLimp = true, isDamaged = false, severity = 0 },
}

injured = {}

QBCore = nil
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
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmor then
            playerArmor = armor
        end

        local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
        local healthDamaged = (playerHealth ~= health) -- Players health was damaged

        local damageDone = (playerHealth - health)

        if armorDamaged or healthDamaged then
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]
            local weapon = GetDamagingWeapon(ped)

            if hit and bodypart ~= 'NONE' then
                local checkDamage = true
                if damageDone >= Config.HealthDamage then
                    if weapon ~= nil then
                        if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                            checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                            if armorDamaged then
                                TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(GetPlayerPed(-1)))
                            end
                        end
    
                        if checkDamage then
    
                            if IsDamagingEvent(damageDone, weapon) then
                                CheckDamage(ped, bone, weapon, damageDone)
                            end
                        end
                    end
                elseif Config.AlwaysBleedChanceWeapons[weapon] then
                    if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                        checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                    end
                    if math.random(100) < Config.AlwaysBleedChance and checkDamage then
                        ApplyBleed(1)
                    end
                end
            end

            CheckWeaponDamage(ped)
        end

        playerHealth = health
        playerArmor = armor

        if not isInHospitalBed then
            ProcessDamage(ped)
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait((1000 * Config.MessageTimer))
        DoLimbAlert()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SetClosestBed()
        if isStatusChecking then
            statusCheckTime = statusCheckTime - 1
            if statusCheckTime <= 0 then
                statusChecks = {}
                isStatusChecking = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    --[[local blip = AddBlipForCoord(-254.88, 6324.5, 32.58)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 25)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Hospital de Paleto")
    EndTextCommandSetBlipName(blip)--]]

    local blip = AddBlipForCoord(304.27, -600.33, 43.28)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 25)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Hospital PillBox")
    EndTextCommandSetBlipName(blip)

    while true do
        Citizen.Wait(1)
        if QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))

            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, true) < 1.5) then
                if doctorCount >= Config.MinimalDoctors then
                    QBCore.Functions.DrawText3D(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, "~g~E~w~ - Chamar um médico")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, "~g~E~w~ - Fazer check-in")
                end
                if IsControlJustReleased(0, Keys["E"]) then
                    if doctorCount >= Config.MinimalDoctors then
                        TriggerServerEvent("hospital:server:SendDoctorAlert")
                    else
                        TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
                        QBCore.Functions.Progressbar("hospital_checkin", "A fazer check-in..", 2000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            local bedId = GetAvailableBed()
                            if bedId ~= nil then 
                                TriggerServerEvent("hospital:server:SendToBed", bedId, true)
                            else
                                QBCore.Functions.Notify("Nenhuma cama disponivel de momento..", "error")
                            end
                        end, function() -- Cancel
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            QBCore.Functions.Notify("Não fizeste o check-in!", "error")
                        end)
                    end
                end
            elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, true) < 4.5) then
                if doctorCount >= Config.MinimalDoctors then
                    QBCore.Functions.DrawText3D(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, "Chamar médico")
                else
                    QBCore.Functions.DrawText3D(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z, "Fazer check-in")
                end
            end
            
            if closestBed ~= nil and not isInHospitalBed then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["beds"][closestBed].x, Config.Locations["beds"][closestBed].y, Config.Locations["beds"][closestBed].z, true) < 1.5) then
                    QBCore.Functions.DrawText3D(Config.Locations["beds"][closestBed].x, Config.Locations["beds"][closestBed].y, Config.Locations["beds"][closestBed].z + 0.3, "~g~E~w~ - Deitar na cama")
                    if IsControlJustReleased(0, Keys["E"]) then
                        if GetAvailableBed(closestBed) ~= nil then 
                            TriggerServerEvent("hospital:server:SendToBed", closestBed, false)
                        else
                            QBCore.Functions.Notify("Todas as camas estão ocupadas..", "error")
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

function GetAvailableBed(bedId)
    local retval = nil
    if bedId == nil then 
        for k, v in pairs(Config.Locations["beds"]) do
            if not Config.Locations["beds"][k].taken then
                retval = k
            end
        end
    else
        if not Config.Locations["beds"][bedId].taken then
            retval = bedId
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if QBCore ~= nil then
            if isInHospitalBed and canLeaveBed then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                QBCore.Functions.DrawText3D(pos.x, pos.y, pos.z, "~g~E~w~ - Sair da cama..")
                if IsControlJustReleased(0, Keys["E"]) then
                    LeaveBed()
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('hospital:client:Revive')
AddEventHandler('hospital:client:Revive', function()
    local player = PlayerPedId()

    if isDead then
        SetLaststand(false)
		local playerPos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        isDead = false
        SetEntityInvincible(GetPlayerPed(-1), false)
    elseif InLaststand then
        local playerPos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        isDead = false
        SetEntityInvincible(GetPlayerPed(-1), false)
        SetLaststand(false)
    end

    if isInHospitalBed then
        loadAnimDict(inBedDict)
        TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        SetEntityInvincible(GetPlayerPed(-1), true)
        canLeaveBed = true
    end

    TriggerServerEvent("hospital:server:RestoreWeaponDamage")

    local ped = GetPlayerPed(-1)
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)

    ResetAll()

    TriggerServerEvent('qb-hud:Server:RelieveStress', 100)
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    TriggerServerEvent("hospital:server:SetLaststandStatus", false)
    
    QBCore.Functions.Notify("Foste reanimado!")
end)

RegisterNetEvent('hospital:client:SetPain')
AddEventHandler('hospital:client:SetPain', function()
    ApplyBleed(math.random(1,4))
    if not BodyParts[Config.Bones[24816]].isDamaged then
        BodyParts[Config.Bones[24816]].isDamaged = true
        BodyParts[Config.Bones[24816]].severity = math.random(1, 4)
        table.insert(injured, {
            part = Config.Bones[24816],
            label = BodyParts[Config.Bones[24816]].label,
            severity = BodyParts[Config.Bones[24816]].severity
        })
    end

    if not BodyParts[Config.Bones[40269]].isDamaged then
        BodyParts[Config.Bones[40269]].isDamaged = true
        BodyParts[Config.Bones[40269]].severity = math.random(1, 4)
        table.insert(injured, {
            part = Config.Bones[40269],
            label = BodyParts[Config.Bones[40269]].label,
            severity = BodyParts[Config.Bones[40269]].severity
        })
    end

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end)

RegisterNetEvent('hospital:client:KillPlayer')
AddEventHandler('hospital:client:KillPlayer', function()
    SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('hospital:client:HealInjuries')
AddEventHandler('hospital:client:HealInjuries', function(type)
    if type == "full" then
        ResetAll()
    else
        ResetPartial()
    end
    TriggerServerEvent("hospital:server:RestoreWeaponDamage")
    QBCore.Functions.Notify("As tuas feridas foram curadas!")
end)

RegisterNetEvent('hospital:client:SendToBed')
AddEventHandler('hospital:client:SendToBed', function(id, data, isRevive)
    bedOccupying = id
    bedOccupyingData = data
    SetBedCam()
    Citizen.CreateThread(function ()
        Citizen.Wait(5)
        local player = PlayerPedId()
        if isRevive then
            QBCore.Functions.Notify("Vais ser tratado..")
            Citizen.Wait(Config.AIHealTimer * 1000)
            TriggerEvent("hospital:client:Revive")
        else
            canLeaveBed = true
        end
    end)
end)

RegisterNetEvent('hospital:client:SetBed')
AddEventHandler('hospital:client:SetBed', function(id, isTaken)
    Config.Locations["beds"][id].taken = isTaken
end)


RegisterNetEvent('hospital:client:RespawnAtHospital')
AddEventHandler('hospital:client:RespawnAtHospital', function()
    TriggerServerEvent("hospital:server:RespawnAtHospital")
    TriggerEvent("police:client:DeEscort")
end)

RegisterNetEvent('hospital:client:SendBillEmail')
AddEventHandler('hospital:client:SendBillEmail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "Senhor"
        if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Senhora"
        end
        local charinfo = QBCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Hospital Pillbox",
            subject = "Custos de Hospital",
            message = "Caro/a " .. gender .. " " .. charinfo.lastname .. ",<br /><br />Por meio deste EMail irás receber os custos da tua ultima visita ao hospital..<br />Os custos finais são: <strong>"..amount.."€</strong><br /><br />Cumprimentos.!",
            button = {}
        })
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("hospital:server:SetDoctor")
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    local ped = GetPlayerPed(-1)
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    isLoggedIn = true
    TriggerServerEvent("hospital:server:SetDoctor")
    Citizen.CreateThread(function()
        Wait(1000)
        QBCore.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
            onDuty = PlayerData.job.onduty
            SetPedArmour(GetPlayerPed(-1), PlayerData.metadata["armor"])
            if (not PlayerData.metadata["inlaststand"] and PlayerData.metadata["isdead"]) then
                local player = PlayerId()
                local playerPed = PlayerPedId()
                deathTime = Laststand.ReviveInterval
                OnDeath(true)
                DeathTimer()
            elseif (PlayerData.metadata["inlaststand"] and not PlayerData.metadata["isdead"]) then
                SetLaststand(true, true)
            else
                TriggerServerEvent("hospital:server:SetDeathStatus", false)
                TriggerServerEvent("hospital:server:SetLaststandStatus", false)
            end
        end)
    end)
end)

RegisterNetEvent('hospital:client:SetDoctorCount')
AddEventHandler('hospital:client:SetDoctorCount', function(amount)
    doctorCount = amount
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
    TriggerServerEvent("hospital:server:SetDoctor")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    TriggerServerEvent('hospital:server:SetLaststandStatus', false)
    TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(GetPlayerPed(-1)))
    if bedOccupying ~= nil then 
        TriggerServerEvent("hospital:server:LeaveBed", bedOccupying)
    end
    isDead = false
    deathTime = 0
    SetEntityInvincible(GetPlayerPed(-1), false)
    SetPedArmour(GetPlayerPed(-1), 0)
    ResetAll()
end)

function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            ClearEntityLastDamageEntity(ped)
            return v
        end
    end

    return nil
end

function IsDamagingEvent(damageDone, weapon)
    math.randomseed(GetGameTimer())
    local luck = math.random(100)
    local multi = damageDone / Config.HealthDamage

    return luck < (Config.HealthDamage * multi) or (damageDone >= Config.ForceInjury or multi > Config.MaxInjuryChanceMulti or Config.ForceInjuryWeapons[weapon])
end

function DoLimbAlert()
    local player = PlayerPedId()
    if not isDead then
        if #injured > 0 then
            local limbDamageMsg = ''
            if #injured <= Config.AlertShowInfo then
                for k, v in pairs(injured) do
                    limbDamageMsg = limbDamageMsg .. "Dores no/a " .. v.label .. ". Sentes "..Config.WoundStates[v.severity]
                    if k < #injured then
                        limbDamageMsg = limbDamageMsg .. " | "
                    end
                end
            else
                limbDamageMsg = "Sentes dores em muitos sitios.."
            end
            QBCore.Functions.Notify(limbDamageMsg, "primary", 5000)
        end
    end
end

function DoBleedAlert()
    local player = PlayerPedId()
    if not isDead and tonumber(isBleeding) > 0 then
        QBCore.Functions.Notify("Estas "..Config.BleedingStates[tonumber(isBleeding)].label, "error", 5000)
    end
end

function IsInjuryCausingLimp()
    for k, v in pairs(BodyParts) do
        if v.causeLimp and v.isDamaged then
            return true
        end
    end

    return false
end

function SetClosestBed() 
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for k, v in pairs(Config.Locations["beds"]) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true) < dist)then
                current = k
                dist = GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true)
            current = k
        end
    end
    if current ~= closestBed and not isInHospitalBed then
        closestBed = current
    end
end

function ResetPartial()
    for k, v in pairs(BodyParts) do
        if v.isDamaged and v.severity <= 2 then
            v.isDamaged = false
            v.severity = 0
        end
    end

    for k, v in pairs(injured) do
        if v.severity <= 2 then
            v.severity = 0
            table.remove(injured, k)
        end
    end

    if isBleeding <= 2 then
        isBleeding = 0
        bleedTickTimer = 0
        advanceBleedTimer = 0
        fadeOutTimer = 0
        blackoutTimer = 0
    end
    
    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end

function ResetAll()
    isBleeding = 0
    bleedTickTimer = 0
    advanceBleedTimer = 0
    fadeOutTimer = 0
    blackoutTimer = 0
    onDrugs = 0
    wasOnDrugs = false
    onPainKiller = 0
    wasOnPainKillers = false
    injured = {}

    for k, v in pairs(BodyParts) do
        v.isDamaged = false
        v.severity = 0
    end
    
    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    CurrentDamageList = {}
    TriggerServerEvent('hospital:server:SetWeaponDamage', CurrentDamageList)

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
    TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
    TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
end

function SetBedCam()
    isInHospitalBed = true
    canLeaveBed = false
    local player = PlayerPedId()

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end

	if IsPedDeadOrDying(player) then
		local playerPos = GetEntityCoords(player, true)
		NetworkResurrectLocalPlayer(playerPos, true, true, false)
    end
    
    bedObject = GetClosestObjectOfType(bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z, 1.0, bedOccupyingData.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(player, bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z + 0.02)
    --SetEntityInvincible(PlayerPedId(), true)
    Citizen.Wait(500)
    FreezeEntityPosition(player, true)

    loadAnimDict(inBedDict)

    TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(player, bedOccupyingData.h)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 1.0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -45.0, 0.0, GetEntityHeading(player) + 180, true)

    DoScreenFadeIn(1000)

    Citizen.Wait(1000)
    FreezeEntityPosition(player, true)
end

function LeaveBed()
    local player = PlayerPedId()

    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Citizen.Wait(0)
    end
    
    FreezeEntityPosition(player, false)
    SetEntityInvincible(player, false)
    SetEntityHeading(player, bedOccupyingData.h + 90)
    TaskPlayAnim(player, getOutDict , getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(player)
    TriggerServerEvent('hospital:server:LeaveBed', bedOccupying)
    FreezeEntityPosition(bedObject, true)

    
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
    isInHospitalBed = false
end

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Fardas"
    ClearMenu()
    Menu.addButton("Fardas", "OutfitsList", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function OutfitsLijst()
    QBCore.Functions.TriggerCallback('apartments:GetOutfits', function(outfits)
        ped = GetPlayerPed(-1);
        MenuTitle = "Fardas :"
        ClearMenu()

        if outfits == nil then
            QBCore.Functions.Notify("Não tens nenhuma farda salva...", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(outfits) do
                Menu.addButton(outfits[k].outfitname, "optionMenu", outfits[k]) 
            end
        end
        Menu.addButton("Voltar", "MenuOutfits",nil)
    end)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "Opções"
    ClearMenu()

    Menu.addButton("Escolher Farda", "selectOutfit", outfitData) 
    Menu.addButton("Apagar Farda", "removeOutfit", outfitData) 
    Menu.addButton("Voltar", "OutfitsList",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    QBCore.Functions.Notify(oData.outfitname.." selecionado", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    QBCore.Functions.Notify(oData.outfitname.." removido", "success", 2500)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

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
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end