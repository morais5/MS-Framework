local currentTattoos = {}
local cam = nil
local back = 1
local opacity = 1
local scaleType = nil
local scaleString = ""

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

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	isLoggedIn = true
	Citizen.Wait(300)
	QBCore.Functions.TriggerCallback('qb-tattooshop:GetPlayerTattoos', function(tattooList)
		if tattooList then
			ClearPedDecorations(PlayerPedId())
			for k, v in pairs(tattooList) do
				if v.Count ~= nil then
					for i = 1, v.Count do
						SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
					end
				else
					SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
				end
			end
			currentTattoos = tattooList
		end
	end)
end)


-- for debugging and restarting resource


Citizen.CreateThread(function()
	AddTextEntry("Tattoos", "Tattoo Shop")
	for k, v in pairs(Config.Shops) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 75)
		SetBlipColour(blip, 1)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("Tattoos")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Fix for onesync issues reapply after 5 minutes
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		if not IsMenuOpen() then
			QBCore.Functions.TriggerCallback('qb-tattooshop:GetPlayerTattoos', function(tattooList)
				if tattooList then
					ClearPedDecorations(PlayerPedId())
					for k, v in pairs(tattooList) do
						if v.Count ~= nil then
							for i = 1, v.Count do
								SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
							end
						else
							SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
						end
					end
					currentTattoos = tattooList
				end
			end)
		end
	end
end)

function refreshTattoos()
	QBCore.Functions.TriggerCallback('qb-tattooshop:GetPlayerTattoos', function(tattooList)
		if tattooList then
			ClearPedDecorations(PlayerPedId())
			for k, v in pairs(tattooList) do
				if v.Count ~= nil then
					for i = 1, v.Count do
						SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
					end
				else
					SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
				end
			end
			currentTattoos = tattooList
		end
	end)
end


function DrawTattoo(collection, name)
	ClearPedDecorations(PlayerPedId())
	for k, v in pairs(currentTattoos) do
		if v.Count ~= nil then
			for i = 1, v.Count do
				SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
			end
		else
			SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
		end
	end
	for i = 1, opacity do
		SetPedDecoration(PlayerPedId(), collection, name)
	end
end

function GetNaked()
	-- clothes:loadSkin
	-- hash = GetEntityModel(PlayerPedId())
	-- if hash == `mp_m_freemode_01` then
	-- 	print("This player is using the male freemode model.")
	-- end
		if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
			local nakedMale = {
				outfitData = {
					["pants"]       = { item = 14, texture = 0},  -- Broek
					["arms"]        = { item = 15, texture = 0},  -- Armen
					["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
					["vest"]        = { item = 0, texture = 0},  -- Body Vest
					["torso2"]      = { item = 91, texture = 0},  -- Jas / Vesten
					["shoes"]       = { item = 5, texture = 0},  -- Schoenen
					["decals"]      = { item = 10, texture = 0},  -- Decals
					["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
					["hat"]         = { item = -1, texture = -1},  -- Pet
					["glass"]       = { item = 0, texture = 0},  -- Bril
					["mask"]         = { item = 0, texture = 0},  -- Masker
				},
			}
			TriggerEvent('qb-clothing:client:loadOutfit', nakedMale)
		else
			local nakedFemale = {
				outfitData = {
					["pants"]       = { item = 16, texture = 0},  -- Broek
					["arms"]        = { item = 15, texture = 0},  -- Armen
					["t-shirt"]     = { item = -1, texture = 0},  -- T Shirt
					["vest"]        = { item = 0, texture = 0},  -- Body Vest
					["torso2"]      = { item = 101, texture = 1},  -- Jas / Vesten
					["shoes"]       = { item = 5, texture = 0},  -- Schoenen
					["decals"]      = { item = 0, texture = 0},  -- Decals
					["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
					["hat"]         = { item = -1, texture = -1},  -- Pet
					["glass"]       = { item = 0, texture = 0},  -- Bril
					["mask"]         = { item = 0, texture = 0},  -- Masker
				},
			}
			TriggerEvent('qb-clothing:client:loadOutfit', nakedFemale)
		end
end

function ResetSkin()
	TriggerServerEvent("qb-clothes:loadPlayerSkin")
	Citizen.Wait(100)
	ClearPedDecorations(PlayerPedId())
	for k, v in pairs(currentTattoos) do
		if v.Count ~= nil then
			for i = 1, v.Count do
				SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
			end
		else
			SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
		end
	end
end

function ReqTexts(text, slot)
	RequestAdditionalText(text, slot)
	while not HasAdditionalTextLoaded(slot) do
		Citizen.Wait(0)
	end
end

function OpenTattooShop()
	refreshTattoos()
	TattooMenu.OpenMenu("tattoo")
	FreezeEntityPosition(PlayerPedId(), true)
	GetNaked()
	ReqTexts("TAT_MNU", 9)
end

function CloseTattooShop()
	ClearAdditionalText(9, 1)
	FreezeEntityPosition(PlayerPedId(), false)
	EnableAllControlActions(0)
	back = 1
	opacity = 1
	ResetSkin()
	return true
end

function ButtonPress()
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function IsMenuOpen()
	return (TattooMenu.IsMenuOpened('tattoo') or string.find(tostring(TattooMenu.CurrentMenu() or ""), "ZONE_"))	
end

function BuyTattoo(collection, name, label, price)
	QBCore.Functions.TriggerCallback('qb-tattooshop:PurchaseTattoo', function(success)
		if success then
			table.insert(currentTattoos, {collection = collection, nameHash = name, Count = opacity})
		end
	end, currentTattoos, price, {collection = collection, nameHash = name, Count = opacity}, GetLabelText(label))
end

function RemoveTattoo(name, label)
	for k, v in pairs(currentTattoos) do
		if v.nameHash == name then
			table.remove(currentTattoos, k)
		end
	end
	TriggerServerEvent("qb-tattooshop:server:RemoveTattoo", currentTattoos)
	QBCore.Functions.Notify("You have removed the " .. GetLabelText(label) .. " tattoo", 'success')
end

function CreateScale(sType)
	if scaleString ~= sType and sType == "OpenShop" then
		scaleType = setupScaleform("instructional_buttons", "Open Tattoo Shop", 38)
		scaleString = sType
	elseif scaleString ~= sType and sType == "Control" then
		scaleType = setupScaleform2("instructional_buttons", "Change Camera View", 21, "Change Opacity", {90, 89}, "Buy/Remove Tattoo", 191)
		scaleString = sType
	end
end

Citizen.CreateThread(function()
	TattooMenu.CreateMenu("tattoo", "Tattoo Shop", function()
        return CloseTattooShop()
    end)
    TattooMenu.SetSubTitle('tattoo', "Categories")
	
	for k, v in ipairs(Config.TattooCats) do
		TattooMenu.CreateSubMenu(v[1], "tattoo", v[2])
		TattooMenu.SetSubTitle(v[1], v[2])
	end

    while true do 
        Citizen.Wait(0)
		local CanSleep = true
		if not IsMenuOpen() then
			for _,interiorId in ipairs(Config.interiorIds) do
				if GetInteriorFromEntity(PlayerPedId()) == interiorId then
					CanSleep = false
					if not IsPedInAnyVehicle(PlayerPedId(), false) then
						CreateScale("OpenShop")
						DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)
						if IsControlJustPressed(0, 38) then
							OpenTattooShop()
						end
					end
				end
			end
		end

		if IsMenuOpen() then
			DisableAllControlActions(0)
			CanSleep = false
		end
		
        if TattooMenu.IsMenuOpened('tattoo') then
			CanSleep = false
            for k, v in ipairs(Config.TattooCats) do
				TattooMenu.MenuButton(v[2], v[1])
			end
			ClearPedDecorations(PlayerPedId())
			for k,v in pairs(currentTattoos) do
				if v.Count ~= nil then
					for i = 1, v.Count do
						SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
					end
				else
					SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
				end
			end
			if DoesCamExist(cam) then
				DetachCam(cam)
				SetCamActive(cam, false)
				RenderScriptCams(false, false, 0, 1, 0)
				DestroyCam(cam, false)
			end
			TattooMenu.Display()
        end
		for k, v in ipairs(Config.TattooCats) do
			if TattooMenu.IsMenuOpened(v[1]) then
				CanSleep = false
				if not DoesCamExist(cam) then
					cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
					SetCamActive(cam, true)
					RenderScriptCams(true, false, 0, true, true)
					StopCamShaking(cam, true)
				end
				CreateScale("Control")
				DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)
				if IsDisabledControlJustPressed(0, 21) then
					ButtonPress()
					if back == #v[3] then
						back = 1
					else
						back = back + 1
					end
				end
				if IsDisabledControlJustPressed(0, 90) then
					ButtonPress()
					if opacity == 10 then
						opacity = 10
					else
						opacity = opacity + 1
					end
				end
				if IsDisabledControlJustPressed(0, 89) then
					ButtonPress()
					if opacity == 1 then
						opacity = 1
					else
						opacity = opacity - 1
					end
				end
				if GetCamCoord(cam) ~= GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[3][back]) then
					SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[3][back]))
					PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[4]))
				end
				for _, tattoo in pairs(Config.AllTattooList) do
					if tattoo.Zone == v[1] then
						if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
							if tattoo.HashNameMale ~= '' then
								local found = false
								for k, v in pairs(currentTattoos) do
									if v.nameHash == tattoo.HashNameMale then
										found = true
										break
									end
								end
								if found then
									local clicked, hovered = TattooMenu.SpriteButton(GetLabelText(tattoo.Name), "commonmenu", "shop_tattoos_icon_a", "shop_tattoos_icon_b")
									if clicked then
										RemoveTattoo(tattoo.HashNameMale, tattoo.Name)
									end
								else
									local price = math.ceil(tattoo.Price / 20) == 0 and 100 or math.ceil(tattoo.Price / 20)
									local clicked, hovered = TattooMenu.Button(GetLabelText(tattoo.Name), "~HUD_COLOUR_GREENDARK~$" .. price)
									if clicked then
										BuyTattoo(tattoo.Collection, tattoo.HashNameMale, tattoo.Name, price)
									elseif hovered then
										DrawTattoo(tattoo.Collection, tattoo.HashNameMale)
									end
								end
							end
						else
							if tattoo.HashNameFemale ~= '' then
								local found = false
								for k, v in pairs(currentTattoos) do
									if v.nameHash == tattoo.HashNameFemale then
										found = true
										break
									end
								end
								if found then
									local clicked, hovered = TattooMenu.SpriteButton(GetLabelText(tattoo.Name), "commonmenu", "shop_tattoos_icon_a", "shop_tattoos_icon_b")
									if clicked then
										RemoveTattoo(tattoo.HashNameFemale, tattoo.Name)
									end
								else
									local price = math.ceil(tattoo.Price / 20) == 0 and 100 or math.ceil(tattoo.Price / 20)
									local clicked, hovered = TattooMenu.Button(GetLabelText(tattoo.Name), "~HUD_COLOUR_GREENDARK~$" .. price)
									if clicked then
										BuyTattoo(tattoo.Collection, tattoo.HashNameFemale, tattoo.Name, price)
									elseif hovered then
										DrawTattoo(tattoo.Collection, tattoo.HashNameFemale)
									end
								end
							end
						end
					end
				end
				TattooMenu.Display()
			end
		end
		if CanSleep then
			Citizen.Wait(3000)
		end
    end
end)

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end

function setupScaleform2(scaleform, message, button, message2, buttons, message3, button2)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
	
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, buttons[1], true))
    Button(GetControlInstructionalButton(2, buttons[2], true))
    ButtonMessage(message2)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()
	
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, button2, true))
    ButtonMessage(message3)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function setupScaleform(scaleform, message, button)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end
