MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)
local loggingApi = "https://msus.onno204.nl/msus-management/backend/fivem/log"

RegisterServerEvent('ms-log:server:CreateLog')
AddEventHandler('ms-log:server:CreateLog', function(name, title, color, message, tagEveryone)
    if source ~= 0 then  -- Prevents everyone abusing logs.
        local tag = tagEveryone ~= nil and tagEveryone or false
        local webHook = Config.Webhooks[name] ~= nil and Config.Webhooks[name] or Config.Webhooks["default"]
        local embedData = {
            {
                ["title"] = title,
                ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
                ["footer"] = {
                    ["text"] = os.date("%c"),
                },
                ["description"] = message,
            }
        }
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Morais Scripts Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
        Citizen.Wait(100)
        if tag then
            PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Morais Scripts Logs", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
        end
    end
end)

RegisterServerEvent('ms-log:server:sendLog')
AddEventHandler('ms-log:server:sendLog', function(citizenid, logtype, data)
    if source ~= 0 then  -- Prevents everyone abusing logs.
        local dataString = ""
        data = data ~= nil and data or {}
        for key,value in pairs(data) do 
            if dataString ~= "" then
                dataString = dataString .. "&"
            end
            dataString = dataString .. key .."="..value
        end
        local requestUrl = string.format("%s?citizenid=%s&logtype=%s&%s", loggingApi, citizenid, logtype, dataString)
        requestUrl = string.gsub(requestUrl, ' ', "%%20")
        PerformHttpRequest(requestUrl, function(err, text, headers) end, 'GET', '')
    end
end)

MSCore.Commands.Add("testwebhook", ":)", {}, false, function(source, args)
    TriggerEvent("ms-log:server:CreateLog", "default", "TestWebhook", "default", "Triggered **a** test webhook :)")
end, "god")