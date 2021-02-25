rightPosition = {x = 1450, y = 100}
leftPosition = {x = 0, y = 100}
menuPosition = {x = 0, y = 200}

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
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

if Config.MenuPosition then
  if Config.MenuPosition == "left" then
    menuPosition = leftPosition
  elseif Config.MenuPosition == "right" then
    menuPosition = rightPosition
  end
end

if Config.CustomMenuEnabled then
  local RuntimeTXD = CreateRuntimeTxd('Custom_Menu_Head')
  local Object = CreateDui(Config.MenuImage, 512, 128)
  _G.Object = Object
  local TextureThing = GetDuiHandle(Object)
  local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'Custom_Menu_Head', TextureThing)
  Menuthing = "Custom_Menu_Head"
else
  Menuthing = "shopui_title_sm_hangar"
end

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Animações", "", menuPosition["x"], menuPosition["y"], Menuthing, Menuthing)
_menuPool:Add(mainMenu)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local EmoteTable = {}
local FavEmoteTable = {}
local DanceTable = {}
local PropETable = {}
local WalkTable = {}
local FaceTable = {}
local FavoriteEmote = ""

Citizen.CreateThread(function()
  while true do
    if Config.FavKeybindEnabled then
      if IsControlPressed(0, Keys["F3"]) then
        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
          if FavoriteEmote ~= "" then
            EmoteCommandStart({FavoriteEmote, 0})
            Wait(3000)
          end
        end
      end
    end
    Citizen.Wait(1)
  end
end)

function AddEmoteMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Animações", "", "", Menuthing, Menuthing)
    local dancemenu = _menuPool:AddSubMenu(submenu, "🕺 Animações de Dança", "", "", Menuthing, Menuthing)
    local propmenu = _menuPool:AddSubMenu(submenu, "📦 Animações com Props", "", "", Menuthing, Menuthing)
    --favmenu:AddItem(unbind2item)
    table.insert(EmoteTable, "🕺 Animações de Dança")
    table.insert(EmoteTable, "🕺 Animações de Dança")

    for a,b in pairsByKeys(AnimationList.Emotes) do
      x,y,z = table.unpack(b)
      emoteitem = NativeUI.CreateItem(z, "/a ("..a..")")
      favemoteitem = NativeUI.CreateItem(z)
      submenu:AddItem(emoteitem)
      --favmenu:AddItem(favemoteitem)
      table.insert(EmoteTable, a)
      table.insert(FavEmoteTable, a)
    end

    for a,b in pairsByKeys(AnimationList.Dances) do
      x,y,z = table.unpack(b)
      danceitem = NativeUI.CreateItem(z, "/a ("..a..")")
      dancemenu:AddItem(danceitem)
      table.insert(DanceTable, a)
    end

    for a,b in pairsByKeys(AnimationList.PropEmotes) do
      x,y,z = table.unpack(b)
      propitem = NativeUI.CreateItem(z, "/a ("..a..")")
      propfavitem = NativeUI.CreateItem(z)
      propmenu:AddItem(propitem)
      -- favmenu:AddItem(propfavitem)
      table.insert(PropETable, a)
      table.insert(FavEmoteTable, a)
    end

    dancemenu.OnItemSelect = function(sender, item, index)
      EmoteMenuStart(DanceTable[index], "dances")
    end

    propmenu.OnItemSelect = function(sender, item, index)
      EmoteMenuStart(PropETable[index], "props")
    end

    submenu.OnItemSelect = function(sender, item, index)
     if EmoteTable[index] ~= "🌟 Keybind" then
      EmoteMenuStart(EmoteTable[index], "emotes")
    end
  end
end

function AddCancelEmote(menu)
    local newitem = NativeUI.CreateItem("Stop Emote ", "~r~X~w~ Parar emote")
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, checked_)
        if item == newitem then
          EmoteCancel()
          DestroyAllProps()
        end
    end
end

function AddWalkMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Formas de Andar", "", "", Menuthing, Menuthing)

    walkreset = NativeUI.CreateItem("Normal (Reset)", "Default")
    submenu:AddItem(walkreset)
    table.insert(WalkTable, "Reset para default")

    WalkInjured = NativeUI.CreateItem("Injured", "")
    submenu:AddItem(WalkInjured)
    table.insert(WalkTable, "move_m@injured")

    for a,b in pairsByKeys(AnimationList.Walks) do
      x = table.unpack(b)
      walkitem = NativeUI.CreateItem(a, "")
      submenu:AddItem(walkitem)
      table.insert(WalkTable, x)
    end

    submenu.OnItemSelect = function(sender, item, index)
      if item ~= walkreset then
        WalkMenuStart(WalkTable[index])
      else
        ResetPedMovementClipset(PlayerPedId())
      end
    end
end

function AddFaceMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Moods", "", "", Menuthing, Menuthing)

    facereset = NativeUI.CreateItem("Normal (Reset)", "Reset para default")
    submenu:AddItem(facereset)
    table.insert(FaceTable, "")

    for a,b in pairsByKeys(AnimationList.Expressions) do
      x,y,z = table.unpack(b)
      faceitem = NativeUI.CreateItem(a, "")
      submenu:AddItem(faceitem)
      table.insert(FaceTable, a)
    end

    submenu.OnItemSelect = function(sender, item, index)
      if item ~= facereset then
        EmoteMenuStart(FaceTable[index], "expression")
      else
        ClearFacialIdleAnimOverride(PlayerPedId())
      end
    end
end

function AddInfoMenu(menu)
    local infomenu = _menuPool:AddSubMenu(menu, "Info / Update notes", "Check here for update notes (1.5.1a)", "", Menuthing, Menuthing)
    contact = NativeUI.CreateItem("Suggestions?", "'dullpear_dev' on FiveM forums for any feature/emote suggestions! ✉️")
    u151a = NativeUI.CreateItem("1.5.1a", "Fixed tryclothes/2, changed the guitar emotes slightly and changed facial expressions to 'moods'")
    u151 = NativeUI.CreateItem("1.5.1", "Added /walk and /walks, for walking styles without menu")
    u150 = NativeUI.CreateItem("1.5.0", "Added Facial Expressions menu (if enabled by server owner)")
    u142 = NativeUI.CreateItem("1.4.2", "Added many new prop emotes (guitar-guitar3, book, bouquet, teddy, backpack, burger and more)")
    infomenu:AddItem(contact)
    infomenu:AddItem(u151a)
    infomenu:AddItem(u151)
    infomenu:AddItem(u150)
    infomenu:AddItem(u142)
end

function OpenEmoteMenu()
    mainMenu:Visible(not mainMenu:Visible())
end

RegisterNetEvent('animations:client:ToggleMenu')
AddEventHandler('animations:client:ToggleMenu', function()
  if CanDoEmote then
    OpenEmoteMenu()
  else
    QBCore.Functions.Notify("Não podes fazer emotes neste momento", "error")
  end
end)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

AddEmoteMenu(mainMenu)
--AddCancelEmote(mainMenu)
if Config.WalkingStylesEnabled then
  AddWalkMenu(mainMenu)
end
if Config.ExpressionsEnabled then
  AddFaceMenu(mainMenu)
end
--AddInfoMenu(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
    end
end)

