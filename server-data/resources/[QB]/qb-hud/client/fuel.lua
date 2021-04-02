Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

DecorRegister("CurrentFuel", 3)
local gasStations = {
    {49.41872, 2778.793, 58.04395,600},
    {263.8949, 2606.463, 44.98339,600},
    {1039.958, 2671.134, 39.55091,900},
    {1207.26, 2660.175, 37.89996,900},
    {2539.685, 2594.192, 37.94488,1500},
    {2679.858, 3263.946, 55.24057,1500},
    {2005.055, 3773.887, 32.40393,1200},
    {1687.156, 4929.392, 42.07809,900},
    {1701.314, 6416.028, 32.76395,1200},
    {179.8573, 6602.839, 31.86817,600},
    {-94.46199, 6419.594, 31.48952,600},
    {-2554.996, 2334.402, 33.07803,600},
    {-1800.375, 803.6619, 138.6512,600},
    {-1437.622, -276.7476, 46.20771,600},
    {-2096.243, -320.2867, 13.16857,600},
    {-724.6192, -935.1631, 19.21386,600},
    {-526.0198, -1211.003, 18.18483,600},
    {-70.21484, -1761.792, 29.53402,600},
    {265.6484,-1261.309, 29.29294,600},
    {819.6538,-1028.846, 26.40342,780},
    {1208.951,-1402.567, 35.22419,900},
    {1181.381,-330.8471, 69.31651,900},
    {620.8434, 269.1009, 103.0895,780},
    {2581.321, 362.0393, 108.4688,1500},
    {1785.363, 3330.372, 41.38188,1200},
    {-319.537, -1471.5116, 30.54118,600},
    {-66.58, -2532.56, 6.14, 400}
}

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GLOBAL_PED, 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
local showGasStations = false

CreateThread(function()
    for _, item in pairs(gasStations) do
        if not showGasStations then
            if item.blip ~= nil then
                RemoveBlip(item.blip)
            end
        else
            item.blip = AddBlipForCoord(item[1], item[2], item[3])
            SetBlipSprite(item.blip, 361)
            SetBlipScale(item.blip, 0.7)
            SetBlipAsShortRange(item.blip, true)
            SetBlipColour (item.blip, 75)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Gas")
            EndTextCommandSetBlipName(item.blip)
        end
    end
end)

Citizen.CreateThread(function()
    showGasStations = true
    TriggerEvent('CarPlayerHud:ToggleGas')
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function TargetVehicle()
    --playerped = PlayerPedId()
    coordA = GetEntityCoords(GLOBAL_PED, 1)
    coordB = GetOffsetFromEntityInWorldCoords(GLOBAL_PED, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function IsNearGasStations()
    local location = {}
    local hasFound = false
    local pos = GetEntityCoords(GLOBAL_PED, false)
    for k,v in ipairs(gasStations) do
        if(Vdist(v[1], v[2], v[3], pos.x, pos.y, pos.z) < 22.0)then
            location = {v[1], v[2], v[3],v[4]}
            hasFound = true
        end
    end

    if hasFound then return location,true end
    return {},false
end

RegisterNetEvent("RefuelCar")
AddEventHandler("RefuelCar",function()
    local w = `WEAPON_PetrolCan` 
    local curw = GetSelectedPedWeapon(GLOBAL_PED)
    if curw == w then
        coordA = GetEntityCoords(GLOBAL_PED, 1)
        coordB = GetOffsetFromEntityInWorldCoords(GLOBAL_PED, 0.0, 100.0, 0.0)
        targetVehicle = getVehicleInDirection(coordA, coordB)
        if DoesEntityExist(targetVehicle) then
            SetPedAmmo( GLOBAL_PED, GetSelectedPedWeapon(GLOBAL_PED), 0 )

            if DecorExistOn(targetVehicle, "CurrentFuel") then 
                curFuel = DecorGetInt(targetVehicle, "CurrentFuel")
                
                curFuel = curFuel + 30
                if curFuel > 100 then
                    curFuel = 100
                end
                DecorSetInt(targetVehicle, "CurrentFuel", curFuel)
            else
                DecorSetInt(targetVehicle, "CurrentFuel", 50)
            end

            DecorSetInt(targetVehicle, "CurrentFuel", 100)
            TriggerEvent('QBCore:Notify', "Refueled", "success")
        else
            TriggerEvent('QBCore:Notify', "No Target", "error")
        end
    else
        TriggerEvent('QBCore:Notify', "Need a Gas Can", "error")
    end
end)

RegisterNetEvent("RefuelCarServerReturn")
AddEventHandler("RefuelCarServerReturn",function()
    local timer = (100 - curFuel) * 400
    refillVehicle()
    QBCore.Functions.Progressbar("refueling", "Refueling", timer, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }, {}, {}, {}, function() -- Done
            local veh = TargetVehicle()
            DecorSetInt(veh, "CurrentFuel", 100)
            endanimation()
        end, function()
            endanimation()
            TriggerEvent("DoShortHudText", "Failed!", 2)
    end)
end)

local petrolCan = {title = "Petrol Can", name = "PetrolCan", costs = 100, description = {}, model = "WEAPON_PetrolCan"}

function refillVehicle()
    ClearPedSecondaryTask(GLOBAL_PED)
    loadAnimDict( "weapon@w_sp_jerrycan" ) 
    TaskPlayAnim( GLOBAL_PED, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
end

function endanimation()
    shiftheld = false
    ctrlheld = false
    tabheld = false
    ClearPedTasksImmediately(GLOBAL_PED)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TargetVehicle()
    --playerped = PlayerPedId()
    coordA = GetEntityCoords(GLOBAL_PED, 1)
    coordB = GetOffsetFromEntityInWorldCoords(GLOBAL_PED, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function round( n )
    return math.floor( n + 0.5 )
end

Fuel = 45
DrivingSet = false
LastVehicle = nil
lastupdate = 0
local fuelMulti = 0

RegisterNetEvent("carHud:FuelMulti")
AddEventHandler("carHud:FuelMulti",function(multi)
    fuelMulti = multi
end)

alarmset = false

RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
        TriggerEvent('QBCore:Notify', "Low fuel.", "error")
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()

    while true do

        Wait(250)
        --local player = PlayerPedId()

        if (IsPedInAnyVehicle(GLOBAL_PED, false)) then

            local veh = GetVehiclePedIsIn(GLOBAL_PED,false)

            if GetPedInVehicleSeat(veh, -1) == GLOBAL_PED then

                if not DrivingSet then

                    if LastVehicle ~= veh then
                        if not DecorExistOn(veh, "CurrentFuel") then
                            Fuel = math.random(80,100)
                        else
                            Fuel = DecorGetInt(veh, "CurrentFuel")
                        end
                    else
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end

                    DrivingSet = true
                    LastVehicle = veh
                    lastupdate = 0

                    if not DecorExistOn(veh, "CurrentFuel") then 
                        Fuel = math.random(80,100)
                        DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    end

                else

                    if Fuel > 105 then
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end                     
                    if Fuel == 101 then
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end
                end

                if ( lastupdate > 300) then
                    DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    lasteupdate = 0
                end

                lastupdate = lastupdate + 1

                if Fuel > 0 then
                    if IsVehicleEngineOn(veh) then
                        local fueltankhealth = GetVehiclePetrolTankHealth(veh)
                        if fueltankhealth == 1000.0 then
                            SetVehiclePetrolTankHealth(veh, 4000.0)
                        end
                        local algofuel = GetEntitySpeed(GetVehiclePedIsIn(GLOBAL_PED, false)) * 2.236936
                        if algofuel > 160 then
                            algofuel = algofuel * 1.8
                        else
                            algofuel = algofuel / 2.0
                        end
                        algofuel = algofuel / 15000

                        if algofuel == 0 then
                            algofuel = 0.0001
                        end

                        --TriggerEvent('chatMessage', '', { 0, 0, 0 }, '' .. algofuel .. '')
                        if IsPedInAnyBoat(GLOBAL_PED) then
                            algofuel = 0.0090
                        end
                        if fuelMulti == 0 then fuelMulti = 1 end
                        local missingTankHealth = (4000 - fueltankhealth) / 1000

                        if missingTankHealth > 1 then
                            missingTankHealth = missingTankHealth * (missingTankHealth * missingTankHealth * 12)
                        end

                        local factorFuel = (algofuel + fuelMulti / 10000) * (missingTankHealth+1)
                        Fuel = Fuel - factorFuel  
                    end
                end

                if Fuel <= 4 and Fuel > 0 then
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        local decayChance = math.random(20,100)
                        if decayChance > 90 then
                            SetVehicleEngineOn(veh,0,0,1)
                            SetVehicleUndriveable(veh,true)
                            Wait(100)
                            SetVehicleEngineOn(veh,1,0,1)
                            SetVehicleUndriveable(veh,false)
                        end
                    end
                     
                end

                if Fuel < 15 then
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        TriggerEvent("CarFuelAlarm")
                    end
                end

                if Fuel < 1 then

                    if Fuel ~= 0 then
                        Fuel = 0
                        DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    end

                    if IsVehicleEngineOn(veh) or IsThisModelAHeli(GetEntityModel(veh)) then
                        SetVehicleEngineOn(veh,0,0,1)
                        SetVehicleUndriveable(veh,false)
                    end
                end
            end
        else

            if DrivingSet then
                DrivingSet = false
                DecorSetInt(LastVehicle, "CurrentFuel", round(Fuel))
            end
            Wait(1500)
        end
    end
end)

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalUse"] = table["generalUse"]
end)

Citizen.CreateThread(function()
    local bool = false
    local counter = 0
    while true do

        if counter == 0 then
            loc,bool = IsNearGasStations()
            counter = 5
        end
        counter = counter - 1
        if bool == true then

            local veh = TargetVehicle()

            if DoesEntityExist(veh) and IsEntityAVehicle(veh) and #(GetEntityCoords(veh) - GetEntityCoords(GLOBAL_PED)) < 5.0 then

                curFuel = DecorGetInt(veh, "CurrentFuel")
                costs = (100 - curFuel)
                if costs < 0 then
                    costs = 0
                end
                info = string.format("Press ~g~"..Controlkey["generalUse"][2].."~s~ to refuel your vehicle | ~g~$%s + tax", costs)
                local crd = GetEntityCoords(veh)
                DrawMarker(2,crd["x"],crd["y"],crd["z"]+1.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 100, 15, 15, 130, 0, 0, 0, 0)
                --DisplayHelpText(info)
                DrawText3Ds(crd["x"], crd["y"], crd["z"]+0.5, info)
                if IsControlJustPressed(1, Controlkey["generalUse"][1]) then
                    if curFuel >= 100 then
                        PlaySound(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
                        TriggerEvent('QBCore:Notify', "Your gas tank is full", "error")
                    else
                        costs = math.ceil(costs)
                        QBCore.Functions.TriggerCallback('QBCore:HasMoney', function(hasMoney)
                            if hasMoney == true then
                                TriggerEvent('RefuelCarServerReturn')
                                TriggerEvent('QBCore:Notify', "Refueling your car", "success")
                            else
                                TriggerEvent('QBCore:Notify', "You dont have that amount", "error")
                            end
                        end, costs)
                    end
                end
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(500)
        end
    end
end)

function GetFuel(vehicle)
    local fuel = DecorGetInt(vehicle, "CurrentFuel")
    return fuel
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
        DecorSetInt(vehicle, "CurrentFuel", fuel)
	end
end