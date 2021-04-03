MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

function round(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local src = source
	local pData = MSCore.Functions.GetPlayer(src)
	local amount = round(price)

	if pData.Functions.RemoveMoney('cash', amount, "bought-fuel") then
		TriggerClientEvent("MSCore:Notify", src, "Your vehicle has been refilled", "success")
	end
end)
