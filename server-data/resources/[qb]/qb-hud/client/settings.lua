CreateThread(function()
    SetWeaponDamageModifier(`WEAPON_UNARMED`, 0.05) -- Melee
	SetWeaponDamageModifier(`WEAPON_BOTTLE`, 0.1) -- Melee
	SetWeaponDamageModifier(`WEAPON_FLASHLIGHT`, 0.3) -- Melee
	SetWeaponDamageModifier(`WEAPON_KNUCKLE`, 0.4) -- Melee
	SetWeaponDamageModifier(`WEAPON_NIGHTSTICK`, 0.0) -- Melee
	SetWeaponDamageModifier(`WEAPON_HAMMER`, 0.1) -- Melee
	SetWeaponDamageModifier(`WEAPON_CROWBAR`, 0.1) -- Melee
	SetWeaponDamageModifier(`WEAPON_POOLCUE`, 0.1) -- Melee
	SetWeaponDamageModifier(`WEAPON_GOLFCLUB`, 0.1) -- Melee
	SetWeaponDamageModifier(`WEAPON_BAT`, 0.1) -- Melee
	SetWeaponDamageModifier(`WEAPON_KNIFE`, 0.2) -- Melee
	SetWeaponDamageModifier(`WEAPON_DAGGER`, 0.2) -- Melee
	SetWeaponDamageModifier(`WEAPON_SWITCHBLADE`, 0.2) -- Melee
	SetWeaponDamageModifier(`WEAPON_MACHETE`, 0.2) -- Melee
	SetWeaponDamageModifier(`WEAPON_HATCHET`, 0.2) -- 
	SetWeaponDamageModifier(`WEAPON_GUSENBERG`, 1.05)
   	SetWeaponDamageModifier(`WEAPON_STUNGUN`, 0.0) -- Pistol / Melee
	SetWeaponDamageModifier(`WEAPON_SMOKEGRENADE`, 0.1) -- Utility
	SetWeaponDamageModifier(`WEAPON_SNOWBALL`, 0.0) -- Utility
	SetWeaponDamageModifier(`WEAPON_HIT_BY_WATER_CANNON`, 0.0) -- Fire Truck Cannon
    DisablePlayerVehicleRewards(GLOBAL_PLYID)					-- Call it once.
    SetAudioFlag("PoliceScannerDisabled", true)
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
	SetRadarBigmapEnabled(false, false)
	while true do
        --
        -- 1 : WANTED_STARS
        -- 2 : WEAPON_ICON
        -- 3 : CASH
        -- 4 : MP_CASH
        -- 5 : MP_MESSAGE
        -- 6 : VEHICLE_NAME
        -- 7 : AREA_NAME
        -- 8 : VEHICLE_CLASS
        -- 9 : STREET_NAME
        -- 10 : HELP_TEXT
        -- 11 : FLOATING_HELP_TEXT_1
        -- 12 : FLOATING_HELP_TEXT_2
        -- 13 : CASH_CHANGE
        -- 14 : RETICLE
        -- 15 : SUBTITLE_TEXT
        -- 16 : RADIO_STATIONS
        -- 17 : SAVING_GAME
        -- 18 : GAME_STREAM
        -- 19 : WEAPON_WHEEL
        -- 20 : WEAPON_WHEEL_STATS
        -- 21 : HUD_COMPONENTS
        -- 22 : HUD_WEAPONS
        --
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(2)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        -- HideHudComponentThisFrame(5)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(10)
        HideHudComponentThisFrame(11)
        HideHudComponentThisFrame(12)
        HideHudComponentThisFrame(13)
        HideHudComponentThisFrame(14)
        HideHudComponentThisFrame(15)
        HideHudComponentThisFrame(16)
        HideHudComponentThisFrame(17)
        HideHudComponentThisFrame(18)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        -- HideHudComponentThisFrame(21)
        -- HideHudComponentThisFrame(22)

        HudWeaponWheelIgnoreSelection()  -- CAN'T SELECT WEAPON FROM SCROLL WHEEL
        DisableControlAction(0, 37, true)
        
        HideMinimapInteriorMapThisFrame()
        SetRadarZoom(1000)

        local found, currentWeapon = GetCurrentPedWeapon(GLOBAL_PED)
        if found == 1 then 
            DisplayAmmoThisFrame(true)
        else 
            DisplayAmmoThisFrame(false)
        end

        for i = 1, 12 do
			EnableDispatchService(i, false)
		end

		if GetPlayerWantedLevel(GLOBAL_PED) ~= 0 then
			SetPlayerWantedLevel(GLOBAL_PED, 0, false)
			SetPlayerWantedLevelNow(GLOBAL_PED, false)
			SetPlayerWantedLevelNoDrop(GLOBAL_PED, 0, false)
		end

        Citizen.Wait(0)
    end
end)

CreateThread(function()
    while true do
        if GetPed() ~= PlayerPedId() then
            pedId = PlayerPedId()
            SetPedMinGroundTimeForStungun(GLOBAL_PED, 5000)
        end
        if GetPlayer() ~= PlayerId() then
            SetPlayerHealthRechargeMultiplier(GLOBAL_PLYID, 0.0)
        end
        SetPedMinGroundTimeForStungun(GLOBAL_PED, 5000)
        SetPlayerHealthRechargeMultiplier(GLOBAL_PLYID, 0.0)
        SetRadarBigmapEnabled(false, false)
        Wait(2000)
    end
end)

-- DISABLE BLIND FIRING
Citizen.CreateThread(function()
    while true do
        if IsPedInCover(GetPed(), 0) and not IsPedAimingFromCover(GetPed()) then
            DisablePlayerFiring(GetPed(), true)
        end
        Citizen.Wait(0)
    end
end)