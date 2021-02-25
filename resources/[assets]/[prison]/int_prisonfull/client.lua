RegisterNetEvent('prison:client:JailAlarm')
AddEventHandler('prison:client:JailAlarm', function(toggle)
    if toggle then
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")

        RefreshInterior(alarmIpl)
        EnableInteriorProp(alarmIpl, "prison_alarm")
    
        Citizen.CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Citizen.Wait(100)
            end
            StartAlarm("PRISON_ALARMS", true)
        end)
    else
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")

        RefreshInterior(alarmIpl)
        DisableInteriorProp(alarmIpl, "prison_alarm")
    
        Citizen.CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Citizen.Wait(100)
            end
            StopAllAlarms(true)
        end)
    end
end)