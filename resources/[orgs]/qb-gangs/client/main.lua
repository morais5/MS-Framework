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

isLoggedIn = false
local PlayerGang = {}


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
end)

-- Codigo
function DrawText3D(x, y, z, text)
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

-- Bloods

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "bloods" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnbloods"].coords.x, Config.Locations["ogcarspawnbloods"].coords.y, Config.Locations["ogcarspawnbloods"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["ogcarspawnbloods"].coords.x, Config.Locations["ogcarspawnbloods"].coords.y, Config.Locations["ogcarspawnbloods"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnbloods"].coords.x, Config.Locations["ogcarspawnbloods"].coords.y, Config.Locations["ogcarspawnbloods"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["ogcarspawnbloods"].coords.x, Config.Locations["ogcarspawnbloods"].coords.y, Config.Locations["ogcarspawnbloods"].coords.z, "~g~E~w~ - Guardar Veiculo")
                        else
                            DrawText3D(Config.Locations["ogcarspawnbloods"].coords.x, Config.Locations["ogcarspawnbloods"].coords.y, Config.Locations["ogcarspawnbloods"].coords.z, "~g~E~w~ - Garagem")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                ogVehicleSpawnBloods()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "bloods" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashbloods"].coords.x, Config.Locations["stashbloods"].coords.y, Config.Locations["stashbloods"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashbloods"].coords.x, Config.Locations["stashbloods"].coords.y, Config.Locations["stashbloods"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashbloods"].coords.x, Config.Locations["stashbloods"].coords.y, Config.Locations["stashbloods"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashbloods"].coords.x, Config.Locations["stashbloods"].coords.y, Config.Locations["stashbloods"].coords.z, "~g~E~w~ - Armario ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            print('nonce')
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "bloodstash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "bloodstash")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

-- Hyper

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "hyper" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnhyper"].coords.x, Config.Locations["ogcarspawnhyper"].coords.y, Config.Locations["ogcarspawnhyper"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["ogcarspawnhyper"].coords.x, Config.Locations["ogcarspawnhyper"].coords.y, Config.Locations["ogcarspawnhyper"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnhyper"].coords.x, Config.Locations["ogcarspawnhyper"].coords.y, Config.Locations["ogcarspawnhyper"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["ogcarspawnhyper"].coords.x, Config.Locations["ogcarspawnhyper"].coords.y, Config.Locations["ogcarspawnhyper"].coords.z, "~g~E~w~ - Guardar Veiculo")
                        else
                            DrawText3D(Config.Locations["ogcarspawnhyper"].coords.x, Config.Locations["ogcarspawnhyper"].coords.y, Config.Locations["ogcarspawnhyper"].coords.z, "~g~E~w~ - Garagem")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                ogVehicleSpawnHyper()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "hyper" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashhyper"].coords.x, Config.Locations["stashhyper"].coords.y, Config.Locations["stashhyper"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashhyper"].coords.x, Config.Locations["stashhyper"].coords.y, Config.Locations["stashhyper"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashhyper"].coords.x, Config.Locations["stashhyper"].coords.y, Config.Locations["stashhyper"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashhyper"].coords.x, Config.Locations["stashhyper"].coords.y, Config.Locations["stashhyper"].coords.z, "~g~E~w~ - Armario ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            print('nonce')
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "stashhyper", {
                                maxweight = 999999999999999999,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "stashhyper")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

-- Bahamas

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "bahamas" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnbahamas"].coords.x, Config.Locations["ogcarspawnbahamas"].coords.y, Config.Locations["ogcarspawnbahamas"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["ogcarspawnbahamas"].coords.x, Config.Locations["ogcarspawnbahamas"].coords.y, Config.Locations["ogcarspawnbahamas"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnbahamas"].coords.x, Config.Locations["ogcarspawnbahamas"].coords.y, Config.Locations["ogcarspawnbahamas"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["ogcarspawnbahamas"].coords.x, Config.Locations["ogcarspawnbahamas"].coords.y, Config.Locations["ogcarspawnbahamas"].coords.z, "~g~E~w~ - Guardar Veiculo")
                        else
                            DrawText3D(Config.Locations["ogcarspawnbahamas"].coords.x, Config.Locations["ogcarspawnbahamas"].coords.y, Config.Locations["ogcarspawnbahamas"].coords.z, "~g~E~w~ - Garagem")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                ogVehicleSpawnBahamas()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "bahamas" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashbahamas"].coords.x, Config.Locations["stashbahamas"].coords.y, Config.Locations["stashbahamas"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashbahamas"].coords.x, Config.Locations["stashbahamas"].coords.y, Config.Locations["stashbahamas"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashbahamas"].coords.x, Config.Locations["stashbahamas"].coords.y, Config.Locations["stashbahamas"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashbahamas"].coords.x, Config.Locations["stashbahamas"].coords.y, Config.Locations["stashbahamas"].coords.z, "~g~E~w~ - Armario ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            print('nonce')
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "bahamasstash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "bahamasstash")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

-- Vanilla

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "vanilla" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnvanilla"].coords.x, Config.Locations["ogcarspawnvanilla"].coords.y, Config.Locations["ogcarspawnvanilla"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["ogcarspawnvanilla"].coords.x, Config.Locations["ogcarspawnvanilla"].coords.y, Config.Locations["ogcarspawnvanilla"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnvanilla"].coords.x, Config.Locations["ogcarspawnvanilla"].coords.y, Config.Locations["ogcarspawnvanilla"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["ogcarspawnvanilla"].coords.x, Config.Locations["ogcarspawnvanilla"].coords.y, Config.Locations["ogcarspawnvanilla"].coords.z, "~g~E~w~ - Guardar Veiculo")
                        else
                            DrawText3D(Config.Locations["ogcarspawnvanilla"].coords.x, Config.Locations["ogcarspawnvanilla"].coords.y, Config.Locations["ogcarspawnvanilla"].coords.z, "~g~E~w~ - Garagem")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                ogVehicleSpawnVanilla()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "vanilla" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashvanilla"].coords.x, Config.Locations["stashvanilla"].coords.y, Config.Locations["stashvanilla"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashvanilla"].coords.x, Config.Locations["stashvanilla"].coords.y, Config.Locations["stashvanilla"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashvanilla"].coords.x, Config.Locations["stashvanilla"].coords.y, Config.Locations["stashvanilla"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashvanilla"].coords.x, Config.Locations["stashvanilla"].coords.y, Config.Locations["stashvanilla"].coords.z, "~g~E~w~ - Armario ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            print('nonce')
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "vanillastash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "vanillastash")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

----Groove-----

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "groove" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnGroove"].coords.x, Config.Locations["ogcarspawnGroove"].coords.y, Config.Locations["ogcarspawnGroove"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["ogcarspawnGroove"].coords.x, Config.Locations["ogcarspawnGroove"].coords.y, Config.Locations["ogcarspawnGroove"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnGroove"].coords.x, Config.Locations["ogcarspawnGroove"].coords.y, Config.Locations["ogcarspawnGroove"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["ogcarspawnGroove"].coords.x, Config.Locations["ogcarspawnGroove"].coords.y, Config.Locations["ogcarspawnGroove"].coords.z, "~g~E~w~ - Guardar Veiculo")
                        else
                            DrawText3D(Config.Locations["ogcarspawnGroove"].coords.x, Config.Locations["ogcarspawnGroove"].coords.y, Config.Locations["ogcarspawnGroove"].coords.z, "~g~E~w~ - Garagem")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                ogVehicleSpawnGroove()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "groove" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashGroove"].coords.x, Config.Locations["stashGroove"].coords.y, Config.Locations["stashGroove"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashGroove"].coords.x, Config.Locations["stashGroove"].coords.y, Config.Locations["stashGroove"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashGroove"].coords.x, Config.Locations["stashGroove"].coords.y, Config.Locations["stashGroove"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashGroove"].coords.x, Config.Locations["stashGroove"].coords.y, Config.Locations["stashGroove"].coords.z, "~g~E~w~ - Armario ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Groovestash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "Groovestash")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

-------Cartel-------

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "cartel" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnCartel"].coords.x, Config.Locations["ogcarspawnCartel"].coords.y, Config.Locations["ogcarspawnCartel"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["ogcarspawnCartel"].coords.x, Config.Locations["ogcarspawnCartel"].coords.y, Config.Locations["ogcarspawnCartel"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnCartel"].coords.x, Config.Locations["ogcarspawnCartel"].coords.y, Config.Locations["ogcarspawnCartel"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["ogcarspawnCartel"].coords.x, Config.Locations["ogcarspawnCartel"].coords.y, Config.Locations["ogcarspawnCartel"].coords.z, "~g~E~w~ - Guardar Veiculo")
                        else
                            DrawText3D(Config.Locations["ogcarspawnCartel"].coords.x, Config.Locations["ogcarspawnCartel"].coords.y, Config.Locations["ogcarspawnCartel"].coords.z, "~g~E~w~ - Garagem")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                ogVehicleSpawnCartel()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "cartel"  then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashCartel"].coords.x, Config.Locations["stashCartel"].coords.y, Config.Locations["stashCartel"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashCartel"].coords.x, Config.Locations["stashCartel"].coords.y, Config.Locations["stashCartel"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashCartel"].coords.x, Config.Locations["stashCartel"].coords.y, Config.Locations["stashCartel"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashCartel"].coords.x, Config.Locations["stashCartel"].coords.y, Config.Locations["stashCartel"].coords.z, "~g~E~w~ - Armario ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Carteltash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "Carteltash")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

-------Mafia-------

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "mafia" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnMafia"].coords.x, Config.Locations["ogcarspawnMafia"].coords.y, Config.Locations["ogcarspawnMafia"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["ogcarspawnMafia"].coords.x, Config.Locations["ogcarspawnMafia"].coords.y, Config.Locations["ogcarspawnMafia"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["ogcarspawnMafia"].coords.x, Config.Locations["ogcarspawnMafia"].coords.y, Config.Locations["ogcarspawnMafia"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["ogcarspawnMafia"].coords.x, Config.Locations["ogcarspawnMafia"].coords.y, Config.Locations["ogcarspawnMafia"].coords.z, "~g~E~w~ - Guardar Veiculo")
                        else
                            DrawText3D(Config.Locations["ogcarspawnMafia"].coords.x, Config.Locations["ogcarspawnMafia"].coords.y, Config.Locations["ogcarspawnMafia"].coords.z, "~g~E~w~ - Garagem")
                        end
                        if IsControlJustReleased(0, Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                ogVehicleSpawnMafia()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerGang.name == "mafia" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashMafia"].coords.x, Config.Locations["stashMafia"].coords.y, Config.Locations["stashMafia"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["stashMafia"].coords.x, Config.Locations["stashMafia"].coords.y, Config.Locations["stashMafia"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["stashMafia"].coords.x, Config.Locations["stashMafia"].coords.y, Config.Locations["stashMafia"].coords.z, true) < 1.5) then
                            DrawText3D(Config.Locations["stashMafia"].coords.x, Config.Locations["stashMafia"].coords.y, Config.Locations["stashMafia"].coords.z, "~g~E~w~ - Armario ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "Mafiastash", {
                                maxweight = 4000000,
                                slots = 500,
                            })
                            TriggerEvent("inventory:client:SetCurrentStash", "Mafiastash")
                            end
                        end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

-- Bloods
function ogVehicleSpawnBloods()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleListBloods", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

-- Hyper
function ogVehicleSpawnHyper()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleListHyper", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

-- Bahamas
function ogVehicleSpawnBahamas()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleListBahamas", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

-- Vanilla
function ogVehicleSpawnVanilla()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleListVanilla", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

-- Cartel
function ogVehicleSpawnCartel()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleListCartel", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

-- Mafia 
function ogVehicleSpawnMafia()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleListMafia", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

-- Groove
function ogVehicleSpawnGroove()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garagem"
    ClearMenu()
    Menu.addButton("Veiculos", "VehicleListGroove", nil)
    Menu.addButton("Fechar Menu", "closeMenuFull", nil) 
end

-- Bloods
function VehicleListBloods(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Veiculos:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicleBloods", k, "Garagem", " Motor: 100%", " Chassi: 100%", " Gasol: 100%")
    end
        
    Menu.addButton("Voltar", "ogVehicleSpawnBloods",nil)
end

-- Hyper
function VehicleListHyper(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Veiculos:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicleHyper", k, "Garagem", " Motor: 100%", " Chassi: 100%", " Gasol: 100%")
    end
        
    Menu.addButton("Voltar", "ogVehicleSpawnHyper",nil)
end

-- Bahamas
function VehicleListBahamas(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Veiculos:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicleBahamas", k, "Garagem", " Motor: 100%", " Chassi: 100%", " Gasol: 100%")
    end
        
    Menu.addButton("Voltar", "ogVehicleSpawnBahamas",nil)
end

-- Vanilla
function VehicleListVanilla(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Veiculos:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicleVanilla", k, "Garagem", " Motor: 100%", " Chassi: 100%", " Gasol: 100%")
    end
        
    Menu.addButton("Voltar", "ogVehicleSpawnVanilla",nil)
end

-- Cartel
function VehicleListCartel(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Veiculos:"
    ClearMenu()
    for k, v in pairs(Config.VehiclesCartel) do
        Menu.addButton(Config.VehiclesCartel[k], "TakeOutVehicleCartel", k, "Garagem", " Motor: 100%", " Chassi: 100%", " Gasol: 100%")
    end
        
    Menu.addButton("Voltar", "ogVehicleSpawnCartel",nil)
end

-- Mafia
function VehicleListMafia(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Veiculos:"
    ClearMenu()
    for k, v in pairs(Config.VehiclesMafia) do
        Menu.addButton(Config.VehiclesMafia[k], "TakeOutVehicleMafia", k, "Garagem", " Motor: 100%", " Chassi: 100%", " Gasol: 100%")
    end
        
    Menu.addButton("Voltar", "ogVehicleSpawnMafia",nil)
end

-- Groove
function VehicleListGroove(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Vehicle:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicleGroove", k, "Garagem", " Motor: 100%", " Chassi: 100%", " Gasol: 100%")
    end
        
    Menu.addButton("Return", "ogVehicleSpawnGroove",nil)
end

function TakeOutVehicleBloods(vehicleInfo)
    local coords = Config.Locations["ogcarspawnbloods"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "OG"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function TakeOutVehicleHyper(vehicleInfo)
    local coords = Config.Locations["ogcarspawnhyper"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "OG"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function TakeOutVehicleBahamas(vehicleInfo)
    local coords = Config.Locations["ogcarspawnbahamas"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "OG"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function TakeOutVehicleVanilla(vehicleInfo)
    local coords = Config.Locations["ogcarspawnvanilla"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "OG"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function TakeOutVehicleCartel(vehicleInfo)
    local coords = Config.Locations["ogcarspawnCartel"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "OG"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 0,0,0)
        SetVehicleCustomSecondaryColour(veh, 0,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function TakeOutVehicleGroove(vehicleInfo)
    local coords = Config.Locations["ogcarspawnGroove"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "OG"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 45, 216, 0)
        SetVehicleCustomSecondaryColour(veh, 45, 216, 0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function TakeOutVehicleMafia(vehicleInfo)
    local coords = Config.Locations["ogcarspawnMafia"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "OG"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 0,0,0)
        SetVehicleCustomSecondaryColour(veh, 0,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end