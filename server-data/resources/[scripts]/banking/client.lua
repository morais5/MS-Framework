Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

MSCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if MSCore == nil then
            TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

-- Settings
local depositAtATM = false -- Allows the player to deposit at an ATM rather than only in banks (Default: false)
local giveCashAnywhere = false -- Allows the player to give CASH to another player, no matter how far away they are. (Default: false)
local withdrawAnywhere = false -- Allows the player to withdraw cash from bank account anywhere (Default: false)
local depositAnywhere = false -- Allows the player to deposit cash into bank account anywhere (Default: false)
local displayBankBlips = true -- Toggles Bank Blips on the map (Default: true)
local displayAtmBlips = false -- Toggles ATM blips on the map (Default: false) // THIS IS UGLY. SOME ICONS OVERLAP BECAUSE SOME PLACES HAVE MULTIPLE ATM MACHINES. NOT RECOMMENDED
local enableBankingGui = true -- Enables the banking GUI (Default: true) // MAY HAVE SOME ISSUES

-- ATMS
local atms = {
  {name="Caixa Multibank", id=277, x=-386.733, y=6045.953, z=31.501},
  {name="Caixa Multibank", id=277, x=-284.037, y=6224.385, z=31.187},
  {name="Caixa Multibank", id=277, x=-284.037, y=6224.385, z=31.187},
  {name="Caixa Multibank", id=277, x=-135.165, y=6365.738, z=31.101},
  {name="Caixa Multibank", id=277, x=-110.753, y=6467.703, z=31.784},
  {name="Caixa Multibank", id=277, x=-94.9690, y=6455.301, z=31.784},
  {name="Caixa Multibank", id=277, x=155.4300, y=6641.991, z=31.784},
  {name="Caixa Multibank", id=277, x=174.6720, y=6637.218, z=31.784},
  {name="Caixa Multibank", id=277, x=1703.138, y=6426.783, z=32.730},
  {name="Caixa Multibank", id=277, x=1735.114, y=6411.035, z=35.164},
  {name="Caixa Multibank", id=277, x=1702.842, y=4933.593, z=42.051},
  {name="Caixa Multibank", id=277, x=1967.333, y=3744.293, z=32.272},
  {name="Caixa Multibank", id=277, x=1821.917, y=3683.483, z=34.244},
  {name="Caixa Multibank", id=277, x=1174.532, y=2705.278, z=38.027},
  {name="Caixa Multibank", id=277, x=540.0420, y=2671.007, z=42.177},
  {name="Caixa Multibank", id=277, x=2564.399, y=2585.100, z=38.016},
  {name="Caixa Multibank", id=277, x=2558.683, y=349.6010, z=108.050},
  {name="Caixa Multibank", id=277, x=2558.051, y=389.4817, z=108.660},
  {name="Caixa Multibank", id=277, x=1077.692, y=-775.796, z=58.218},
  {name="Caixa Multibank", id=277, x=1139.018, y=-469.886, z=66.789},
  {name="Caixa Multibank", id=277, x=1168.975, y=-457.241, z=66.641},
  {name="Caixa Multibank", id=277, x=1153.884, y=-326.540, z=69.245},
  {name="Caixa Multibank", id=277, x=381.2827, y=323.2518, z=103.270},
  {name="Caixa Multibank", id=277, x=236.4638, y=217.4718, z=106.840},
  {name="Caixa Multibank", id=277, x=265.0043, y=212.1717, z=106.780},
  {name="Caixa Multibank", id=277, x=285.2029, y=143.5690, z=104.970},
  {name="Caixa Multibank", id=277, x=157.7698, y=233.5450, z=106.450},
  {name="Caixa Multibank", id=277, x=-164.568, y=233.5066, z=94.919},
  {name="Caixa Multibank", id=277, x=-1827.04, y=785.5159, z=138.020},
  {name="Caixa Multibank", id=277, x=-1409.39, y=-99.2603, z=52.473},
  {name="Caixa Multibank", id=277, x=-1205.35, y=-325.579, z=37.870},
  {name="Caixa Multibank", id=277, x=-1215.64, y=-332.231, z=37.881},
  {name="Caixa Multibank", id=277, x=-2072.41, y=-316.959, z=13.345},
  {name="Caixa Multibank", id=277, x=-2975.72, y=379.7737, z=14.992},
  {name="Caixa Multibank", id=277, x=-2962.60, y=482.1914, z=15.762},
  {name="Caixa Multibank", id=277, x=-2955.70, y=488.7218, z=15.486},
  {name="Caixa Multibank", id=277, x=-3044.22, y=595.2429, z=7.595},
  {name="Caixa Multibank", id=277, x=-3144.13, y=1127.415, z=20.868},
  {name="Caixa Multibank", id=277, x=-3241.10, y=996.6881, z=12.500},
  {name="Caixa Multibank", id=277, x=-3241.11, y=1009.152, z=12.877},
  {name="Caixa Multibank", id=277, x=-1305.40, y=-706.240, z=25.352},
  {name="Caixa Multibank", id=277, x=-538.225, y=-854.423, z=29.234},
  {name="Caixa Multibank", id=277, x=-711.156, y=-818.958, z=23.768},
  {name="Caixa Multibank", id=277, x=-717.614, y=-915.880, z=19.268},
  {name="Caixa Multibank", id=277, x=-526.566, y=-1222.90, z=18.434},
  {name="Caixa Multibank", id=277, x=-256.831, y=-719.646, z=33.444},
  {name="Caixa Multibank", id=277, x=-203.548, y=-861.588, z=30.205},
  {name="Caixa Multibank", id=277, x=112.4102, y=-776.162, z=31.427},
  {name="Caixa Multibank", id=277, x=112.9290, y=-818.710, z=31.386},
  {name="Caixa Multibank", id=277, x=119.9000, y=-883.826, z=31.191},
  {name="Caixa Multibank", id=277, x=149.4551, y=-1038.95, z=29.366},
  {name="Caixa Multibank", id=277, x=-846.304, y=-340.402, z=38.687},
  {name="Caixa Multibank", id=277, x=-1204.35, y=-324.391, z=37.877},
  {name="Caixa Multibank", id=277, x=-1216.27, y=-331.461, z=37.773},
  {name="Caixa Multibank", id=277, x=-56.1935, y=-1752.53, z=29.452},
  {name="Caixa Multibank", id=277, x=-261.692, y=-2012.64, z=30.121},
  {name="Caixa Multibank", id=277, x=-273.001, y=-2025.60, z=30.197},
  {name="Caixa Multibank", id=277, x=314.187, y=-278.621, z=54.170},
  {name="Caixa Multibank", id=277, x=-351.534, y=-49.529, z=49.042},
  {name="Caixa Multibank", id=277, x=24.589, y=-946.056, z=29.357},
  {name="Caixa Multibank", id=277, x=-254.112, y=-692.483, z=33.616},
  {name="Caixa Multibank", id=277, x=-1570.197, y=-546.651, z=34.955},
  {name="Caixa Multibank", id=277, x=-1415.909, y=-211.825, z=46.500},
  {name="Caixa Multibank", id=277, x=-1430.112, y=-211.014, z=46.500},
  {name="Caixa Multibank", id=277, x=33.232, y=-1347.849, z=29.497},
  {name="Caixa Multibank", id=277, x=129.216, y=-1292.347, z=29.269},
  {name="Caixa Multibank", id=277, x=287.645, y=-1282.646, z=29.659},
  {name="Caixa Multibank", id=277, x=289.012, y=-1256.545, z=29.440},
  {name="Caixa Multibank", id=277, x=295.839, y=-895.640, z=29.217},
  {name="Caixa Multibank", id=277, x=1686.753, y=4815.809, z=42.008},
  {name="Caixa Multibank", id=277, x=-302.408, y=-829.945, z=32.417},
  {name="Caixa Multibank", id=277, x=5.134, y=-919.949, z=29.557},

}

ATMObjects = {
  -870868698,
  -1126237515,
  -1364697528,
  506770882,
}

-- Banks
local banks = {
  [1] = {name="Bank", Closed = false, id=108, x = 314.187,   y = -278.621,  z = 54.170},
  [2] = {name="Bank", Closed = false, id=108, x = 150.266,   y = -1040.203, z = 29.374},
  [3] = {name="Bank", Closed = false,  id=108, x = -351.534,  y = -49.529,   z = 49.042},
  [4] = {name="Bank", Closed = false, id=108, x = -1212.980, y = -330.841,  z = 37.787},
  [5] = {name="Bank", Closed = false, id=108, x = -2962.582, y = 482.627,   z = 15.703},
  [6] = {name="Bank", Closed = false, id=108, x = -112.202,  y = 6469.295,  z = 31.626},
  [7] = {name="Bank", Closed = false, id=108, x = 241.727,   y = 220.706,   z = 106.286},
}

RegisterNetEvent('ms-banking:client:SetBankClosed')
AddEventHandler('ms-banking:client:SetBankClosed', function(BankId, bool)
  banks[BankId].Closed = bool
end)

-- Display Map Blips
Citizen.CreateThread(function()
  if (displayBankBlips == true) then
    for _, item in pairs(banks) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipColour(item.blip, 0)
        SetBlipScale(item.blip, 0.6)
        SetBlipAsShortRange(item.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
  end

  if (displayAtmBlips == true) then
    for _, item in pairs(atms) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipScale(item.blip, 0.65)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
  end
end)

-- NUI Variables
local atBank = false
local atATM = false
local bankOpen = false
local atmOpen = false

-- Open Gui and Focus NUI
function openGui()
  local ped = GetPlayerPed(-1)
  local playerPed = GetPlayerPed(-1)
  local PlayerData = MSCore.Functions.GetPlayerData()
  TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, true)
  MSCore.Functions.Progressbar("use_bank", "A ler o cartão de credito...", 2500, false, true, {}, {}, {}, {}, function() -- Done
      ClearPedTasksImmediately(ped)
      SetNuiFocus(true, true)
      SendNUIMessage({
        openBank = true,
        PlayerData = PlayerData
      })
  end, function() -- Cancel
      ClearPedTasksImmediately(ped)
      MSCore.Functions.Notify("Cancelado..", "error")
  end)
end

-- Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
end

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        inRange = false

        local pos = GetEntityCoords(GetPlayerPed(-1))
        local nearbank, bankkey = IsNearBank()

        if nearbank then
          atBank = true
          inRange = true
          if not banks[bankkey].Closed then
            DrawMarker(2, banks[bankkey].x, banks[bankkey].y, banks[bankkey].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 55, 255, 55, 255, 0, 0, 0, 1, 0, 0, 0)
            DrawText3Ds(banks[bankkey].x, banks[bankkey].y, banks[bankkey].z + 0.3, '[E] Inserir cartão')
            if IsControlJustPressed(1, Keys["E"])  then
                if (not IsInVehicle()) then
                    if bankOpen then
                        closeGui()
                        bankOpen = false
                    else
                        openGui()
                        bankOpen = true
                    end
                end
            end
          else
            DrawText3Ds(banks[bankkey].x, banks[bankkey].y, banks[bankkey].z + 0.3, 'O bank esta fechado')
            DrawMarker(2, banks[bankkey].x, banks[bankkey].y, banks[bankkey].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 255, 55, 55, 255, 0, 0, 0, 1, 0, 0, 0)
          end
        elseif IsNearATM() then
          atBank = true
          inRange = true
          DrawText3Ds(pos.x, pos.y, pos.z, '[E] Inserir cartão')
          if IsControlJustPressed(1, Keys["E"])  then
              if (not IsInVehicle()) then
                  if bankOpen then
                      closeGui()
                      bankOpen = false
                  else
                      openGui()
                      bankOpen = true
                  end
              end
          end
        end

        if not inRange then
          Citizen.Wait(1500)
        end
    end
end)

-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if bankOpen or atmOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
  cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
  SendNUIMessage({openSection = "deposit"})
  cb('ok')
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
  TriggerServerEvent('bank:withdraw', data.amount)
  SetTimeout(500, function()
    local PlayerData = MSCore.Functions.GetPlayerData()
    SendNUIMessage({
      updateBalance = true,
      PlayerData = PlayerData
    })
  end)
  cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
  TriggerServerEvent('bank:deposit', data.amount)
  SetTimeout(500, function()
    local PlayerData = MSCore.Functions.GetPlayerData()
    SendNUIMessage({
      updateBalance = true,
      PlayerData = PlayerData
    })
  end)
  cb('ok')
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  local fromPlayer = GetPlayerServerId();
  TriggerEvent('bank:transfer', tonumber(fromPlayer), tonumber(data.toPlayer), tonumber(data.amount))
  cb('ok')
end)

-- Check if player is near an atm
function IsNearATM()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for k, v in pairs(ATMObjects) do
    local closestObj = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, v, false, 0, 0)
    local objCoords = GetEntityCoords(closestObj)
    if closestObj ~= 0 then
      local dist = GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, objCoords.x, objCoords.y, objCoords.z, true)
      if dist <= 2 then
        return true
      end
    end
  end
  return false
end

-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near a bank
function IsNearBank()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for key, item in pairs(banks) do
    local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 2) then
      return true, key
    end
  end
end

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = GetDistanceBetweenCoords(ply2Coords["x"], ply2Coords["y"], ply2Coords["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
  if(distance <= 5) then
    return true
  end
end

function GetClosestPlayer()
  local closestPlayers = MSCore.Functions.GetPlayersFromCoords()
  local closestDistance = -1
  local closestPlayer = -1
  local coords = GetEntityCoords(GetPlayerPed(-1))

  for i=1, #closestPlayers, 1 do
      if closestPlayers[i] ~= PlayerId() then
          local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
          local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

          if closestDistance == -1 or closestDistance > distance then
              closestPlayer = closestPlayers[i]
              closestDistance = distance
          end
      end
end

return closestPlayer, closestDistance
end

RegisterNetEvent('banking:client:CheckDistance')
AddEventHandler('banking:client:CheckDistance', function(targetId, amount)
  local player, distance = GetClosestPlayer()
  if player ~= -1 and distance < 2.5 then
    local playerId = GetPlayerServerId(player)
    if targetId == playerId then
      TriggerServerEvent('banking:server:giveCash', playerId, amount)
    end
  else
    MSCore.Functions.Notify('Não tens ninguem por perto...', 'error')
  end
end)