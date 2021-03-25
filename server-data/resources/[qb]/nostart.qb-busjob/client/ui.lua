--[[ ====================================================
                      UI Display TOGGLE.
			NIET SCHRIKKEN ONNO DIT IS OM TE TESTEN
				NIET TE VEEL OP DE CODE LETTEN
					NO TUCHY TUCHY ONNO
				  BEDANKT VOOR UW GEDULD
     ==================================================== ]]--	
mdt = true
first = false
bus_job = true

RegisterNetEvent("Toggle")
AddEventHandler("Toggle", function()
	if ( mdt ) then
		SendNUIMessage({
			meta = 'open'
		})
		mdt = false
	else
		SendNUIMessage({
			meta = 'close'
		})
		mdt = true
	end
end)

--[[ ====================================================
                      UI Screen updates.
     ==================================================== ]]--
	 
function deur(status)
	--deur('deur-closed')
	--deur('deur-open')
	SendNUIMessage({
		meta = status
	})
end

function stop(status)
	--stop('visible')
	--stop('hidden')
	SendNUIMessage({
		text = status,
		meta = 'stop'
	})
end

function halte(naam)
	SendNUIMessage({
		text = naam,
		meta = 'halte'
	})
end

function geld(amount)
	local stat = "€"..amount
	SendNUIMessage({
		text = stat,
		meta = 'geld'
	})
end

function lijn(nummer)
	--lijn(3)
	local buslijn = 'LIJN - '..nummer
	SendNUIMessage({
		text = buslijn,
		meta = 'lijn'
	})
end

function ShowUI(ui)
	if ui == 'open' then
		Wait(2000)
		SendNUIMessage({
			meta = 'open'
		})
		mdt = false
		first = true
	end
end


Citizen.CreateThread(function()

	local Ped = GetPlayerPed(-1)
	local PedId = PlayerPedId()
	local PedVehicle = GetVehiclePedIsIn(Ped)
	
	while true do
		Wait(7)
		
		if mdt == false then		
		uur = {
			[1] = '01', 
			[2] = '02', 
			[3] = '03', 
			[4] = '04',
			[5] = '05',
			[6] = '06',
			[7] = '07',
			[8] = '08',
			[9] = '09',
			[10] = '10',
			[11] = '11',
			[12] = '12',
			[13] = '13',
			[14] = '14',
			[15] = '15',
			[16] = '16',
			[17] = '17',
			[18] = '18',
			[19] = '19', 
			[20] = '20',
			[21] = '21',
			[22] = '22',
			[23] = '23', 
			[24] = '24', 
			[0] = '00'
		}
		local tmin = GetClockMinutes()
		local thou = GetClockHours()
			
			if (tmin < 10) then
				tminut = "0"..GetClockMinutes()
			else
				tminut = GetClockMinutes()
			end
			
			if (thou<10) then
				thour  = "0"..GetClockHours()
			else
				thour = GetClockHours()
			end

			SendNUIMessage({
				text = (thour .. ' : ' .. tminut),
				meta = 'tijd'
			})
			
		end
		
		if mdt ~= true then
			local Passengers = GetVehicleNumberOfPassengers(GetVehiclePedIsIn(GetPlayerPed(-1)))
			SendNUIMessage({
				text = (Passengers),
				meta = 'passengers'
			})
		end
		
		if mdt ~= true then
			CalculateDateToDisplay()
			SendNUIMessage({
				text = (dayOfMonth .. "-" .. month .. "-" .. year),
				meta = 'datum'
			})
		end
		
		if mdt ~= true then
			local fuel = GetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)))
			local width = ((fuel/100)*100)
			SendNUIMessage({
				text = (math.floor(fuel)),
				width = (width),
				meta = 'brandstof'
			})
		end
		
		if mdt == false and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) == false then
			SendNUIMessage({
				meta = 'close'
			})
			first = false
			mdt = true
		elseif mdt ~= false and first ~= true and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) == true and GetVehiclePedIsIn(GetPlayerPed(-1), true) == Bus and IsWorking_Bus == true then
			--print("BUS MODEL:"..GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)))
			--print("STOEL:"..GetSeatPedIsTryingToEnter(PlayerPedId()))
			Wait(1000)
				SendNUIMessage({
					meta = 'open'
				})
			first = true
			mdt = false
		end
		
		if mdt == false then
			local Speed1 = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
			local meta = 'speed'
		
			if Speed1 == 1 then
				local Speed = 0
			else
				Speed = Speed1
			end
			
			SendNUIMessage({
				text = (math.floor(Speed)),
				meta = meta
			})
		end
		
		local mdt = true
		if IsControlJustPressed(1, 214) or IsDisabledControlJustPressed(1, 214) then
			if IsWorking_Bus == true then
				if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and GetVehiclePedIsIn(GetPlayerPed(-1), true) == Bus then
					TriggerEvent("Toggle", source)
				else
					notification('Je moet in een ~g~Bus~s~ zitten om de ~b~~h~[UI]~h~ ~s~te openen!')
				end
			end
		end
	end
end)

--[[ ====================================================
                      Helper Functions.
     ====================================================]]--

function CalculateDateToDisplay()
	month = GetClockMonth()
	dayOfMonth = GetClockDayOfMonth()
	year = GetClockYear()
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
	 
function notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(false, false)
end

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end
