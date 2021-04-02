MSCore = nil

TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)

--CODE

local Races = {}
RegisterServerEvent('ms-streetraces:NewRace')
AddEventHandler('ms-streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local xPlayer = MSCore.Functions.GetPlayer(src)
    if xPlayer.Functions.RemoveMoney('cash', RaceTable.amount, "streetrace-created") then
        Races[RaceId] = RaceTable
        Races[RaceId].creator = GetPlayerIdentifiers(src)[1]
        table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
        TriggerClientEvent('ms-streetraces:SetRace', -1, Races)
        TriggerClientEvent('ms-streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('MSCore:Notify', src, "You joind the race for $"..Races[RaceId].amount..",-", 'success')
    end
end)

RegisterServerEvent('ms-streetraces:RaceWon')
AddEventHandler('ms-streetraces:RaceWon', function(RaceId)
    local src = source
    local xPlayer = MSCore.Functions.GetPlayer(src)
    xPlayer.Functions.AddMoney('cash', Races[RaceId].pot, "race-won")
    TriggerClientEvent('MSCore:Notify', src, "You won the race and $"..Races[RaceId].pot..",- recieved", 'success')
    TriggerClientEvent('ms-streetraces:SetRace', -1, Races)
    TriggerClientEvent('ms-streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterServerEvent('ms-streetraces:JoinRace')
AddEventHandler('ms-streetraces:JoinRace', function(RaceId)
    local src = source
    local xPlayer = MSCore.Functions.GetPlayer(src)
    local zPlayer = MSCore.Functions.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if xPlayer.PlayerData.money.cash >= Races[RaceId].amount then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
            if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount, "streetrace-joined") then
                TriggerClientEvent('ms-streetraces:SetRace', -1, Races)
                TriggerClientEvent('ms-streetraces:SetRaceId', src, RaceId)
                TriggerClientEvent('MSCore:Notify', zPlayer.PlayerData.source, GetPlayerName(src).." Joined the race", 'primary')
            end
        else
            TriggerClientEvent('MSCore:Notify', src, "You dont have enough cash", 'error')
        end
    else
        TriggerClientEvent('MSCore:Notify', src, "The person wo made the race is offline!", 'error')
        Races[RaceId] = {}
    end
end)

MSCore.Commands.Add("race", "A street race has started.", {{name="bedrag", help="The stake amount for the race."}}, true, function(source, args)
    local src = source
    local xPlayer = MSCore.Functions.GetPlayer(src)
    local amount = tonumber(args[1])
    if GetJoinedRace(GetPlayerIdentifiers(src)[1]) == 0 then
        if xPlayer.PlayerData.money.cash >= amount then
            TriggerClientEvent('ms-streetraces:CreateRace', src, amount)
        else
            TriggerClientEvent('MSCore:Notify', src, "You don't have enough cash in your pocket", 'error')
        end
    else
        TriggerClientEvent('MSCore:Notify', src, "Your already in a race!", 'error')
    end
end)

MSCore.Commands.Add("stoprace", "Stop a race as creator.", {}, false, function(source, args)
    local src = source
    CancelRace(src)
end)

MSCore.Commands.Add("quitrace", "Quiting the race. (You wont get ur money back)", {}, false, function(source, args)
    local src = source
    local xPlayer = MSCore.Functions.GetPlayer(src)
    local RaceId = GetJoinedRace(GetPlayerIdentifiers(src)[1])
    local zPlayer = MSCore.Functions.GetPlayer(Races[RaceId].creator)
    if RaceId ~= 0 then
        if GetCreatedRace(GetPlayerIdentifiers(src)[1]) ~= RaceId then
            RemoveFromRace(GetPlayerIdentifiers(src)[1])
            TriggerClientEvent('MSCore:Notify', src, "You quited the race and wont get ur money back", 'error')
            TriggerClientEvent('esx:showNotification', zPlayer.PlayerData.source, GetPlayerName(src) .." has quited the race!", "red")
        else
            TriggerClientEvent('MSCore:Notify', src, "/stoprace to stop the race", 'error')
        end
    else
        TriggerClientEvent('MSCore:Notify', src, "Your not in a race.", 'error')
    end
end)

MSCore.Commands.Add("startrace", "Starting race", {}, false, function(source, args)
    local src = source
    local RaceId = GetCreatedRace(GetPlayerIdentifiers(src)[1])
    
    if RaceId ~= 0 then
        Races[RaceId].started = true
        TriggerClientEvent('ms-streetraces:SetRace', -1, Races)
        TriggerClientEvent("ms-streetraces:StartRace", -1, RaceId)
    else
        TriggerClientEvent('MSCore:Notify', src, "You did not start a race", 'error')
    end
end)

function CancelRace(source)
    local xPlayer = MSCore.Functions.GetPlayer(source)
    local RaceId = GetCreatedRace(GetPlayerIdentifiers(source)[1])

    if RaceId ~= 0 then
        for key, race in pairs(Races) do
            if Races[key] ~= nil and Races[key].creator == xPlayer.PlayerData.steam then
                if not Races[key].started then
                    for _, iden in pairs(Races[key].joined) do
                        local xdPlayer = MSCore.Functions.GetPlayer(iden)
                        xdPlayer.Functions.AddMoney('cash', Races[key].amount, "race-cancelled")
                        TriggerClientEvent('MSCore:Notify', xdPlayer.PlayerData.source, "The race has stopped you recieved $"..Races[key].amount..",-Back", 'error')
                        TriggerClientEvent('ms-streetraces:StopRace', xdPlayer.PlayerData.source)
                        RemoveFromRace(iden)
                    end
                else
                    TriggerClientEvent('MSCore:Notify', xPlayer.PlayerData.source, "The race has already started..", 'error')
                end
                TriggerClientEvent('MSCore:Notify', source, "Race has been stopped!", 'error')
                Races[key] = nil
            end
        end
        TriggerClientEvent('ms-streetraces:SetRace', -1, Races)
    else
        TriggerClientEvent('MSCore:Notify', source, "You did not start a race!", 'error')
    end
end

function RemoveFromRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end
