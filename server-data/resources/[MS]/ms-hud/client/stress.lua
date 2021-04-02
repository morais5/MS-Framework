PlayerJob = {}
stress = 0
local StressGain = 0
local IsGaining = false

RegisterNetEvent("MSCore:Client:OnPlayerUnload")
AddEventHandler("MSCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
    msHud.Show = false
    SendNUIMessage({
        action = "hudtick",
        show = true,
    })
end)

RegisterNetEvent("MSCore:Client:OnPlayerLoaded")
AddEventHandler("MSCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    msHud.Show = true
    PlayerJob = MSCore.Functions.GetPlayerData().job
end)

Citizen.CreateThread(function()
    while true do
        --local ped = PlayerPedId()

        if IsPedShooting(GLOBAL_PED) then
            local StressChance = math.random(1, 3)
            local odd = math.random(1, 3)
            if StressChance == odd then
                local PlusStress = math.random(2, 4) / 100
                StressGain = StressGain + PlusStress
            end
            if not IsGaining then
                IsGaining = true
            end
        else
            if IsGaining then
                IsGaining = false
            end
        end

        if (PlayerJob.name ~= "police") then
            if IsPlayerFreeAiming(GLOBAL_PLYID) and not IsPedShooting(GLOBAL_PED) then
                local CurrentWeapon = GetSelectedPedWeapon(GLOBAL_PED)
                local WeaponData = MSCore.Shared.Weapons[CurrentWeapon]
                if WeaponData.name:upper() ~= "WEAPON_UNARMED" then
                    local StressChance = math.random(1, 20)
                    local odd = math.random(1, 20)
                    if StressChance == odd then
                        local PlusStress = math.random(1, 3) / 100
                        StressGain = StressGain + PlusStress
                    end
                end
                if not IsGaining then
                    IsGaining = true
                end
            else
                if IsGaining then
                    IsGaining = false
                end
            end
        end

        Citizen.Wait(4)
    end
end)

RegisterNetEvent('ms-hud:client:UpdateStress')
AddEventHandler('ms-hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

Citizen.CreateThread(function()
    while true do
        if not IsGaining then
            StressGain = math.ceil(StressGain)
            if StressGain > 0 then
                TriggerEvent("DoShortHudText", 'Gained stress')
                TriggerServerEvent('ms-hud:Server:UpdateStress', StressGain)
                StressGain = 0
            end
        end

        Citizen.Wait(3000)
    end
end)

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(msHud.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(msHud.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        --local ped = PlayerPedId()
        local Wait = GetEffectInterval(stress)
        if stress >= 90 then
            local ShakeIntensity = GetShakeIntensity(stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 3000, 500)

            if not IsPedRagdoll(GLOBAL_PED) and IsPedOnFoot(GLOBAL_PED) and not IsPedSwimming(GLOBAL_PED) then
                --local player = PlayerPedId()
                SetPedToRagdollWithFall(GLOBAL_PED, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(GLOBAL_PED), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end

            Citizen.Wait(500)
            for i = 1, FallRepeat, 1 do
                Citizen.Wait(750)
                DoScreenFadeOut(200)
                Citizen.Wait(1000)
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                SetFlash(0, 0, 200, 750, 200)
            end
        elseif stress >= msHud.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 2500, 500)
        end
        Citizen.Wait(Wait)
    end
end)