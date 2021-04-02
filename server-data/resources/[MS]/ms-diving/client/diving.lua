local CurrentDivingLocation = {
    Area = 0,
    Blip = {
        Radius = nil,
        Label = nil
    }
}

RegisterNetEvent('ms-diving:client:NewLocations')
AddEventHandler('ms-diving:client:NewLocations', function()
    MSCore.Functions.TriggerCallback('ms-diving:server:GetDivingConfig', function(Config, Area)
        MSCoreDiving.Locations = Config
        TriggerEvent('ms-diving:client:SetDivingLocation', Area)
    end)
end)

RegisterNetEvent('ms-diving:client:SetDivingLocation')
AddEventHandler('ms-diving:client:SetDivingLocation', function(DivingLocation)
    CurrentDivingLocation.Area = DivingLocation

    for _,Blip in pairs(CurrentDivingLocation.Blip) do
        if Blip ~= nil then
            RemoveBlip(Blip)
        end
    end
    
    Citizen.CreateThread(function()
        RadiusBlip = AddBlipForRadius(MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.z, 100.0)
        
        SetBlipRotation(RadiusBlip, 0)
        SetBlipColour(RadiusBlip, 40)

        CurrentDivingLocation.Blip.Radius = RadiusBlip

        LabelBlip = AddBlipForCoord(MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)

        SetBlipSprite (LabelBlip, 587)
        SetBlipDisplay(LabelBlip, 2)
        SetBlipScale  (LabelBlip, 0.7)
        SetBlipColour(LabelBlip, 0)
        SetBlipAsShortRange(LabelBlip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Diving Spot')
        EndTextCommandSetBlipName(LabelBlip)

        CurrentDivingLocation.Blip.Label = LabelBlip
    end)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

Citizen.CreateThread(function()
    while true do
        local inRange = false
        local Ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(Ped)

        if CurrentDivingLocation.Area ~= 0 then
            local AreaDistance = GetDistanceBetweenCoords(Pos, MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)
            local CoralDistance = nil

            if AreaDistance < 100 then
                inRange = true
            end

            if inRange then
                for cur, CoralLocation in pairs(MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Coral) do
                    CoralDistance = GetDistanceBetweenCoords(Pos, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, true)

                    if CoralDistance ~= nil then
                        if CoralDistance <= 30 then
                            if not CoralLocation.PickedUp then
                                DrawMarker(32, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 1.0, 0.4, 255, 223, 0, 255, true, false, false, false, false, false, false)
                                if CoralDistance <= 1.5 then
                                    DrawText3D(CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, '[E] Collecting coral')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        -- loadAnimDict("pickup_object")
                                        local times = math.random(2, 5)
                                        CallCops()
                                        FreezeEntityPosition(Ped, true)
                                        MSCore.Functions.Progressbar("take_coral", "Collecting coral..", times * 1000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                                            anim = "plant_floor",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            TakeCoral(cur)
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end, function() -- Cancel
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2500)
        end

        Citizen.Wait(3)
    end
end)

function TakeCoral(coral)
    MSCoreDiving.Locations[CurrentDivingLocation.Area].coords.Coral[coral].PickedUp = true
    TriggerServerEvent('ms-diving:server:TakeCoral', CurrentDivingLocation.Area, coral, true)
end

RegisterNetEvent('ms-diving:client:UpdateCoral')
AddEventHandler('ms-diving:client:UpdateCoral', function(Area, Coral, Bool)
    MSCoreDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
end)

function CallCops()
    local Call = math.random(1, 3)
    local Chance = math.random(1, 3)
    local Ped = GetPlayerPed(-1)
    local Coords = GetEntityCoords(Ped)

    if Call == Chance then
        TriggerServerEvent('ms-diving:server:CallCops', Coords)
    end
end

RegisterNetEvent('ms-diving:server:CallCops')
AddEventHandler('ms-diving:server:CallCops', function(Coords, msg)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "911-MESSAGE", "error", msg)
    local transG = 100
    local blip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, 100.0)
    SetBlipSprite(blip, 10)
    SetBlipColour(blip, 38)
    SetBlipAlpha(blip, transG)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("911 - Dive site")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end

RegisterNetEvent('ms-diving:client:UseGear')
AddEventHandler('ms-diving:client:UseGear', function(bool)
    if bool then
        GearAnim()
        MSCore.Functions.Progressbar("equip_gear", "Putting on wet suit..", 5000, false, true, {}, {}, {}, {}, function() -- Done
            DeleteGear()
            local maskModel = GetHashKey("p_d_scuba_mask_s")
            local tankModel = GetHashKey("p_s_scuba_tank_s")
    
            RequestModel(tankModel)
            while not HasModelLoaded(tankModel) do
                Citizen.Wait(1)
            end
            TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone1 = GetPedBoneIndex(GetPlayerPed(-1), 24818)
            AttachEntityToEntity(TankObject, GetPlayerPed(-1), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.tank = TankObject
    
            RequestModel(maskModel)
            while not HasModelLoaded(maskModel) do
                Citizen.Wait(1)
            end
            
            MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone2 = GetPedBoneIndex(GetPlayerPed(-1), 12844)
            AttachEntityToEntity(MaskObject, GetPlayerPed(-1), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.mask = MaskObject
    
            SetEnableScuba(GetPlayerPed(-1), true)
            SetPedMaxTimeUnderwater(GetPlayerPed(-1), 2000.00)
            currentGear.enabled = true
            TriggerServerEvent('ms-diving:server:RemoveGear')
            ClearPedTasks(GetPlayerPed(-1))
            TriggerEvent('chatMessage', "SYSTEM", "error", "/wetsuit to take off your wetsuit!")
        end)
    else
        if currentGear.enabled then
            GearAnim()
            MSCore.Functions.Progressbar("remove_gear", "Removing wet suit..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                DeleteGear()

                SetEnableScuba(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 1.00)
                currentGear.enabled = false
                TriggerServerEvent('ms-diving:server:GiveBackGear')
                ClearPedTasks(GetPlayerPed(-1))
                MSCore.Functions.Notify('You took your wetsuit off')
            end)
        else
            MSCore.Functions.Notify('You are not wearing a diving gear..', 'error')
        end
    end
end)

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end