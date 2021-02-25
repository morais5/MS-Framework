local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)

Citizen.CreateThread(function()
	LoadInterior(Interior)
end)
