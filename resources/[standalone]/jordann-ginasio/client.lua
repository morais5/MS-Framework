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

local isworkingout = false


--========================Jogging==========================--
local jogspotz = {
  [1] = {x = -1195.740, y = -1568.039,  z = 4.621}, -- Gym beach
  [2] = {x = -1197.805, y = -1578.603, z = 4.608}, -- Gym beach
}

Citizen.CreateThread(function()
 while true do
    Citizen.Wait(0)
    for _,v in pairs(jogspotz) do
      if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 20) and not isworkingout then  
          DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
        if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 0.5) then
          drawTxt('~c~Carrega ~g~E~c~ oara começar a correr')
          if IsControlJustPressed(0, 38) then
            isworkingout = true
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_JOG_STANDING", 0, true)
            Citizen.Wait(40000)
            QBCore.Functions.Notify("Já estas a suar", "error")
            ExecuteCommand('eu - a suar')	
            Citizen.Wait(35000)
            QBCore.Functions.Notify("Vigor aumentado..", "success")
            ClearPedTasksImmediately(GetPlayerPed(-1))
            ExecuteCommand('eu - cansa e para de correr')
            exports["qb-skillz"]:UpdateSkill("Stamina", 1)
            isworkingout = false      
            Wait(300000)
          end 
        end
      end
    end 
  end
end)

--========================PushUps==========================--
local pushupspotz = {
  [1] = {x = -1207.974, y = -1562.175, z = 4.608}, -- Gym beach 
  [2] = {x = -1204.972, y = -1560.021, z = 4.614}, -- Gym beach 
}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    for _,v in pairs(pushupspotz) do
      if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 20) and not isworkingout then
        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
        if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 0.5) then
          drawTxt('~c~Carrega ~g~E~c~ para começares a fazer flexões')
          if IsControlJustPressed(0, 38) then
            isworkingout = true
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_push_ups", 0, true)
            Citizen.Wait(25000)
            QBCore.Functions.Notify("Já estas a suar", "error")
            Citizen.Wait(45000)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            ExecuteCommand('eu - a respirar')
            exports["qb-skillz"]:UpdateSkill("Stamina", 0.5)
            exports["qb-skillz"]:UpdateSkill("Strength", 0.5)
            isworkingout = false      
            Wait(300000)
          end
        end
      end
    end 
  end
end)

--========================ChinUps==========================--
Citizen.CreateThread(function() --==Beach==--
  while true do
    Citizen.Wait(0)
    if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1200.060, -1571.120, 4.609, true) < 20) and not isworkingout then
      DrawMarker(2, -1200.060, -1571.120, 4.609, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
      if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1200.060, -1571.120, 4.609, true) < 0.5) then
        drawTxt('~c~Carrega ~g~E~c~ para começar a flexões')
        if IsControlJustPressed(0, 38) then
          SetEntityCoords(GetPlayerPed(-1),-1200.060, -1571.120, 4.609-0.99, 0.0, 0.0, 0.0, true)
          SetEntityHeading(GetPlayerPed(-1), 218.203)
          isworkingout = true
          TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_MUSCLE_CHIN_UPS", 0, true)
          Citizen.Wait(25000)
          QBCore.Functions.Notify("Já estas a suar", "error")
          Citizen.Wait(45000)
          ClearPedTasksImmediately(GetPlayerPed(-1))
          ExecuteCommand('eu - a respirar')
          exports["qb-skillz"]:UpdateSkill("Stamina", 0.5)
          exports["qb-skillz"]:UpdateSkill("Strength", 0.5)
          isworkingout = false      
          Wait(300000)
        end
      end
    end 
  end
end)

--=============Strength and Stamina=============-

local circuitspotz = {
  [1] = {x =  -1199.400, y = -1563.382, z = 4.620}, -- Gym beach 
}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    for _,v in pairs(circuitspotz) do
      if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 20) and not isworkingout then
        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
        if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 0.5) then
          drawTxt('~c~Carrega ~g~E~c~ para trabalhar em sua resistência e força ')
          if IsControlJustPressed(0, 38) then
            isworkingout = true
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_JOG_STANDING", 0, true)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_push_ups", 0, true)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_JOG_STANDING", 0, true)
            Citizen.Wait(5000)
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_push_ups", 0, true)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_JOG_STANDING", 0, true)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_push_ups", 0, true)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_JOG_STANDING", 0, true)
            Citizen.Wait(40000)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_push_ups", 0, true)
            Citizen.Wait(45000)
            QBCore.Functions.Notify("Já estas a suar", "error")
            --TriggerServerEvent('stats:add', 'Lung Capacity', 1)
            -- QBCore.Functions.Notify("Stamina & Strength increased..", "success")
            ClearPedTasksImmediately(GetPlayerPed(-1))
            ExecuteCommand('eu - cansa e para de correr')
            exports["qb-skillz"]:UpdateSkill("Strength", 1)
            exports["qb-skillz"]:UpdateSkill("Stamina", 1)
            isworkingout = false      
            Wait(300000)
          end
        end
      end
    end 
  end
end)

--==============Swimming Lung Capacity

local ped = GetPlayerPed(-1)
  Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(0)
    if IsPedSwimming(ped) and math.random(1, 500) > 50 then 
      --TriggerServerEvent('stats:add', 'Lung Capacity', 1)
      Wait(1000)
      QBCore.Functions.Notify("Medidor de fitness: capacidade pulmonar aumentada", "success")
      exports["qb-skillz"]:UpdateSkill("Lung Capacity", 1) 
      PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', 0, 1)
      Wait(1000)
    end
  end
end)
--=======================================

function drawTxt(text)
  SetTextFont(0)
  SetTextProportional(0)
  SetTextScale(0.32, 0.32)
  SetTextColour(0, 255, 255, 255)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(1)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(0.5, 0.93)
end


