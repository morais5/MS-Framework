-------------------------------------
------- Created by CODERC-SLO -------
-----------Money Loundry---------------
------------------------------------- 
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
QBCore = nil 


Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
	
	while QBCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = QBCore.Functions.GetPlayerData()
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

--------------------------------------------onload player----------------------------
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
  
end)

-------------------------------------------setjob-------------------------------------
RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
 
    PlayerData.job = JobInfo
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)
-----------------------------------------------------------------------------------------



-------------------------------------BLIP PROCESS MONEY CLEANING---------------------
local blips = {
    {title="Bahamas", colour=50, id=93, x = -1381.75, y = -632.47, z = 30.82}

    
    --
    
}
-----------------------------CREATE BLIP PROCESS MONEY CLEANING-----------------------
Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.7)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end) 


helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
-- Draw 3D text Function:
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
-----------------------------------------------PROCESS MONEY CLEANING-----------------------------------------------
local sellX4 = -1381.75
local sellY4 = -632.47
local sellZ4 = 30.82
-----------------------------------------------PROCESS MONEY CLEANING-----------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        -----------------------------------------------LOCAL------------------------------------------------------

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        ---local distanza marker 1----------------------
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX4, sellY4, sellZ4)
      
        ---end local distanza marker 1------------------
       
        local vehicled = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        local playerPeds = PlayerPedId()

        -------------------------------------------MARKER----------------------------------------

		if dist <= 10.0 then
			DrawMarker(25, sellX4, sellY4, sellZ4-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
            --DrawMarker(20, sellX4, sellY4, sellZ4 + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.2, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
        end
            
        -------------------------------------------fine marker pavimento-----------------------------------------
        --####################################################################################################---

        -------------------------------------------ingresso in marker 1--------------------------------------------
        if dist <= 3.0 then

            ---------------------------------------eseguo il controllo se sono in macchina----------------------
		    if GetPedInVehicleSeat(vehicled, -1) == GetPlayerPed(-1) then
              ----se sono in macchina non esegue nessuna funzione
            else
                ----se sono a piedi eseguo il codice---------------------------------------

                -------------creo il testo-------------------------------------------------
                DrawText3Ds(sellX4, sellY4, sellZ4+0.1,'~g~[E]~w~ Para lavar dinheiro sujo')
                ---------------------------------------------------------------------------
                
                -----------pressione tasto E-----------------------------------------------
                if IsControlJustPressed(0, Keys['E']) then 

                -----------locali di controllo xpoint-------------------------------------------------
                local hasBagd7 = false
                local s1d7 = false
               
				---------controllo se ho i punti xp---------------------------------------------------
               
                         --controllo se ho l'item
                                        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result2)
                                        hasBagd7 = result2
                                        s1d7 = true
                                        end, 'black_money')
                                        while(not s1d7) do
                                        Citizen.Wait(100)
                                        end
                                       
                                                  ----se ho l'item eseguo
                                                    if (hasBagd7) then
                                                          -----------eseguo----
                                                          procOn()
                                  
                                                    else
                                                      QBCore.Functions.Notify('Não tens dinheiro sujo', 'error')
                                                    end
                      
                        
                   
                    ----------------fine progress Bar-----------------------------------------------------------------------------

                end	
                -----------------------------------------------fine pressione tasto-----------------------------------------------
               
            end
            -----------------------------------------------fine controllo se sono in  macchina---------------------------------------
		
		end	
        ---------------------------------------------------fine ingresso marker 1-------------------------------------------------------

    end
    -------fine while-------------------------------------------------------------------------------------------------
end)

function procOn()
    -- local
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local inventory = QBCore.Functions.GetPlayerData().inventory
    local count = 0
    ----
    if(count == 0) then
    QBCore.Functions.Progressbar("search_register", "A lavar..", 20000, false, true, {disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()end, function()
                        
                    end)
		 local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
		 --prop_money_bag_01
         prop = CreateObject(GetHashKey('prop_cash_case_02'), x, y, z,  true,  true, true)
         SetEntityHeading(prop, GetEntityHeading(GetPlayerPed(-1)))
         LoadDict('amb@medic@standing@tendtodead@idle_a')
         TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
         Citizen.Wait(20000)
         LoadDict('amb@medic@standing@tendtodead@exit')
         TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
         ClearPedTasks(GetPlayerPed(-1))
         DeleteEntity(prop)
         TriggerServerEvent('pulisci:moneblak')
    else
    
    
    end
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end
----------------------------------------------------------------END MONEY CLEANING------------------------------------------------------------