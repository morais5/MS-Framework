QBCore = nil

local isLoggedIn = true
local CurrentWeaponData = {}
local PlayerData = {}
local CanShoot = true

function DrawText3Ds(x, y, z, text)
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
        if isLoggedIn then
            TriggerServerEvent("weapons:server:SaveWeaponAmmo")
        end
        Citizen.Wait(60000)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    if QBCore.Functions.GetPlayerData() ~= nil then
        TriggerServerEvent("weapons:server:LoadWeaponAmmo")
        isLoggedIn = true
        PlayerData = QBCore.Functions.GetPlayerData()

        QBCore.Functions.TriggerCallback("weapons:server:GetConfig", function(RepairPoints)
            for k, data in pairs(RepairPoints) do
                Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
                Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
            end
        end)
    end
end)

local MultiplierAmount = 0

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
                if IsPedShooting(GetPlayerPed(-1)) or IsControlJustPressed(0, 24) then
                    if CanShoot then
                        local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
                        local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
                        if QBCore.Shared.Weapons[weapon]["name"] == "weapon_snowball" then
                            TriggerServerEvent('QBCore:Server:RemoveItem', "snowball", 1)
                        else
                            if ammo > 0 then
                                MultiplierAmount = MultiplierAmount + 1
                            end
                        end
                    else
                        TriggerEvent('inventory:client:CheckWeapon')
                        QBCore.Functions.Notify("Esta arma esta danificada e não pode ser utilizada..", "error")
                        MultiplierAmount = 0
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local player = PlayerId()
        local weapon = GetSelectedPedWeapon(ped)
        local ammo = GetAmmoInPedWeapon(ped, weapon)

        if ammo == 1 then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            if IsPedInAnyVehicle(ped, true) then
                SetPlayerCanDoDriveBy(player, false)
            end
        else
            EnableControlAction(0, 24, true) -- Attack
			EnableControlAction(0, 257, true) -- Attack 2
            if IsPedInAnyVehicle(ped, true) then
                SetPlayerCanDoDriveBy(player, true)
            end
        end

        if IsPedShooting(ped) then
            print('schiet')
            if ammo - 1 < 1 then
                print('reset')
                SetAmmoInClip(GetPlayerPed(-1), GetHashKey(QBCore.Shared.Weapons[weapon]["name"]), 1)
            end
        end
        
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) then
            local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
            if ammo > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
            else
                TriggerEvent('inventory:client:CheckWeapon')
                TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, 0)
            end

            if MultiplierAmount > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                MultiplierAmount = 0
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount, itemData)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if CurrentWeaponData ~= nil then
        if QBCore.Shared.Weapons[weapon]["name"] ~= "weapon_unarmed" and QBCore.Shared.Weapons[weapon]["ammotype"] == type:upper() then
            local total = (GetAmmoInPedWeapon(GetPlayerPed(-1), weapon))
            local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
            local retval = GetMaxAmmoInClip(ped, weapon, 1)
            retval = tonumber(retval)

            if (total + retval) <= (retval + 1) then
                QBCore.Functions.Progressbar("taking_bullets", "A carregar balas..", math.random(4000, 6000), false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    if QBCore.Shared.Weapons[weapon] ~= nil then
                        SetAmmoInClip(ped, weapon, 0)
                        SetPedAmmo(ped, weapon, retval)
                        TriggerServerEvent("weapons:server:AddWeaponAmmo", CurrentWeaponData, retval)
                        TriggerServerEvent('QBCore:Server:RemoveItem', itemData.name, 1, itemData.slot)
                        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemData.name], "remove")
                        TriggerEvent('QBCore:Notify', retval.." Balas carregadas!", "success")
                    end
                end, function()
                    QBCore.Functions.Notify("Cancelado..", "error")
                end)
            else
                QBCore.Functions.Notify("A tua arma ja esta carregada..", "error")
            end
        else
            QBCore.Functions.Notify("Não tens uma arma..", "error")
        end
    else
        QBCore.Functions.Notify("Não tens uma arma..", "error")
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("weapons:server:LoadWeaponAmmo")
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()

    QBCore.Functions.TriggerCallback("weapons:server:GetConfig", function(RepairPoints)
        for k, data in pairs(RepairPoints) do
            Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
            Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
        end
    end)
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false

    for k, v in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = false
        Config.WeaponRepairPoints[k].RepairingData = {}
    end
end)

RegisterNetEvent('weapons:client:SetWeaponQuality')
AddEventHandler('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
        TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, amount)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            local inRange = false
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)

            for k, data in pairs(Config.WeaponRepairPoints) do
                local distance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z, true)

                if distance < 10 then
                    inRange = true

                    if distance < 1 then
                        if data.IsRepairing then
                            if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'A loja de reparo de armas de momento ~r~NÃO esta~w~ disponivel..')
                            else
                                if not data.RepairingData.Ready then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'A tua arma esta a ser reparada')
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Receber Arma')
                                end
                            end
                        else
                            if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
                                if not data.RepairingData.Ready then
                                    local WeaponData = QBCore.Shared.Weapons[GetHashKey(CurrentWeaponData.name)]
                                    local WeaponClass = (QBCore.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Reparar Arma, ~g~€'..Config.WeaponRepairCotsts[WeaponClass]..'~w~')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        QBCore.Functions.TriggerCallback('weapons:server:RepairWeapon', function(HasMoney)
                                            if HasMoney then
                                                CurrentWeaponData = {}
                                            end
                                        end, k, CurrentWeaponData)
                                    end
                                else
                                    if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'A loja de reparo de armas de momento ~r~NÃO esta~w~ disponivel..')
                                    else
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Receber Arma')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                        end
                                    end
                                end
                            else
                                if data.RepairingData.CitizenId == nil then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'Não tens nenhuma arma na mão..')
                                elseif data.RepairingData.CitizenId == PlayerData.citizenid then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Receber Arma')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if not inRange then
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent("weapons:client:SyncRepairShops")
AddEventHandler("weapons:client:SyncRepairShops", function(NewData, key)
    Config.WeaponRepairPoints[key].IsRepairing = NewData.IsRepairing
    Config.WeaponRepairPoints[key].RepairingData = NewData.RepairingData
end)

RegisterNetEvent("weapons:client:EquipAttachment")
AddEventHandler("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = QBCore.Shared.Weapons[weapon]
    
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData.name = WeaponData.name:upper()
        if Config.WeaponAttachments[WeaponData.name] ~= nil then
            if Config.WeaponAttachments[WeaponData.name][attachment] ~= nil then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, Config.WeaponAttachments[WeaponData.name][attachment])
            else
                QBCore.Functions.Notify("Esta arma não suporta este acessorio..", "error")
            end
        end
    else
        QBCore.Functions.Notify("Não tens nenhuma arma na mão..", "error")
    end
end)

RegisterNetEvent("addAttachment")
AddEventHandler("addAttachment", function(component)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = QBCore.Shared.Weapons[weapon]
    GiveWeaponComponentToPed(ped, GetHashKey(WeaponData.name), GetHashKey(component))
end)