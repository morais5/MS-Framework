local PreviousWalkset = nil

function WalkMenuStart(name)
  RequestWalking(name)
  SetPedMovementClipset(PlayerPedId(), name, 0.2)
  TriggerEvent("crouchprone:client:SetWalkSet", name)
  RemoveAnimSet(name)
  PreviousWalkset = name
end

function RequestWalking(set)
  RequestAnimSet(set)
  while not HasAnimSetLoaded(set) do
    Citizen.Wait(1)
  end 
end

function WalksOnCommand(source, args, raw)
  local WalksCommand = ""
  for a in pairsByKeys(AnimationList.Walks) do
    WalksCommand = WalksCommand .. ""..string.lower(a)..", "
  end
  --EmoteChatMessage(WalksCommand)
  --EmoteChatMessage("To reset do /walk reset")
end

function WalkCommandStart(source, args, raw)
  local name = firstToUpper(args[1])

  if name == "Reset" then
      ResetPedMovementClipset(PlayerPedId()) return
  end

  local name2 = table.unpack(AnimationList.Walks[name])
  if name2 ~= nil then
    WalkMenuStart(name2)
  else
    --EmoteChatMessage("'"..name.."' is not a valid walk")
  end
end

local WalkstickUsed = false
local WandelstokObject = nil

RegisterNetEvent('animations:UseWandelStok')
AddEventHandler('animations:UseWandelStok', function()
  if not WalkstickUsed then
    local ped = GetPlayerPed(-1)
    RequestAnimSet('move_heist_lester')
    while not HasAnimSetLoaded('move_heist_lester') do
      Citizen.Wait(1)
    end
    SetPedMovementClipset(ped, 'move_heist_lester', 1.0) 
    WandelstokObject = CreateObject(GetHashKey("prop_cs_walking_stick"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(WandelstokObject, ped, GetPedBoneIndex(ped, 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
  else
    local ped = GetPlayerPed(-1)
    if PreviousWalkset ~= nil then
      RequestAnimSet(PreviousWalkset)
      while not HasAnimSetLoaded(PreviousWalkset) do
        Citizen.Wait(1)
      end
      SetPedMovementClipset(ped, PreviousWalkset, 1.0)
    end
    DetachEntity(WandelstokObject, 0, 0)
    DeleteEntity(WandelstokObject)
  end
  WalkstickUsed = not WalkstickUsed
end)