local notInteressted = false

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false

        if not notInteressted then
            for k, v in pairs(QBDiving.SellLocations) do
                local dist = GetDistanceBetweenCoords(pos, v["coords"]["x"], v["coords"]["y"], v["coords"]["z"], true)

                if dist < 20 then
                    inRange = true

                    if dist < 1 then
                        DrawText3D(v["coords"]["x"], v["coords"]["y"], v["coords"]["z"] - 0.1, '~g~G~w~ - Vender coral')

                        if IsControlJustPressed(0, Keys["G"]) then
                            TriggerServerEvent('qb-diving:server:SellCoral')
                            notInteressted = true
                            SetTimeout(60000, ClearTimeOut)
                        end
                    end
                end
            end
        else
            Citizen.Wait(5000)
        end

        if not inRange then
            Citizen.Wait(1500)
        end

        Citizen.Wait(3)
    end
end)

function ClearTimeOut()
    notInteressted = not notInteressted
end