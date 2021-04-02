MSCore = {}
MSCore.Config = MSConfig
MSCore.Shared = MShared
MSCore.ServerCallbacks = {}
MSCore.UseableItems = {}

function GetCoreObject()
	return MSCore
end

RegisterServerEvent('MSCore:GetObject')
AddEventHandler('MSCore:GetObject', function(cb)
	cb(GetCoreObject())
end)