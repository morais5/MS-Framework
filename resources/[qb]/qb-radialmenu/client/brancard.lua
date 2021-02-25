local IsAttached = false
local BrancardObject = nil
local IsLayingOnBed = false

local ValidVIEKELS = {
    "asprinter",
    "aeklasse",
}

function CheckForVehicles()
    local PlayerPed = GetPlayerPed(-1)
    local PlayerPos = GetEntityCoords(PlayerPed)
    local veh = 0
    for k, v in pairs(ValidVIEKELS) do
        veh = GetClosestVehicle(PlayerPos.x, PlayerPos.y, PlayerPos.z, 7.5, GetHashKey(v), 70)
        if veh ~= 0 then
            break
        end
    end
    return veh
end

RegisterNetEvent('hospital:client:TakeBrancard')
AddEventHandler('hospital:client:TakeBrancard', function()
    local PlayerPed = GetPlayerPed(-1)
    local PlayerPos = GetEntityCoords(PlayerPed)
    local Vehicle = CheckForVehicles()

    if Vehicle ~= 0 then
        local VehCoords = GetOffsetFromEntityInWorldCoords(PlayerPed, 0, 0.75, 0)
        LoadModel("prop_ld_binbag_01")
        Obj = CreateObject(GetHashKey('prop_ld_binbag_01'), GetEntityCoords(PlayerPedId()), true)
        if Obj ~= nil or Obj ~= 0 then
            SetEntityRotation(Obj, 0.0, 0.0, GetEntityHeading(Vehicle), false, false)
            FreezeEntityPosition(Obj, true)
            PlaceObjectOnGroundProperly(Obj)
            BrancardObject = Obj
            SetTimeout(200, function()
                AttachToBrancard()
                IsAttached = true
            end)
        else
            QBCore.Functions.Notify("Algo deu errado meu amigo..", 'error')
        end
    else
        QBCore.Functions.Notify("Você não está perto de uma ambulância..", 'error')
    end
end)

RegisterNetEvent('hospital:client:RemoveBrancard')
AddEventHandler('hospital:client:RemoveBrancard', function()
    local PlayerPed = GetPlayerPed(-1)
    local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0, 1.5, 0)

    if BrancardObject ~= nil then
        local BCoords = GetEntityCoords(BrancardObject)
        local Dist = GetDistanceBetweenCoords(PlayerPos.x, PlayerPos.y, PlayerPos.z, BCoords.x, BCoords.y, BCoords.z, true)

        if Dist < 3.0 then
            if DoesEntityExist(BrancardObject) then
                DeleteEntity(BrancardObject)
                ClearPedTasks(PlayerPed)
                DetachEntity(PlayerPed, false, true)
                TriggerServerEvent('qb-radialmenu:server:RemoveBrancard', PlayerPos, BrancardObject)
                IsAttached = false
                BrancardObject = nil
                IsLayingOnBed = false
            end
        else
            QBCore.Functions.Notify('Estas muito longe!', 'error')
        end
    end
end)

function SetClosestBrancard()
    local Ped = GetPlayerPed(-1)
    local c = GetEntityCoords(Ped)
    local Object = GetClosestObjectOfType(c.x, c.y, c.z, 10.0, GetHashKey("prop_ld_binbag_01"), false, false, false)

    if Object ~= 0 then
        BrancardObject = Object
    end
end

Citizen.CreateThread(function()
    while true do
        SetClosestBrancard()
        Citizen.Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while true do
        local PlayerPed = GetPlayerPed(-1)
        local PlayerPos = GetEntityCoords(PlayerPed)
        
        if BrancardObject ~= nil then
            local ObjectCoords = GetEntityCoords(BrancardObject)
            local OffsetCoords = GetOffsetFromEntityInWorldCoords(BrancardObject, 0, 0.85, 0)
            local Distance = GetDistanceBetweenCoords(PlayerPos, OffsetCoords.x, OffsetCoords.y, OffsetCoords.z, true)

            if Distance <= 1.0 then
                if not IsAttached then
                    DrawText3Ds(OffsetCoords.x, OffsetCoords.y, OffsetCoords.z, '~g~E~w~ -Pegar na Maca / ~g~H~w~ Travar')
                    if IsControlJustPressed(0, 51) then
                        AttachToBrancard()
                        IsAttached = true
                    end
                    if IsControlJustPressed(0, Keys["H"]) then
                        FreezeEntityPosition(BrancardObject, true)
                    end
                else
                    DrawText3Ds(OffsetCoords.x, OffsetCoords.y, OffsetCoords.z, '~g~E~w~ - Largar Maca')
                    if IsControlJustPressed(0, 51) then
                        DetachBrancard()
                        IsAttached = false
                    end
                end

                if not IsLayingOnBed then
                    if not IsAttached then
                        DrawText3Ds(OffsetCoords.x, OffsetCoords.y, OffsetCoords.z + 0.2, '~g~G~w~ - Deitar na maca')
                        if IsControlJustPressed(0, Keys["G"]) or IsDisabledControlJustPressed(0, Keys["G"]) then
                            LayOnBrancard()
                        end
                    end
                end
            elseif Distance <= 2 then
                if not IsLayingOnBed then
                    DrawText3Ds(OffsetCoords.x, OffsetCoords.y, OffsetCoords.z, 'Aproxima-te')
                else
                    if not IsAttached then
                        DrawText3Ds(OffsetCoords.x, OffsetCoords.y, OffsetCoords.z + 0.2, '~g~G~w~ - Sair da Maca')
                        if IsControlJustPressed(0, Keys["G"]) or IsDisabledControlJustPressed(0, Keys["G"]) then
                            GetOffBrancard()
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

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


RegisterNetEvent('qb-radialmenu:client:RemoveBrancardFromArea')
AddEventHandler('qb-radialmenu:client:RemoveBrancardFromArea', function(PlayerPos, BObject)
    local Ped = GetPlayerPed(-1)
    local Pos = GetEntityCoords(Ped)

    if Pos ~= PlayerPos then
        local Distance = GetDistanceBetweenCoords(Pos.x, Pos.y, Pos.z, PlayerPos.x, PlayerPos.y, PlayerPos.z, true)

        if BrancardObject ~= nil or BrancardObject ~= 0 then
            if BrancardObject == BObject then
                if Distance < 10 then
                    if IsEntityPlayingAnim(Ped, 'anim@heists@box_carry@', 'idle', false) then
                        DetachBrancard()
                    end

                    if IsEntityPlayingAnim(Ped, "anim@gangops@morgue@table@", "ko_front", false) then
                        local Coords = GetOffsetFromEntityInWorldCoords(Ped, 0.85, 0.0, 0)
                        ClearPedTasks(Ped)
                        DetachEntity(Ped, false, true)
                        SetEntityCoords(Ped, Coords.x, Coords.y, Coords.z)
                        IsLayingOnBed = false
                    end
                end
            end
        end
    end
end)

function LayOnBrancard()
    local inBedDicts = "anim@gangops@morgue@table@"
    local inBedAnims = "ko_front"
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)
    local Object = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("prop_ld_binbag_01"), false, false, false)
    local player, distance = GetClosestPlayer()

    if player == -1 then
        LoadAnim(inBedDicts)
        if Object ~= nil or Object ~= 0 then
            TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
            AttachEntityToEntity(PlayerPed, Object, 0, 0, 0.0, 1.6, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
            IsLayingOnBed = true
        end
    else
        if distance < 2.0 then
            TriggerServerEvent('qb-radialmenu:Brancard:BusyCheck', GetPlayerServerId(player), "lay")
        else
            LoadAnim(inBedDicts)
            if Object ~= nil or Object ~= 0 then
                TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
                AttachEntityToEntity(PlayerPed, Object, 0, 0, 0.0, 1.6, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
                IsLayingOnBed = true
            end
        end
    end
end

RegisterNetEvent('qb-radialmenu:Brancard:client:BusyCheck')
AddEventHandler('qb-radialmenu:Brancard:client:BusyCheck', function(OtherId, type)
    local ped = GetPlayerPed(-1)
    if type == "lay" then
        LoadAnim("anim@gangops@morgue@table@")
        IsEntityPlayingAnim(entity, animDict, animName, p4)
        if IsEntityPlayingAnim(ped, "anim@gangops@morgue@table@", "ko_front", 3) then
            TriggerServerEvent('qb-radialmenu:server:BusyResult', true, OtherId, type)
        else
            TriggerServerEvent('qb-radialmenu:server:BusyResult', false, OtherId, type)
        end
    else
        LoadAnim('anim@heists@box_carry@')
        if IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
            TriggerServerEvent('qb-radialmenu:server:BusyResult', true, OtherId, type)
        else
            TriggerServerEvent('qb-radialmenu:server:BusyResult', false, OtherId, type)
        end
    end
end)

RegisterNetEvent('qb-radialmenu:client:Result')
AddEventHandler('qb-radialmenu:client:Result', function(IsBusy, type)
    local inBedDicts = "anim@gangops@morgue@table@"
    local inBedAnims = "ko_front"
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)
    local Object = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("prop_ld_binbag_01"), false, false, false)
    
    if type == "lay" then
        if not IsBusy then
            NetworkRequestControlOfEntity(BrancardObject)
            LoadAnim(inBedDicts)
            TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
            AttachEntityToEntity(PlayerPed, Object, 0, 0, 0.0, 1.6, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
            IsLayingOnBed = true
        else
            QBCore.Functions.Notify("Esta maca ja esta em uso!", "error")
            IsLayingOnBed = false
        end
    else
        if not IsBusy then
            NetworkRequestControlOfEntity(BrancardObject)
            LoadAnim("anim@heists@box_carry@")
            TaskPlayAnim(PlayerPed, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
            SetTimeout(150, function()
                AttachEntityToEntity(BrancardObject, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, -1.0, -1.0, 195.0, 180.0, 180.0, 90.0, false, false, true, false, 2, true)
            end)
            FreezeEntityPosition(Obj, false)
            IsAttached = true
        else
            QBCore.Functions.Notify("Esta maca ja esta em uso!", "error")
            IsAttached = false
        end
    end
end)

function GetOffBrancard()
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)
    local Coords = GetOffsetFromEntityInWorldCoords(BrancardObject, 0.85, 0.0, 0)

    ClearPedTasks(PlayerPed)
    DetachEntity(PlayerPed, false, true)
    SetEntityCoords(PlayerPed, Coords.x, Coords.y, Coords.z)
    IsLayingOnBed = false
end

local DetachKeys = {157, 158, 160, 164, 165, 73, 36}
Citizen.CreateThread(function()
    while true do
        if IsAttached then
            for _, PressedKey in pairs(DetachKeys) do
                if IsControlJustPressed(0, PressedKey) or IsDisabledControlJustPressed(0, PressedKey) then
                    DetachBrancard()
                end
            end

            if IsPedShooting(GetPlayerPed(-1)) or IsPlayerFreeAiming(PlayerId()) or IsPedInMeleeCombat(GetPlayerPed(-1)) then
                DetachBrancard()
            end

            if IsPedDeadOrDying(GetPlayerPed(-1), false) then
                DetachBrancard()
            end

            if IsPedRagdoll(GetPlayerPed(-1)) then
                DetachBrancard()
            end
        else
            Citizen.Wait(1000)
        end 
        Citizen.Wait(5)
    end
end)

function AttachToBrancard()
    local PlayerPed = PlayerPedId()
    local ClosestPlayer, distance = GetClosestPlayer()
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)

    if BrancardObject ~= nil then
        if ClosestPlayer == -1 then
            NetworkRequestControlOfEntity(BrancardObject)
            LoadAnim("anim@heists@box_carry@")
            TaskPlayAnim(PlayerPed, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
            SetTimeout(150, function()
                AttachEntityToEntity(BrancardObject, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, -1.0, -1.0, 195.0, 180.0, 180.0, 90.0, false, false, true, false, 2, true)
            end)
            FreezeEntityPosition(Obj, false)
        else
            if distance < 2.0 then
                TriggerServerEvent('qb-radialmenu:Brancard:BusyCheck', GetPlayerServerId(ClosestPlayer), "attach")
            else
                NetworkRequestControlOfEntity(BrancardObject)
                LoadAnim("anim@heists@box_carry@")
                TaskPlayAnim(PlayerPed, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
                SetTimeout(150, function()
                    AttachEntityToEntity(BrancardObject, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, -1.0, -1.0, 195.0, 180.0, 180.0, 90.0, false, false, true, false, 2, true)
                end)
                FreezeEntityPosition(Obj, false)
            end
        end
    end
end


function DetachBrancard()
    local PlayerPed = GetPlayerPed(-1)
    DetachEntity(BrancardObject, false, true)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    IsAttached = false
end

Citizen.CreateThread(function()
    Wait(1000)
    local Ped = GetPlayerPed(-1)
    local Pos = GetEntityCoords(Ped)
    local Object = GetClosestObjectOfType(Pos.x, Pos.y, Pos.z, 5.0, GetHashKey("prop_ld_binbag_01"), false, false, false)
    DeleteObject(Object)
    ClearPedTasksImmediately(GetPlayerPed(-1))
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if BrancardObject ~= nil then
            DetachBrancard()
            DeleteObject(BrancardObject)
            ClearPedTasksImmediately(GetPlayerPed(-1))
        end
    end
end)

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end