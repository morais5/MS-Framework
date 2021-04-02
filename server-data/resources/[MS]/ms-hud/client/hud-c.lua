isLoggedIn = false
local oxygenTank = 25.0
local oxyOn = false
local attachedProp = 0
local attachedProp2 = 0
local lownotify = 0
local toghud = true
local mumbleInfo = 2
invehicle = false
local hunger = 100
local thirst = 100

MSCore = nil

Citizen.CreateThread(function()
	while true do
		GLOBAL_PED = PlayerPedId()
		GLOBAL_PLYID = PlayerId()
		GLOBAL_SRVID = GetPlayerServerId(GLOBAL_PLYID)
		Wait(5000)
	end
	if MSCore ~= nil then
		TriggerEvent("hud:client:SetMoney")
		return
	end
end)

Citizen.CreateThread(function()
    while MSCore == nil do
        TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)
        Wait(200)
    end
end)

RegisterNetEvent("hud:client:UpdateNeeds")
AddEventHandler("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent("MSCore:Client:OnPlayerLoaded")
AddEventHandler("MSCore:Client:OnPlayerLoaded", function()
	isLoggedIn = true
end)

RegisterCommand('hud', function()
	if toghud then 
		TriggerEvent('ms-hud:client:toggleui', false)
	else 
		TriggerEvent('ms-hud:client:toggleui', true)
	end 
end)

RegisterNetEvent('ms-hud:client:toggleui')
AddEventHandler('ms-hud:client:toggleui', function(show)
	if show then toghud = true; else toghud = false; end
end)

RegisterNetEvent('mumble:updateMumbleInfo')
AddEventHandler('mumble:updateMumbleInfo', function(mode)
	mumbleInfo = mode
	-- 3 - Shouting
	-- 4 - Whisper
	-- 2 - Normal
end)

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
	
	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', -0.0160, -0.030, 0.140, 0.23)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', -0.012, 0.015, 0.2, 0.292)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.012, 0.015, 0.2, 0.292)
	
	local minimap = RequestScaleformMovie("minimap")
	SetRadarBigmapEnabled(true, false)
	Wait(0)
	SetRadarBigmapEnabled(false, false)
	  
	SetBlipAlpha(GetNorthRadarBlip(), 0)

    while true do
        Wait(100)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
		EndScaleformMovieMethod()
		if IsBigmapActive() or IsBigmapFull() then
            SetBigmapActive(false, false)
        end

        if not invehicle and IsPedInAnyVehicle(GLOBAL_PED, false) then
			invehicle = true
			SetMapZoomDataLevel(0, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 0
			SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
			SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
			SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
			SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4

			Wait(100)
			SetRadarZoom(1100)
        end 
    end
end)

--General UI Updates
local isPause = false
Citizen.CreateThread(function()
	while true do
		local sleep = 10000
		if isLoggedIn then
			sleep = 200

			local health = (GetEntityHealth(GLOBAL_PED) - 100)
			local armor = GetPedArmour(GLOBAL_PED)
			local oxyMultiplier = (100.00 / msHud.MaxOxygen)
			local oxy = (GetPlayerUnderwaterTimeRemaining(GLOBAL_PLYID) * oxyMultiplier)
			local talking = false
			local stamina = false
			local mumbleData = exports["mumble-voip"]:RetrieveMumbleData()

			if mumbleData and mumbleData[GLOBAL_SRVID] and not mumbleData[GLOBAL_SRVID].radioActive and NetworkIsPlayerTalking(GLOBAL_PLYID) then 
                talking = 'normal'
			elseif mumbleData and mumbleData[GLOBAL_SRVID] and mumbleData[GLOBAL_SRVID].radioActive then 
                talking = 'radio'
			else 
                talking = false 
            end
			
			if not isPause and IsPauseMenuActive() then
				isPause = true
				toghud = false
			elseif isPause and not IsPauseMenuActive() then
				isPause = false
				toghud = true
			end

			if not IsPedInAnyVehicle(GLOBAL_PED, false) then
				stamina = math.ceil(100 - GetPlayerSprintStaminaRemaining(GLOBAL_PLYID))
			end

			if (GetPlayerUnderwaterTimeRemaining(GLOBAL_PLYID) * oxyMultiplier) > 100.0 then
				oxy = 100.0
			end

			SendNUIMessage({
				action = 'updateStatusHud',
				show = toghud,
				health = health,
				armor = armor,
				oxygen = oxy,
				stamina = stamina,
				mumble = mumbleInfo,
				talking = talking,
			})
		end
		Wait(sleep)
    end
end)

--Food Thirst
Citizen.CreateThread(function()
	while true do
		if isLoggedIn then
		SendNUIMessage({
			action = "updateStatusHud",
			show = toghud,
			hunger = hunger,
			thirst = thirst,
			stress = stress,
		})
		end
		Wait(5000)
    end
end)


RegisterNetEvent("RemoveOxyTank")
AddEventHandler("RemoveOxyTank",function()
	if oxygenTank > 25.0 then
		oxygenTank = 25.0
		TriggerEvent('scuba:toggle', false)
	end
end)

RegisterNetEvent("UseOxygenTank")
AddEventHandler("UseOxygenTank",function()
	oxygenTank = 100.0
	TriggerEvent('scuba:toggle', true) 
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1
		if isLoggedIn then
			if oxygenTank > 0 and IsPedSwimmingUnderWater(GLOBAL_PED) then
				SetPedDiesInWater(GLOBAL_PED, false)
				if oxygenTank > 25.0 then
					oxygenTank = oxygenTank - 0.0015625
				else
					oxygenTank = oxygenTank - 1
					if oxygenTank <= 3.0 then 
						SetPedDiesInWater(GLOBAL_PED, true)
					end 
					if oxygenTank <= 0 then 
						oxygenTank = 0 
					end 
				end
			end

			if not IsPedSwimmingUnderWater(GLOBAL_PED) and oxygenTank < 25.0 then
				oxygenTank = oxygenTank + 0.01
				if oxygenTank > 25.0 then
					oxygenTank = 25.0
				end
			end

			if not IsPedSwimmingUnderWater(GLOBAL_PED) and oxygenTank < 25.0 then
				oxygenTank = oxygenTank + 3.125 -- 8 seconds to 25 oxygen
				if oxygenTank > 25.0 then
					oxygenTank = 25.0
				end
			end

			if oxygenTank > 25.0 and not oxyOn then
				oxyOn = true
				lownotify = 0
				attachProp("p_s_scuba_tank_s", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
				attachProp2("p_s_scuba_mask_s", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
			elseif oxyOn and oxygenTank <= 25.0 then
				oxyOn = false
				lownotify = 0
				removeAttachedProp()
				removeAttachedProp2()
				TriggerEvent('scuba:toggle', false)
			end
			if not oxyOn then
				sleep = 1000
			end
		end
		Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    while true do
		Wait(3000)
		if isLoggedIn then 
			if oxyOn then 
				if IsPedSwimmingUnderWater(GLOBAL_PED) then
					if oxygenTank <= 25.2 and lownotify == 2 then
						TriggerEvent("DoShortHudText", 'Oxygen Tank Empty: 0.0 units', 2)
						lownotify = 3
						local loop = 6
						while loop > 0 do 
							loop = loop - 1
							PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
							Wait(500)
						end 
					elseif oxygenTank <= 35.0 and lownotify == 1 then
						TriggerEvent("DoShortHudText", 'Oxygen Level Dangerously Low: 35.0 units', 2)
						lownotify = 2
						local loop = 5
						while loop > 0 do 
							loop = loop - 1
							PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
							Wait(700)
						end 
					elseif oxygenTank <= 50.0 and lownotify == 0 then
						TriggerEvent("DoShortHudText", 'Oxygen Level Low: 50.0 units', 2)
						lownotify = 1
						local loop = 3
						while loop > 0 do 
							loop = loop - 1
							PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
							Wait(700)
						end
					end
				end	    
			end 
		end    
	end
end)

function removeAttachedProp2()
	DeleteEntity(attachedProp2)
	attachedProp2 = 0
end

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
	loadAnimDict('anim@narcotics@trash')
	TaskPlayAnim(GLOBAL_PED,'anim@narcotics@trash', 'drop_front',0.9, -8, 3800, 49, 3.0, 0, 0, 0)
end

function attachProp2(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp2()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(GLOBAL_PED, boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(GLOBAL_PED, true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end
	attachedProp2 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp2, GLOBAL_PED, bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(attachModel)
end

function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent 
	local bone = GetPedBoneIndex(GLOBAL_PED, boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(GLOBAL_PED, true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, GLOBAL_PED, bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(attachModel)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Wait( 5 )
    end
end


RegisterNetEvent("amp:useItem:watch")
AddEventHandler("amp:useItem:watch", function()
	TriggerEvent('hud:toggleWatch')
end)

RegisterNetEvent("amp:useItem:scubatank")
AddEventHandler("amp:useItem:scubatank", function()
	TriggerEvent('amp:scubaEquip')
end)

