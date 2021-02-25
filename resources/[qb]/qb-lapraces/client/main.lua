QBCore = nil

RaceData = {
    InCreator = false,
    InRace = false,
    ClosestCheckpoint = 0,
}

CreatorData = {
    RaceName = nil,
    Checkpoints = {},
    TireDistance = 3.0,
    ConfirmDelete = false,
}

CurrentRaceData = {
    RaceId = nil,
    RaceName = nil,
    Checkpoints = {},
    Started = false,
    CurrentCheckpoint = nil,
    TotalLaps = 0,
    Lap = 0,
}

local Countdown = 10

function IsInRace()
    local retval = false
    if RaceData.InRace then
        retval = true
    end
    return retval
end

function IsInEditor()
    local retval = false
    if RaceData.InCreator then
        retval = true
    end
    return retval
end

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('qb-lapraces:client:StartRaceEditor')
AddEventHandler('qb-lapraces:client:StartRaceEditor', function(RaceName)
    if not RaceData.InCreator then
        CreatorData.RaceName = RaceName
        RaceData.InCreator = true
        CreatorUI()
        CreatorLoop()
    else
        QBCore.Functions.Notify('Ja estas a fazer uma corrida.', 'error')
    end 
end)

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

function GetClosestCheckpoint()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for id, house in pairs(CreatorData.Checkpoints) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y, CreatorData.Checkpoints[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y, CreatorData.Checkpoints[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y, CreatorData.Checkpoints[id].coords.z, true)
            current = id
        end
    end
    RaceData.ClosestCheckpoint = current
end

function CreatorUI()
    Citizen.CreateThread(function()
        while true do
            if RaceData.InCreator then
                SendNUIMessage({
                    action = "Update",
                    type = "creator",
                    data = CreatorData,
                    racedata = RaceData,
                    active = true,
                })
            else
                SendNUIMessage({
                    action = "Update",
                    type = "creator",
                    data = CreatorData,
                    racedata = RaceData,
                    active = false,
                })
                break
            end
            Citizen.Wait(200)
        end
    end)
end

function CreatorLoop()
    Citizen.CreateThread(function()
        while RaceData.InCreator do
            local PlayerPed = GetPlayerPed(-1)
            local PlayerVeh = GetVehiclePedIsIn(PlayerPed)

            if PlayerVeh ~= 0 then
                if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustPressed(0, Keys["7"]) then
                    AddCheckpoint()
                end

                if IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustPressed(0, Keys["8"]) then
                    if CreatorData.Checkpoints ~= nil and next(CreatorData.Checkpoints) ~= nil then
                        DeleteCheckpoint()
                    else
                        QBCore.Functions.Notify('Ainda não definiste um checkpoint ..', 'error')
                    end
                end

                if IsControlJustPressed(0, Keys["K"]) or IsDisabledControlJustPressed(0, Keys["K"]) then
                    if CreatorData.Checkpoints ~= nil and #CreatorData.Checkpoints >= 2 then
                        SaveRace()
                    else
                        QBCore.Functions.Notify('O minimo de checkpoints é 10', 'error')
                    end
                end

                if IsControlJustPressed(0, Keys["]"]) or IsDisabledControlJustPressed(0, Keys["]"]) then
                    if CreatorData.TireDistance + 1.0 ~= 16.0 then
                        CreatorData.TireDistance = CreatorData.TireDistance + 1.0
                    else
                        QBCore.Functions.Notify('Não podes fazer mais que 15')
                    end
                end

                if IsControlJustPressed(0, Keys["["]) or IsDisabledControlJustPressed(0, Keys["["]) then
                    if CreatorData.TireDistance - 1.0 ~= 1.0 then
                        CreatorData.TireDistance = CreatorData.TireDistance - 1.0
                    else
                        QBCore.Functions.Notify('Tens que ter no minimo 2')
                    end
                end
            else
                local coords = GetEntityCoords(GetPlayerPed(-1))
                DrawText3Ds(coords.x, coords.y, coords.z, 'You have to be in a vehicle .')
            end

            if IsControlJustPressed(0, Keys["9"]) or IsDisabledControlJustPressed(0, Keys["9"]) then
                if not CreatorData.ConfirmDelete then
                    CreatorData.ConfirmDelete = true
                    QBCore.Functions.Notify('Clica outra vez no [9] para confirmar', 'error', 5000)
                else
                    for id, CheckpointData in pairs(CreatorData.Checkpoints) do
                        if CheckpointData.blip ~= nil then
                            RemoveBlip(CheckpointData.blip)
                        end
                    end

                    for id,_ in pairs(CreatorData.Checkpoints) do
                        if CreatorData.Checkpoints[id].pileleft ~= nil then
                            local coords = CreatorData.Checkpoints[id].offset.left
                            local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 8.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                            DeleteObject(Obj)
                            ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                            CreatorData.Checkpoints[id].pileleft = nil
                        end

                        if CreatorData.Checkpoints[id].pileright ~= nil then
                            local coords = CreatorData.Checkpoints[id].offset.right
                            local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 8.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                            DeleteObject(Obj)
                            ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                            CreatorData.Checkpoints[id].pileright = nil
                        end
                    end

                    RaceData.InCreator = false
                    CreatorData.RaceName = nil
                    CreatorData.Checkpoints = {}
                    QBCore.Functions.Notify('Editor-Corrida Cancelado!', 'error')
                    CreatorData.ConfirmDelete = false
                end
            end
            Citizen.Wait(3)
        end
    end)
end

function SaveRace()
    local RaceDistance = 0

    for k, v in pairs(CreatorData.Checkpoints) do
        if k + 1 <= #CreatorData.Checkpoints then
            local checkpointdistance = GetDistanceBetweenCoords(v.coords.x, v.coords.y, v.coords.z, CreatorData.Checkpoints[k + 1].coords.x, CreatorData.Checkpoints[k + 1].coords.y, CreatorData.Checkpoints[k + 1].coords.z, true)
            RaceDistance = RaceDistance + checkpointdistance
        end
    end

    CreatorData.RaceDistance = RaceDistance

    TriggerServerEvent('qb-lapraces:server:SaveRace', CreatorData)

    QBCore.Functions.Notify('Corrida: '..CreatorData.RaceName..' salva!', 'success')

    for id,_ in pairs(CreatorData.Checkpoints) do
        if CreatorData.Checkpoints[id].blip ~= nil then
            RemoveBlip(CreatorData.Checkpoints[id].blip)
            CreatorData.Checkpoints[id].blip = nil
        end
        if CreatorData.Checkpoints[id] ~= nil then
            if CreatorData.Checkpoints[id].pileleft ~= nil then
                local coords = CreatorData.Checkpoints[id].offset.left
                local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                DeleteObject(Obj)
                ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                CreatorData.Checkpoints[id].pileleft = nil
            end
            if CreatorData.Checkpoints[id].pileright ~= nil then
                local coords = CreatorData.Checkpoints[id].offset.right
                local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                DeleteObject(Obj)
                ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                CreatorData.Checkpoints[id].pileright = nil
            end
        end
    end

    RaceData.InCreator = false
    CreatorData.RaceName = nil
    CreatorData.Checkpoints = {}
end

function AddCheckpoint()
    local PlayerPed = GetPlayerPed(-1)
    local PlayerPos = GetEntityCoords(PlayerPed)
    local PlayerVeh = GetVehiclePedIsIn(PlayerPed)
    local Offset = {
        left = {
            x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).x,
            y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).y,
            z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).z,
        },
        right = {
            x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).x,
            y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).y,
            z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).z,
        }
    }

    table.insert(CreatorData.Checkpoints, {
        coords = {
            x = PlayerPos.x,
            y = PlayerPos.y,
            z = PlayerPos.z,
        },
        offset = Offset,
    })


    for id, CheckpointData in pairs(CreatorData.Checkpoints) do
        if CheckpointData.blip ~= nil then
            RemoveBlip(CheckpointData.blip)
        end

        CheckpointData.blip = AddBlipForCoord(CheckpointData.coords.x, CheckpointData.coords.y, CheckpointData.coords.z)
        
        SetBlipSprite(CheckpointData.blip, 1)
        SetBlipDisplay(CheckpointData.blip, 4)
        SetBlipScale(CheckpointData.blip, 0.8)
        SetBlipAsShortRange(CheckpointData.blip, true)
        SetBlipColour(CheckpointData.blip, 26)
        ShowNumberOnBlip(CheckpointData.blip, id)
        SetBlipShowCone(CheckpointData.blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Checkpoint: "..id)
        EndTextCommandSetBlipName(CheckpointData.blip)
    end
end

function DeleteCheckpoint()
    local NewCheckpoints = {}
    if RaceData.ClosestCheckpoint ~= 0 then
        if CreatorData.Checkpoints[RaceData.ClosestCheckpoint] ~= nil then
            if CreatorData.Checkpoints[RaceData.ClosestCheckpoint].blip ~= nil then
                RemoveBlip(CreatorData.Checkpoints[RaceData.ClosestCheckpoint].blip)
                CreatorData.Checkpoints[RaceData.ClosestCheckpoint].blip = nil
            end
            if CreatorData.Checkpoints[RaceData.ClosestCheckpoint].pileleft ~= nil then
                local coords = CreatorData.Checkpoints[RaceData.ClosestCheckpoint].offset.left
                local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                DeleteObject(Obj)
                ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                CreatorData.Checkpoints[RaceData.ClosestCheckpoint].pileleft = nil
            end
            if CreatorData.Checkpoints[RaceData.ClosestCheckpoint].pileright ~= nil then
                local coords = CreatorData.Checkpoints[RaceData.ClosestCheckpoint].offset.right
                local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                DeleteObject(Obj)
                ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                CreatorData.Checkpoints[RaceData.ClosestCheckpoint].pileright = nil
            end

            for id, data in pairs(CreatorData.Checkpoints) do
                if id ~= RaceData.ClosestCheckpoint then
                    table.insert(NewCheckpoints, data)
                end
            end
            CreatorData.Checkpoints = NewCheckpoints
        else
            QBCore.Functions.Notify('Não podes ir tão rapido..', 'error')
        end
    else
        QBCore.Functions.Notify('Não podes ir tão rapido..', 'error')
    end
end

RegisterNetEvent('qb-lapraces:client:UpdateRaceRacerData')
AddEventHandler('qb-lapraces:client:UpdateRaceRacerData', function(RaceId, RaceData)
    if (CurrentRaceData.RaceId ~= nil) and CurrentRaceData.RaceId == RaceId then
        CurrentRaceData.Racers = RaceData.Racers
    end
end)

Citizen.CreateThread(function()
    while true do
        if RaceData.InCreator then
            local PlayerPed = GetPlayerPed(-1)
            local PlayerVeh = GetVehiclePedIsIn(PlayerPed)

            if PlayerVeh ~= 0 then
                local Offset = {
                    left = {
                        x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).x,
                        y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).y,
                        z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).z,
                    },
                    right = {
                        x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).x,
                        y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).y,
                        z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).z,
                    }
                }

                DrawText3Ds(Offset.left.x, Offset.left.y, Offset.left.z, 'Checkpoint L')
                DrawText3Ds(Offset.right.x, Offset.right.y, Offset.right.z, 'Checkpoint R')
            end
        end
        Citizen.Wait(3)
    end
end)

function SetupPiles()
    for k, v in pairs(CreatorData.Checkpoints) do
        if CreatorData.Checkpoints[k].pileleft == nil then
            ClearAreaOfObjects(v.offset.left.x, v.offset.left.y, v.offset.left.z, 50.0, 0)
            CreatorData.Checkpoints[k].pileleft = CreateObject(GetHashKey("prop_offroad_tyres02"), v.offset.left.x, v.offset.left.y, v.offset.left.z, 0, 0, 0)
            PlaceObjectOnGroundProperly(CreatorData.Checkpoints[k].pileleft)
            FreezeEntityPosition(CreatorData.Checkpoints[k].pileleft, 1)
            SetEntityAsMissionEntity(CreatorData.Checkpoints[k].pileleft, 1, 1)
        end

        if CreatorData.Checkpoints[k].pileright == nil then
            ClearAreaOfObjects(v.offset.right.x, v.offset.right.y, v.offset.right.z, 50.0, 0)
            CreatorData.Checkpoints[k].pileright = CreateObject(GetHashKey("prop_offroad_tyres02"), v.offset.right.x, v.offset.right.y, v.offset.right.z, 0, 0, 0)
            PlaceObjectOnGroundProperly(CreatorData.Checkpoints[k].pileright)
            FreezeEntityPosition(CreatorData.Checkpoints[k].pileleft, 1)
            SetEntityAsMissionEntity(CreatorData.Checkpoints[k].pileleft, 1, 1)
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(CreatorData.Checkpoints) do
            if CreatorData.Checkpoints[k].pileleft ~= nil then
                local coords = CreatorData.Checkpoints[k].offset.right
                local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                DeleteObject(Obj)
                ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                CreatorData.Checkpoints[k].pileright = nil
            end
            if CreatorData.Checkpoints[k].pileright ~= nil then
                local coords = CreatorData.Checkpoints[k].offset.right
                local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                DeleteObject(Obj)
                ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                CreatorData.Checkpoints[k].pileright = nil
            end
        end

        for k, v in pairs(CurrentRaceData.Checkpoints) do
            if CurrentRaceData.Checkpoints[k] ~= nil then
                if CurrentRaceData.Checkpoints[k].pileleft ~= nil then
                    local coords = CurrentRaceData.Checkpoints[k].offset.right
                    local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                    DeleteObject(Obj)
                    ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                    CurrentRaceData.Checkpoints[k].pileright = nil
                end
                if CurrentRaceData.Checkpoints[k].pileright ~= nil then
                    local coords = CurrentRaceData.Checkpoints[k].offset.right
                    local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
                    DeleteObject(Obj)
                    ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
                    CurrentRaceData.Checkpoints[k].pileright = nil
                end
            end
        end
    end
end)

RegisterNetEvent('qb-lapraces:client:JoinRace')
AddEventHandler('qb-lapraces:client:JoinRace', function(Data, Laps)
    if not RaceData.InRace then
        RaceData.InRace = true
        SetupRace(Data, Laps)
        TriggerServerEvent('qb-lapraces:server:UpdateRaceState', CurrentRaceData.RaceId, false, true)
    else
        QBCore.Functions.Notify('Your already in a race..', 'error')
    end
end)

RegisterNetEvent('qb-lapraces:client:LeaveRace')
AddEventHandler('qb-lapraces:client:LeaveRace', function(data)
    QBCore.Functions.Notify('You have left the race!')
    for k, v in pairs(CurrentRaceData.Checkpoints) do
        if CurrentRaceData.Checkpoints[k].blip ~= nil then
            RemoveBlip(CurrentRaceData.Checkpoints[k].blip)
            CurrentRaceData.Checkpoints[k].blip = nil
        end
        if CurrentRaceData.Checkpoints[k].pileleft ~= nil then
            local coords = CurrentRaceData.Checkpoints[k].offset.left
            local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
            DeleteObject(Obj)
            ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
            CurrentRaceData.Checkpoints[k].pileleft = nil
        end
        if CurrentRaceData.Checkpoints[k].pileright ~= nil then
            local coords = CurrentRaceData.Checkpoints[k].offset.right
            local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
            DeleteObject(Obj)
            ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
            CurrentRaceData.Checkpoints[k].pileright = nil
        end
    end
    CurrentRaceData.RaceName = nil
    CurrentRaceData.Checkpoints = {}
    CurrentRaceData.Started = false
    CurrentRaceData.CurrentCheckpoint = 0
    CurrentRaceData.TotalLaps = 0
    CurrentRaceData.Lap = 0
    CurrentRaceData.RaceTime = 0
    CurrentRaceData.TotalTime = 0
    CurrentRaceData.BestLap = 0
    CurrentRaceData.RaceId = nil
    RaceData.InRace = false
    FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
end)

local FinishedUITimeout = false

function RaceUI()
    Citizen.CreateThread(function()
        while true do
            if CurrentRaceData.Checkpoints ~= nil and next(CurrentRaceData.Checkpoints) ~= nil then
                if CurrentRaceData.Started then
                    CurrentRaceData.RaceTime = CurrentRaceData.RaceTime + 1
                    CurrentRaceData.TotalTime = CurrentRaceData.TotalTime + 1
                end
                SendNUIMessage({
                    action = "Update",
                    type = "race",
                    data = {
                        CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint,
                        TotalCheckpoints = #CurrentRaceData.Checkpoints,
                        TotalLaps = CurrentRaceData.TotalLaps,
                        CurrentLap = CurrentRaceData.Lap,
                        RaceStarted = CurrentRaceData.Started,
                        RaceName = CurrentRaceData.RaceName,
                        Time = CurrentRaceData.RaceTime,
                        TotalTime = CurrentRaceData.TotalTime,
                        BestLap = CurrentRaceData.BestLap,
                    },
                    racedata = RaceData,
                    active = true,
                })
            else
                if not FinishedUITimeout then
                    FinishedUITimeout = true
                    SetTimeout(10000, function()
                        FinishedUITimeout = false
                        SendNUIMessage({
                            action = "Update",
                            type = "race",
                            data = {},
                            racedata = RaceData,
                            active = false,
                        })
                    end)
                end
                break
            end
            Citizen.Wait(12)
        end
    end)
end

function SetupRace(RaceData, Laps)
    RaceData.RaceId = RaceData.RaceId
    CurrentRaceData = {
        RaceId = RaceData.RaceId,
        Creator = RaceData.Creator,
        RaceName = RaceData.RaceName,
        Checkpoints = RaceData.Checkpoints,
        Started = false,
        CurrentCheckpoint = 1,
        TotalLaps = Laps,
        Lap = 1,
        RaceTime = 0,
        TotalTime = 0,
        BestLap = 0,
        Racers = {}
    }

    for k, v in pairs(CurrentRaceData.Checkpoints) do
        ClearAreaOfObjects(v.offset.left.x, v.offset.left.y, v.offset.left.z, 50.0, 0)
        CurrentRaceData.Checkpoints[k].pileleft = CreateObject(GetHashKey("prop_offroad_tyres02"), v.offset.left.x, v.offset.left.y, v.offset.left.z, 0, 0, 0)
        PlaceObjectOnGroundProperly(CurrentRaceData.Checkpoints[k].pileleft)
        FreezeEntityPosition(CurrentRaceData.Checkpoints[k].pileleft, 1)
        SetEntityAsMissionEntity(CurrentRaceData.Checkpoints[k].pileleft, 1, 1)

        ClearAreaOfObjects(v.offset.right.x, v.offset.right.y, v.offset.right.z, 50.0, 0)
        CurrentRaceData.Checkpoints[k].pileright = CreateObject(GetHashKey("prop_offroad_tyres02"), v.offset.right.x, v.offset.right.y, v.offset.right.z, 0, 0, 0)
        PlaceObjectOnGroundProperly(CurrentRaceData.Checkpoints[k].pileright)
        FreezeEntityPosition(CurrentRaceData.Checkpoints[k].pileright, 1)
        SetEntityAsMissionEntity(CurrentRaceData.Checkpoints[k].pileright, 1, 1)

        CurrentRaceData.Checkpoints[k].blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(CurrentRaceData.Checkpoints[k].blip, 1)
        SetBlipDisplay(CurrentRaceData.Checkpoints[k].blip, 4)
        SetBlipScale(CurrentRaceData.Checkpoints[k].blip, 0.6)
        SetBlipAsShortRange(CurrentRaceData.Checkpoints[k].blip, true)
        SetBlipColour(CurrentRaceData.Checkpoints[k].blip, 26)
        ShowNumberOnBlip(CurrentRaceData.Checkpoints[k].blip, k)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Checkpoint: "..k)
        EndTextCommandSetBlipName(CurrentRaceData.Checkpoints[k].blip)
    end

    RaceUI()
end

function showNonLoopParticle(dict, particleName, coords, scale, time)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    local particleHandle = StartParticleFxLoopedAtCoord(particleName, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, scale, false, false, false)
    SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
    return particleHandle
end

function DoPilePfx()
    if CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint] ~= nil then
        local Timeout = 500
        local Size = 2.0
        local left = showNonLoopParticle('core', 'ent_sht_flame', CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint].offset.left, Size)
        local right = showNonLoopParticle('core', 'ent_sht_flame', CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint].offset.right, Size)

        SetTimeout(Timeout, function()
            StopParticleFxLooped(left, false)
            StopParticleFxLooped(right, false)
        end)
    end
end

RegisterNetEvent('qb-lapraces:client:RaceCountdown')
AddEventHandler('qb-lapraces:client:RaceCountdown', function()
    TriggerServerEvent('qb-lapraces:server:UpdateRaceState', CurrentRaceData.RaceId, true, false)
    if CurrentRaceData.RaceId ~= nil then
        while Countdown ~= 0 do
            if CurrentRaceData.RaceName ~= nil then
                if Countdown == 10 then
                    QBCore.Functions.Notify('The race will start in 10 seconds', 'error', 2500)
                    PlaySound(-1, "slow", "SHORT_PLAYER_SWITCH_SOUND_SET", 0, 0, 1)
                elseif Countdown <= 5 then
                    QBCore.Functions.Notify(Countdown, 'error', 500)
                    PlaySound(-1, "slow", "SHORT_PLAYER_SWITCH_SOUND_SET", 0, 0, 1)
                end
                Countdown = Countdown - 1
                FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), true), true)
            else
                break
            end
            Citizen.Wait(1000)
        end
        if CurrentRaceData.RaceName ~= nil then
            SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
            QBCore.Functions.Notify('GO!', 'success', 1000)
            SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].blip, 1.0)
            FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), true), false)
            DoPilePfx()
            CurrentRaceData.Started = true
            Countdown = 10
        else
            FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1), true), false)
            Countdown = 10
        end
    else
        QBCore.Functions.Notify('You are currently notin a race..', 'error')
    end
end)

function IsRaceCreator(CitizenId)
    local retval = false
    if CurrentRaceData.RaceId ~= nil then
        if CurrentRaceData.Creator == CitizenId then
            retval = true
        end
    end
    return retval
end

function GetMaxDistance(OffsetCoords)
    local Distance = GetDistanceBetweenCoords(OffsetCoords.left.x, OffsetCoords.left.y, OffsetCoords.left.z, OffsetCoords.right.x, OffsetCoords.right.y, OffsetCoords.right.z, true)
    local Retval = 7.5
    if Distance > 20.0 then
        Retval = 12.5
    end
    return Retval
end

Citizen.CreateThread(function()
    while true do

        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if CurrentRaceData.RaceName ~= nil then
            if CurrentRaceData.Started then
                local cp = 0
                if CurrentRaceData.CurrentCheckpoint + 1 > #CurrentRaceData.Checkpoints then
                    cp = 1
                else
                    cp = CurrentRaceData.CurrentCheckpoint + 1
                end
                local data = CurrentRaceData.Checkpoints[cp]
                local CheckpointDistance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z, true)
                local MaxDistance = GetMaxDistance(CurrentRaceData.Checkpoints[cp].offset)

                if CheckpointDistance < MaxDistance then
                    if CurrentRaceData.TotalLaps == 0 then
                        if CurrentRaceData.CurrentCheckpoint + 1 < #CurrentRaceData.Checkpoints then
                            CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                            SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
                            TriggerServerEvent('qb-lapraces:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                            DoPilePfx()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint].blip, 0.6)
                            SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].blip, 1.0)
                        else
                            DoPilePfx()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                            TriggerServerEvent('qb-lapraces:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, true)
                            FinishRace()
                        end
                    else
                        if CurrentRaceData.CurrentCheckpoint + 1 > #CurrentRaceData.Checkpoints then
                            if CurrentRaceData.Lap + 1 > CurrentRaceData.TotalLaps then
                                DoPilePfx()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                                TriggerServerEvent('qb-lapraces:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, true)
                                FinishRace()
                            else
                                DoPilePfx()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                if CurrentRaceData.RaceTime < CurrentRaceData.BestLap then
                                    CurrentRaceData.BestLap = CurrentRaceData.RaceTime
                                elseif CurrentRaceData.BestLap == 0 then
                                    CurrentRaceData.BestLap = CurrentRaceData.RaceTime
                                end
                                CurrentRaceData.RaceTime = 0
                                CurrentRaceData.Lap = CurrentRaceData.Lap + 1
                                CurrentRaceData.CurrentCheckpoint = 1
                                SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
                                TriggerServerEvent('qb-lapraces:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                            end
                        else
                            CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                            if CurrentRaceData.CurrentCheckpoint ~= #CurrentRaceData.Checkpoints then
                                SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
                                TriggerServerEvent('qb-lapraces:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                                SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint].blip, 0.6)
                                SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].blip, 1.0)
                            else
                                SetNewWaypoint(CurrentRaceData.Checkpoints[1].coords.x, CurrentRaceData.Checkpoints[1].coords.y)
                                TriggerServerEvent('qb-lapraces:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                                SetBlipScale(CurrentRaceData.Checkpoints[#CurrentRaceData.Checkpoints].blip, 0.6)
                                SetBlipScale(CurrentRaceData.Checkpoints[1].blip, 1.0)
                            end
                            DoPilePfx()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                    end
                end
            else
                local data = CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint]
                -- DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'Ga hier staan')
                DrawMarker(4, data.coords.x, data.coords.y, data.coords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.9, 1.5, 1.5, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    local retval = 0
    if seconds <= 0 then
        retval = "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        retval = hours..":"..mins..":"..secs
    end
    return retval
end

function FinishRace()
    TriggerServerEvent('qb-lapraces:server:FinishPlayer', CurrentRaceData, CurrentRaceData.TotalTime, CurrentRaceData.TotalLaps, CurrentRaceData.BestLap)
    if CurrentRaceData.BestLap ~= 0 then
        QBCore.Functions.Notify('Race finished '..SecondsToClock(CurrentRaceData.TotalTime)..', Whit best lap as: '..SecondsToClock(CurrentRaceData.BestLap))
    else
        QBCore.Functions.Notify('Race finished '..SecondsToClock(CurrentRaceData.TotalTime))
    end
    for k, v in pairs(CurrentRaceData.Checkpoints) do
        if CurrentRaceData.Checkpoints[k].blip ~= nil then
            RemoveBlip(CurrentRaceData.Checkpoints[k].blip)
            CurrentRaceData.Checkpoints[k].blip = nil
        end
        if CurrentRaceData.Checkpoints[k].pileleft ~= nil then
            local coords = CurrentRaceData.Checkpoints[k].offset.left
            local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
            DeleteObject(Obj)
            ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
            CurrentRaceData.Checkpoints[k].pileleft = nil
        end
        if CurrentRaceData.Checkpoints[k].pileright ~= nil then
            local coords = CurrentRaceData.Checkpoints[k].offset.right
            local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, GetHashKey("prop_offroad_tyres02"), 0, 0, 0)
            DeleteObject(Obj)
            ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
            CurrentRaceData.Checkpoints[k].pileright = nil
        end
    end
    CurrentRaceData.RaceName = nil
    CurrentRaceData.Checkpoints = {}
    CurrentRaceData.Started = false
    CurrentRaceData.CurrentCheckpoint = 0
    CurrentRaceData.TotalLaps = 0
    CurrentRaceData.Lap = 0
    CurrentRaceData.RaceTime = 0
    CurrentRaceData.TotalTime = 0
    CurrentRaceData.BestLap = 0
    CurrentRaceData.RaceId = nil
    RaceData.InRace = false
end

RegisterNetEvent('qb-lapraces:client:PlayerFinishs')
AddEventHandler('qb-lapraces:client:PlayerFinishs', function(RaceId, Place, FinisherData)
    if CurrentRaceData.RaceId ~= nil then
        if CurrentRaceData.RaceId == RaceId then
            QBCore.Functions.Notify(FinisherData.PlayerData.charinfo.firstname..' Finished on place : '..Place, 'error', 3500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if RaceData.InCreator then
            GetClosestCheckpoint()
            SetupPiles()
        end
        Citizen.Wait(1000)
    end
end)

local ToFarCountdown = 10

RegisterNetEvent('qb-lapraces:client:WaitingDistanceCheck')
AddEventHandler('qb-lapraces:client:WaitingDistanceCheck', function()
    Wait(1000)
    Citizen.CreateThread(function()
        while true do
            if not CurrentRaceData.Started then
                local ped = GetPlayerPed(-1)
                local pos = GetEntityCoords(ped)
                if CurrentRaceData.Checkpoints[1] ~= nil then
                    local cpcoords = CurrentRaceData.Checkpoints[1].coords
                    local dist = GetDistanceBetweenCoords(pos, cpcoords.x, cpcoords.y, cpcoords.z, true)
                    if dist > 115.0 then
                        if ToFarCountdown ~= 0 then
                            ToFarCountdown = ToFarCountdown - 1
                            QBCore.Functions.Notify('Go back to the start in 10 seconds: '..ToFarCountdown..'s', 'error', 500)
                        else
                            TriggerServerEvent('qb-lapraces:server:LeaveRace', CurrentRaceData)
                            ToFarCountdown = 10
                            break
                        end
                        Citizen.Wait(1000)
                    else
                        if ToFarCountdown ~= 10 then
                            ToFarCountdown = 10
                        end
                    end
                end
            else
                break
            end
            Citizen.Wait(3)
        end
    end)
end)