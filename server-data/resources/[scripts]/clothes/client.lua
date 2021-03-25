local Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

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

firstChar = false
cmenu = {show = 0, row = 0, field = 1}
text_in = 0
headblend = 0
haircolor_1 = 0
haircolor_2 = 0
draw = {0,0,0}
prop = {0,0,1}
overlay = {0,0,0}
model_id = 1
bar = {x=0.628, y=0.142, x1=0.037,y1=0.014}
pedType = ""

local faceProps = {
	[1] = { ["Prop"] = -1, ["Texture"] = -1 },
	[2] = { ["Prop"] = -1, ["Texture"] = -1 },
	[3] = { ["Prop"] = -1, ["Texture"] = -1 },
	[4] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
	[5] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
	[6] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
}

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function custDrawRect(x, y, width, height, r, g, b, a)
	y = y + 0.5
	y = y * 0.8
	x = x * 0.8
	width = width * 0.8
	height = height * 0.8
	DrawRect(x, y, width, height, r, g, b, a)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	y = y + 0.502
	y = y * 0.8
	x = x * 0.8  
	width = width * 0.8
	height = height * 0.8
	SetTextFont(6)
	SetTextProportional(0)
	SetTextScale(0.35, 0.35)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

isCop = false
isEms = false
isJudge = false

function startClothes(hasToPay)
	cmenu.show = 1
	cmenu.row = 1
	cmenu.field = 1
	text_in = 0
	if firstChar then
		TriggerEvent("doIntroCam")
	elseif hasToPay then
		QBCore.Functions.GetPlayerData(function(PlayerData)
			local cashBalance = PlayerData.money["cash"]
			local cashBalance = PlayerData.money["bank"]
			if cashBalance >= 100 or cashBalance >= 100 then
				TriggerServerEvent("clothes:server:PayClothes")
			else
				QBCore.Functions.Notify("You don\'t have enough money! (€100,-)")
			end
		end)
	end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function clothingbad()
   	loadAnimDict( "clothingshirt" )    	
	BagkPlayAnim( GetPlayerPed(-1), "clothingshirt", "try_shirt_negative_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
	--Wait(6100)
	--ClearPedSecondaryBagk(GetPlayerPed(-1))
end

function clothinggood()
    loadAnimDict("clothingshirt")    	
	BagkPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	BagkPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

local copListM = {
[1] = {},
[2] = {},
[3] = {},
[4] = {},
[5] = {31,32},
[6] = {44,45},
[7] = {},
[8] = {1,2,3,4,5,6,7,8,9,15,42,43,44,110,111,119,120,125,128},
[9] = {16,18,20,37,38,39,42,43,44,53,54,55,57,58,67,71,72,92,93,129,130},
[10] = {1,2,3,10,12,13,14,15,18,19,20,21,22,23,24,26,27},
[11] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15},
[12] = {17,18,19,24,26,29,30,31,32,34,35,36,39,40,46,47,51,52,64,74,75,80,81,93,94,97,98,100,101,102,103,118,123,133,143,149,150,154,156,183},
}

local copListF = {
[1] = {},
[2] = {},
[3] = {},
[4] = {},
[5] = {30,31,41},
[6] = {44,45},
[7] = {},
[8] = {1,2,3,5,6,8,19,29,30,81,82,95,98},
[9] = {2,3,6,7,8,9,10,19,30,31,32,34,35,49,51,52,65,66,67,101,103,159,160},
[10] = {1,2,14,16,17,18,19,20,21,23,24,25,26,28,29,30},
[11] = {1,2,3,4,5,6,7,10,11,12,13,14},
[12] = {16,19,20,21,25,31,33,34,36,38,40,44,84,85,88,89,90,91,92,93,94,110,119,126,140,146,151,153,172},
}

function ClothShop()

	HideHudAndRadarThisFrame()
	custDrawRect(0.12,0.07,0.22,0.09,33,33,33,200) -- header
	drawTxt(0.177, 0.066, 0.25, 0.03, 0.40,"Clothes shop",255,255,255,255) -- header
	custDrawRect(0.12,0.024,0.216,0.005,111,1,1,220) -- blue_head
	if cmenu.show == 1 then
		if cmenu.row == 1 then custDrawRect(0.12,0.135,0.22,0.035,76,88,102,220) else custDrawRect(0.12,0.135,0.22,0.035,33,33,33,200) end
		if cmenu.row == 2 then custDrawRect(0.12,0.172,0.22,0.035,76,88,102,220) else custDrawRect(0.12,0.172,0.22,0.035,33,33,33,200) end
		if cmenu.row == 3 then custDrawRect(0.12,0.209,0.22,0.035,76,88,102,220) else custDrawRect(0.12,0.209,0.22,0.035,33,33,33,200) end
		if cmenu.row == 4 then custDrawRect(0.12,0.246,0.22,0.035,76,88,102,220) else custDrawRect(0.12,0.246,0.22,0.035,33,33,33,200) end
		if cmenu.row == 5 then custDrawRect(0.12,0.283,0.22,0.035,76,88,102,220) else custDrawRect(0.12,0.283,0.22,0.035,33,33,33,200) end
		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"General",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"Accesories",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"Model",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Overlay",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.276, 0.25, 0.03, 0.40,"Save",255,255,255,255) -- row_2 (+0.037)

		

	elseif cmenu.show == 2 then
		-- debug_you_can_delete_it
		local drawstr = string.format("Type: %d | Color: %d | Color 2: %d",draw[1],draw[2],draw[3])

		drawTxt(0.242, 0.225, 0, 0, 0.40,drawstr,255,255,255,255)
		custDrawRect(0.328,0.244,0.18,0.035,33,33,33,200)

		-- debug_end
		custDrawRect(0.12,0.135,0.22,0.035,76,88,102,220)
		custDrawRect(0.12,0.172,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.209,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.246,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.283,0.22,0.035,33,33,33,200)

		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"~b~General",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"Accesories",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"Model",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Overlay",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.276, 0.25, 0.03, 0.40,"Save",255,255,255,255) -- row_2 (+0.037)
		---
		custDrawRect(0.328,0.051,0.18,0.049,33,33,33,200) -- title
		drawTxt(0.382,0.048,0.175,0.035, 0.40,"General",255,255,255,255)
		custDrawRect(0.328,0.024,0.175,0.005,111,1,1,220)
		if cmenu.row == 1 then custDrawRect(0.328,0.096,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.096,0.18,0.035,33,33,33,200) end
		if cmenu.row == 2 then custDrawRect(0.328,0.133,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.133,0.18,0.035,33,33,33,200) end
		if cmenu.row == 3 then custDrawRect(0.328,0.170,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.170,0.18,0.035,33,33,33,200) end
		if cmenu.row == 4 then custDrawRect(0.328,0.207,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.207,0.18,0.035,33,33,33,200) end
		--


		local accessoriesList = {
			[1] = "Face",
			[2] = "Mask",
			[3] = "Hair",
			[4] = "Arms",
			[5] = "Pants",
			[6] = "Bag",			
			[7] = "Shoes",
			[8] = "Neck/Tie",
			[9] = "Undershirt",
			[10] = "Vests",			
			[11] = "Decals",
			[12] = "Jackets / Top shirts",
		}

		local draw_str = "Slot: " .. accessoriesList[cmenu.field] .. " " .. cmenu.field .. "/12"

		drawTxt(0.328,0.093,0.175,0.035, 0.40,draw_str,255,255,255,255)
		--
		if GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= 0 and GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= false then
			custDrawRect(0.328,0.142,0.175,0.014,222,222,222,220)
			local link = 0.138/(GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1)
			if accessoriesList[cmenu.field] == "Face" then
				link = 0.138/45
			end

			local new_x = (bar.x-0.069)+(link*draw[1])
			new_x = new_x - 0.3
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			custDrawRect(new_x,bar.y,bar.x1,bar.y1,111,1,1,220)
			-- row_3


			custDrawRect(0.328,0.179,0.175,0.014,222,222,222,220) -- bar_main
			local link = 0.138/(GetNumberOfPedTextureVariations(GetPlayerPed(-1), cmenu.field-1, draw[1])-1)
			if accessoriesList[cmenu.field] == "Hair" then
				link = 0.138/(GetNumHairColors()-1)
			end
			local new_x = (bar.x-0.069)+(link*draw[2])
			new_x = new_x - 0.3
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			custDrawRect(new_x,bar.y+0.037,bar.x1,bar.y1,111,1,1,220)
			--
			custDrawRect(0.328,0.216,0.175,0.014,222,222,222,220) 
			local link = 0.138/2
			if accessoriesList[cmenu.field] == "Hair" then
				link = 0.138/(GetNumHairColors()-1)
			end
			local new_x = (bar.x-0.069)+(link*draw[3])
			new_x = new_x - 0.3
			if new_x < 0.259 then new_x = 0.259 end
			if new_x > 0.397 then new_x = 0.397 end
			custDrawRect(new_x,bar.y+0.074,bar.x1,bar.y1,111,1,1,220) -- +2 rows
			--
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field > 1 then 
						cmenu.field = cmenu.field-1
						draw[1] = 0
						draw[2] = 0
					else 
						cmenu.field = 12
						draw[1] = 0
						draw[2] = 0
					end
				elseif cmenu.row == 2 then
					if draw[1] > 0 then draw[1] = draw[1]-1 else draw[1] = 0 end
					if not isJudge then
						if not isCop and model_id == 1 and not isEms then
							if pedType == "male" then
								for i = #copListM[cmenu.field], 1, -1 do
								    if draw[1] == copListM[cmenu.field][i] then
										i = 1
										draw[1] = draw[1]-1
									end
								end
							else
								for i = #copListF[cmenu.field], 1, -1 do
								    if draw[1] == copListM[cmenu.field][i] then
										i = 1
										draw[1] = draw[1]-1
									end
								end
							end
						end
					end

					draw[2] = 0
					if accessoriesList[cmenu.field] == "Face" then
						headblend = draw[1]
						SetPedHeadBlendData(GetPlayerPed(-1), draw[1], draw[1], draw[1], draw[1], draw[1], draw[1], 1.0, 1.0, 1.0, true)
					else
						SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
					end
				elseif cmenu.row == 3 then
					if draw[2] > 0 then draw[2] = draw[2]-1 else draw[2] = 0 end
					if accessoriesList[cmenu.field] == "Hair" then
						SetPedHairColor(GetPlayerPed(-1), draw[2], draw[3])
						haircolor_1 = draw[2]
						haircolor_2 = draw[3]
					else
						SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
					end
				elseif cmenu.row == 4 then
					if draw[3] > 0 then draw[3] = draw[3]-1 end
					if accessoriesList[cmenu.field] == "Hair" then
						SetPedHairColor(GetPlayerPed(-1), draw[2], draw[3])
						haircolor_1 = draw[2]
						haircolor_2 = draw[3]
					end
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field < 12 then 
						cmenu.field = cmenu.field+1 
						draw[1] = 0
						draw[2] = 0
					else 
						cmenu.field = 1
						draw[1] = 0
						draw[2] = 0
					end
				elseif cmenu.row == 2 then
					if draw[1] < GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 then draw[1] = draw[1]+1 else draw[1] = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 end
					if not isJudge then
						if not isCop and model_id == 1 and not isEms then
							if pedType == "male" then
								for i,v in ipairs(copListM[cmenu.field]) do
									if draw[1] == v then
										draw[1] = draw[1]+1
									end
								end
							else
								for i,v in ipairs(copListF[cmenu.field]) do
									if draw[1] == v then
										draw[1] = draw[1]+1
									end
								end
							end
						end
					end
					draw[2] = 0
					if accessoriesList[cmenu.field] == "Face" then
						headblend = draw[1]
						SetPedHeadBlendData(GetPlayerPed(-1), draw[1], draw[1], draw[1], draw[1], draw[1], draw[1], 1.0, 1.0, 1.0, true)
					else
						SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
					end
				elseif cmenu.row == 3 then
					if accessoriesList[cmenu.field] == "Hair" then
						if draw[2] < GetNumHairColors()-1 then draw[2] = draw[2]+1 else draw[2] = GetNumHairColors()-1 end
						SetPedHairColor(GetPlayerPed(-1), draw[2], draw[3])
						haircolor_1 = draw[2]
						haircolor_2 = draw[3]
					else
						if draw[2] < GetNumberOfPedTextureVariations(GetPlayerPed(-1), cmenu.field-1, draw[1])-1 then draw[2] = draw[2]+1 else draw[2] = GetNumberOfPedTextureVariations(GetPlayerPed(-1), cmenu.field-1, draw[1])-1 end
						SetPedComponentVariation(GetPlayerPed(-1), cmenu.field-1, draw[1], draw[2], draw[3])
					end
				elseif cmenu.row == 4 then
					if accessoriesList[cmenu.field] == "Hair" then
						if draw[3] < GetNumHairColors()-1 then draw[3] = draw[3]+1 end
						SetPedHairColor(GetPlayerPed(-1), draw[2], draw[3])
						haircolor_1 = draw[2]
						haircolor_2 = draw[3]
					else
						if draw[3] < 2 then draw[3] = draw[3]+1 end
					end
				end
			end
		else
			drawTxt(0.328,0.130,0.175,0.035, 0.40,"Not available",255,255,255,255)
			drawTxt(0.328,0.167,0.175,0.035, 0.40,"Not available",255,255,255,255)
			drawTxt(0.328,0.204,0.175,0.035, 0.40,"Not available",255,255,255,255)
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field > 1 then 
					cmenu.field = cmenu.field-1
					draw[1] = 0
					draw[2] = 0
				else 
					cmenu.field = 12
					draw[1] = 0
					draw[2] = 0
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field < 12 then 
					cmenu.field = cmenu.field+1
					draw[1] = 0
					draw[2] = 0
				else 
					cmenu.field = 1
					draw[1] = 0
					draw[2] = 0
				end
			end
		end
	elseif cmenu.show == 3 then
		-- debug_you_can_delete_it

		local drawstr = string.format("Type: %d | Color: %d",prop[1],prop[2])

		drawTxt(0.242, 0.188, 0, 0, 0.40,drawstr,255,255,255,255)

		custDrawRect(0.328,0.207,0.18,0.035,33,33,33,200)



		-- debug_end
		custDrawRect(0.12,0.135,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.172,0.22,0.035,76,88,102,220)
		custDrawRect(0.12,0.209,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.246,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.283,0.22,0.035,33,33,33,200)

		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"General",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"~b~Accesories",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"Model",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Overlay",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.276, 0.25, 0.03, 0.40,"Save",255,255,255,255) -- row_2 (+0.037)
		---
		custDrawRect(0.328,0.051,0.18,0.049,33,33,33,200) -- title
		drawTxt(0.382,0.048,0.175,0.035, 0.40,"Accesories",255,255,255,255)
		custDrawRect(0.328,0.024,0.175,0.005,111,1,1,220)
		if cmenu.row == 1 then custDrawRect(0.328,0.096,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.096,0.18,0.035,33,33,33,200) end
		if cmenu.row == 2 then custDrawRect(0.328,0.133,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.133,0.18,0.035,33,33,33,200) end
		if cmenu.row == 3 then custDrawRect(0.328,0.170,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.170,0.18,0.035,33,33,33,200) end

		local accessoriesList = {
			[1] = "Helms",
			[2] = "Glasses",
			[3] = "Earrings",
			[4] = "Not available",
			[5] = "Not available",
			[6] = "Not available",			
			[7] = "Watch",
			[8] = "Bracelets",
		}

		local draw_str = "Slot: " .. accessoriesList[cmenu.field] .. " " .. cmenu.field .. "/8"

		drawTxt(0.328,0.093,0.175,0.035, 0.40,draw_str,255,255,255,255)
		--
		if GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= 0 and GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1) ~= false then
			custDrawRect(0.328,0.142,0.175,0.014,222,222,222,220)
			local link = 0.138/(GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1)
			local new_x = (bar.x-0.069)+(link*prop[1])


			new_x = new_x - 0.3
			custDrawRect(new_x,bar.y,bar.x1,bar.y1,111,1,1,220)
			-- row_3
			custDrawRect(0.328,0.179,0.175,0.014,222,222,222,220) -- bar_main
			local link = 0.138/(GetNumberOfPedPropTextureVariations(GetPlayerPed(-1), cmenu.field-1, prop[1])-1)
			local new_x = (bar.x-0.069)+(link*prop[2])
			new_x = new_x - 0.3


			custDrawRect(new_x,bar.y+0.037,bar.x1,bar.y1,111,1,1,220)
			--
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field > 1 then 
						cmenu.field = cmenu.field-1 
						prop[1] = 0
						prop[2] = 0
					else 
						cmenu.field = 8
						prop[1] = 0
						prop[2] = 0
					end
				elseif cmenu.row == 2 then
					if prop[1] > 0 then prop[1] = prop[1]-1 else prop[1] = 0 end
					prop[2] = 0
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				elseif cmenu.row == 3 then
					if prop[2] > 0 then prop[2] = prop[2]-1 else prop[2] = 0 end
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field < 8 then 
						cmenu.field = cmenu.field+1 
						prop[1] = 0
						prop[2] = 0
					else 
						cmenu.field = 1
						prop[1] = 0
						prop[2] = 0
					end
				elseif cmenu.row == 2 then
					if prop[1] < GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 then prop[1] = prop[1]+1 else prop[1] = GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), cmenu.field-1)-1 end
					prop[2] = 0
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				elseif cmenu.row == 3 then
					if prop[2] < GetNumberOfPedPropTextureVariations(GetPlayerPed(-1), cmenu.field-1, prop[1])-1 then prop[2] = prop[2]+1 else prop[2] = GetNumberOfPedPropTextureVariations(GetPlayerPed(-1), cmenu.field-1, prop[1])-1 end
					SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				end
			end
		else
			drawTxt(0.328,0.130,0.175,0.035, 0.40,"Not available",255,255,255,255)
			drawTxt(0.328,0.167,0.175,0.035, 0.40,"Not available",255,255,255,255)
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field > 1 then 
					cmenu.field = cmenu.field-1
					prop[1] = 0
					prop[2] = 0
				else 
					cmenu.field = 8
					prop[1] = 0
					prop[2] = 0
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field < 8 then 
					cmenu.field = cmenu.field+1
					prop[1] = 0
					prop[2] = 0
				else
					cmenu.field = 1
					prop[1] = 0
					prop[2] = 0
				end
			end
		end
	elseif cmenu.show == 4 then
		custDrawRect(0.12,0.135,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.172,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.209,0.22,0.035,76,88,102,220)
		custDrawRect(0.12,0.246,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.283,0.22,0.035,33,33,33,200)

		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"General",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"Accesories",255,255,255,255)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"~b~Model",255,255,255,255)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"Overlay",255,255,255,255)
		drawTxt(0.177, 0.276, 0.25, 0.03, 0.40,"Save",255,255,255,255)

		custDrawRect(0.328,0.051,0.18,0.049,33,33,33,200)
		drawTxt(0.382,0.048,0.175,0.035, 0.40,"Model",255,255,255,255)
		custDrawRect(0.328,0.024,0.175,0.005,111,1,1,220)
		if cmenu.row == 1 then custDrawRect(0.328,0.096,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.096,0.18,0.035,33,33,33,200) end
		if cmenu.row == 2 then custDrawRect(0.328,0.133,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.133,0.18,0.035,33,33,33,200) end
		if cmenu.row == 3 then custDrawRect(0.328,0.170,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.170,0.18,0.035,33,33,33,200) end

		local draw_str = string.format("Slot: < %d / " .. #selected_skins .. " >", model_id)
		drawTxt(0.328,0.093,0.175,0.035, 0.40,draw_str,255,255,255,255)
		draw_str = string.format("%s", selected_skins[model_id])
		drawTxt(0.328,0.093+0.037,0.175,0.035, 0.40,draw_str,255,255,255,255)
		drawTxt(0.328,0.093+0.037*2,0.175,0.035, 0.40,"Search by name",255,255,255,255)
		if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left

			RequestModel(selected_skins[(model_id - 1)])
			RequestModel(selected_skins[(model_id - 2)])
			RequestModel(selected_skins[(model_id - 3)])
			RequestModel(selected_skins[(model_id - 4)])
			RequestModel(selected_skins[(model_id - 5)])
			RequestModel(selected_skins[(model_id - 6)])
			RequestModel(selected_skins[(model_id - 7)])
			RequestModel(selected_skins[(model_id - 8)])
			RequestModel(selected_skins[(model_id - 9)])
			RequestModel(selected_skins[(model_id - 10)])
		
			if cmenu.row == 1 then
				if model_id > 1 then
					model_id=model_id-1
				else
					model_id = #selected_skins
				end
			end
			ChangeToSkinNoUpdate(selected_skins[model_id])
		end
		if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right


			RequestModel(selected_skins[(model_id + 1)])
			RequestModel(selected_skins[(model_id + 2)])
			RequestModel(selected_skins[(model_id + 3)])
			RequestModel(selected_skins[(model_id + 4)])
			RequestModel(selected_skins[(model_id + 5)])
			RequestModel(selected_skins[(model_id + 6)])
			RequestModel(selected_skins[(model_id + 7)])
			RequestModel(selected_skins[(model_id + 8)])
			RequestModel(selected_skins[(model_id + 9)])
			RequestModel(selected_skins[(model_id + 10)])


			
			if cmenu.row == 1 then
				if model_id < #selected_skins then
					model_id=model_id+1
				else
					model_id = 1
				end
			end
			ChangeToSkinNoUpdate(selected_skins[model_id])
		end
		if ( IsControlJustPressed(1,201) or IsControlJustPressed(1,38) ) then -- Enter
			if cmenu.row == 1 or cmenu.row == 2 then
				ChangeToSkinNoUpdate(selected_skins[model_id])
			elseif cmenu.row == 3 then
				if text_in == 0 then
					text_in = 1
					DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
				end
			end
			--camOff()
		end
	elseif cmenu.show == 5 then
		local drawstr = string.format("Type: %d | Color: %d",overlay[1], overlay[2])

		drawTxt(0.242, 0.188, 0, 0, 0.40,drawstr,255,255,255,255)

		custDrawRect(0.328,0.207,0.18,0.035,33,33,33,200)



		-- debug_end
		custDrawRect(0.12,0.135,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.172,0.22,0.035,33,33,33,220)
		custDrawRect(0.12,0.209,0.22,0.035,33,33,33,200)
		custDrawRect(0.12,0.246,0.22,0.035,76,88,102,200)
		custDrawRect(0.12,0.283,0.22,0.035,33,33,33,200)
		drawTxt(0.177, 0.128, 0.25, 0.03, 0.40,"General",255,255,255,255)
		drawTxt(0.177, 0.165, 0.25, 0.03, 0.40,"Accesories",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.202, 0.25, 0.03, 0.40,"Model",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.239, 0.25, 0.03, 0.40,"~b~Overlay",255,255,255,255) -- row_2 (+0.037)
		drawTxt(0.177, 0.276, 0.25, 0.03, 0.40,"Save",255,255,255,255) -- row_2 (+0.037)
		---
		custDrawRect(0.328,0.051,0.18,0.049,33,33,33,200) -- title
		drawTxt(0.382,0.048,0.175,0.035, 0.40,"Overlay",255,255,255,255)
		custDrawRect(0.328,0.024,0.175,0.005,111,1,1,220)
		if cmenu.row == 1 then custDrawRect(0.328,0.096,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.096,0.18,0.035,33,33,33,200) end
		if cmenu.row == 2 then custDrawRect(0.328,0.133,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.133,0.18,0.035,33,33,33,200) end
		if cmenu.row == 3 then custDrawRect(0.328,0.170,0.18,0.035,76,88,102,220) else custDrawRect(0.328,0.170,0.18,0.035,33,33,33,200) end

		local accessoriesList = {
			[1] = "Beards",
			[2] = "Eyebrows",
			[3] = "Age",
			[4] = "Make-up",
		}

		local draw_str = "Slot: " .. accessoriesList[cmenu.field] .. " " .. cmenu.field .. "/4"

		drawTxt(0.328,0.093,0.175,0.035, 0.40,draw_str,255,255,255,255)
		--
		if GetNumHeadOverlayValues(cmenu.field-1) ~= 0 and GetNumHeadOverlayValues(cmenu.field-1) ~= false then
			custDrawRect(0.328,0.142,0.175,0.014,222,222,222,220)
			local link = 0.138/(GetNumHeadOverlayValues(cmenu.field))
			local new_x = (bar.x-0.069)+(link*overlay[1])


			new_x = new_x - 0.3
			custDrawRect(new_x,bar.y,bar.x1,bar.y1,111,1,1,220)
			-- row_3
			custDrawRect(0.328,0.179,0.175,0.014,222,222,222,220) -- bar_main
			local link = 0.138/(GetNumHairColors()-1)
			local new_x = (bar.x-0.069)+(link*overlay[2])
			new_x = new_x - 0.3


			custDrawRect(new_x,bar.y+0.037,bar.x1,bar.y1,111,1,1,220)
			--
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field > 1 then 
						cmenu.field = cmenu.field-1 
						overlay[1] = 0
						overlay[2] = 0
					else 
						cmenu.field = 4
						overlay[1] = 0
						overlay[2] = 0
					end
				elseif cmenu.row == 2 then
					if overlay[1] > 0 then overlay[1] = overlay[1]-1 else overlay[1] = 0 end
					overlay[2] = 0
					SetPedHeadOverlay(GetPlayerPed(-1), cmenu.field, overlay[1], 1.0)	
					--SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				elseif cmenu.row == 3 then
					if overlay[2] > 0 then overlay[2] = overlay[2]-1 else overlay[2] = 0 end
					SetPedHeadOverlayColor(GetPlayerPed(-1), cmenu.field, 1, overlay[2], 0)
					--SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, prop[1], prop[2], prop[3])
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					if cmenu.field < 4 then 
						cmenu.field = cmenu.field+1 
						overlay[1] = 0
						overlay[2] = 0
					else 
						cmenu.field = 1
						overlay[1] = 0
						overlay[2] = 0
					end
				elseif cmenu.row == 2 then
					if overlay[1] < GetNumHeadOverlayValues(cmenu.field)-1 then overlay[1] = overlay[1]+1 else overlay[1] = GetNumHeadOverlayValues(cmenu.field)-1 end
					overlay[2] = 0
					--SetPedHeadBlendData(GetPlayerPed(-1), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, true)
					SetPedHeadOverlay(GetPlayerPed(-1), cmenu.field, overlay[1], 1.0)
					--SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, overlay[1], overlay[2], overlay[3])
				elseif cmenu.row == 3 then
					if overlay[2] < GetNumHairColors()-1 then overlay[2] = overlay[2]+1 else overlay[2] = GetNumHairColors()-1 end
					SetPedHeadOverlayColor(GetPlayerPed(-1), cmenu.field, 1, overlay[2], 0)	
					--SetPedPropIndex(GetPlayerPed(-1), cmenu.field-1, overlay[1], overlay[2], overlay[3])
				end
			end
		else
			drawTxt(0.328,0.130,0.175,0.035, 0.40,"Not available",255,255,255,255)
			drawTxt(0.328,0.167,0.175,0.035, 0.40,"Not available",255,255,255,255)
			if IsControlJustPressed(1, 189) or IsDisabledControlJustPressed(1, 189) then -- left
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field > 1 then 
					cmenu.field = cmenu.field-1
					overlay[1] = 0
					overlay[2] = 0
				else 
					cmenu.field = 8
					overlay[1] = 0
					overlay[2] = 0
				end
			end
			if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.field < 8 then 
					cmenu.field = cmenu.field+1
					overlay[1] = 0
					overlay[2] = 0
				else
					cmenu.field = 1
					overlay[1] = 0
					overlay[2] = 0
				end
			end
		end
	end
end

function ShowRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

cam = -1

function invisCheck()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstPed()
	local success
	local rped = nil
	local distanceFrom
	repeat
	    local pos = GetEntityCoords(ped)
	    local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
	    if distance < 5.0 and ped ~= GetPlayerPed(-1) then
	    	SetEntityLocallyInvisible(ped)
	    end
	    success, ped = FindNextPed(handle)
	until not success
	EndFindPed(handle)
end

RegisterNetEvent("clothes:client:OpenMenu")
AddEventHandler("clothes:client:OpenMenu", function(hasToPay)
	startClothes(hasToPay)
end)

RegisterNetEvent("doIntroCam")
AddEventHandler("doIntroCam", function()
	local spinning = true
	if(not DoesCamExist(cam)) then

		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
		SetCamRot(cam, 0.0, 0.0, 0.0)
		SetCamActive(cam,  true)
		RenderScriptCams(true,  false,  0,  true,  true)

		SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
	end

	SetEntityInvincible(GetPlayerPed(-1), true)
	Citizen.Wait(2000)
	FreezeEntityPosition(GetPlayerPed(-1),true)
	while cmenu.show ~= 0 do
		Citizen.Wait(1)
		NetworkSetTalkerProximity(0.0)
		invisCheck()

		if IsDisabledControlPressed(0, Keys["A"]) or IsControlPressed(0, Keys["A"]) then
			SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(GetPlayerPed(-1))-1.0)
		end

		if IsDisabledControlPressed(0, Keys["D"]) or IsControlPressed(0, Keys["D"]) then
			SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(GetPlayerPed(-1))+1.0)
		end

		DisableAllControlActions(0)
		EnableControlAction(0, Keys["UP"], true)
		EnableControlAction(0, Keys["DOWN"], true)
		EnableControlAction(0, Keys["LEFT"], true)
		EnableControlAction(0, Keys["RIGHT"], true)
		EnableControlAction(0, Keys["ENTER"], true)
		EnableControlAction(0, Keys["BACKSPACE"], true)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		SetCamCoord(cam, x+1.7, y+1.5, z+0.4)
		SetCamRot(cam, 0.0, 0.0, 124.9)

	end

	FreezeEntityPosition(GetPlayerPed(-1), false)
	SetEntityInvincible(GetPlayerPed(-1), false)
	NetworkSetTalkerProximity(0.0)
	firstChar = false
	camOff()
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	TriggerServerEvent("clothes:loadPlayerSkin")
end)

RegisterNetEvent("clothes:loadSkin")
AddEventHandler("clothes:loadSkin", function(new, model, data)
	SetEntityInvincible(GetPlayerPed(-1),true)
	local function setDefault()
		Citizen.CreateThread(function()
			QBCore.Functions.GetPlayerData(function(PlayerData)
				firstChar = true
				if PlayerData.charinfo.gender == 0 then
					TriggerEvent("maleclothesstart", true)
				else
					TriggerEvent("femaleclothesstart", true)
				end
				DoScreenFadeIn(50)
			end)
		end)
	end

	if new then setDefault() return end

	local model = model ~= nil and tonumber(model) or false

	if not model then setDefault() return end
	if not data then setDefault() return end

	if not IsModelInCdimage(model) or not IsModelValid(model) then setDefault() return end

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)

		data = json.decode(data)

		if not data or data == "" then setDefault() return end

		for i = 0, 11 do
			local idx = tostring(i)
			if (i == 0) then
				SetPedHeadBlendData(GetPlayerPed(-1), data.drawables[idx], data.drawables[idx], data.drawables[idx], data.drawables[idx], data.drawables[idx], data.drawables[idx], 1.0, 1.0, 1.0, true)
			elseif (i == 2) then
				SetPedComponentVariation(GetPlayerPed(-1), i, tonumber(data.drawables[idx]), 0, 0)
				SetPedHairColor(GetPlayerPed(-1), tonumber(data.textures[idx]), tonumber(data.palletetextures[idx]))
			else
				SetPedComponentVariation(GetPlayerPed(-1), i, tonumber(data.drawables[idx]), tonumber(data.textures[tonumber(idx)]), tonumber(data.palletetextures[tonumber(idx)]))
			end
		end

		for i = 0, 8 do
			local idx = tostring(i)
			if (i ~= 4 and i ~= 5 and i ~= 6) then
				SetPedPropIndex(GetPlayerPed(-1), i, tonumber(data.props[idx]), tonumber(data.proptextures[idx]), true)
			end
		end
		for i = 0, 4 do
			local idx = tostring(i)
			SetPedHeadOverlay(GetPlayerPed(-1), i, tonumber(data.overlays[idx]), 1.0)
			SetPedHeadOverlayColor(GetPlayerPed(-1), i, 1, tonumber(data.overlaycolors[idx]), 0)
		end
	end)
	SetEntityInvincible(GetPlayerPed(-1),false)
end)

function ChangeToSkinNoUpdate(skin)
	SetEntityInvincible(GetPlayerPed(-1),true)
	local model = GetHashKey(skin)
	if IsModelInCdimage(model) and IsModelValid(model) then
		lastmodel = selected_skins[model_id]
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), model)
		if skin ~= "tony" and skin ~= "g_m_m_chigoon_02_m" and skin ~= "u_m_m_jesus_01" and skin ~= "a_m_y_stbla_m" and skin ~= "ig_terry_m" and skin ~= "a_m_m_ktown_m" and skin ~= "a_m_y_skater_m" and skin ~= "u_m_y_coop" and skin ~= "ig_car3guy1_m" then
			SetPedRandomComponentVariation(GetPlayerPed(-1), true)
		end
		
		SetModelAsNoLongerNeeded(model)
	else
		--TriggerEvent("DoLongHudText","Model not found / No Model Change 2")

	end

	SetEntityInvincible(GetPlayerPed(-1),false)
end

function ChangeToSkin(skin)
	SetEntityInvincible(GetPlayerPed(-1),true)
	if skin == nil and lastmodel ~= nil then
		skin = lastmodel
	end
	lastmodel = skin

	local model = GetEntityModel(GetPlayerPed(-1))

	local drawables = {}
	local textures = {}
	local palletetextures = {}

	local props = {}
	local proptextures = {}

	local overlays = {}
	local overlaycolors = {}

	for i = 0, 11 do
		if (i == 0) then
			local drawable = headblend
			drawables[i] = drawable
		elseif (i == 2) then
			local drawable = GetPedDrawableVariation(GetPlayerPed(-1), i)
			drawables[i] = drawable

			local texture = haircolor_1
			textures[i] = texture

			local palletetexture = haircolor_2
			palletetextures[i] = palletetexture
		else
			local drawable = GetPedDrawableVariation(GetPlayerPed(-1), i)
			drawables[i] = drawable
			
			local texture = GetPedTextureVariation(GetPlayerPed(-1), i)
			textures[i] = texture

			local palletetexture = GetPedPaletteVariation(GetPlayerPed(-1), i)
			palletetextures[i] = palletetexture
		end
	end

	for i = 0, 8 do
		if (i ~= 4 and i ~= 5 and i ~= 6) then
			local prop = GetPedPropIndex(GetPlayerPed(-1), i)
			props[i] = prop

			local proptexture = GetPedPropTextureIndex(GetPlayerPed(-1), i)
			proptextures[i] = proptexture
		end
	end

	for i = 0, 4 do
		local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(GetPlayerPed(-1), i)
		overlays[i] = overlayValue
		overlaycolors[i] = firstColour
	end

	local clothing = {
		drawables = drawables,
		textures = textures,
		palletetextures = palletetextures,
		props = props,
		proptextures = proptextures,
		overlays = overlays,
		overlaycolors = overlaycolors,
	}

	clothing = json.encode(clothing)
	TriggerServerEvent("clothes:saveSkin", model, clothing)

	clothinggood()
	
	SetEntityInvincible(GetPlayerPed(-1),false)
end

function SaveOutfit(skin, outfitName)
	SetEntityInvincible(GetPlayerPed(-1),true)
	if (not skin or skin == nil) and lastmodel ~= nil then
		skin = lastmodel
	end
	lastmodel = skin

	local model = GetEntityModel(GetPlayerPed(-1))

	local drawables = {}
	local textures = {}
	local palletetextures = {}

	local props = {}
	local proptextures = {}

	local overlays = {}
	local overlaycolors = {}

	for i = 0, 11 do
		if (i == 0) then
			local drawable = headblend
			drawables[i] = drawable
		elseif (i == 2) then
			local drawable = GetPedDrawableVariation(GetPlayerPed(-1), i)
			drawables[i] = drawable

			local texture = haircolor_1
			textures[i] = texture

			local palletetexture = haircolor_2
			palletetextures[i] = palletetexture
		else
			local drawable = GetPedDrawableVariation(GetPlayerPed(-1), i)
			drawables[i] = drawable
			
			local texture = GetPedTextureVariation(GetPlayerPed(-1), i)
			textures[i] = texture

			local palletetexture = GetPedPaletteVariation(GetPlayerPed(-1), i)
			palletetextures[i] = palletetexture
		end
	end

	for i = 0, 8 do
		if (i ~= 4 and i ~= 5 and i ~= 6) then
			local prop = GetPedPropIndex(GetPlayerPed(-1), i)
			props[i] = prop

			local proptexture = GetPedPropTextureIndex(GetPlayerPed(-1), i)
			proptextures[i] = proptexture
		end
	end

	for i = 0, 4 do
		local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(GetPlayerPed(-1), i)
		overlays[i] = overlayValue
		overlaycolors[i] = firstColour
	end

	local clothing = {
		drawables = drawables,
		textures = textures,
		palletetextures = palletetextures,
		props = props,
		proptextures = proptextures,
		overlays = overlays,
		overlaycolors = overlaycolors,
	}

	clothing = json.encode(clothing)
	TriggerServerEvent("clothes:saveOutfit", model, clothing, outfitName)

	clothinggood()
	
	SetEntityInvincible(GetPlayerPed(-1),false)
end

function LocalPed()
	return GetPlayerPed(-1)
end

function drawTxt2(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

local clothingspots = {
	[1] = {x = 1683.45667, y = 4823.17725, z = 42.1631294},
	[2] = {x = -712.215881, y = -155.352982, z = 37.4151268},
	[3] = {x = -1192.94495, y = -772.688965, z = 17.3255997},
	[4] = {x =  425.236, y = -806.008, z = 28.491},
	[5] = {x = -162.658, y = -303.397, z = 38.733},
	[6] = {x = 75.950, y = -1392.891, z = 28.376},
	[7] = {x = -822.194, y = -1074.134, z = 10.328},
	[8] = {x = -1450.711, y = -236.83, z = 48.809},
	[9] = {x = 4.254, y = 6512.813, z = 30.877},
	[10] = {x = 615.180, y = 2762.933, z = 41.088},
	[11] = {x = 1196.785, y = 2709.558, z = 37.222},
	[12] = {x = -3171.453, y = 1043.857, z = 19.863},
	[13] = {x = -1100.959, y = 2710.211, z = 18.107},
	[14] = {x = -1207.6564941406, y = -1456.8890380859, z = 4.3784737586975},
	[15] = {x = 121.76, y = -224.6, z = 53.56},
}

function IsNearClothes()
	local dstchecked = 1000
	for i = 1, #clothingspots do
		clothcoords = clothingspots[i]
		local comparedst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),  clothcoords.x, clothcoords.y, clothcoords.z, true)
		if comparedst < dstchecked then
			dstchecked = comparedst
		end
	end
	return dstchecked
end

PedModels = {
  "s_m_y_cop_01",
  "s_f_y_cop_01",
  "s_m_y_sheriff_01",
  "s_f_y_sheriff_01",
  "s_m_y_swat_01"
}

RegisterNetEvent('clothes:client:SaveOutfit')
AddEventHandler('clothes:client:SaveOutfit', function(skin, name)
	SaveOutfit(skin, name)
end)

RegisterNetEvent('clothes:client:ChangeToSkin')
AddEventHandler('clothes:client:ChangeToSkin', function()
	ChangeToSkin()
end)

RegisterNetEvent('femaleclothesstart')
AddEventHandler('femaleclothesstart', function(hasToPay)
	selected_skins = fr_skins
	startClothes(hasToPay)
end)

RegisterNetEvent('maleclothesstart')
AddEventHandler('maleclothesstart', function(hasToPay)
	selected_skins = frm_skins
	startClothes(hasToPay)
end)

Citizen.CreateThread(function()
	for k, item in pairs(clothingspots) do
		local blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(blip, 73)
		SetBlipColour(blip, 47)
		SetBlipScale  (blip, 0.7)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Loja De Roupa")
		EndTextCommandSetBlipName(blip)
	  end
	while true do
		Citizen.Wait(1)
		local nearcloth = IsNearClothes()

		if nearcloth < 5.0 and cmenu.show == 0 and QBCore ~= nil then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			QBCore.Functions.DrawText3D(pos.x, pos.y, pos.z, "~g~E~w~ - To change your clothes / ~g~H~w~ - To save your clothes")
			if IsControlJustPressed(1, Keys["E"]) then
				clothingbad()
				QBCore.Functions.GetPlayerData(function(PlayerData)
					if PlayerData.charinfo.gender == 0 then
						TriggerEvent("maleclothesstart", true)
					else
						TriggerEvent("femaleclothesstart", true)
					end
					DoScreenFadeIn(50)
				end)
			elseif IsControlJustPressed(0, Keys["H"]) then
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP9N", "", "", "", "", "", 20)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(7)
                end
				local outfitName = GetOnscreenKeyboardResult()
				SaveOutfit(lastmodel, outfitName)
			end
		else
			if nearcloth > 5 then 
				Citizen.Wait(math.ceil(nearcloth * 10))
			end
		end
	end
end)

function camOff()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(cam, false)
end

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if cmenu.show == 1 then
			ClothShop()
			if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
				if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 5 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
				if cmenu.row < 5 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				cmenu = {show = 0, row = 0, field = 1}
				ChangeToSkin(lastmodel)
			elseif IsControlJustPressed(1,201) or IsControlJustPressed(1,38) or IsControlJustPressed(0,18) then -- Enter
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if cmenu.row == 1 then
					cmenu.show = 2
					cmenu.row = 1
				elseif cmenu.row == 2 then
					cmenu.show = 3
					cmenu.row = 1
				elseif cmenu.row == 3 then
					cmenu.show = 4
					cmenu.row = 1
				elseif cmenu.row == 4 then
					cmenu.show = 5
					cmenu.row = 1
				elseif cmenu.row == 5 then
					cmenu.show = 0
					cmenu.row = 0
					cmenu.field = 0
					ChangeToSkin(lastmodel)
				end
			end
		elseif cmenu.show == 2 then
			ClothShop()
			if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
				if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 4 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
				if cmenu.row < 4 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				cmenu.show = 1
				cmenu.row = 1
				cmenu.field = 1
			end
		elseif cmenu.show == 3 then
			ClothShop()
			if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
				if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 3 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
				if cmenu.row < 3 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				cmenu.show = 1
				cmenu.row = 2
				cmenu.field = 1
			end
		elseif cmenu.show == 4 then
			if text_in == 1 then
				HideHudAndRadarThisFrame()
				if UpdateOnscreenKeyboard() == 3 then text_in = 0
				elseif UpdateOnscreenKeyboard() == 1 then 
					text_in = 0
				elseif UpdateOnscreenKeyboard() == 2 then text_in = 0 end
			else
				ClothShop()
				if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
					if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 3 end
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
					if cmenu.row < 3 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					cmenu.show = 1
					cmenu.row = 3
					cmenu.field = 1
				end
			end
		elseif cmenu.show == 5 then
			ClothShop()
			if IsControlJustPressed(1, 188) or IsDisabledControlJustPressed(1, 188) then -- up
				if cmenu.row > 1 then cmenu.row = cmenu.row-1 else cmenu.row = 3 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 187) or IsDisabledControlJustPressed(1, 187) then -- down
				if cmenu.row < 3 then cmenu.row = cmenu.row+1 else cmenu.row = 1 end
				PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
			elseif IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- backspase
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				cmenu.show = 1
				cmenu.row = 4
				cmenu.field = 1
			end
		else
			Citizen.Wait(1000)
		end
	end
end)
local removeWear = false
RegisterNetEvent("clothes:client:updatefacewear")
AddEventHandler("clothes:client:updatefacewear",function()
	for i = 0, 3 do
		if GetPedPropIndex(GetPlayerPed(-1), i) ~= -1 then
			faceProps[i+1]["Prop"] = GetPedPropIndex(GetPlayerPed(-1), i)
		end
		if GetPedPropTextureIndex(GetPlayerPed(-1), i) ~= -1 then
			faceProps[i+1]["Texture"] = GetPedPropTextureIndex(GetPlayerPed(-1), i)
		end
	end

	if GetPedDrawableVariation(GetPlayerPed(-1), 1) ~= -1 then
		faceProps[4]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 1)
		faceProps[4]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 1)
		faceProps[4]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 1)
	end

	if GetPedDrawableVariation(GetPlayerPed(-1), 11) ~= -1 then
		faceProps[5]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 11)
		faceProps[5]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 11)
		faceProps[5]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 11)
	end
end)

RegisterNetEvent("clothes:client::adjustfacewear")
AddEventHandler("clothes:client::adjustfacewear",function(type)
	if QBCore.Functions.GetPlayerData().metadata["ishandcuffed"] then return end
	removeWear = not removeWear
	local AnimSet = "none"
	local AnimationOn = "none"
	local AnimationOff = "none"
	local PropIndex = 0

	local AnimSet = "mp_masks@on_foot"
	local AnimationOn = "put_on_mask"
	local AnimationOff = "put_on_mask"

	faceProps[6]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 0)
	faceProps[6]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 0)
	faceProps[6]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 0)

	for i = 0, 3 do
		if GetPedPropIndex(GetPlayerPed(-1), i) ~= -1 then
			faceProps[i+1]["Prop"] = GetPedPropIndex(GetPlayerPed(-1), i)
		end
		if GetPedPropTextureIndex(GetPlayerPed(-1), i) ~= -1 then
			faceProps[i+1]["Texture"] = GetPedPropTextureIndex(GetPlayerPed(-1), i)
		end
	end

	if GetPedDrawableVariation(GetPlayerPed(-1), 1) ~= -1 then
		faceProps[4]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 1)
		faceProps[4]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 1)
		faceProps[4]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 1)
	end

	if GetPedDrawableVariation(GetPlayerPed(-1), 11) ~= -1 then
		faceProps[5]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 11)
		faceProps[5]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 11)
		faceProps[5]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 11)
	end

	if type == 1 then
		PropIndex = 0
	elseif type == 2 then
		PropIndex = 1

		AnimSet = "clothingspecs"
		AnimationOn = "take_off"
		AnimationOff = "take_off"

	elseif type == 3 then
		PropIndex = 2
	elseif type == 4 then
		PropIndex = 1
		if removeWear then
			AnimSet = "missfbi4"
			AnimationOn = "takeoff_mask"
			AnimationOff = "takeoff_mask"
		end
	elseif type == 5 then
		PropIndex = 11
		AnimSet = "oddjobs@basejump@ig_15"
		AnimationOn = "puton_parachute"
		AnimationOff = "puton_parachute"	
		--mp_safehouseshower@male@ male_shower_idle_d_towel
		--mp_character_creation@customise@male_a drop_clothes_a
		--oddjobs@basejump@ig_15 puton_parachute_bag
	end

	loadAnimDict( AnimSet )
	if type == 5 then
		if removeWear then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 2, faceProps[6]["Texture"], faceProps[6]["Palette"])
		end
	end
	if removeWear then
		BagkPlayAnim( GetPlayerPed(-1), AnimSet, AnimationOff, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
		Citizen.Wait(500)
		if type ~= 5 then
			if type == 4 then
				SetPedComponentVariation(GetPlayerPed(-1), PropIndex, -1, -1, -1)
			else
				if type ~= 2 then
					ClearPedProp(GetPlayerPed(-1), tonumber(PropIndex))
				end
			end
		end
	else
		BagkPlayAnim( GetPlayerPed(-1), AnimSet, AnimationOn, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
		Citizen.Wait(500)
		if type ~= 5 and type ~= 2 then
			if type == 4 then
				SetPedComponentVariation(GetPlayerPed(-1), PropIndex, faceProps[type]["Prop"], faceProps[type]["Texture"], faceProps[type]["Palette"])
			else
				SetPedPropIndex( GetPlayerPed(-1), tonumber(PropIndex), tonumber(faceProps[PropIndex+1]["Prop"]), tonumber(faceProps[PropIndex+1]["Texture"]), false)
			end
		end
	end
	if type == 5 then
		if not removeWear then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 1, faceProps[6]["Texture"], faceProps[6]["Palette"])
			SetPedComponentVariation(GetPlayerPed(-1), PropIndex, faceProps[type]["Prop"], faceProps[type]["Texture"], faceProps[type]["Palette"])
		else
			SetPedComponentVariation(GetPlayerPed(-1), PropIndex, -1, -1, -1)
		end
		Citizen.Wait(1800)
	end
	if type == 2 then
		Citizen.Wait(600)
		if removeWear then
			ClearPedProp(GetPlayerPed(-1), tonumber(PropIndex))
		end

		if not removeWear then
			Citizen.Wait(140)
			SetPedPropIndex( GetPlayerPed(-1), tonumber(PropIndex), tonumber(faceProps[PropIndex+1]["Prop"]), tonumber(faceProps[PropIndex+1]["Texture"]), false)
		end
	end
	if type == 4 and removeWear then
		Citizen.Wait(1200)
	end
	ClearPedBagks(GetPlayerPed(-1))
end)