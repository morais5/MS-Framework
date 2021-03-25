QBCore = nil

isLoggedIn = false
PlayerJob = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

local CurrentShop = nil
local CurrentVehicleData = {}
local ShoppingCart = {
    id = "shoppingcart",
    label = "Shopping cart",
    buttons = {},
}
local CartedItem = false

-- Functions

Citizen.CreateThread(function()
    for k, v in pairs(QBCustoms.Locations) do
		local blip = AddBlipForCoord(v["coords"].x, v["coords"].y, v["coords"].z)
		SetBlipSprite(blip, 72)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip,true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Benny's Motorworks")
        EndTextCommandSetBlipName(blip)
    end
end)

function OpenCustoms(shop, k)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    local repaircosts = nil
    SetVehicleModKit(veh, 0)

    CurrentVehicleData = QBCore.Functions.GetVehicleProperties(veh)
    SetEntityCoords(veh, shop["coords"].x, shop["coords"].y, shop["coords"].z, 0.0, 0.0, 0.0, false)
    SetEntityHeading(veh, shop["coords"].h)
    FreezeEntityPosition(veh, true)

    if k == 7 then
        QBCore.Functions.TriggerCallback('qb-vehicletuning:server:IsMechanicAvailable', function(Mechanic)
            if Mechanic < 2 then
                if IsVehicleDamaged(veh) or GetVehicleBodyHealth(veh) < 980 or GetVehicleEngineHealth(veh) < 980 then
                    local vehdamage = GetVehicleBodyHealth(veh)
                    local pricemultiplier = vehdamage / 1050
                    repaircosts = round(400 + (500 * pricemultiplier), -2)
                end
            end

            SetNuiFocus(true, false)
            SendNUIMessage({
                action = "open",
                mods = GetAvailableMods(),
                costs = repaircosts,
            })
            TriggerServerEvent('qb-customs:server:UpdateBusyState', k, true)
            CurrentShop = k
        end)
    else
        SetNuiFocus(true, false)
        SendNUIMessage({
            action = "open",
            mods = GetAvailableMods(),
            costs = repaircosts,
        })
        TriggerServerEvent('qb-customs:server:UpdateBusyState', k, true)
        CurrentShop = k
    end
end

RegisterNUICallback('CanRepairVehicle', function(data, cb)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)

    QBCore.Functions.TriggerCallback('qb-customs:server:CanPurchase', function(CanBuy)
        if CanBuy then
	        SetVehicleFixed(veh)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "airwrench", 0.1)
            cb(true)
        else
            QBCore.Functions.Notify('You dont have enough money..', 'error')
            cb(false)
        end
    end, data.price)
end)

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
      local mult = 10^numDecimalPlaces
      return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function IsVehicleBlacklisted(veh)
    local retval = false
    for _, vehicle in pairs(QBCustoms.BlacklistedVehicles) do
        if veh == GetHashKey(vehicle) then
            retval = true
            break
        end
    end
    return retval
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow(1, 0, 0, 0, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function GetAvailableMods()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))

    if QBCore.Shared.VehicleModels[GetEntityModel(veh)] ~= nil then
        model = QBCore.Shared.VehicleModels[GetEntityModel(veh)].model
        VehicleData = QBCore.Shared.Vehicles[model]
        VehiclePrice = VehicleData.price
    else
        VehiclePrice = 50000
    end

    -- SetVehicleModKit(veh, 0)
    local VehicleIsABike = false
    if IsThisModelABike(GetEntityModel(veh)) then
        VehicleIsABike = true
    end
    local mods = {}
    for k, v in pairs(QBCustoms.Mods) do
        if v.buttons ~= nil and next(v.buttons) ~= nil then
            if v.id ~= 48 then
                if v.multiplier ~= nil then
                    for key, btn in pairs(v.buttons) do
                        if key ~= 1 then
                            btn.price = VehiclePrice * v.multiplier
                            btn.increaseby = btn.price / (GetNumVehicleMods(veh, v.id) / 2)
                        else
                            btn.price = 0
                        end
                        btn.price = round(btn.price, -2)
                        btn.increaseby = round(btn.increaseby, -2)
                    end
                end
                table.insert(mods, {
                    label = v.label,
                    id = v.id,
                    buttons = v.buttons,
                })
            end
        else
            if v.id == 48 then
                if GetVehicleLiveryCount(veh) > 0 then
                    local buttons = {}
                    table.insert(buttons, {
                        price = 0,
                        increaseby = 0,
                        name = "Standard",
                        modid = -1,
                        liverytype = "livery",
                        modtype = "liveries",
                    })
                    for i = 0, (GetVehicleLiveryCount(veh) - 1), 1 do
                        table.insert(buttons, {
                            price = v.price,
                            increaseby = v.increaseby,
                            name = "Livery #"..i + 1,
                            modid = i,
                            liverytype = "livery",
                            modtype = "liveries",
                        })
                    end
                    table.insert(mods, {
                        label = v.label,
                        id = v.id,
                        buttons = buttons,
                        modtype = "liveries",
                    })
                elseif GetNumVehicleMods(veh, 48) > 0 then
                    local buttons = {}
                    table.insert(buttons, {
                        price = 0,
                        increaseby = 0,
                        name = "Standard",
                        modid = -1,
                        liverytype = "mod",
                        modtype = "liveries",
                    })
                    for i = 0, (GetNumVehicleMods(veh, 48) - 1), 1 do
                        table.insert(buttons, {
                            price = v.price,
                            increaseby = v.increaseby,
                            name = "Livery #"..i + 1,
                            modid = i,
                            liverytype = "mod",
                            modtype = "liveries",
                        })
                    end
                    table.insert(mods, {
                        label = v.label,
                        id = v.id,
                        buttons = buttons,
                        modtype = "liveries",
                    })
                end
            else
                if not VehicleIsABike then
                    if v.id ~= 23 and v.id ~= 24 then
                        if v.id == "wheels" then
                            local wheeltypes = {}
                            table.insert(wheeltypes, {
                                price = 0,
                                increaseby = 0,
                                name = "Standard Wheel",
                                modid = -1,
                                wheeltype = -1
                            })
                            for i = 1, #v.categorys, 1 do
                                local buttons = {}
                                if v.categorys[i].label ~= "JDM Rims" then
                                    for w = 1, v.categorys[i].amount, 1 do
                                        table.insert(buttons, {
                                            price = 1200,
                                            increaseby = 0,
                                            name = v.categorys[i].label.." #"..w,
                                            modid = w,
                                            wheeltype = v.categorys[i].wheeltype,
                                            modtype = "wheels",
                                        })
                                    end
                                else
                                    for c = 50, 108, 1 do
                                        label = (c - 49)
                                        table.insert(buttons, {
                                            price = 1500,
                                            increaseby = 0,
                                            name = v.categorys[i].label.." #"..label,
                                            modid = c,
                                            wheeltype = v.categorys[i].wheeltype,
                                            modtype = "wheels",
                                        })
                                    end
                                end
                                table.insert(wheeltypes, {
                                    name = v.categorys[i].label,
                                    buttons = buttons,
                                })
                            end
                            table.insert(mods, {
                                label = v.label,
                                id = v.id,
                                buttons = {
                                    {
                                        id = "wheels",
                                        name = "Wheel Types",
                                        buttons = wheeltypes,
                                    },
                                    {
                                        id = "wheelcolors",
                                        name = "Wheel Colors",
                                        buttons = QBCustoms.WheelColors,
                                    },
                                    {
                                        id = "wheelaccessories",
                                        name = "Wheel Accessoires",
                                        buttons = QBCustoms.WheelAccessories,
                                    },
                                },
                            })
                        else
                            if GetNumVehicleMods(veh, v.id) > 0 then
                                local buttons = {}
                                table.insert(buttons, {
                                    price = 0,
                                    increaseby = 0,
                                    name = "Standard "..v.label,
                                    modid = -1,
                                    modtype = v.id,
                                })
                                for i = 0, (GetNumVehicleMods(veh, v.id) - 1), 1 do
                                    if v.multiplier ~= nil then
                                        v.price = VehiclePrice * v.multiplier
                                        v.increaseby = v.price / GetNumVehicleMods(veh, v.id)
                                        v.price = round(v.price, -2)
                                        v.increaseby = round(v.increaseby, -2)
                                    else
                                        v.price = v.price ~= nil and v.price or 500
                                        v.increaseby = v.increaseby ~= nil and v.increaseby or 500
                                    end
                                    table.insert(buttons, {
                                        price = v.price,
                                        increaseby = v.increaseby,
                                        name = v.label.." #"..i + 1,
                                        modid = i,
                                        modtype = v.id,
                                    })
                                end
                                table.insert(mods, {
                                    label = v.label,
                                    id = v.id,
                                    buttons = buttons,
                                })
                            end
                        end
                    end
                else
                    if v.id ~= "wheels" then
                        if GetNumVehicleMods(veh, v.id) > 0 then
                            local buttons = {}
                            table.insert(buttons, {
                                price = 0,
                                increaseby = 0,
                                name = "Standard "..v.label,
                                modid = 0,
                                modtype = v.modtype,
                            })
                            for i = 1, GetNumVehicleMods(veh, v.id), 1 do
                                v.price = v.price ~= nil and v.price or 800
                                v.increaseby = v.increaseby ~= nil and v.increaseby or 0
                                table.insert(buttons, {
                                    price = v.price,
                                    increaseby = v.increaseby,
                                    name = v.label.." #"..i,
                                    modid = i,
                                    modtype = v.modtype,
                                })
                            end
                            table.insert(mods, {
                                label = v.label,
                                id = v.id,
                                buttons = buttons,
                                modtype = v.modtype,
                            })
                        end
                    elseif v.id == "wheels" then
                        table.insert(mods, {
                            label = "Wheel",
                            id = "wheels",
                            buttons = {
                                {
                                    id = "wheelcolors",
                                    name = "Wheel Colors",
                                    buttons = QBCustoms.WheelColors,
                                },
                                {
                                    id = "wheelaccessories",
                                    name = "Wheel Accessoires",
                                    buttons = QBCustoms.WheelAccessories,
                                },
                            },
                        })
                    end
                end
            end
        end
    end
    
    table.sort(mods, function(a, b)
		return a.label < b.label
	end)

    return mods
end

-- Loops

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false

        for k, loc in pairs(QBCustoms.Locations) do
            local distance = GetDistanceBetweenCoords(pos, loc["coords"].x, loc["coords"].y, loc["coords"].z, true)
            if distance < 20 then
                inRange = true
                if distance < 10 then
                    if not loc["busy"] then
                        if IsPedInAnyVehicle(ped) then
                            local veh = GetVehiclePedIsIn(ped)
                            local seat = GetPedInVehicleSeat(veh, -1)
                            if seat == ped then
                                if not IsVehicleBlacklisted(GetEntityModel(GetVehiclePedIsIn(ped))) then
                                    -- Draws Purpel Marker
                                    DrawMarker(21, loc["coords"].x, loc["coords"].y, loc["coords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.4, 66, 87, 245, 155, false, false, false, true, false, false, false)

                                    if distance < 3 then
                                        DrawText3Ds(loc["coords"].x, loc["coords"].y, loc["coords"].z, 'Press ~b~ENTER~w~ to use Benny\'s.')
                                        
                                        -- Check if ENTER is pressed
                                        isLoggedIn = true
                                        PlayerJob = QBCore.Functions.GetPlayerData().job
                                        if isLoggedIn then
                                            if PlayerJob ~= nil and PlayerJob.name == 'mechanic' then
                                                if IsControlJustPressed(0, 191) then -- ENTER
                                                    OpenCustoms(loc, k)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

function OnIndexChange(id, data)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)

    if data.modid ~= nil and id ~= nil then
        if id == "respray" then
            if data.modid ~= nil then
                if data.colortype == "primary" then
                    local CartedSecondary = GetCartedColor("secondary")
                    if CartedSecondary ~= nil then
                        SetVehicleColours(veh, data.modid, CartedSecondary.modid)
                    else
                        SetVehicleColours(veh, data.modid, CurrentVehicleData.color2)
                    end
                elseif data.colortype == "secondary" then
                    local CartedPrimary = GetCartedColor("primary")
                    if CartedPrimary ~= nil then
                        SetVehicleColours(veh, CartedPrimary.modid, data.modid)
                    else
                        SetVehicleColours(veh, CurrentVehicleData.color1, data.modid)
                    end
                else
                    local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                    SetVehicleExtraColours(veh, data.modid, wheelColor)
                end
            end
        elseif id == "wheelcolors" then
            local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
            SetVehicleExtraColours(veh, pearlescentColor, data.modid)
        elseif id == "wheelaccessories" then
            if data.smokecolor ~= nil then
                ToggleVehicleMod(veh, 20, true)
                SetVehicleTyreSmokeColor(veh, data.smokecolor[1], data.smokecolor[2], data.smokecolor[3])
            end
        elseif id == 48 then
            if data.modid ~= -1 then
                data.modid = tonumber(data.modid)
                if data.liverytype == "mod" then
                    SetVehicleMod(veh, 48, data.modid, false)
                elseif data.liverytype == "livery" then
                    SetVehicleLivery(veh, data.modid)
                end
            end
        elseif id == 18 or id == 20 or id == 22 then
            if data.modid == 0 then
                ToggleVehicleMod(veh, id, false)
            else
                ToggleVehicleMod(veh, id, true)
            end
        elseif id == "wheels" then
            if data.wheeltype ~= nil then
                SetVehicleWheelType(veh, data.wheeltype)
                SetVehicleMod(veh, 23, data.modid)
            end
        else
            if data.modid ~= nil and id ~= nil then
                SetVehicleMod(veh, id, data.modid, false)
            end
        end
    end
end

-- NUI Callback's

RegisterNUICallback('CloseMenu', function()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)

    FreezeEntityPosition(veh, false)

    SetNuiFocus(false, false)
    TriggerServerEvent('qb-customs:server:UpdateBusyState', CurrentShop, false)
    ShoppingCart.buttons = {}
    QBCore.Functions.SetVehicleProperties(veh, CurrentVehicleData)
    CurrentShop = nil
end)

RegisterNUICallback('print', function(data, cb)
    -- TriggerServerEvent('qb-customs:print', data.print)
end)

RegisterNUICallback('OnIndexChange', function(data, cb)
    if data.cart == nil then
        if data.id ~= nil then
            OnIndexChange(data.id, data.data)
        end
    end

    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end)

RegisterNUICallback('SelectSound', function()
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end)
RegisterNUICallback('BackSound', function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end)
RegisterNUICallback('QuitSound', function()
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end)

-- Events

RegisterNetEvent('qb-customs:client:UpdateBusyState')
AddEventHandler('qb-customs:client:UpdateBusyState', function(k, bool)
    QBCustoms.Locations[k]["busy"] = bool
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        SetNuiFocus(false, false)
    end
end)

RegisterNUICallback('GetCurrentMod', function(data, cb)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local currentmod = -1

    if data.data ~= nil and next(data.data) ~= nil then
        if data.data.id ~= nil then
            if data.data.id ~= "respray" and data.data.id ~= "wheels" and data.data.id ~= "wheelcolors" and data.data.id ~= "wheelaccessories" then
                if data.data.id >= 0 and data.data.id <= 46 then
                    if data.data.id == 18 or data.data.id == 20 or data.data.id == 22 then
                        if not CurrentVehicleData[QBCustoms.indexToName[data.data.id]] then
                            currentmod = -1
                        else
                            currentmod = 0
                        end
                    else
                        currentmod = CurrentVehicleData[QBCustoms.indexToName[data.data.id]]
                    end
                end
            elseif data.data.id == "respray" then
                if data.data.buttons ~= nil then
                    for k, v in pairs(data.data.buttons) do
                        if v.colortype == "primary" then
                            if v.modid == CurrentVehicleData.color1 then
                                currentmod = (k - 2)
                                break
                            end
                        elseif v.colortype == "secondary" then
                            if v.modid == CurrentVehicleData.color2 then
                                currentmod = (k - 2)
                                break
                            end
                        elseif v.colortype == "pearlescent" then
                            if v.modid == CurrentVehicleData.pearlescentColor then
                                currentmod = (k - 2)
                                break
                            end
                        end
                    end
                end
            elseif data.data.id == "wheels" then
                if data.data.buttons ~= nil and next(data.data.buttons) ~= nil then
                    for k, v in pairs(data.data.buttons) do
                        if v.wheeltype == CurrentVehicleData.wheels and v.modid == CurrentVehicleData.modFrontWheels then
                            currentmod = (k - 2)
                            break
                        end
                    end
                end
            elseif data.data.id == "wheelcolors" then
                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                for k, v in pairs(QBCustoms.WheelColors) do
                    if v.modid == wheelColor then
                        currentmod = (k - 2)
                        break
                    end
                end
            elseif data.data.id == "wheelaccessories" then
                local current = GetTyreSmokeKey()
                currentmod = (current - 2)
            end
        end
    end

    cb(currentmod)
end)

RegisterNUICallback('AddItemToCart', function(data, cb)
    if ShoppingCart.buttons ~= nil and next(ShoppingCart.buttons) ~= nil then
        for k, v in pairs(ShoppingCart.buttons) do
            if v.modtype ~= "respray" then
                if v.modtype == data.ItemData.modtype then
                    table.remove(ShoppingCart.buttons, k)
                end
            else
                if v.colortype == data.ItemData.colortype then
                    table.remove(ShoppingCart.buttons, k)
                end
            end
        end
    end
    if data.ItemData.originalprice ~= nil then
        data.ItemData.price = data.ItemData.originalprice
    end
    table.insert(ShoppingCart.buttons, data.ItemData)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "airwrench", 0.1)
    CartedItem = true
end)

RegisterNUICallback('ToggleCartedItem', function(data, cb)
    CartedItem = data.toggle
end)

function GetCartedColor(type)
    local retval = nil
    for k, v in pairs(ShoppingCart.buttons) do
        if v.colortype == type then
            retval = v
        end
    end
    return retval
end

RegisterNUICallback('CheckIfCartedItem', function(data, cb)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

    QBCore.Functions.SetVehicleProperties(veh, CurrentVehicleData)
    if ShoppingCart.buttons ~= nil and next(ShoppingCart.buttons) ~= nil then
        for k, v in pairs(ShoppingCart.buttons) do
            if v.modtype ~= nil then
                if v.modtype ~= "respray" and v.modtype ~= "wheels" and v.modtype ~= "wheelcolor" and v.modtype ~= "wheelaccessories" and v.modtype ~= "frontwheels" and v.modtype ~= "backwheels" and v.modtype ~= "liveries" then
                    if v.modid == 18 or v.modid == 22 then
                        if data.modid == 0 then
                            ToggleVehicleMod(veh, v.modid, false)
                        else
                            ToggleVehicleMod(veh, v.modid, true)
                        end
                    else
                        SetVehicleMod(veh, v.modtype, v.modid, false)
                    end
                elseif v.modtype == "respray" then
                    if v.colortype == "primary" then
                        local CartedSecondary = GetCartedColor("secondary")
                        if CartedSecondary ~= nil then
                            SetVehicleColours(veh, v.modid, CartedSecondary.modid)
                        else
                            SetVehicleColours(veh, v.modid, CurrentVehicleData.color2)
                        end
                    elseif v.colortype == "secondary" then
                        local CartedSecondary = GetCartedColor("primary")
                        if CartedSecondary ~= nil then
                            SetVehicleColours(veh, CartedSecondary.modid, v.modid)
                        else
                            SetVehicleColours(veh, CurrentVehicleData.color1, v.modid)
                        end
                    else
                        local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                        SetVehicleExtraColours(veh, v.modid, wheelColor)
                    end
                elseif v.modtype == "wheels" then
                    if v.wheeltype ~= nil then
                        SetVehicleWheelType(veh, v.wheeltype)
                        SetVehicleMod(veh, 23, v.modid)
                    end
                elseif v.modtype == "liveries" then
                    if v.modid ~= -1 then
                        if v.liverytype == "mod" then
                            SetVehicleMod(veh, 48, v.modid, false)
                        elseif v.liverytype == "livery" then
                            SetVehicleLivery(veh, v.modid)
                        end
                    end
                elseif v.modtype == "frontwheels" then
                    SetVehicleWheelType(veh, 6)
                    SetVehicleMod(veh, 23, v.modid)
                elseif v.modtype == "backwheels" then
                    SetVehicleWheelType(veh, 6)
                    SetVehicleMod(veh, 24, v.modid)
                elseif v.modtype == "wheelcolor" then
                    local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                    SetVehicleExtraColours(veh, pearlescentColor, v.modid)
                elseif v.modtype == "wheelaccessories" then
                    if v.tireid ~= 0 then
                        ToggleVehicleMod(veh, v.modid, true)
                        SetVehicleTyreSmokeColor(veh, v.smokecolor[1], v.smokecolor[2], v.smokecolor[3])
                    else
                        ToggleVehicleMod(veh, v.modid, false)
                    end
                end
            end
        end
    end
end)

RegisterNUICallback('RemoveCartItem', function(data, cb)
    for k, v in pairs(ShoppingCart.buttons) do
        if v.modtype ~= "wheels" and v.modtype ~= "respray" then
            if v.modtype == data.ItemData.modtype and v.modid == data.ItemData.modid then
                table.remove(ShoppingCart.buttons, k)
            end
        elseif v.modtype == "respray" then
            if v.colortype == data.ItemData.colortype and v.modid == data.ItemData.modid then
                table.remove(ShoppingCart.buttons, k)
            end
        elseif v.modtype == "wheels" then
            table.remove(ShoppingCart.buttons, k)
        end
    end

    CartedItem = false
end)

RegisterNUICallback('GetShoppingCart', function(data, cb)
    cb(ShoppingCart)
end)

function CalculatePrice()
    local totalprice = 0
    for k, v in pairs(ShoppingCart.buttons) do
        totalprice = totalprice + v.price
    end
    return totalprice
end

RegisterNUICallback('PurchaseUpgrades', function(data, cb)
    local TotalPrice = CalculatePrice()
    local String = ""

    QBCore.Functions.TriggerCallback('qb-customs:server:CanPurchase', function(CanBuy)
        if CanBuy then
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsIn(ped)

            FreezeEntityPosition(veh, false)

            SendNUIMessage({
                action = "close"
            })
            SetNuiFocus(false, false)

            TriggerServerEvent('qb-customs:server:UpdateBusyState', CurrentShop, false)

            QBCore.Functions.SetVehicleProperties(veh, CurrentVehicleData)
            if ShoppingCart.buttons ~= nil and next(ShoppingCart.buttons) ~= nil then
                for k, v in pairs(ShoppingCart.buttons) do
                    String = String .. "\n #" .. k .. " Upgrade: **" .. v.name .. "** Price: **€" .. v.originalprice .. "**" 
                    if v.modtype ~= nil then
                        if v.modtype ~= "respray" and v.modtype ~= "wheels" and v.modtype ~= "wheelcolor" and v.modtype ~= "wheelaccessories" and v.modtype ~= "frontwheels" and v.modtype ~= "backwheels" and v.modtype ~= "liveries" then
                            if v.modtype == 18 or v.modtype == 22 then
                                if v.modid == 0 then
                                    ToggleVehicleMod(veh, v.modtype, false)
                                else
                                    ToggleVehicleMod(veh, v.modtype, true)
                                end
                            else
                                SetVehicleMod(veh, v.modtype, v.modid, false)
                            end
                        elseif v.modtype == "respray" then
                            if v.colortype == "primary" then
                                local CartedSecondary = GetCartedColor("secondary")
                                if CartedSecondary ~= nil then
                                    SetVehicleColours(veh, v.modid, CartedSecondary.modid)
                                else
                                    SetVehicleColours(veh, v.modid, CurrentVehicleData.color2)
                                end
                            elseif v.colortype == "secondary" then
                                local CartedSecondary = GetCartedColor("primary")
                                if CartedSecondary ~= nil then
                                    SetVehicleColours(veh, CartedSecondary.modid, v.modid)
                                else
                                    SetVehicleColours(veh, CurrentVehicleData.color1, v.modid)
                                end
                            else
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                                SetVehicleExtraColours(veh, v.modid, wheelColor)
                            end
                        elseif v.modtype == "wheels" then
                            if v.wheeltype ~= nil then
                                SetVehicleWheelType(veh, v.wheeltype)
                                SetVehicleMod(veh, 23, v.modid)
                            end
                        elseif v.modtype == "liveries" then
                            if v.modid ~= -1 then
                                if v.liverytype == "mod" then
                                    SetVehicleMod(veh, 48, v.modid, false)
                                elseif v.liverytype == "livery" then
                                    SetVehicleLivery(veh, v.modid)
                                end
                            end
                        elseif v.modtype == "frontwheels" then
                            SetVehicleWheelType(veh, 6)
                            SetVehicleMod(veh, 23, v.modid)
                        elseif v.modtype == "backwheels" then
                            SetVehicleWheelType(veh, 6)
                            SetVehicleMod(veh, 24, v.modid)
                        elseif v.modtype == "wheelcolor" then
                            local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                            SetVehicleExtraColours(veh, pearlescentColor, v.modid)
                        elseif v.modtype == "wheelaccessories" then
                            if v.tireid ~= 0 then
                                ToggleVehicleMod(veh, v.modid, true)
                                SetVehicleTyreSmokeColor(veh, v.smokecolor[1], v.smokecolor[2], v.smokecolor[3])
                            else
                                ToggleVehicleMod(veh, v.modid, false)
                            end
                        end
                    end
                end
                local PlayerData = QBCore.Functions.GetPlayerData()
                TriggerServerEvent("qb-log:server:sendLog", PlayerData.citizenid, "buy", {upgrades = String, citizenid = PlayerData.citizenid})
	            TriggerServerEvent("qb-log:server:CreateLog", "bennys", "buy", "green", "**" .. PlayerData.name .. "** (citizenid: *" .. PlayerData.citizenid .. "* | id: *(" .. PlayerData.source .. ")* has paid **€" .. TotalPrice .. "** for the following upgrade\'s: \n" .. String)
            end

            CurrentShop = nil
            ShoppingCart.buttons = {}

            CurrentVehicleData = QBCore.Functions.GetVehicleProperties(veh)

            TriggerServerEvent('qb-customs:server:SaveVehicleProps', CurrentVehicleData)
        else
            QBCore.Functions.Notify('You dont have enough money..', 'error')
        end
    end, TotalPrice)
end)

function GetTyreSmokeKey()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local cur = table.pack(GetVehicleTyreSmokeColor(veh))
    local retval = -1

    for k, v in pairs(QBCustoms.WheelAccessories) do
        if v.smokecolor[1] == cur[1] and v.smokecolor[2] == cur[2] and v.smokecolor[3] == cur[3] then
            retval = k
            break
        end
    end
    return retval
end

RegisterNUICallback('GetCartItem', function(data, cb)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local retval = -1

    if data.data ~= nil then
        if ShoppingCart.buttons ~= nil and next(ShoppingCart.buttons) ~= nil then
            for k, v in pairs(ShoppingCart.buttons) do
                if v.modtype ~= "respray" and v.modtype ~= "wheels" and v.modtype ~= "wheelaccessories" and v.modtype ~= "wheelcolor" then
                    for _, mod in pairs(data.data) do
                        if v.modtype ~= 18 then
                            if v.modtype == mod.modtype and v.modid == mod.modid then
                                retval = v.modid
                                break
                            end
                        else
                            if v.modid == mod.modid then
                                retval = 0
                                break
                            end
                        end
                    end
                elseif v.modtype == "respray" then
                    for k, mod in pairs(data.data) do
                        if v.modid == mod.modid and v.colortype == mod.colortype and v.spraytype == mod.spraytype then
                            retval = (k - 2)
                            break
                        else

                        end
                    end
                elseif v.modtype == "wheels" then
                    for k, mod in pairs(data.data) do
                        if v.modid == mod.modid and v.wheeltype == mod.wheeltype then
                            retval = (k - 2)
                            break
                        end
                    end
                elseif v.modtype == "wheelcolor" then
                    for k, mod in pairs(data.data) do
                        for _, color in pairs(QBCustoms.WheelColors) do
                            if mod.modid == color.modid then
                                retval = (k - 2)
                                break
                            end
                        end
                    end
                elseif v.modtype == "wheelaccessories" then
                    for _, mod in pairs(data.data) do
                        if mod.smokecolor ~= nil then
                            if mod.smokecolor[1] == v.smokecolor[1] and mod.smokecolor[2] == v.smokecolor[2] and mod.smokecolor[2] == v.smokecolor[2] then
                                retval = (mod.tireid - 2)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    cb(retval)
end)