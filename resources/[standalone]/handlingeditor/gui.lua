	function mysplit(inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t={} ; i=1
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			t[i] = str
			i = i + 1
		end
		return t
	end

Citizen.CreateThread(function()
	chdata = {} -- our table where we will store our handling information 
	
	WarMenu.CreateMenu('hedit', 'Handling Editor') -- gui creation stuff
	WarMenu.SetTitleColor('hedit', 0,0,0)
	WarMenu.SetTitleBackgroundColor('hedit', 80,80,80)
	while true do
		if WarMenu.IsMenuOpened('hedit') then
			for i,theKey in pairs(chdata) do
				if tonumber(theKey.value) then -- if the handling value is a number, we will round and trim it so it's not ridicilously long.
					theKey.value = math.floor(tonumber(theKey.value) * 10^(3) + 0.5) / 10^(3)
				end
				if type(theKey.value) == "vector3" then -- if the handling value is a vector3, we will unpack it and display it with commas
					local v1,v2,v3 = table.unpack(theKey.value)
					theKey.value = v1..","..v2..","..v3
				end
				theKey.value = tostring(theKey.value) -- convert it to a string for good measure
				
				if theKey.value and WarMenu.Button(theKey.name, theKey.value) then -- make sure we actually have a value and create the button so it can be "pressed"
						
					-- following is the onscreen keyboard code i use to select a new value, note that it will accept strings as of now
						
					AddTextEntry('FMMC_KEY_TIP12N', "Enter new "..theKey.name.." value :") 

					DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12N", "", theKey.value, "", "", "", 128 + 1)
				
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
				
					local result = GetOnscreenKeyboardResult()
				
					if result then
						-- do magic
						if theKey.type == "vector3" then
							local x,y,z = table.unpack( mysplit( result, "," ) )
							if x and y and z then
								result = vector3(tonumber(x),tonumber(y),tonumber(z))
							else
								break
							end
						end
						
						-- the onscreen keyboard code ends here
								
						SetVehicleHandlingData( GetVehiclePedIsIn( PlayerPedId(),false), theKey.name, result ) -- set the handling data we want for our vehicle
						Wait(200)
						chdata = GetAllVehicleHandlingData( GetVehiclePedIsIn( PlayerPedId(), false ) ) -- wait 200ms and refresh the handling data so we are up to date on what the new values are
					end
					
					
				end
			end
		
		WarMenu.Display()
		elseif IsControlJustReleased(0, 29) and GetVehiclePedIsIn( PlayerPedId(), false ) ~= 0 then -- Press B, also make sure we are in a vehicle otherwise the script will crash
			chdata = GetAllVehicleHandlingData( GetVehiclePedIsIn( PlayerPedId(), false ) ) -- get the new handling data
			WarMenu.OpenMenu('hedit') -- open the UI!
		end
		
		Citizen.Wait(0)
	end
	
	
end
)

