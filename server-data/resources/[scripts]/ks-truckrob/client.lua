
QBCore = nil

local PlayerData = nil
local CurrentEventNum = nil
local timing, isPlayerWhitelisted = math.ceil(1 * 60000), false

local ArmoredTruckVeh
local itemC4prop
local missionInProgress = false
local missionCompleted = false
local TruckIsExploded = false
local TruckIsDemolished = false
local KillGuardsText = false
local openText = false
local bomText = false

local streetName
local _
local playerGender

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)






RegisterNetEvent('ks-TruckRobbery:outlawNotify')
AddEventHandler('ks-TruckRobbery:outlawNotify', function(alert)
	if isPlayerWhitelisted then
		TriggerEvent('chat:addMessage', { args = { "^5 Despacho: " .. alert }})
	end
end)



-- // Function for 3D text // --
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





RegisterNetEvent('ks-TruckRobbery:TruckRobberyInProgress')
AddEventHandler('ks-TruckRobbery:TruckRobberyInProgress', function(targetCoords)
	if isPlayerWhitelisted and Config.PoliceBlipShow then
		local alpha = Config.PoliceBlipAlpha
		local policeNotifyBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.PoliceBlipRadius)

		SetBlipHighDetail(policeNotifyBlip, true)
		SetBlipColour(policeNotifyBlip, Config.PoliceBlipColor)
		SetBlipAlpha(policeNotifyBlip, alpha)
		SetBlipAsShortRange(policeNotifyBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.PoliceBlipTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(policeNotifyBlip, alpha)

			if alpha == 0 then
				RemoveBlip(policeNotifyBlip)
				return
			end
		end
	end
end)



-- Activate hack
RegisterNetEvent("ks-TruckRobbery:startje")
AddEventHandler("ks-TruckRobbery:startje",function(spot)

TriggerEvent("ks-TruckRobbery:hackertje")

end)


RegisterNetEvent("ks-TruckRobbery:hackertje")
AddEventHandler("ks-TruckRobbery:hackertje",function()
	local player = PlayerPedId()
	FreezeEntityPosition(player, true)
	--Citizen.Wait(4000)
	QBCore.Functions.Progressbar("hack", "Insira o cartão SD no tablet..", 8500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
		--playAnim('anim@cellphone@in_car@ps', 'cop_b_idle', 10500)
		animDict = "amb@code_human_wander_texting@male@base",
        anim = "base",
        flags = 50,

    }, {}, {}, function() 
	end)-- Done
	Citizen.Wait(8500)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",Config.HackingBlocks,Config.HackingTime,HackingMinigame)
end)

-- Function for Hacking Success/Fail:
function HackingMinigame(success)
    local player = PlayerPedId()
    TriggerEvent('mhacking:hide')
    if success then
		Citizen.Wait(350)
		TriggerEvent("ks-TruckRobbery:startMission",source,0)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		print('deu')
		QBCore.Functions.Notify("Você invadiu o sistema", "error")
		FreezeEntityPosition(player,false)
		ClearPedTasks(player)
    else
		--ESX.ShowNotification("You ~r~failed~s~ to hack into the ~b~network~s~")
		TriggerEvent('chatMessage', "SYSTEM", "error", "Você não conseguiu hackear a rede")
		FreezeEntityPosition(player,false)
		ClearPedTasks(player)
	end
end
---

-- Making sure that players don't get the same mission at the same time
RegisterNetEvent("ks-TruckRobbery:startMission")
AddEventHandler("ks-TruckRobbery:startMission",function(spot)
	local num = math.random(1,#Config.ArmoredTruck)
	local numy = 0
	while Config.ArmoredTruck[num].InUse and numy < 100 do
		numy = numy+1
		num = math.random(1,#Config.ArmoredTruck)
	end
	if numy == 100 then
	    QBCore.Functions.Notify("Sem missões disponíveis!")
	else
		CurrentEventNum = num
		TriggerEvent("ks-TruckRobbery:startTheEvent",num)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		print('deu2 a cena do caminhão')
		QBCore.Functions.Notify("O caminhão está marcado no seu GPS!")
	end
end)

-- Core Mission Part
RegisterNetEvent('ks-TruckRobbery:startTheEvent')
AddEventHandler('ks-TruckRobbery:startTheEvent', function(num)
	
	local loc = Config.ArmoredTruck[num]
	Config.ArmoredTruck[num].InUse = true
	local playerped = GetPlayerPed(-1)
	
	TriggerServerEvent("ks-TruckRobbery:syncMissionData",Config.ArmoredTruck)

	RequestModel(GetHashKey('stockade'))
	while not HasModelLoaded(GetHashKey('stockade')) do
		Citizen.Wait(0)
	end

	ClearAreaOfVehicles(loc.Location.x, loc.Location.y, loc.Location.z, 15.0, false, false, false, false, false) 	
	ArmoredTruckVeh = CreateVehicle(GetHashKey('stockade'), loc.Location.x, loc.Location.y, loc.Location.z, -2.436,  996.786, 25.1887, true, true)
	SetEntityAsMissionEntity(ArmoredTruckVeh)
	SetEntityHeading(ArmoredTruckVeh, 52.00)
	
	local taken = false
	local blip = CreateMissionBlip(loc.Location)
	
	RequestModel("s_m_m_security_01")
	while not HasModelLoaded("s_m_m_security_01") do
		Wait(10)
	end
	
	local TruckDriver = CreatePedInsideVehicle(ArmoredTruckVeh, 1, "s_m_m_security_01", -1, true, true)
	local TruckPassenger = CreatePedInsideVehicle(ArmoredTruckVeh, 1, "s_m_m_security_01", 0, true, true)
	
	-- Natives for Truck Driver & Passenger
	SetPedFleeAttributes(TruckDriver, 0, 0)
	SetPedFleeAttributes(TruckPassenger, 0, 0)
	SetPedCombatAttributes(TruckDriver, 46, 1)
	SetPedCombatAttributes(TruckPassenger, 46, 1)
	SetPedCombatAbility(TruckDriver, 100)
	SetPedCombatAbility(TruckPassenger, 100)
	SetPedCombatMovement(TruckDriver, 2)
	SetPedCombatMovement(TruckPassenger, 2)
	SetPedCombatRange(TruckDriver, 2)
	SetPedCombatRange(TruckPassenger, 2)
	SetPedKeepTask(TruckDriver, true)
	SetPedKeepTask(TruckPassenger, true)
	TaskEnterVehicle(TruckPassenger,ArmoredTruckVeh,-1,0,1.0,1)
	GiveWeaponToPed(TruckDriver, GetHashKey(Config.DriverWeapon),250,false,true)
	GiveWeaponToPed(TruckPassenger, GetHashKey(Config.PassengerWeapon),250,false,true)
	SetPedAsCop(TruckDriver, true)
	SetPedAsCop(TruckPassenger, true)
	SetPedDropsWeaponsWhenDead(TruckDriver, false)
	SetPedDropsWeaponsWhenDead(TruckPassenger, false)
	TaskVehicleDriveWander(TruckDriver, ArmoredTruckVeh, 80.0, 443)
	
	missionInProgress = true
	
	while not taken do
		Citizen.Wait(3)
		
		if missionInProgress == true then
			local pos = GetEntityCoords(GetPlayerPed(-1), false)
			local TruckPos = GetEntityCoords(ArmoredTruckVeh) 
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, TruckPos.x, TruckPos.y, TruckPos.z, false)

			if distance <= 30.0  then
				if KillGuardsText == false then
					QBCore.Functions.Notify("Mate os guardas!")
					KillGuardsText = true
				end
			end
			
			if distance <= 5 and TruckIsDemolished == false then
			    local requiredItems = {
				    [1] = {name = QBCore.Shared.Items["tijdbom"]["name"], image = QBCore.Shared.Items["tijdbom"]["image"]},
			    }
		        if not requiredItemsShowed then
		            requiredItemsShowed = true
		            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
			            end
		        else
			        if requiredItemsShowed then
			        requiredItemsShowed = false
			        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
		            end
				end
			
			
			
		end
		
		if TruckIsExploded == true then
		    if openText == false then
				QBCore.Functions.Notify("Pressione E para roubar tudo :)!")
				openText = true
			end
			local pos = GetEntityCoords(GetPlayerPed(-1), false)
			local TruckPos = GetEntityCoords(ArmoredTruckVeh) 
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, TruckPos.x, TruckPos.y, TruckPos.z, false)

			if distance > 45.0 then
			Citizen.Wait(500)
			end
			
			if distance <= 4.5 then
				if IsControlJustPressed(0, Config.KeyToRobFromTruck ) then 
					TruckIsExploded = false
					RobbingTheMoney()
					Citizen.Wait(500)
				end
			end
		end
		
		if missionCompleted == true then
			QBCore.Functions.Notify("Missão completa")
			Config.ArmoredTruck[num].InUse = false
			RemoveBlip(blip)
			TriggerServerEvent("ks-TruckRobbery:syncMissionData",Config.ArmoredTruck)
			taken = true
			missionInProgress = false
			missionCompleted = false
			TruckIsExploded = false
			TruckIsDemolished = false
			KillGuardsText = false
			openText = false
			bomText = false
			break
		end
		
	end
end)


-- Usable Item Event:
RegisterNetEvent("ks-TruckRobbery:UsableItem")
AddEventHandler("ks-TruckRobbery:UsableItem",function()
	local pos = GetEntityCoords(GetPlayerPed(-1), false)
	local TruckPos = GetEntityCoords(ArmoredTruckVeh) 
	local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, TruckPos.x, TruckPos.y, TruckPos.z, false)
	if missionInProgress == true then
    if distance <= 5 and TruckIsDemolished == false then				 
			QBCore.Functions.TriggerCallback('ks-TruckRobbery:server:Hasbomb', function(HasItem)
				if HasItem then
				    TriggerServerEvent("ks-TruckRobbery:RemoveItem")
					BlowTheTruckDoor()
					Citizen.Wait(500) 
				else
					QBCore.Functions.Notify('Você precisa de uma bomba-relógio ..', 'error')
				end
			end)
		end
	end
end)

-- Function for blowing the door on the truck
function BlowTheTruckDoor()
	if IsVehicleStopped(ArmoredTruckVeh) then
		if (IsVehicleSeatFree(ArmoredTruckVeh, -1) and IsVehicleSeatFree(ArmoredTruckVeh, 0) and IsVehicleSeatFree(ArmoredTruckVeh, 1)) then
		    
			TruckIsDemolished = true
			
			RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
			while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do
				Citizen.Wait(50)
			end
			
			if Config.PoliceNotfiyEnabled == true then
				TriggerServerEvent('ks-TruckRobbery:TruckRobberyInProgress',GetEntityCoords(PlayerPedId()),streetName)
			end

			QBCore.Functions.Progressbar("hack", "Coloque a bomba", 5500, false, true, {

            }, {}, {}, function() 
	        end)-- Done
			
			local playerPed = GetPlayerPed(-1)
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			itemC4prop = CreateObject(GetHashKey('prop_c4_final_green'), x, y, z+0.2,  true,  true, true)
			AttachEntityToEntity(itemC4prop, playerPed, GetPedBoneIndex(playerPed, 60309), 0.06, 0.0, 0.06, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
			SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
			Citizen.Wait(700)
			FreezeEntityPosition(playerPed, true)
			TaskPlayAnim(playerPed, 'anim@heists@ornate_bank@thermal_charge_heels', "thermal_charge", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			TriggerServerEvent('ks-TruckRobbery:server:PoliceAlertMessage', 'As pessoas tentam roubar coisas da loja iFruit', pos, true)
			Citizen.Wait(5500)
			
			ClearPedTasks(playerPed)
			DetachEntity(itemC4prop)
			AttachEntityToEntity(itemC4prop, ArmoredTruckVeh, GetEntityBoneIndexByName(ArmoredTruckVeh, 'door_pside_r'), -0.7, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
			FreezeEntityPosition(playerPed, false)
			Citizen.Wait(500)
			
			QBCore.Functions.Progressbar("hack", "Espere..", 9500, false, true, {

            }, {}, {}, function() 
	        end)-- Done			
			Citizen.Wait((Config.DetonateTimer * 1000))
			
			local TruckPos = GetEntityCoords(ArmoredTruckVeh)
			SetVehicleDoorBroken(ArmoredTruckVeh, 2, false)
			SetVehicleDoorBroken(ArmoredTruckVeh, 3, false)
			AddExplosion(TruckPos.x,TruckPos.y,TruckPos.z, 'EXPLOSION_TANKER', 2.0, true, false, 2.0)
			ApplyForceToEntity(ArmoredTruckVeh, 0, TruckPos.x,TruckPos.y,TruckPos.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
			TruckIsExploded = true
			QBCore.Functions.Notify('Roubo de caminhão iniciado..', 'error')
		else
			QBCore.Functions.Notify('Seguranças ainda estão vivos..', 'error')
		end
	else
		QBCore.Functions.Notify('O caminhão ainda não parou ..', 'error')
	end
end

-- Function for robbing the money in the truck
function RobbingTheMoney()
	
	RequestAnimDict('anim@heists@ornate_bank@grab_cash_heels')
	while not HasAnimDictLoaded('anim@heists@ornate_bank@grab_cash_heels') do
		Citizen.Wait(50)
	end
	
	local playerPed = GetPlayerPed(-1)
	local pos = GetEntityCoords(playerPed)
	
	moneyBag = CreateObject(GetHashKey('prop_cs_heist_bag_02'),pos.x, pos.y,pos.z, true, true, true)
	AttachEntityToEntity(moneyBag, playerPed, GetPedBoneIndex(playerPed, 57005), 0.0, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
	TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
	FreezeEntityPosition(playerPed, true)
	

	QBCore.Functions.Progressbar("hack", "Agarre com suas garras..", 6000, false, true, {

    }, {}, {}, function() 
	end)-- Done	
	Citizen.Wait(6000)
	
	
	DeleteEntity(moneyBag)
	ClearPedTasks(playerPed)
	FreezeEntityPosition(playerPed, false)
	
	if Config.EnablePlayerMoneyBag == true then
		SetPedComponentVariation(playerPed, 5, 45, 0, 2)
	end
	
	TriggerServerEvent("ks-TruckRobbery:missionComplete")
	
	TruckIsExploded = false
	TruckIsDemolished = false
	missionInProgress = false
	Citizen.Wait(1000)
	missionCompleted = true
end

-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

-- Blip for the Armored Truck on the move
function CreateMissionBlip(location)
	local blip = AddBlipForEntity(ArmoredTruckVeh)
	SetBlipSprite(blip, Config.BlipSpriteTruck)
	SetBlipColour(blip, Config.BlipColourTruck)
	AddTextEntry('MYBLIP', Config.BlipNameForTruck)
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, Config.BlipScaleTruck) 
	SetBlipAsShortRange(blip, true)
	return blip
end

-- Sync mission data
RegisterNetEvent("ks-TruckRobbery:syncMissionData")
AddEventHandler("ks-TruckRobbery:syncMissionData",function(data)
	Config.ArmoredTruck = data
end)
