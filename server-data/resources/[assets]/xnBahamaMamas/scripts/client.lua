-- The following thread checks and disables the outside ambient music at the club since we have our own now
CreateThread(function()
	while true do
		Wait(1000)
		if IsAmbientZoneEnabled("az_dlc_heists_bahama_mamas") then
			SetAmbientZoneStatePersistent("az_dlc_heists_bahama_mamas", false, false)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if GetInteriorFromEntity(PlayerPedId()) == Config.IntID then
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 140, true)
			if not DoesEntityExist(Config.InsidePeds["Bar1"][1]) then
				LoadBahamas()
			end
		else
			if DoesEntityExist(Config.InsidePeds["Bar1"][1]) then
				LeaveBahamas()
			end
		end
	end
end)

function RequestEntModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end
	SetModelAsNoLongerNeeded(model)
end

function PlayAnim(ped, animDict, animName)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do 
		Wait(0) 
	end
	TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, -1, 1, 1, false, false, false)
	RemoveAnimDict(animDict)
end

function RequestTexture(texture)
	RequestStreamedTextureDict(texture)
	while not HasStreamedTextureDictLoaded(texture) do 
		Wait(0) 
	end
	SetStreamedTextureDictAsNoLongerNeeded(texture)
end

function DrawMyNotification(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

function ShowClubNotification(msg)
	RequestTexture("char_bahamamamas")
	DrawMyNotification('Bahama Mamas', '', msg, "char_bahamamamas", 1)
end

function CreatePeds()
	for k, v in pairs(Config.InsidePeds) do
		if not v[1] then
			RequestEntModel(v[3])
			v[1] = CreatePed(v[2], v[3], v[4], false, true)
			if v[5] ~= nil then
				TaskStartScenarioAtPosition(v[1], v[5], v[4], -1, false, true)
			end
			SetModelAsNoLongerNeeded(v[2])
		end
		for q, t in pairs(Config.PedComponents) do
			if q == k then
				t[1] = v[1]
			end
		end
		for i, o in pairs(Config.PedAnims) do
			if i == k then
				o[1] = v[1]
			end
		end
		if k == "Bar3" or string.match(k, "sitting") then
			FreezeEntityPosition(v[1], true)
		end
		SetPedAsEnemy(v[1], false)
		SetBlockingOfNonTemporaryEvents(v[1], true)
		SetPedResetFlag(v[1], 249, true)
		SetPedConfigFlag(v[1], 185, true)
		SetPedConfigFlag(v[1], 108, true)
		SetPedConfigFlag(v[1], 106, true)
		SetPedCanEvasiveDive(v[1], false)
		N_0x2f3c3d9f50681de4(v[1], 1)
		SetPedCanRagdollFromPlayerImpact(v[1], false)
		SetPedCanRagdoll(v[1], false)
		SetPedConfigFlag(v[1], 208, true)
		SetEntityInvincible(v[1], true)
	end
	for k, v in pairs(Config.PedComponents) do
		SetPedComponentVariation(v[1], v[2], v[3], v[4], v[5])
	end
	for k, v in pairs(Config.PedAnims) do
		PlayAnim(v[1], v[2], v[3])
	end
end

function DeletePeds()
	for k, v in pairs(Config.InsidePeds) do
		if DoesEntityExist(v[1]) then
			DeleteEntity(v[1])
			v[1] = false
		end
	end
end

function LoadBahamas()
	CreatePeds()
	if IsPedArmed(PlayerPedId(), 7) then
		SetCurrentPedWeapon(PlayerPedId(), "WEAPON_UNARMED" ,true)
	end
	ShowClubNotification("We don't tolerate any violence around here. We will be holding onto your weapons until you leave.")
	Wait(1000)
	for k,v in pairs(Config.InsidePeds) do
		FreezeEntityPosition(v[1], true)
	end
end

function LeaveBahamas()
	DeletePeds()
	EnableAllControlActions(0)
end