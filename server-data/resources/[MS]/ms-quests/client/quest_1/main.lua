local Q1_Tasks = {
    [1] = {
        TaskCompleted = false,
    }
}

local Q1_Data = {
    [1] = {
        NpcData = nil,
    }
}

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local q1Pos = Q1_Config.Tasks[1].coords
            local dist = GetDistanceBetweenCoords(pos, q1Pos.x, q1Pos.y, q1Pos.z, false)

            if dist <= 10 then
                DrawMarker(2, q1Pos.x, q1Pos.y, q1Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.2, 0.05, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                if dist < 1.5 then
                    DrawText3D(q1Pos.x, q1Pos.y, q1Pos.z, '~g~E~w~ - Read letter')
                    if IsControlJustPressed(0, Config.Keys["E"]) then
                        ReadLetter(true)
                    end
                end
            else
                Citizen.Wait(1500)
            end
        end

        Citizen.Wait(3)
    end
end)

function ReadLetter(bool)
    SendNUIMessage({
        action = "Task1Letter",
        toggle = bool
    })
end