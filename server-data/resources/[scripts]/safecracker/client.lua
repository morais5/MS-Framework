QBCore = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if QBCore == nil then
			TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
			Citizen.Wait(200)
		end
	end
end)

function StartMinigame(combo)
	--if not self or not SafeCracker.Config then return; end
	local Coords = GetEntityCoords(GetPlayerPed(-1), false)
	local Object = GetClosestObjectOfType(Coords.x, Coords.y, Coords.z, 5.0, GetHashKey("v_ilev_gangsafedoor"), false, false, false)
	local ObjectHeading = GetEntityHeading(Object)
	local txd = CreateRuntimeTxd(SafeCracker.Config.TextureDict)
	for i = 1, 2 do CreateRuntimeTextureFromImage(txd, tostring(i), "LockPart" .. i .. ".PNG") end
	loadAnimDict("mini@safe_cracking")
	TaskPlayAnim(GetPlayerPed(-1), "mini@safe_cracking", "dial_turn_anti_fast_1", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
	FreezeEntityPosition(GetPlayerPed(-1), true)
	SetEntityHeading(GetPlayerPed(-1), ObjectHeading)
	SafeCracker.MinigameOpen = true
	SafeCracker.SoundID 	  = GetSoundId() 
	SafeCracker.Timer 		  = GetGameTimer()
  	SafeCracker.StayClosed = false

	if not RequestAmbientAudioBank(SafeCracker.Config.AudioBank, false) then RequestAmbientAudioBank(SafeCracker.Config.AudioBankName, false); end
	if not HasStreamedTextureDictLoaded(SafeCracker.Config.TextureDict, false) then RequestStreamedTextureDict(SafeCracker.Config.TextureDict, false); end
	Citizen.CreateThread(function() 
		Update(combo)
	end)
end

RegisterNetEvent('SafeCracker:StartMinigame')
AddEventHandler('SafeCracker:StartMinigame', function(combo)
	StartMinigame(combo); 
end)

function Update(combo)
	--if not self or not SafeCracker.Config or not SafeCracker.MinigameOpen or not SafeCracker.cS or not SafeCracker.dS then return; end	
	Citizen.CreateThread(function() HandleMinigame(combo); end)
	while SafeCracker.MinigameOpen do
		InputCheck()  
		if IsEntityDead(GetPlayerPed(PlayerId())) then EndMinigame(false, false); end
		Citizen.Wait(0)
	end
end

function InputCheck()
	--if not self or not SafeCracker.Config or not SafeCracker.MinigameOpen then return; end	
	local leftKeyPressed 	= IsControlPressed( 0, Keys[ 'LEFT' ] ) 	or 0
	local rightKeyPressed 	= IsControlPressed( 0, Keys[ 'RIGHT' ] )	or 0
	if 		IsControlPressed( 0, Keys[ 'ESC' ] ) 			then EndMinigame(false); end
	if 		IsControlPressed( 0, Keys[ 'Z' ] ) 			then rotSpeed 	=   0.1; modifier = 33;
    elseif 	IsControlPressed( 0, Keys[ 'LEFTSHIFT' ] )	then rotSpeed 	=   1.0; modifier = 50; 
    else 																 rotSpeed	=   0.4; modifier = 90; end

    local lockRotation = math.max(modifier / rotSpeed, 0.1)

	if leftKeyPressed ~= 0 or rightKeyPressed ~= 0 then
		
    	SafeCracker.LockRotation = SafeCracker.LockRotation - ( rotSpeed * tonumber( leftKeyPressed ) )
    	SafeCracker.LockRotation = SafeCracker.LockRotation + ( rotSpeed * tonumber( rightKeyPressed ) )
    	if (GetGameTimer() - SafeCracker.Timer) > lockRotation then 
    		PlaySoundFrontend(0, SafeCracker.Config.SafeTurnSound, SafeCracker.Config.SafeSoundset, false)
    		SafeCracker.Timer = GetGameTimer() 
    	end
    end
end

function HandleMinigame(combo) 
	--if not self or not SafeCracker.Config or not SafeCracker.MinigameOpen then return; end

	local lockRot = math.random(150.00, 300.00)	

	local lockNumbers 	 = {}
	local correctGuesses = {}
	lockNumbers[1] = combo[1]
	lockNumbers[2] = combo[2]
	lockNumbers[3] = combo[3]
	lockNumbers[4] = combo[4]
	lockNumbers[5] = combo[5]

	-----------------------
	-- REDO LOCK NUMBERS --
	-----------------------
	-- Make numbers persist if chosen.
	-- Add number count for difficulty.
	-- Multiples of 2 are positive, 45 - 359;
	-- Multiples of 3 are negative, 719 - 405;
	-- Everything else is negative, 45 - 359;

	---------------------------------------------
	-- Still havn't done, you're welcome to ^^ --
	---------------------------------------------
	--[[for i = 1,5 do
		print(math.floor((lockNumbers[i] % 360) / 3.60))
	end]]--
	--------------------------------------
	-- Comment this out for a challenge --
	--------------------------------------

    local correctCount	= 1
    local hasRandomized	= false

    SafeCracker.LockRotation = 0.0 + lockRot
								
	while SafeCracker.MinigameOpen do	
		--				Texture Dictionary, Texture Name, xPos, yPos, xSize, ySize, 		   Heading,   R,   G,   B,   A,
		DrawSprite(SafeCracker.Config.TextureDict, 		 "1",  0.8,  0.5,  0.15,  0.26, -SafeCracker.LockRotation, 255, 255, 255, 255)
		DrawSprite(SafeCracker.Config.TextureDict, 		 "2",  0.8,  0.5, 0.176, 0.306, 		      -0.0, 255, 255, 255, 255)	

		hasRandomized = true

		local lockVal = math.floor(SafeCracker.LockRotation)

		if 		correctCount > 1 and 	correctCount < 6 and lockVal + (SafeCracker.Config.LockTolerance * 3.60) < lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] < lockNumbers[correctCount] then EndMinigame(false); SafeCracker.MinigameOpen = false; 
		elseif 	correctCount > 1 and 	correctCount < 6 and lockVal - (SafeCracker.Config.LockTolerance * 3.60) > lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] > lockNumbers[correctCount] then EndMinigame(false); SafeCracker.MinigameOpen = false; 
		elseif 	correctCount > 5 then 	EndMinigame(true)
		end

		for k,v in pairs(lockNumbers) do
			if not hasRandomized then SafeCracker.LockRotation = lockRot; end
			if lockVal == v and correctCount == k then
				local canAdd = true
				for key,val in pairs(correctGuesses) do
					if val == lockVal and key == correctCount then
						canAdd = false
					end
				end

				if canAdd then 				
					PlaySoundFrontend(-1, SafeCracker.Config.SafePinSound, SafeCracker.Config.SafeSoundset, true)
					correctGuesses[correctCount] = lockVal
					correctCount = correctCount + 1; 
				end   				  			
			end
		end
		Citizen.Wait(0)
	end
end


function EndMinigame(won)
	--if not self or not SafeCracker.Config or not SafeCracker.MinigameOpen then return; end

	SafeCracker.MinigameOpen = false
	if won then 
		PlaySoundFrontend(SafeCracker.SoundID, SafeCracker.Config.SafeFinalSound, SafeCracker.Config.SafeSoundset, true)
		QBCore.Functions.Notify("Kluis geopend..", "success")
	else
		QBCore.Functions.Notify("Kluis gefaald..", "error")
	end
  	TriggerEvent('SafeCracker:EndMinigame', won)
	FreezeEntityPosition(GetPlayerPed(-1), false)
	ClearPedTasksImmediately(GetPlayerPed(-1))
end

RegisterNetEvent('SafeCracker:EndGame')
AddEventHandler('SafeCracker:EndGame', function() EndMinigame(); end)

function OpenSafeDoor()
  Citizen.CreateThread(function(...)
    local objs = {}
    local doorHash = (GetHashKey(SafeCracker.SafeModels.Door) % 0x100000000)
    for k,v in pairs(objs) do
      if (GetEntityModel(v)% 0x100000000) == doorHash then 

        local doorHeading = GetEntityPhysicsHeading(v)
        local doorPosition = GetEntityCoords(v)

        SetEntityCollision(v, false, false)
        FreezeEntityPosition(v, false)

        local targetHeading = doorHeading + 150
        local tick = 0
        while targetHeading > GetEntityHeading(v) and tick < 500 do    
          tick = tick + 1
          SetEntityHeading(v, GetEntityHeading(v) + 0.3)
          SetEntityCoords(v, doorPosition, false, false, false, false)
          Citizen.Wait(0)
        end

        if not (GetEntityHeading(v) >= targetHeading) then SetEntityHeading(v, targetHeading); end
      end
    end  
  end)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function SpawnSafeObject(table, position, heading)
	if not table then table = SafeCracker.SafeObjects; end
	if not table or not position or not heading then return; end
	if type(table) ~= 'table' or type(position) ~= 'vector3' or type(heading) ~= 'number' then return; end

	LoadModelTable(SafeCracker.SafeModels)

	local retTable = {}
	local i = 0
	for k,v in pairs(table) do
		i = i + 1
		local hash = GetHashKey(v.ModelName) % 0x100000000
		local newHeading = heading + v.Heading

		local newObj = CreateObject(hash, v.Pos.x + position.x, v.Pos.y + position.y, v.Pos.z + position.z, false, false, false)

		if v.ModelName == SafeCracker.SafeModels.Door then 
			SafeCracker.DoorObj = newObj
			SafeCracker.DoorHeading = GetEntityHeading(SafeCracker.DoorObj)
		end

		SetEntityAsMissionEntity(newObj, true)
		FreezeEntityPosition(newObj, true)
		SetEntityHeading(newObj, newHeading)

		if v.Rot.x ~= 0.0 or v.Rot.y ~= 0.0 or v.Rot.z ~= 0.0 then SetEntityRotation(newObj, v.Rot.x, v.Rot.y, v.Rot.z, 1, true); end
		retTable[v.ModelName] = newObj		
	end

	ReleaseModelTable(SafeCracker.SafeModels)
	SafeCracker.Objects = retTable
	return retTable
end

function DelSafe()
	for k,v in pairs(SafeCracker.Objects) do DeleteObject(v); end
end

RegisterNetEvent('SafeCracker:SpawnSafe')
AddEventHandler('SafeCracker:SpawnSafe', function(tab, pos, heading, cb) if cb then cb(SpawnSafeObject(tab,pos,heading)) else SpawnSafeObject(tab,pos,heading); end; end)

function LoadModelTable(table)
  if type(table) ~= 'table' then return false; end
  for k,v in pairs(table) do
    if type(v) == 'string' then
      local hk = GetHashKey(v) % 0x100000000
      while not HasModelLoaded(hk) do
        RequestModel(hk)
        Citizen.Wait(0)
      end
    end
  end
  return true
end

function ReleaseModelTable(table)
  if type(table) ~= 'table' then return false; end
  for k,v in pairs(table) do
    if type(v) == 'string' then
      local hk = GetHashKey(v) % 0x100000000
      if HasModelLoaded(hk) then
        SetModelAsNoLongerNeeded(hk)
      end
    end
  end
  return true
end