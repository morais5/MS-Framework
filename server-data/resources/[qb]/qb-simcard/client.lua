QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('QBCore-simcard:changeNumber')
AddEventHandler('QBCore-simcard:changeNumber', function(xPlayer) 
    DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 20)
    local input = true
    Citizen.CreateThread(function()
        while input do
            if input == true then
                HideHudAndRadarThisFrame()
                if UpdateOnscreenKeyboard() == 3 then
                    input = false
                elseif UpdateOnscreenKeyboard() == 1 then
                    local inputText = GetOnscreenKeyboardResult()
                    local isValid = tonumber(inputText) ~= nil
                    if isValid then
                        if string.len(inputText) == 10 then
                            local rawNumber = number
                                TriggerServerEvent('QBCore-simcard:useSimCard', inputText)        
                                input = false
                            else
                            QBCore.Functions.Notify("Phone numbers need to be 10 digits!", "error")
                            DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 20)
                        end
                    else
                        DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 20)
                        QBCore.Functions.Notify("Phone numbers must only contain digits!", "error")
                    end   
                elseif UpdateOnscreenKeyboard() == 2 then
                    input = false
                end
            end
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent('QBCore-simcard:startNumChange')
AddEventHandler('QBCore-simcard:startNumChange', function(newNum)

    QBCore.Functions.Progressbar("number_change", "Changing Phone Number", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@business@bgen@bgen_no_work@",
        anim = "sit_phone_idle_01_nowork" ,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@bgen@bgen_no_work@", "sit_phone_idle_01_nowork", 1.0)
        QBCore.Functions.Notify("Phone number updated to " .. newNum)
        TriggerServerEvent('QBCore-simcard:changeNumber', newNum)        
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@bgen@bgen_no_work@", "sit_phone_idle_01_nowork", 1.0)
        QBCore.Functions.Notify("Failed!", "error")
    end)
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end