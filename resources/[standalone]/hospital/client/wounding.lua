WeaponDamageList = {
	["WEAPON_UNARMED"] = "Marcas de punhos",
	["WEAPON_ANIMAL"] = "Mordidas de animais",
	["WEAPON_COUGAR"] = "Mordidas de animais",
	["WEAPON_KNIFE"] = "Ferimento de facada",
    ["WEAPON_NIGHTSTICK"] = "Batida de pau ou algo assim",
    ["WEAPON_BREAD"] = "Amassado na cabeça por causa do pão!",
	["WEAPON_HAMMER"] = "Batida de pau ou algo assim",
	["WEAPON_BAT"] = "Batida de pau ou algo assim",
	["WEAPON_GOLFCLUB"] = "Batida de pau ou algo assim",
	["WEAPON_CROWBAR"] = "Batida de pau ou algo assim",
	["WEAPON_PISTOL"] = "Balas de pistola no corpo",
	["WEAPON_COMBATPISTOL"] = "Balas de pistola no corpo",
	["WEAPON_APPISTOL"] = "Balas de pistola no corpo",
	["WEAPON_PISTOL50"] = "50 Cal Balas de pistola no corpo",
	["WEAPON_MICROSMG"] = "Balas de SMG no corpo",
	["WEAPON_SMG"] = "Balas de SMG no corpo",
	["WEAPON_ASSAULTSMG"] = "Balas de SMG no corpo",
	["WEAPON_ASSAULTRIFLE"] = "Balas de Rifle no corpo",
	["WEAPON_CARBINERIFLE"] = "Balas de Rifle no corpo",
	["WEAPON_ADVANCEDRIFLE"] = "Balas de Rifle no corpo",
	["WEAPON_MG"] = "Balas de MachineGun no corpo",
	["WEAPON_COMBATMG"] = "Balas de MachineGun no corpo",
	["WEAPON_PUMPSHOTGUN"] = "Balas de Shotgun no corpo",
	["WEAPON_SAWNOFFSHOTGUN"] = "Balas de Shotgun no corpo",
	["WEAPON_ASSAULTSHOTGUN"] = "Balas de Shotgun no corpo",
	["WEAPON_BULLPUPSHOTGUN"] = "Balas de Shotgun no corpo",
	["WEAPON_STUNGUN"] = "Tazed no corpo",
	["WEAPON_SNIPERRIFLE"] = "Balas de Sniper no corpo",
	["WEAPON_HEAVYSNIPER"] = "Balas de Sniper no corpo",
	["WEAPON_REMOTESNIPER"] = "Balas de Sniper no corpo",
	["WEAPON_GRENADELAUNCHER"] = "Queimaduras e fragmentos",
	["WEAPON_GRENADELAUNCHER_SMOKE"] = "Ferimentos de Fumaças",
	["WEAPON_RPG"] = "Queimaduras e fragmentos",
	["WEAPON_STINGER"] = "Queimaduras e fragmentos",
	["WEAPON_MINIGUN"] = "Varias balas no corpo",
	["WEAPON_GRENADE"] = "Queimaduras e fragmentos",
	["WEAPON_STICKYBOMB"] = "Queimaduras e fragmentos",
	["WEAPON_SMOKEGRENADE"] = "Ferimentos de Fumaças",
	["WEAPON_BZGAS"] = "Ferimentos de Gas Toxico",
	["WEAPON_MOLOTOV"] = "Varias queimaduras",
	["WEAPON_FIREEXTINGUISHER"] = "Cheio de espuma de extintor",
	["WEAPON_PETROLCAN"] = "Ferimentos de Galão de Gasolina",
	["WEAPON_FLARE"] = "Ferimentos de Flare",
	["WEAPON_BARBED_WIRE"] = "Ferimentos de Arame farpado",
	["WEAPON_DROWNING"] = "Afogado",
	["WEAPON_DROWNING_IN_VEHICLE"] = "Afogado",
	["WEAPON_BLEEDING"] = "Perdeu bastante sangue",
	["WEAPON_ELECTRIC_FENCE"] = "Ferimentos de cerca eletrica",
	["WEAPON_EXPLOSION"] = "Varias queimaduras (de explosivos)",
	["WEAPON_FALL"] = "Ossos partidos",
	["WEAPON_EXHAUSTION"] = "Morreu de exaustão",
	["WEAPON_HIT_BY_WATER_CANNON"] = "Pele esfolada",
	["WEAPON_RAMMED_BY_CAR"] = "Acidente de carro",
	["WEAPON_RUN_OVER_BY_CAR"] = "Atropelado por um veiculo",
	["WEAPON_HELI_CRASH"] = "Acidente de Helicoptero",
	["WEAPON_FIRE"] = "Varias queimaduras",
}

onPainKillers = false
painkillerAmount = 0

CurrentDamageList = {}

Citizen.CreateThread(function()
	while true do
		if #injured > 0 then
			local level = 0
			for k, v in pairs(injured) do
				if v.severity > level then
					level = v.severity
				end
			end

			SetPedMoveRateOverride(PlayerPedId(), Config.MovementRate[level])
			
			Citizen.Wait(5)
		else
			Citizen.Wait(1000)
		end
	end
end)

local prevPos = nil
Citizen.CreateThread(function()
    Citizen.Wait(2500)
    prevPos = GetEntityCoords(PlayerPedId(), true)
    while true do
        Citizen.Wait(1000)
        if isBleeding > 0 and not onPainKillers then
            local player = PlayerPedId()
            if bleedTickTimer >= Config.BleedTickRate and not isInHospitalBed then
                if not isDead and not InLaststand then
                    if isBleeding > 0 then
                        if fadeOutTimer + 1 == Config.FadeOutTimer then
                            if blackoutTimer + 1 == Config.BlackoutTimer then
                                SetFlash(0, 0, 100, 7000, 100)

                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(0)
                                end

                                if not IsPedRagdoll(player) and IsPedOnFoot(player) and not IsPedSwimming(player) then
                                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                    SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                                end

                                Citizen.Wait(1500)
                                DoScreenFadeIn(1000)
                                blackoutTimer = 0
                            else
                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(0)
                                end
                                DoScreenFadeIn(500)

                                if isBleeding > 3 then
                                    blackoutTimer = blackoutTimer + 2
                                else
                                    blackoutTimer = blackoutTimer + 1
                                end
                            end

                            fadeOutTimer = 0
                        else
                            fadeOutTimer = fadeOutTimer + 1
                        end

                        local bleedDamage = tonumber(isBleeding) * Config.BleedTickDamage
                        ApplyDamageToPed(player, bleedDamage, false)
                        DoBleedAlert()
                        playerHealth = playerHealth - bleedDamage
                        local randX = math.random() + math.random(-1, 1)
                        local randY = math.random() + math.random(-1, 1)
                        local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), randX, randY, 0)
                        TriggerServerEvent("evidence:server:CreateBloodDrop", QBCore.Functions.GetPlayerData().citizenid, QBCore.Functions.GetPlayerData().metadata["bloodtype"], coords)

                        if advanceBleedTimer >= Config.AdvanceBleedTimer then
                            ApplyBleed(1)
                            advanceBleedTimer = 0
                        else
                            advanceBleedTimer = advanceBleedTimer + 1
                        end
                    end
                end
                bleedTickTimer = 0
            else
                if math.floor(bleedTickTimer % (Config.BleedTickRate / 10)) == 0 then
                    local currPos = GetEntityCoords(player, true)
                    local moving = #(vector2(prevPos.x, prevPos.y) - vector2(currPos.x, currPos.y))
                    if (moving > 1 and not IsPedInAnyVehicle(player)) and isBleeding > 2 then
                        advanceBleedTimer = advanceBleedTimer + Config.BleedMovementAdvance
                        bleedTickTimer = bleedTickTimer + Config.BleedMovementTick
                        prevPos = currPos
                    else
                        bleedTickTimer = bleedTickTimer + 1
                    end
                end
                bleedTickTimer = bleedTickTimer + 1
            end
        end
    end
end)

function ProcessDamage(ped)
    if not isDead and not InLaststand and not onPainKillers then
        for k, v in pairs(injured) do
            if (v.part == 'LLEG' and v.severity > 1) or (v.part == 'RLEG' and v.severity > 1) or (v.part == 'LFOOT' and v.severity > 2) or (v.part == 'RFOOT' and v.severity > 2) then
                if legCount >= Config.LegInjuryTimer then
                    if not IsPedRagdoll(ped) and IsPedOnFoot(ped) then
                        local chance = math.random(100)
                        if (IsPedRunning(ped) or IsPedSprinting(ped)) then
                            if chance <= Config.LegInjuryChance.Running then
                                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        else
                            if chance <= Config.LegInjuryChance.Walking then
                                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        end
                    end
                    legCount = 0
                else
                    legCount = legCount + 1
                end
            elseif (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) or (v.part == 'RARM' and v.severity > 1) or (v.part == 'RHAND' and v.severity > 1) or (v.part == 'RFINGER' and v.severity > 2) then
                if armcount >= Config.ArmInjuryTimer then
                    local chance = math.random(100)

                    if (v.part == 'LARM' and v.severity > 1) or (v.part == 'LHAND' and v.severity > 1) or (v.part == 'LFINGER' and v.severity > 2) then
                        local isDisabled = 15
                        Citizen.CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Citizen.Wait(1)
                            end
                        end)
                    else
                        local isDisabled = 15
                        Citizen.CreateThread(function()
                            while isDisabled > 0 do
                                if IsPedInAnyVehicle(ped, true) then
                                    DisableControlAction(0, 63, true) -- veh turn left
                                end

                                if IsPlayerFreeAiming(PlayerId()) then
                                    DisableControlAction(0, 25, true) -- Disable weapon firing
                                end

                                isDisabled = isDisabled - 1
                                Citizen.Wait(1)
                            end
                        end)
                    end

                    armcount = 0
                else
                    armcount = armcount + 1
                end
            elseif (v.part == 'HEAD' and v.severity > 2) then
                if headCount >= Config.HeadInjuryTimer then
                    local chance = math.random(100)

                    if chance <= Config.HeadInjuryChance then
                        SetFlash(0, 0, 100, 10000, 100)

                        DoScreenFadeOut(100)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(0)
                        end

                        if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                            SetPedToRagdoll(ped, 5000, 1, 2)
                        end

                        Citizen.Wait(5000)
                        DoScreenFadeIn(250)
                    end
                    headCount = 0
                else
                    headCount = headCount + 1
                end
            end
        end
    end
end

function CheckWeaponDamage(ped)
	for k, v in pairs(WeaponDamageList) do
        if HasPedBeenDamagedByWeapon(ped, GetHashKey(k), 0) then
            if not IsInDamageList(k) then
                TriggerEvent("chatMessage", "ESTADO", "error", v)
                table.insert(CurrentDamageList, k)
            end
		end
    end
    TriggerServerEvent("hospital:server:SetWeaponDamage", CurrentDamageList)
end

function IsInDamageList(damage)
    local retval = false
    if CurrentDamageList ~= nil then 
        for k, v in pairs(CurrentDamageList) do
            if CurrentDamageList[k] == damage then
                retval = true
            end
        end
    end

    return retval
end

function CheckDamage(ped, bone, weapon, damageDone)
    if weapon == nil then return end

    if Config.Bones[bone] ~= nil and not isDead and not InLaststand then
        ApplyImmediateEffects(ped, bone, weapon, damageDone)

        if not BodyParts[Config.Bones[bone]].isDamaged then
            BodyParts[Config.Bones[bone]].isDamaged = true
            BodyParts[Config.Bones[bone]].severity = math.random(1, 3)
            table.insert(injured, {
                part = Config.Bones[bone],
                label = BodyParts[Config.Bones[bone]].label,
                severity = BodyParts[Config.Bones[bone]].severity
            })
        else
            if BodyParts[Config.Bones[bone]].severity < 4 then
                BodyParts[Config.Bones[bone]].severity = BodyParts[Config.Bones[bone]].severity + 1

                for k, v in pairs(injured) do
                    if v.part == Config.Bones[bone] then
                        v.severity = BodyParts[Config.Bones[bone]].severity
                    end
                end
            end
        end

        TriggerServerEvent('hospital:server:SyncInjuries', {
            limbs = BodyParts,
            isBleeding = tonumber(isBleeding)
        })

        ProcessRunStuff(ped)
        --DoLimbAlert()
        --DoBleedAlert()
    end
end

function ApplyImmediateEffects(ped, bone, weapon, damageDone)
    local armor = GetPedArmour(ped)
    if Config.MinorInjurWeapons[weapon] and damageDone < Config.DamageMinorToMajor then
        if Config.CriticalAreas[Config.Bones[bone]] then
            if armor <= 0 then
                ApplyBleed(1)
            end
        end

        if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
            if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].minor) then
                SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
            end
        end
    elseif Config.MajorInjurWeapons[weapon] or (Config.MinorInjurWeapons[weapon] and damageDone >= Config.DamageMinorToMajor) then
        if Config.CriticalAreas[Config.Bones[bone]] ~= nil then
            if armor > 0 and Config.CriticalAreas[Config.Bones[bone]].armored then
                if math.random(100) <= math.ceil(Config.MajorArmoredBleedChance) then
                    ApplyBleed(1)
                end
            else
                ApplyBleed(1)
            end
        else
            if armor > 0 then
                if math.random(100) < (Config.MajorArmoredBleedChance) then
                    ApplyBleed(1)
                end
            else
                if math.random(100) < (Config.MajorArmoredBleedChance * 2) then
                    ApplyBleed(1)
                end
            end
        end

        if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
            if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].major) then
                SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
            end
        end
    end
end

RegisterNetEvent('hospital:client:UseBandage')
AddEventHandler('hospital:client:UseBandage', function()
    QBCore.Functions.Progressbar("use_bandage", "A colocar uma bandagem..", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
		anim = "weed_inspecting_high_base_inspector",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
        TriggerServerEvent("QBCore:Server:RemoveItem", "bandage", 1)
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bandage"], "remove")
        SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) + 10)
        if math.random(1, 100) < 50 then
            RemoveBleed(1)
        end
        if math.random(1, 100) < 7 then
            ResetPartial()
        end
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
        QBCore.Functions.Notify("Falhaste", "error")
    end)
end)

RegisterNetEvent('hospital:client:UsePainkillers')
AddEventHandler('hospital:client:UsePainkillers', function()
    QBCore.Functions.Progressbar("use_bandage", "A tomar PainKillers", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("QBCore:Server:RemoveItem", "painkillers", 1)
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["painkillers"], "remove")
        onPainKillers = true
        if painkillerAmount < 3 then
            painkillerAmount = painkillerAmount + 1
        end
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
        QBCore.Functions.Notify("Falhaste", "error")
    end)
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if onPainKillers then
            painkillerAmount = painkillerAmount - 1
            Citizen.Wait(Config.PainkillerInterval * 1000)
            if painkillerAmount <= 0 then
                painkillerAmount = 0
                onPainKillers = false
            end
        else
            Citizen.Wait(3000)
        end
    end
end)

function ProcessRunStuff(ped)
    if IsInjuryCausingLimp() then
        RequestAnimSet("move_m@injured")
        while not HasAnimSetLoaded("move_m@injured") do
            Citizen.Wait(0)
        end
        SetPedMovementClipset(ped, "move_m@injured", 1 )
        SetPlayerSprint(PlayerId(), false)
    end
end

function RemoveBleed(level)
    if isBleeding ~= 0 then
        if isBleeding - level < 0 then
            isBleeding = 0
        else
            isBleeding = isBleeding - level
        end
        DoBleedAlert()
    end
end

function ApplyBleed(level)
    if isBleeding ~= 4 then
        if isBleeding + level > 4 then
            isBleeding = 4
        else
            isBleeding = isBleeding + level
        end
        DoBleedAlert()
    end
end