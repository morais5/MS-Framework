local IsNew = false

RegisterNetEvent('qb-interior:client:SetNewState')
AddEventHandler('qb-interior:client:SetNewState', function(bool)
	IsNew = bool
end)

-- Thanks Stroudy <3
function CreateHotelFurnished(spawn)
	local object = {}

	local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":2.5,"y":-15.901171875,"x":4.251012802124,"h":2.2633972168}')
	
	local building = CreateObject(`playerhouse_hotel`, spawn.x - 0.7,spawn.y-0.4,spawn.z-1.42,false,false,false)

	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
	
	local motelstuff = CreateObject(GetHashKey("v_49_motelmp_stuff"),spawn.x,spawn.y,spawn.z,false,false,false)
	local motelbed = CreateObject(GetHashKey("v_49_motelmp_bed"),spawn.x+1.4,spawn.y-0.55,spawn.z,false,false,false)
	local motelclothes = CreateObject(GetHashKey("v_49_motelmp_clothes"),spawn.x-2.0,spawn.y+2.0,spawn.z+0.15,false,false,false)
	local winframe = CreateObject(GetHashKey("v_49_motelmp_winframe"),spawn.x+0.74,spawn.y-4.26,spawn.z+1.11,false,false,false)
	local glass = CreateObject(GetHashKey("v_49_motelmp_glass"),spawn.x+0.74,spawn.y-4.26,spawn.z+1.13,false,false,false)
	local curtains = CreateObject(GetHashKey("v_49_motelmp_curtains"),spawn.x+0.74,spawn.y-4.15,spawn.z+0.9,false,false,false)

	local screen = CreateObject(GetHashKey("v_49_motelmp_screen"),spawn.x-2.21,spawn.y-0.6,spawn.z+0.79,false,false,false)
	--props
	local trainer = CreateObject(GetHashKey("v_res_fa_trainer02r"),spawn.x-1.9,spawn.y+3.0,spawn.z+0.38,false,false,false)
	local trainer2 = CreateObject(GetHashKey("v_res_fa_trainer02l"),spawn.x-2.1,spawn.y+2.95,spawn.z+0.38,false,false,false)

	local sink = CreateObject(GetHashKey("prop_sink_06"),spawn.x+1.1,spawn.y+4.0,spawn.z,false,false,false)
	local chair1 = CreateObject(GetHashKey("prop_chair_04a"),spawn.x+2.1,spawn.y-2.4,spawn.z,false,false,false)
	local chair2 = CreateObject(GetHashKey("prop_chair_04a"),spawn.x+0.7,spawn.y-3.5,spawn.z,false,false,false)
	local kettle = CreateObject(GetHashKey("prop_kettle"),spawn.x-2.3,spawn.y+0.6,spawn.z+0.9,false,false,false)
	local tvCabinet = CreateObject(GetHashKey("Prop_TV_Cabinet_03"),spawn.x-2.3,spawn.y-0.6,spawn.z,false,false,false)
	local tv = CreateObject(GetHashKey("prop_tv_06"),spawn.x-2.3,spawn.y-0.6,spawn.z+0.7,false,false,false)
	local toilet = CreateObject(GetHashKey("Prop_LD_Toilet_01"),spawn.x+2.1,spawn.y+2.9,spawn.z,false,false,false)
	local clock = CreateObject(GetHashKey("Prop_Game_Clock_02"),spawn.x-2.55,spawn.y-0.6,spawn.z+2.0,false,false,false)
	local phone = CreateObject(GetHashKey("v_res_j_phone"),spawn.x+2.4,spawn.y-1.9,spawn.z+0.64,false,false,false)
	local ironBoard = CreateObject(GetHashKey("v_ret_fh_ironbrd"),spawn.x-1.7,spawn.y+3.5,spawn.z+0.15,false,false,false)
	local iron = CreateObject(GetHashKey("prop_iron_01"),spawn.x-1.9,spawn.y+2.85,spawn.z+0.63,false,false,false)
	local mug1 = CreateObject(GetHashKey("V_Ret_TA_Mug"),spawn.x-2.3,spawn.y+0.95,spawn.z+0.9,false,false,false)
	local mug2 = CreateObject(GetHashKey("V_Ret_TA_Mug"),spawn.x-2.2,generator.y+0.9,generator.z+0.9,false,false,false)
	local binder = CreateObject(GetHashKey("v_res_binder"),spawn.x-2.2,spawn.y+1.3,spawn.z+0.87,false,false,false)
	
	FreezeEntityPosition(sink,true)
	FreezeEntityPosition(chair1,true)	
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(tvCabinet,true)	
	FreezeEntityPosition(tv,true)	

	SetEntityHeading(chair1,GetEntityHeading(chair1)+270)
	SetEntityHeading(chair2,GetEntityHeading(chair2)+180)
	SetEntityHeading(kettle,GetEntityHeading(kettle)+90)
	SetEntityHeading(tvCabinet,GetEntityHeading(tvCabinet)+90)
	SetEntityHeading(tv,GetEntityHeading(tv)+90)
	SetEntityHeading(toilet,GetEntityHeading(toilet)+270)
	SetEntityHeading(clock,GetEntityHeading(clock)+90)
	SetEntityHeading(phone,GetEntityHeading(phone)+220)
	SetEntityHeading(ironBoard,GetEntityHeading(ironBoard)+90)
	SetEntityHeading(iron,GetEntityHeading(iron)+230)
	SetEntityHeading(mug1,GetEntityHeading(mug1)+20)
	SetEntityHeading(mug2,GetEntityHeading(mug2)+230)

	table.insert(objects, motelstuff)
	table.insert(objects, motelbed)
	table.insert(objects, motelclothes)
	table.insert(objects, winframe)
	table.insert(objects, glass)
	table.insert(objects, curtains)
	table.insert(objects, screen)
	table.insert(objects, trainer)
	table.insert(objects, trainer2)
	table.insert(objects, sink)
	table.insert(objects, chair1)
	table.insert(objects, chair2)
	table.insert(objects, kettle)
	table.insert(objects, tvCabinet)
	table.insert(objects, tv)
	table.insert(objects, toilet)
	table.insert(objects, clock)
	table.insert(objects, phone)
	table.insert(objects, ironBoard)
	table.insert(objects, iron)
	table.insert(objects, mug1)
	table.insert(objects, mug2)
	table.insert(objects, binder)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + 1.5, POIOffsets.exit.h)

	return { objects, POIOffsets }
end

function CreateApartmentFurnished(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":1.2,"y":4.29636328125,"x":1.172736328125,"h":2.2633972168}')
	POIOffsets.clothes = json.decode('{"z":1.2,"y":-2.6444736328,"x":1.824350097,"h":2.2633972168}')
	POIOffsets.stash = json.decode('{"z":1.2,"y":-1.3440585937501,"x":2.58997509763,"h":2.2633972168}')
	POIOffsets.logout = json.decode('{"z":1.0,"y":0.0555111328,"x":-2.0689604492,"h":2.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`playerhouse_appartment_motel`)
	while not HasModelLoaded(`playerhouse_appartment_motel`) do
	    Citizen.Wait(3)
	end
	local house = CreateObject(`playerhouse_appartment_motel`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x - 1.52089355468, spawn.y - 4.00144140625, spawn.z + 1.5, POIOffsets.exit.h)
	if IsNew then
		SetTimeout(750, function()
			TriggerEvent('qb-clothes:client:CreateFirstCharacter')
			IsNew = false
		end)
	end
    return { objects, POIOffsets }
end

function CreateMichaelShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":1.4,"y":2.65636328125,"x":-10.572736328125,"h":265.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`micheal_shell`)
	while not HasModelLoaded(`micheal_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`micheal_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x - 9.52089355468, spawn.y + 2.80144140625, spawn.z + 1.5, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateTrevorsShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":7.9,"y":-3.9,"x":0.1,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`trevors_shell`)
	while not HasModelLoaded(`trevors_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`trevors_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + 0.0, spawn.y - 3.20144140625, spawn.z + 6.5, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateLesterShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":7.9,"y":-3.9,"x":0.1,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`playerhouse_tier2`)
	while not HasModelLoaded(`playerhouse_tier2`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`playerhouse_tier2`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + 0.0, spawn.y - 3.20144140625, spawn.z + 6.5, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateGunshopShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":5.9,"y":-5.5,"x":-1.0,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`gunshop_shell`)
	while not HasModelLoaded(`gunshop_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`gunshop_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + -1.0, spawn.y + -5.2, spawn.z + 6.5, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

function CreateTrapHouseShell(spawn)
	local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":6.5,"y":-6.20144140625,"x":-0.5,"h":358.633972168}')
	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`traphouse_shell`)
	while not HasModelLoaded(`traphouse_shell`) do
	    Citizen.Wait(1000)
	end
	local house = CreateObject(`traphouse_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
	table.insert(objects, house)

	TeleportToInterior(spawn.x + POIOffsets.exit.x, spawn.y + POIOffsets.exit.y, spawn.z + POIOffsets.exit.z, POIOffsets.exit.h)

    return { objects, POIOffsets }
end

-- Thanks Stroudy <3
function CreateTier1HouseFurnished(spawn, isBackdoor)
    local objects = {}

    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":2.5,"y":-15.901171875,"x":4.251012802124,"h":2.2633972168}')
	POIOffsets.clothes = json.decode('{"z":2.5,"y":-3.9233189,"x":-7.84363671,"h":2.2633972168}')
	POIOffsets.stash = json.decode('{"z":2.5,"y":1.33868212,"x":-9.084908691,"h":2.2633972168}')
	POIOffsets.logout = json.decode('{"z":2.0,"y":-1.1463337,"x":-6.69117089,"h":2.2633972168}')
	POIOffsets.backdoor = json.decode('{"z":2.5,"y":4.3798828125,"x":0.88999176025391,"h":182.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	RequestModel(`playerhouse_tier1_full`)
	while not HasModelLoaded(`playerhouse_tier1_full`) do
	    Citizen.Wait(1000)
	end
    local shell = CreateObject(`playerhouse_tier1_full`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`,spawn.x-1.21854400,spawn.y-1.04389600,spawn.z+1.39068600,false,false,false)
	local mpmid01 = CreateObject(`V_16_mpmidapart01`,spawn.x+0.52447510,spawn.y-5.04953700,spawn.z+1.32,false,false,false)
	local mpmid09 = CreateObject(`V_16_mpmidapart09`,spawn.x+0.82202150,spawn.y+2.29612000,spawn.z+1.88,false,false,false)
	local mpmid07 = CreateObject(`V_16_mpmidapart07`,spawn.x-1.91445900,spawn.y-6.61911300,spawn.z+1.45,false,false,false)
	local mpmid03 = CreateObject(`V_16_mpmidapart03`,spawn.x-4.82565300,spawn.y-6.86803900,spawn.z+1.14,false,false,false)
	local midData = CreateObject(`V_16_midapartdeta`,spawn.x+2.28558400,spawn.y-1.94082100,spawn.z+1.288628,false,false,false)
	local glow = CreateObject(`V_16_treeglow`,spawn.x-1.37408500,spawn.y-0.95420070,spawn.z+1.135,false,false,false)
	local curtins = CreateObject(`V_16_midapt_curts`,spawn.x-1.96423300,spawn.y-0.95958710,spawn.z+1.280,false,false,false)
	local mpmid13 = CreateObject(`V_16_mpmidapart13`,spawn.x-4.65580700,spawn.y-6.61684000,spawn.z+1.259,false,false,false)
	local mpcab = CreateObject(`V_16_midapt_cabinet`,spawn.x-1.16177400,spawn.y-0.97333810,spawn.z+1.27,false,false,false)
	local mpdecal = CreateObject(`V_16_midapt_deca`,spawn.x+2.311386000,spawn.y-2.05385900,spawn.z+1.297,false,false,false)
	local mpdelta = CreateObject(`V_16_mid_hall_mesh_delta`,spawn.x+3.69693000,spawn.y-5.80020100,spawn.z+1.293,false,false,false)
	local beddelta = CreateObject(`V_16_mid_bed_delta`,spawn.x+7.95187400,spawn.y+1.04246500,spawn.z+1.28402300,false,false,false)
	local bed = CreateObject(`V_16_mid_bed_bed`,spawn.x+6.86376900,spawn.y+1.20651200,spawn.z+1.36589100,false,false,false)
	local beddecal = CreateObject(`V_16_MID_bed_over_decal`,spawn.x+7.82861300,spawn.y+1.04696700,spawn.z+1.34753700,false,false,false)
	local bathDelta = CreateObject(`V_16_mid_bath_mesh_delta`,spawn.x+4.45460500,spawn.y+3.21322800,spawn.z+1.21116100,false,false,false)
	local bathmirror = CreateObject(`V_16_mid_bath_mesh_mirror`,spawn.x+3.57740800,spawn.y+3.25032000,spawn.z+1.48871300,false,false,false)

	--props
	local beerbot = CreateObject(`Prop_CS_Beer_Bot_01`,spawn.x+1.73134600,spawn.y-4.88520200,spawn.z+1.91083000,false,false,false)
	local couch = CreateObject(`v_res_mp_sofa`,spawn.x-1.48765600,spawn.y+1.68100600,spawn.z+1.21640500,false,false,false)
	local chair = CreateObject(`v_res_mp_stripchair`,spawn.x-4.44770800,spawn.y-1.78048800,spawn.z+1.21640500,false,false,false)
	local chair2 = CreateObject(`v_res_tre_chair`,spawn.x+2.91325400,spawn.y-5.27835100,spawn.z+1.22746400,false,false,false)
	local plant = CreateObject(`Prop_Plant_Int_04a`,spawn.x+2.78941300,spawn.y-4.39133900,spawn.z+2.12746400,false,false,false)
	local lamp = CreateObject(`v_res_d_lampa`,spawn.x-3.61473100,spawn.y-6.61465100,spawn.z+2.08382800,false,false,false)
	local fridge = CreateObject(`v_res_fridgemodsml`,spawn.x+1.90339700,spawn.y-3.80026800,spawn.z+1.29917900,false,false,false)
	local micro = CreateObject(`prop_micro_01`,spawn.x+2.03442400,spawn.y-4.61585100,spawn.z+2.30395600,false,false,false)
	local sideBoard = CreateObject(`V_Res_Tre_SideBoard`,spawn.x+2.84053000,spawn.y-4.30947100,spawn.z+1.24577300,false,false,false)
	local bedSide = CreateObject(`V_Res_Tre_BedSideTable`,spawn.x-3.50363200,spawn.y-6.55289400,spawn.z+1.30625800,false,false,false)
	local lamp2 = CreateObject(`v_res_d_lampa`,spawn.x+2.69674700,spawn.y-3.83123500,spawn.z+2.09373700,false,false,false)
	local plant2 = CreateObject(`v_res_tre_tree`,spawn.x-4.96064800,spawn.y-6.09898500,spawn.z+1.31631400,false,false,false)
	local tableObj = CreateObject(`V_Res_M_DineTble_replace`,spawn.x-3.50712600,spawn.y-4.13621600,spawn.z+1.29625800,false,false,false)
	local tv = CreateObject(`Prop_TV_Flat_01`,spawn.x-5.53120400,spawn.y+0.76299670,spawn.z+2.17236000,false,false,false)
	local plant3 = CreateObject(`v_res_tre_plant`,spawn.x-5.14112800,spawn.y-2.78951000,spawn.z+1.25950800,false,false,false)
	local chair3 = CreateObject(`v_res_m_dinechair`,spawn.x-3.04652400,spawn.y-4.95971200,spawn.z+1.19625800,false,false,false)
	local lampStand = CreateObject(`v_res_m_lampstand`,spawn.x+1.26588400,spawn.y+3.68883900,spawn.z+1.30556700,false,false,false)
	local stool = CreateObject(`V_Res_M_Stool_REPLACED`,spawn.x-3.23216300,spawn.y+2.06159000,spawn.z+1.20556700,false,false,false)
	local chair4 = CreateObject(`v_res_m_dinechair`,spawn.x-2.82237200,spawn.y-3.59831300,spawn.z+1.25950800,false,false,false)
	local chair5 = CreateObject(`v_res_m_dinechair`,spawn.x-4.14955100,spawn.y-4.71316600,spawn.z+1.19625800,false,false,false)
	local chair6 = CreateObject(`v_res_m_dinechair`,spawn.x-3.80622900,spawn.y-3.37648300,spawn.z+1.19625800,false,false,false)

	local plant4 = CreateObject(`v_res_fa_plant01`,spawn.x+2.97859200,spawn.y+2.55307400,spawn.z+1.85796300,false,false,false)
	local storage = CreateObject(`v_res_tre_storageunit`,spawn.x+8.47819500,spawn.y-2.50979300,spawn.z+1.19712300,false,false,false)
	local storage2 = CreateObject(`v_res_tre_storagebox`,spawn.x+9.75982700,spawn.y-1.35874100,spawn.z+1.29625800,false,false,false)
	local basketmess = CreateObject(`v_res_tre_basketmess`,spawn.x+8.70730600,spawn.y-2.55503600,spawn.z+1.94059590,false,false,false)
	local lampStand2 = CreateObject(`v_res_m_lampstand`,spawn.x+9.54306000,spawn.y-2.50427700,spawn.z+1.30556700,false,false,false)
	local plant4 = CreateObject(`Prop_Plant_Int_03a`,spawn.x+9.87521400,spawn.y+3.90917400,spawn.z+1.20829700,false,false,false)

	local basket = CreateObject(`v_res_tre_washbasket`,spawn.x+9.39091500,spawn.y+4.49676300,spawn.z+1.19625800,false,false,false)
	local wardrobe = CreateObject(`V_Res_Tre_Wardrobe`,spawn.x+8.46626300,spawn.y+4.53223600,spawn.z+1.19425800,false,false,false)
	local basket2 = CreateObject(`v_res_tre_flatbasket`,spawn.x+8.51593000,spawn.y+4.55647300,spawn.z+3.46737300,false,false,false)
	local basket3 = CreateObject(`v_res_tre_basketmess`,spawn.x+7.57797200,spawn.y+4.55198800,spawn.z+3.46737300,false,false,false)
	local basket4 = CreateObject(`v_res_tre_flatbasket`,spawn.x+7.12286400,spawn.y+4.54689200,spawn.z+3.46737300,false,false,false)
	local wardrobe2 = CreateObject(`V_Res_Tre_Wardrobe`,spawn.x+7.24382000,spawn.y+4.53423500,spawn.z+1.19625800,false,false,false)
	local basket5 = CreateObject(`v_res_tre_flatbasket`,spawn.x+8.03364600,spawn.y+4.54835500,spawn.z+3.46737300,false,false,false)

	local switch = CreateObject(`v_serv_switch_2`,spawn.x+6.28086900,spawn.y-0.68169880,spawn.z+2.30326000,false,false,false)

	local table2 = CreateObject(`V_Res_Tre_BedSideTable`,spawn.x+5.84416200,spawn.y+2.57377400,spawn.z+1.22089100,false,false,false)
	local lamp3 = CreateObject(`v_res_d_lampa`,spawn.x+5.84912100,spawn.y+2.58001100,spawn.z+1.95311890,false,false,false)
	local laundry = CreateObject(`v_res_mlaundry`,spawn.x+5.77729800,spawn.y+4.60211400,spawn.z+1.19674400,false,false,false)

	local ashtray = CreateObject(`Prop_ashtray_01`,spawn.x-1.24716200,spawn.y+1.07820500,spawn.z+1.89089300,false,false,false)

	local candle1 = CreateObject(`v_res_fa_candle03`,spawn.x-2.89289900,spawn.y-4.35329700,spawn.z+2.02881310,false,false,false)
	local candle2 = CreateObject(`v_res_fa_candle02`,spawn.x-3.99865700,spawn.y-4.06048500,spawn.z+2.02530190,false,false,false)
	local candle3 = CreateObject(`v_res_fa_candle01`,spawn.x-3.37733400,spawn.y-3.66639800,spawn.z+2.02526200,false,false,false)
	local woodbowl = CreateObject(`v_res_m_woodbowl`,spawn.x-3.50787400,spawn.y-4.11983000,spawn.z+2.02589900,false,false,false)
	local tablod = CreateObject(`V_Res_TabloidsA`,spawn.x-0.80513000,spawn.y+0.51389600,spawn.z+1.18418800,false,false,false)


	local tapeplayer = CreateObject(`Prop_Tapeplayer_01`,spawn.x-1.26010100,spawn.y-3.62966400,spawn.z+2.37883200,false,false,false)
	local woodbowl2 = CreateObject(`v_res_tre_fruitbowl`,spawn.x+2.77764900,spawn.y-4.138297000,spawn.z+2.10340100,false,false,false)
	local sculpt = CreateObject(`v_res_sculpt_dec`,spawn.x+3.03932200,spawn.y+1.62726400,spawn.z+3.58363900,false,false,false)
	local jewlry = CreateObject(`v_res_jewelbox`,spawn.x+3.04164100,spawn.y+0.31671810,spawn.z+3.58363900,false,false,false)

	local basket6 = CreateObject(`v_res_tre_basketmess`,spawn.x-1.64906300,spawn.y+1.62675900,spawn.z+1.39038500,false,false,false)
	local basket7 = CreateObject(`v_res_tre_flatbasket`,spawn.x-1.63938900,spawn.y+0.91133310,spawn.z+1.39038500,false,false,false)

	local basket8 = CreateObject(`v_res_tre_flatbasket`,spawn.x-1.19923400,spawn.y+1.69598600,spawn.z+1.39038500,false,false,false)
	local basket9 = CreateObject(`v_res_tre_basketmess`,spawn.x-1.18293800,spawn.y+0.91436380,spawn.z+1.39038500,false,false,false)
	local bowl = CreateObject(`v_res_r_sugarbowl`,spawn.x-0.26029210,spawn.y-6.66716800,spawn.z+3.77324900,false,false,false)
	local breadbin = CreateObject(`Prop_Breadbin_01`,spawn.x+2.09788500,spawn.y-6.57634000,spawn.z+2.24041900,false,false,false)
	local knifeblock = CreateObject(`v_res_mknifeblock`,spawn.x+1.82084700,spawn.y-6.58438500,spawn.z+2.27399500,false,false,false)

	local toaster = CreateObject(`prop_toaster_01`,spawn.x-1.05790700,spawn.y-6.59017400,spawn.z+2.26793200,false,false,false)
	local wok = CreateObject(`prop_wok`,spawn.x+2.01728800,spawn.y-5.57091500,spawn.z+2.26793200,false,false,false)
	local plant5 = CreateObject(`Prop_Plant_Int_03a`,spawn.x+2.55015600,spawn.y+4.60183900,spawn.z+1.20829700,false,false,false)

	local tumbler = CreateObject(`p_tumbler_cs2_s`,spawn.x-0.90916440,spawn.y-4.24099100,spawn.z+2.26793200,false,false,false)
	local wisky = CreateObject(`p_whiskey_bottle_s`,spawn.x-0.92809300,spawn.y-3.99099100,spawn.z+2.26793200,false,false,false)
	local tissue = CreateObject(`v_res_tissues`,spawn.x+7.95889300,spawn.y-2.54847100,spawn.z+1.94013400,false,false,false)

	local pants = CreateObject(`V_16_Ap_Mid_Pants4`,spawn.x+7.55366500,spawn.y-0.25457100,spawn.z+1.33009200,false,false,false)
	local pants2 = CreateObject(`V_16_Ap_Mid_Pants5`,spawn.x+7.76753200,spawn.y+3.00476500,spawn.z+1.33052800,false,false,false)
	local hairdryer = CreateObject(`v_club_vuhairdryer`,spawn.x+8.12616000,spawn.y-2.50562000,spawn.z+1.96009390,false,false,false)


	FreezeEntityPosition(dt,true)
	FreezeEntityPosition(mpmid01,true)
	FreezeEntityPosition(mpmid09,true)
	FreezeEntityPosition(mpmid07,true)
	FreezeEntityPosition(mpmid03,true)
	FreezeEntityPosition(midData,true)
	FreezeEntityPosition(glow,true)
	FreezeEntityPosition(curtins,true)
	FreezeEntityPosition(mpmid13,true)
	FreezeEntityPosition(mpcab,true)
	FreezeEntityPosition(mpdecal,true)
	FreezeEntityPosition(mpdelta,true)
	FreezeEntityPosition(couch,true)
	FreezeEntityPosition(chair,true)
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(plant,true)
	FreezeEntityPosition(lamp,true)
	FreezeEntityPosition(fridge,true)
	FreezeEntityPosition(micro,true)
	FreezeEntityPosition(sideBoard,true)
	FreezeEntityPosition(bedSide,true)
	FreezeEntityPosition(plant2,true)
	FreezeEntityPosition(tableObj,true)
	FreezeEntityPosition(tv,true)
	FreezeEntityPosition(plant3,true)
	FreezeEntityPosition(chair3,true)
	FreezeEntityPosition(lampStand,true)
	FreezeEntityPosition(chair4,true)
	FreezeEntityPosition(chair5,true)
	FreezeEntityPosition(chair6,true)
    FreezeEntityPosition(plant4,true)
    FreezeEntityPosition(storage,true)
	FreezeEntityPosition(storage2,true)
	FreezeEntityPosition(basket,true)
	FreezeEntityPosition(wardrobe,true)
	FreezeEntityPosition(wardrobe2,true)
	FreezeEntityPosition(table2,true)
	FreezeEntityPosition(lamp3,true)
	FreezeEntityPosition(laundry,true)
	FreezeEntityPosition(beddelta,true)
	FreezeEntityPosition(bed,true)
	FreezeEntityPosition(beddecal,true)
	FreezeEntityPosition(tapeplayer,true)
	FreezeEntityPosition(basket7,true)
	FreezeEntityPosition(basket6,true)
	FreezeEntityPosition(basket8,true)
    FreezeEntityPosition(basket9,true)
    
    
    table.insert(objects, dt)
    table.insert(objects, mpmid01)
    table.insert(objects, mpmid09)
    table.insert(objects, mpmid07)
    table.insert(objects, mpmid03)
    table.insert(objects, midData)
    table.insert(objects, glow)
    table.insert(objects, curtins)
    table.insert(objects, mpmid13)
    table.insert(objects, mpcab)
    table.insert(objects, mpdecal)
    table.insert(objects, mpdelta)
    table.insert(objects, couch)
    table.insert(objects, chair)
    table.insert(objects, chair2)
    table.insert(objects, plant)
    table.insert(objects, lamp)
    table.insert(objects, fridge)
    table.insert(objects, micro)
    table.insert(objects, sideBoard)
    table.insert(objects, bedSide)
    table.insert(objects, plant2)
    table.insert(objects, tableObj)
    table.insert(objects, tv)
    table.insert(objects, plant3)
    table.insert(objects, chair3)
    table.insert(objects, lampStand)
    table.insert(objects, chair4)
    table.insert(objects, chair5)
    table.insert(objects, chair6)
    table.insert(objects, plant4)
    table.insert(objects, storage2)
    table.insert(objects, basket)
    table.insert(objects, wardrobe)
    table.insert(objects, wardrobe2)
    table.insert(objects, table2)
    table.insert(objects, lamp3)
    table.insert(objects, laundry)
    table.insert(objects, beddelta)
    table.insert(objects, bed)
    table.insert(objects, beddecal)
    table.insert(objects, tapeplayer)
    table.insert(objects, basket7)
    table.insert(objects, basket6)
    table.insert(objects, basket8)
    table.insert(objects, basket9)

	SetEntityHeading(beerbot,GetEntityHeading(beerbot)+90)
	SetEntityHeading(couch,GetEntityHeading(couch)-90)
	SetEntityHeading(chair,GetEntityHeading(chair)+getRotation(0.28045480))
	SetEntityHeading(chair2,GetEntityHeading(chair2)+getRotation(0.3276100))
	SetEntityHeading(fridge,GetEntityHeading(chair2)+160)
	SetEntityHeading(micro,GetEntityHeading(micro)-80)
	SetEntityHeading(sideBoard,GetEntityHeading(sideBoard)+90)
	SetEntityHeading(bedSide,GetEntityHeading(bedSide)+180)
	SetEntityHeading(tv,GetEntityHeading(tv)+90)
	SetEntityHeading(plant3,GetEntityHeading(plant3)+90)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+200)
	SetEntityHeading(chair4,GetEntityHeading(chair3)+100)
	SetEntityHeading(chair5,GetEntityHeading(chair5)+135)
	SetEntityHeading(chair6,GetEntityHeading(chair6)+10)
	SetEntityHeading(storage,GetEntityHeading(storage)+180)
	SetEntityHeading(storage2,GetEntityHeading(storage2)-90)
	SetEntityHeading(table2,GetEntityHeading(table2)+90)
	SetEntityHeading(tapeplayer,GetEntityHeading(tapeplayer)+90)
    SetEntityHeading(knifeblock,GetEntityHeading(knifeblock)+180)
    
    if not isBackdoor then
        TeleportToInterior(spawn.x + 3.69693000, spawn.y - 15.080020100, spawn.z + 1.5, spawn.h)
    else
        TeleportToInterior(spawn.x + 0.88999176025391, spawn.y + 4.3798828125, spawn.z + 1.5, spawn.h)
    end

    return { objects, POIOffsets }
end