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

local plateChecked = nil

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

Citizen.CreateThread( function()
    Citizen.Wait( 1000 )
    local resourceName = GetCurrentResourceName()
    SendNUIMessage( { resourcename = resourceName } )
end )

SetNuiFocus(false)

function round( num )
    return tonumber( string.format( "%.0f", num ) )
end

function oppang( ang )
    return ( ang + 180 ) % 360 
end 

function FormatSpeed( speed )
    return string.format( "%03d", speed )
end 

function GetVehicleInDirectionSphere( entFrom, coordFrom, coordTo )
    local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    return vehicle
end

function IsEntityInMyHeading( myAng, tarAng, range )
    local rangeStartFront = myAng - ( range / 2 )
    local rangeEndFront = myAng + ( range / 2 )

    local opp = oppang( myAng )

    local rangeStartBack = opp - ( range / 2 )
    local rangeEndBack = opp + ( range / 2 )

    if ( ( tarAng > rangeStartFront ) and ( tarAng < rangeEndFront ) ) then 
        return true 
    elseif ( ( tarAng > rangeStartBack ) and ( tarAng < rangeEndBack ) ) then 
        return false 
    else 
        return nil 
    end 
end 

local radarEnabled = false 
local hidden = false 
local radarInfo = 
{ 
    patrolSpeed = "000", 

    speedType = "kmh", 

    plateLocked = false,
    lockedPlate = "",

    fwdPrevVeh = 0, 
    fwdXmit = true, 
    fwdMode = "same", 
    fwdSpeed = "000", 
    fwdFast = "000", 
    fwdFastLocked = false, 
    fwdDir = nil, 
    fwdFastSpeed = 0,
	fwdPlate = "",

    bwdPrevVeh = 0, 
    bwdXmit = false, 
    bwdMode = "none", 
    bwdSpeed = "OFF", 
    bwdFast = "OFF",
    bwdFastLocked = false, 
    bwdDir = nil, 
    bwdFastSpeed = 0, 
	bwdPlate = "",

    fastResetLimit = 150,
    fastLimit = 130, 

    angles = { [ "same" ] = { x = 0.0, y = 50.0, z = 0.0 }, [ "opp" ] = { x = -10.0, y = 50.0, z = 0.0 } }
}

RegisterNetEvent('wk:toggleRadar')
AddEventHandler('wk:toggleRadar', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "police" then
            local ped = GetPlayerPed( -1 )
            if (IsPedInAnyVehicle( ped ) ) then 
                local vehicle = GetVehiclePedIsIn( ped, false )
    
                if (IsPoliceVehicle(vehicle)) then
                    radarEnabled = not radarEnabled
    
                    ResetFrontAntenna()
                    ResetRearAntenna()
    
                    SendNUIMessage({
                        toggleradar = true, 
                        fwdxmit = radarInfo.fwdXmit, 
                        fwdmode = radarInfo.fwdMode, 
                        bwdxmit = radarInfo.bwdXmit, 
                        bwdmode = radarInfo.bwdMode
                    })
                else 
                    QBCore.Functions.Notify( "Você deve estar em uma viatura policial!", "error")
                end 
            else 
                QBCore.Functions.Notify( "Você deve estar em um veículo!", "error")
            end 
        end
    end)
end)

RegisterNetEvent( 'wk:changeRadarLimit' )
AddEventHandler( 'wk:changeRadarLimit', function( speed ) 
    radarInfo.fastLimit = speed 
    QBCore.Functions.Notify("Velocidade máxima definida em: " .. speed .. "km/u")
end )

function Radar_SetLimit()
    Citizen.CreateThread( function()
        DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )

        while true do 
            if ( UpdateOnscreenKeyboard() == 1 ) then 
                local speedStr = GetOnscreenKeyboardResult()

                if ( string.len( speedStr ) > 0 ) then 
                    local speed = tonumber( speedStr )

                    if ( speed < 999 and speed > 1 ) then 
                        TriggerEvent( 'wk:changeRadarLimit', speed )
                    end 

                    break
                else 
                    DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )
                end 
            elseif ( UpdateOnscreenKeyboard() == 2 ) then 
                break 
            end  

            Citizen.Wait( 0 )
        end 
    end )
end 

function ResetFrontAntenna()
    if ( radarInfo.fwdXmit ) then 
        radarInfo.fwdSpeed = "000"
        radarInfo.fwdFast = "000"  
    else 
        radarInfo.fwdSpeed = "OFF"
        radarInfo.fwdFast = "   "  
    end 

    radarInfo.fwdDir = nil
    radarInfo.fwdFastSpeed = 0 
    radarInfo.fwdFastLocked = false 
end 

function ResetRearAntenna()
    if ( radarInfo.bwdXmit ) then
        radarInfo.bwdSpeed = "000"
        radarInfo.bwdFast = "000"
    else 
        radarInfo.bwdSpeed = "OFF"
        radarInfo.bwdFast = "   "
    end 

    radarInfo.bwdDir = nil
    radarInfo.bwdFastSpeed = 0 
    radarInfo.bwdFastLocked = false
end 

function ResetFrontFast()
    if ( radarInfo.fwdXmit ) then 
        radarInfo.fwdFast = "000"
        radarInfo.fwdFastSpeed = 0
        radarInfo.fwdFastLocked = false 

        radarInfo.lockedPlate = ""
        radarInfo.fwdPlate = ""
        SendNUIMessage({reset = true, lockfwdfast = false, unlockPlate = true})
    end 
end 

function ResetRearFast()
    if ( radarInfo.bwdXmit ) then 
        radarInfo.bwdFast = "000"
        radarInfo.bwdFastSpeed = 0
        radarInfo.bwdFastLocked = false 

        radarInfo.lockedPlate = ""
        radarInfo.bwdPlate = ""

        SendNUIMessage( {reset = true, lockbwdfast = false } )
    end 
end 

function CloseRadarRC()
    SendNUIMessage({
        toggleradarrc = true
    })

    TriggerEvent( 'wk:toggleMenuControlLock', false )

    SetNuiFocus( false )
end 

function ToggleSpeedType()
    if ( radarInfo.speedType == "mph" ) then 
        radarInfo.speedType = "kmh"
    else 
        radarInfo.speedType = "mph"
    end
end 

function GetVehSpeed( veh )
    if ( radarInfo.speedType == "mph" ) then 
        return GetEntitySpeed( veh ) * 2.236936
    else 
        return GetEntitySpeed( veh ) * 3.6
    end 
end 

function ManageVehicleRadar()
    if ( radarEnabled ) then 
        local ped = GetPlayerPed( -1 )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if (IsPoliceVehicle( vehicle )) then 
                -- Patrol speed 
                local vehicleSpeed = round( GetVehSpeed( vehicle ), 0 )

                radarInfo.patrolSpeed = FormatSpeed( vehicleSpeed )

                -- Rest of the radar options 
                local vehiclePos = GetEntityCoords( vehicle, true )
                local h = round( GetEntityHeading( vehicle ), 0 )

                -- Front Antenna 
                if ( radarInfo.fwdXmit ) then  
                    local forwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.fwdMode ].x, radarInfo.angles[ radarInfo.fwdMode ].y, radarInfo.angles[ radarInfo.fwdMode ].z )
                    local fwdPos = { x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z }
                    local _, fwdZ = GetGroundZFor_3dCoord( fwdPos.x, fwdPos.y, fwdPos.z + 500.0 )

                    if ( fwdPos.z < fwdZ and not ( fwdZ > vehiclePos.z + 1.0 ) ) then 
                        fwdPos.z = fwdZ + 0.5
                    end 

                    local packedFwdPos = vector3( fwdPos.x, fwdPos.y, fwdPos.z )
                    local fwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedFwdPos )

                    if ( DoesEntityExist( fwdVeh ) and IsEntityAVehicle( fwdVeh ) ) then 
                        local fwdVehSpeed = round( GetVehSpeed( fwdVeh ), 0 )
						local fwdPlate = tostring( GetVehicleNumberPlateText(fwdVeh) ) or ""
                        local fwdVehHeading = round( GetEntityHeading( fwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, fwdVehHeading, 100 )
						
                        radarInfo.fwdPlate = fwdPlate
                        if (radarInfo.plateLocked and radarInfo.fwdPlate == radarInfo.lockedPlate or not radarInfo.plateLocked) then
                            radarInfo.fwdSpeed = FormatSpeed( fwdVehSpeed )
                        end
                        radarInfo.fwdDir = dir 

                        if ( fwdVehSpeed > radarInfo.fastLimit and not radarInfo.fwdFastLocked ) then 
                            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
							
                            radarInfo.fwdFastSpeed = fwdVehSpeed 
                            radarInfo.fwdFastLocked = true 

                            SendNUIMessage( { lockfwdfast = true } )
                        end 
                        if plateChecked ~= fwdPlate then
                            QBCore.Functions.TriggerCallback('police:IsPlateFlagged', function(result)
                                if result then
                                    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)
                                    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)   
                                    radarInfo.fwdFastSpeed = fwdVehSpeed 
                                    radarInfo.fwdFastLocked = true 
                                    SendNUIMessage( { lockfwdfast = true } )
                                    QBCore.Functions.Notify("Veículo marcado encontrado!", "error")
                                end
                                plateChecked = fwdPlate
                            end, fwdPlate)
                        end

                        radarInfo.fwdFast = FormatSpeed( radarInfo.fwdFastSpeed )

                        radarInfo.fwdPrevVeh = fwdVeh 
                    end
                end 

                -- Rear Antenna 
                if ( radarInfo.bwdXmit ) then 
                    local backwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.bwdMode ].x, -radarInfo.angles[ radarInfo.bwdMode ].y, radarInfo.angles[ radarInfo.bwdMode ].z )
                    local bwdPos = { x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z }
                    local _, bwdZ = GetGroundZFor_3dCoord( bwdPos.x, bwdPos.y, bwdPos.z + 500.0 )              

                    if ( bwdPos.z < bwdZ and not ( bwdZ > vehiclePos.z + 1.0 ) ) then 
                        bwdPos.z = bwdZ + 0.5
                    end

                    local packedBwdPos = vector3( bwdPos.x, bwdPos.y, bwdPos.z )                
                    local bwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedBwdPos )

                    if ( DoesEntityExist( bwdVeh ) and IsEntityAVehicle( bwdVeh ) ) then
                        local bwdVehSpeed = round( GetVehSpeed( bwdVeh ), 0 )
						local bwdPlate = tostring( GetVehicleNumberPlateText(bwdVeh) ) or ""
                        local bwdVehHeading = round( GetEntityHeading( bwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, bwdVehHeading, 100 )
						
						radarInfo.bwdPlate = bwdPlate
                        radarInfo.bwdSpeed = FormatSpeed( bwdVehSpeed )
                        radarInfo.bwdDir = dir 

                        if ( bwdVehSpeed > radarInfo.fastLimit and not radarInfo.bwdFastLocked ) then 
                            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )

                            radarInfo.bwdFastSpeed = bwdVehSpeed 
                            radarInfo.bwdFastLocked = true 

                            SendNUIMessage( { lockbwdfast = true } )
                        end 
                        if plateChecked ~= bwdPlate then
                            QBCore.Functions.TriggerCallback('police:IsPlateFlagged', function(result)
                                if result then
                                    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)
                                    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)
                                    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                                    Citizen.Wait(100)  
                                    radarInfo.bwdFastSpeed = bwdVehSpeed 
                                    radarInfo.bwdFastLocked = true 
                                    SendNUIMessage( { lockbwdfast = true } )
                                    QBCore.Functions.Notify("Marked vehicle found!", "error")
                                end
                                plateChecked = bwdPlate
                            end, bwdPlate)
                            
                        end

                        radarInfo.bwdFast = FormatSpeed( radarInfo.bwdFastSpeed )

                        radarInfo.bwdPrevVeh = bwdVeh 
                    end  
                end  

                SendNUIMessage({
                    patrolspeed = radarInfo.patrolSpeed, 
                    fwdspeed = radarInfo.fwdSpeed, 
                    fwdfast = radarInfo.fwdFast, 
                    fwddir = radarInfo.fwdDir, 
					fwdPlate = radarInfo.fwdPlate,
                    bwdspeed = radarInfo.bwdSpeed, 
                    bwdfast = radarInfo.bwdFast, 
                    bwddir = radarInfo.bwdDir,
					bwdPlate = radarInfo.bwdPlate,
                })
            end 
        end 
    end 
end 

RegisterNetEvent( 'wk:radarRC' )
AddEventHandler( 'wk:radarRC', function()
    Citizen.Wait( 10 )

    TriggerEvent( 'wk:toggleMenuControlLock', true )

    SendNUIMessage({
        toggleradarrc = true
    })

    SetNuiFocus( true, true )
end )

RegisterNUICallback( "RadarRC", function( data, cb ) 
    -- Toggle Radar
    if ( data == "radar_toggle" ) then 
        TriggerEvent( 'wk:toggleRadar' )

    -- Front Antenna 
    elseif ( data == "radar_frontopp" and radarInfo.fwdXmit ) then
        radarInfo.fwdMode = "opp"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontxmit" ) then 
        radarInfo.fwdXmit = not radarInfo.fwdXmit 
        ResetFrontAntenna()
        SendNUIMessage( { fwdxmit = radarInfo.fwdXmit } )

        if ( radarInfo.fwdXmit == false ) then 
            radarInfo.fwdMode = "none" 
        else 
            radarInfo.fwdMode = "same" 
        end 

        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontsame" and radarInfo.fwdXmit ) then 
        radarInfo.fwdMode = "same"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )

    -- Rear Antenna 
    elseif ( data == "radar_rearopp" and radarInfo.bwdXmit ) then
        radarInfo.bwdMode = "opp"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearxmit" ) then 
        radarInfo.bwdXmit = not radarInfo.bwdXmit 
        ResetRearAntenna()
        SendNUIMessage( { bwdxmit = radarInfo.bwdXmit } )

        if ( radarInfo.bwdXmit == false ) then 
            radarInfo.bwdMode = "none" 
        else 
            radarInfo.bwdMode = "same" 
        end 

        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearsame" and radarInfo.bwdXmit ) then 
        radarInfo.bwdMode = "same"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )

    -- Set Fast Limit 
    elseif ( data == "radar_setlimit" ) then 
        CloseRadarRC()
        Radar_SetLimit()

    -- Speed Type 
    elseif ( data == "radar_speedtype" ) then 
        ToggleSpeedType()

    -- Close 
    elseif ( data == "close" ) then 
        CloseRadarRC()
    end 

    if ( cb ) then cb( 'ok' ) end 
end )

Citizen.CreateThread( function()
    SetNuiFocus( false ) 

    while true do 
        ManageVehicleRadar()

        -- Only run 2 times a second, more realistic, also prevents spam 
        Citizen.Wait( 500 )
    end
end )

Citizen.CreateThread( function()
    while true do 
        -- These control pressed natives must be the disabled check ones. 
        if QBCore ~= nil then 
            -- LCtrl is pressed and M has just been pressed 
            if ( IsDisabledControlPressed( 0, Keys["LEFTCTRL"] ) and IsDisabledControlJustPressed( 0, Keys["7"] ) ) then 
                if QBCore.Functions.GetPlayerData().job.name == "police" and QBCore.Functions.GetPlayerData().job.onduty then
                    TriggerEvent( 'wk:radarRC' )
                end
            end 

            -- LCtrl is not being pressed and M has just been pressed 
            if ( not IsDisabledControlPressed( 0, Keys["LEFTCTRL"] ) and IsDisabledControlJustPressed( 0, Keys["7"] ) ) then 
                if QBCore.Functions.GetPlayerData().job.name == "police" and QBCore.Functions.GetPlayerData().job.onduty then
                    ResetFrontFast()
                    ResetRearFast()
                    ResetFrontAntenna()
                    ResetRearAntenna()
                    QBCore.Functions.Notify("PSP foi redefinido")
                end
            end 

            if ( IsDisabledControlJustPressed( 0, Keys["8"] ) ) then 
                if QBCore.Functions.GetPlayerData().job.name == "police" and QBCore.Functions.GetPlayerData().job.onduty then
                    radarInfo.plateLocked = not radarInfo.plateLocked
                    if (radarInfo.plateLocked) then
                        radarInfo.lockedPlate = radarInfo.fwdPlate
                        SendNUIMessage( { lockPlate = true } )
                        QBCore.Functions.Notify("Placa de carro bloqueada: " .. radarInfo.fwdPlate)
                    else
                        SendNUIMessage( { unlockPlate = true } )
                        QBCore.Functions.Notify("Placa de carro desbloqueada")
                    end
                end
            end

            local ped = GetPlayerPed( -1 )
            local inVeh = IsPedSittingInAnyVehicle( ped )
            local veh = nil 

            if ( inVeh ) then
                veh = GetVehiclePedIsIn( ped, false )
            end 

            if ( ( (not inVeh or (inVeh and GetVehicleClass( veh ) ~= 18)) and radarEnabled and not hidden) or IsPauseMenuActive() and radarEnabled ) then 
                hidden = true 
                SendNUIMessage( { hideradar = true } )
            elseif ( inVeh and GetVehicleClass( veh ) == 18 and radarEnabled and hidden ) then 
                hidden = false 
                SendNUIMessage( { hideradar = false } )
            end 
        end
        

        Citizen.Wait( 0 )
    end 
end )

local locked = false 

RegisterNetEvent( 'wk:toggleMenuControlLock' )
AddEventHandler( 'wk:toggleMenuControlLock', function( lock ) 
    locked = lock 
end )

Citizen.CreateThread( function()
    while true do
        if ( locked ) then 
            local ped = GetPlayerPed( -1 )  

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride

            SetPauseMenuActive( false )
        end 

        Citizen.Wait( 0 )
    end 
end )

function IsPoliceVehicle(vehicle)
	local retval = false
    for model, label in pairs(Config.Vehicles) do
		if GetEntityModel(vehicle) == GetHashKey(model) then
			retval = true
		end
	end
	return retval
end