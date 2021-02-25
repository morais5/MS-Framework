# WarMenu
Fork of @MrDaGree  [GUI Management (Maker) | Mod Menu Style Menus (uhh.. ya)](https://forum.fivem.net/t/release-gui-management-maker-mod-menu-style-menus-uhh-ya)


## How to Install
Use it as separate resource and add `client_script '@warmenu/warmenu.lua'` in your `__resource.lua`


## Features
* Original GTA V look 'n' feel
* Customize each menu separately
* Create nested menus in one line
* It sounds


## Usage
```lua
Citizen.CreateThread(function()
	local items = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" }
	local currentItemIndex = 1
	local selectedItemIndex = 1
	local checkbox = true

	WarMenu.CreateMenu('test', 'Test title')
	WarMenu.CreateSubMenu('closeMenu', 'test', 'Are you sure?')

	while true do
		if WarMenu.IsMenuOpened('test') then
			if WarMenu.CheckBox('Checkbox', checkbox) then
				checkbox = not checkbox
				-- Do your stuff here
			elseif WarMenu.ComboBox('Combobox', items, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
					currentItemIndex = currentIndex
					selectedItemIndex = selectedIndex

					-- Do your stuff here if current index was changed (don't forget to check it)
				end) then
					-- Do your stuff here if current item was activated
			elseif WarMenu.MenuButton('Exit', 'closeMenu') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('closeMenu') then
			if WarMenu.Button('Yes') then
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('No', 'test') then
			end

			WarMenu.Display()
		elseif IsControlJustReleased(0, 244) then -- M by default
			WarMenu.OpenMenu('test')
		end

		Citizen.Wait(0)
	end
end)
```


## API
```lua
WarMenu.debug = bool --false by default

WarMenu.CreateMenu(id, title)
WarMenu.CreateSubMenu(id, parent, subTitle)

WarMenu.CurrentMenu() -- id

WarMenu.OpenMenu(id)
WarMenu.IsMenuOpened(id)
WarMenu.IsAnyMenuOpened()
WarMenu.IsMenuAboutToBeClosed() -- return true if current menu will be closed in next frame
WarMenu.CloseMenu()

-- Controls return true if activated
WarMenu.Button(text) 
WarMenu.MenuButton(text, id)
WarMenu.CheckBox(text, bool, callback)
WarMenu.ComboBox(text, items, currentIndex, selectedIndex, callback)
-- Use them in loop to draw

WarMenu.Display() -- Processing key events and menu logic, use it in loop


-- Customizable options
WarMenu.SetMenuWidth(id, width) -- [0.0..1.0]
WarMenu.SetMenuX(id, x) -- [0.0..1.0] top left corner
WarMenu.SetMenuY(id, y) -- [0.0..1.0] top
WarMenu.SetMenuMaxOptionCountOnScreen(id, count) -- 10 by default

WarMenu.SetTitleColor(id, r, g, b, a)
WarMenu.SetTitleBackgroundColor(id, r, g, b, a)
-- or
WarMenu.SetTitleBackgroundSprite(id, textureDict, textureName)

WarMenu.SetSubTitle(id, text) -- it will uppercase automatically

WarMenu.SetMenuBackgroundColor(id, r, g, b, a)
WarMenu.SetMenuTextColor(id, r, g, b, a)
WarMenu.SetMenuSubTextColor(id, r, g, b, a)
WarMenu.SetMenuFocusColor(id, r, g, b, a)

WarMenu.SetMenuButtonPressedSound(id, name, set) -- https://pastebin.com/0neZdsZ5
```


## Changelog
### 0.9.8
* Added new `WarMenu.IsAnyMenuOpened()` API
* Added new `WarMenu.SetTitleBackgroundSprite()` API
### 0.9.7
* Added new `WarMenu.SetMenuSubTextColor()` API
* @alberto2345: Added alpha parameters to color functions (with default values, so no worry for existing code)
* Improved default `subText` color (see image)
* Fixed flickering after reopening menu
* @alberto2345: Fixed button execution after reopening menu
* Fixed `subTitle` sub menu initializing
* Corrected `WarMenu.CheckBox` usage example
### 0.9.6
* Added new `WarMenu.IsMenuAboutToBeClosed()` API
* Fixed `WarMenu.MenuButton` bug with unnecessary attempts to draw it without current menu
* Fixed `WarMenu.ComboBox` bug with incorrect current index after reopening menu
### 0.9.5
* Changed `WarMenu.ComboBox` control behavior and look - you need to press SELECT in order to confirm your choice.
Also, it has two indexes now - for a current displaying item and user-selected one.
It allows you create more complex menus like Los Santos Customs with Preview Mode.
And don't forget to check new sexy arrows. :wink:
See updated Usage section for more info.
* Added new `SetMenuButtonPressedSound(id, name, set)` API
* Highly improved Debug Mode - more helpful information, better readability
* `SetTitleWrap()` and `SetTitleScale()` APIs were removed due to text alignment complexity
* Fixed lots of potential bugs with Debug Mode
* Code cleaning and refactoring as well as bug fixes
### 0.9
* Initial release