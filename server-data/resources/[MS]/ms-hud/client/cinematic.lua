CC_MaxHeight = 0.4
CC_Bool = false
w = 0

TriggerEvent('chat:addSuggestion', '/letterbox', 'Give yourself a dramatic effect with black bars.')
RegisterCommand("letterbox", function()
    CC_Bool = not CC_Bool
    CC_Display(CC_Bool)
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if w > 0 then
            sleep = 3
            DrawRects()
        end
        Wait(sleep)
    end
end)

function DrawRects()
    DrawRect(0.0, 0.0, 2.0, w, 0, 0, 0, 255)
    DrawRect(0.0, 1.0, 2.0, w, 0, 0, 0, 255)
end

function CC_Display(bool)
    if bool then
        TriggerEvent('ms-hud:client:toggleui', false)
        DisplayRadar(false)
        for i = 0, CC_MaxHeight, 0.01 do 
            Wait(10)
            w = i
        end
    else
        TriggerEvent('ms-hud:client:toggleui', true)
        if IsPedInAnyVehicle(GLOBAL_PED, false) then
            DisplayRadar(true)
        end
        for i = CC_MaxHeight, 0, -0.01 do
            Wait(10)
            w = i
        end 
    end
end