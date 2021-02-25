local resource = GetCurrentResourceName()

function error(...)
    print(string.format("------------------ ERROR IN RESOURCE: %s\n%s\n------------------ END OF ERROR", resource, ...))
    TriggerServerEvent("MG:LogClientError", resource, ...)
end