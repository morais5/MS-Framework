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

local inRadialMenu = false

function setupSubItems()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] then
            if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                Config.MenuItems[4].items = {
                    [1] = {
                        id = 'emergencybutton2',
                        title = 'BotaoDeEmergencia',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:SendPoliceEmergencyAlert',
                        shouldClose = true,
                    },
                }
            end
        else
            if Config.JobInteractions[PlayerData.job.name] ~= nil and next(Config.JobInteractions[PlayerData.job.name]) ~= nil then
                Config.MenuItems[4].items = Config.JobInteractions[PlayerData.job.name]
            else 
                Config.MenuItems[4].items = {}
            end
        end
    end)

    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))

    if Vehicle ~= nil or Vehicle ~= 0 then
        local AmountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle))

        if AmountOfSeats == 2 then
            Config.MenuItems[3].items[3].items = {
                [1] = {
                    id    = -1,
                    title = 'Condutor',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 0,
                    title = 'Co-Piloto',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 3 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Condutor',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Co-Piloto',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Outras',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 4 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Condutor',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Co-Piloto',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Traseiro Esquerdo',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 2,
                    title = 'Traseiro Direito',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        end
    end
end

function openRadial(bool)    
    setupSubItems()

    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        radial = bool,
        items = Config.MenuItems
    })
    inRadialMenu = bool
end

function closeRadial(bool)    
    SetNuiFocus(false, false)
    inRadialMenu = bool
end

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        if IsControlJustPressed(0, Keys["K"]) then
            openRadial(true)
            SetCursorLocation(0.5, 0.5)
        end
    end
end)

RegisterNUICallback('closeRadial', function()
    closeRadial(false)
end)

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData

    if itemData.type == 'client' then
        TriggerEvent(itemData.event, itemData)
    elseif itemData.type == 'server' then
        TriggerServerEvent(itemData.event, itemData)
    end
end)

RegisterNetEvent('qb-radialmenu:client:noPlayers')
AddEventHandler('qb-radialmenu:client:noPlayers', function(data)
    QBCore.Functions.Notify('Ninguem por perto', 'error', 2500)
end)

RegisterNetEvent('qb-radialmenu:client:giveidkaart')
AddEventHandler('qb-radialmenu:client:giveidkaart', function(data)
    print('Im a trigerd event :)')
end)

RegisterNetEvent('qb-radialmenu:client:openDoor')
AddEventHandler('qb-radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)
    local ped = GetPlayerPed(-1)
    local closestVehicle = nil

    if IsPedInAnyVehicle(ped, false) then
        closestVehicle = GetVehiclePedIsIn(ped)
    else
        closestVehicle = getNearestVeh()
    end

    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = GetVehicleNumberPlateText(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        QBCore.Functions.Notify('Nenhum veiculo por perto...', 'error', 2500)
    end
end)

RegisterNetEvent('qb-radialmenu:client:setExtra')
AddEventHandler('qb-radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    local enginehealth = 1000.0
    local bodydamage = 1000.0

    if veh ~= nil then
        local plate = GetVehicleNumberPlateText(closestVehicle)
    
        if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            if DoesExtraExist(veh, extra) then 
                if IsVehicleExtraTurnedOn(veh, extra) then
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    SetVehicleExtra(veh, extra, 1)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    QBCore.Functions.Notify('Extra ' .. extra .. ' Desativado', 'error', 2500)
                else
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    SetVehicleExtra(veh, extra, 0)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    QBCore.Functions.Notify('Extra ' .. extra .. ' Ativado', 'success', 2500)
                end    
            else
                QBCore.Functions.Notify('Extra ' .. extra .. ' Não existe neste veiculo ', 'error', 2500)
            end
        else
            QBCore.Functions.Notify('Não és o condutor do veiculo !', 'error', 2500)
        end
    end
end)

RegisterNetEvent('qb-radialmenu:trunk:client:Door')
AddEventHandler('qb-radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))

    if veh ~= 0 then
        local pl = GetVehicleNumberPlateText(veh)

        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

local Seats = {
    ["-1"] = "Condutor",
    ["0"] = "Passageiro",
    ["1"] = "Traseiro Esquerdo",
    ["2"] = "Traseiro Direito",
}

RegisterNetEvent('qb-radialmenu:client:ChangeSeat')
AddEventHandler('qb-radialmenu:client:ChangeSeat', function(data)
    local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
    local HasHarnass = exports['qb-smallresources']:HasHarness()
    if not HasHarnass then
        local kmh = (speed * 3.6);  

        if IsSeatFree then
            if kmh <= 100.0 then
                SetPedIntoVehicle(GetPlayerPed(-1), Veh, data.id)
                QBCore.Functions.Notify('Mudas-te de assento para  '..data.title..'!')
            else
                QBCore.Functions.Notify('Diminui a velocidade para alterares de assento..')
            end
        else
            QBCore.Functions.Notify('Esse lugar esta ocupado..')
        end
    else
        QBCore.Functions.Notify('Tens um cinto de 3 pontas, não consegues alterar o lugar...', 'error')
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