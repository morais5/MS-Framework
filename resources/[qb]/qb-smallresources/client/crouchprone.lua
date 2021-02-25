local stage = 0
local movingForward = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            if IsControlJustReleased(0, Keys["LEFTCTRL"]) then
                stage = stage + 1
                if stage == 2 then
                    -- Crouch stuff
                    ClearPedTasks(GetPlayerPed(-1))
                    RequestAnimSet("move_ped_crouched")
                    while not HasAnimSetLoaded("move_ped_crouched") do
                        Citizen.Wait(0)
                    end

                    SetPedMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)    
                    SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                    SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                elseif stage == 3 then
                    ClearPedTasks(GetPlayerPed(-1))
                    RequestAnimSet("move_crawl")
                    while not HasAnimSetLoaded("move_crawl") do
                        Citizen.Wait(0)
                    end
                elseif stage > 3 then
                    stage = 0
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    ResetAnimSet()
                    SetPedStealthMovement(GetPlayerPed(-1),0,0)
                end
            end

            if stage == 2 then
                if GetEntitySpeed(GetPlayerPed(-1)) > 1.0 then
                    SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                    SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                elseif GetEntitySpeed(GetPlayerPed(-1)) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
                    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
                    ResetPedStrafeClipset(GetPlayerPed(-1))
                end
            elseif stage == 3 then
                DisableControlAction( 0, 21, true ) -- sprint
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)

                if (IsControlPressed(0, Keys["W"]) and not movingForward) then
                    movingForward = true
                    SetPedMoveAnimsBlendOut(GetPlayerPed(-1))
                    local pronepos = GetEntityCoords(GetPlayerPed(-1))
                    TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z+0.1, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 100.0, 0.4, 1.0, 7, 2.0, 1, 1) 
                    Citizen.Wait(500)
                elseif (not IsControlPressed(0, Keys["W"]) and movingForward) then
                    local pronepos = GetEntityCoords(GetPlayerPed(-1))
                    TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z+0.1, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 100.0, 0.4, 1.0, 6, 2.0, 1, 1)
                    Citizen.Wait(500)
                    movingForward = false
                end

                if IsControlPressed(0, Keys["A"]) then
                    SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(GetPlayerPed(-1)) + 1)
                end     

                if IsControlPressed(0, Keys["D"]) then
                    SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(GetPlayerPed(-1)) - 1)
                end 
            end
        else
            stage = 0
            Citizen.Wait(1000)
        end
    end
end)

local walkSet = "default"
RegisterNetEvent("crouchprone:client:SetWalkSet")
AddEventHandler("crouchprone:client:SetWalkSet", function(clipset)
    walkSet = clipset
end)


function ResetAnimSet()
    if walkSet == "default" then
        ResetPedMovementClipset(GetPlayerPed(-1))
        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
        ResetPedStrafeClipset(GetPlayerPed(-1))
    else
        ResetPedMovementClipset(GetPlayerPed(-1))
        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
        ResetPedStrafeClipset(GetPlayerPed(-1))
        Citizen.Wait(100)
        RequestWalking(walkSet)
        SetPedMovementClipset(PlayerPedId(), walkSet, 1)
        RemoveAnimSet(walkSet)
    end
end

function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        Citizen.Wait(1)
    end 
end