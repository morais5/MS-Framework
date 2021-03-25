local RecentLogs = {}

local function LogClientError(resource, err)
    local src = source
    if not src or not resource or not err then return end

    if #err > 3000 then return end

    local recent = RecentLogs[src]
    if recent and GetGameTimer() - recent < 2000 then return end
    RecentLogs[src] = GetGameTimer()

    local tmp = {
        time = os.date("%x - %I:%M:%S"),
        error = err,
        ownersrc = src,
        ownername = GetPlayerName(src),
        identifier = GetPlayerEndpoint(src),
        resource = resource
    }

    local formattedString = "%s: [%d]%s - %s - %s \n%s\n\n"
    formattedString = string.format(formattedString, tmp.time, tmp.ownersrc, tmp.ownername, tmp.identifier, tmp.resource, tmp.error)

    local dir = "errorlogs"
    local _file = string.format("%s/%s.txt", dir, tmp.identifier)
    local file = io.open(_file, "a")
    local cmd = string.format( "mkdir %s", dir)

    if not file then
        os.execute(cmd)
        file = io.open(_file, "a")
    end

    if file then
        file:write(formattedString)
        file:close()
    end
end

RegisterNetEvent("MG:LogClientError")
AddEventHandler("MG:LogClientError", LogClientError)