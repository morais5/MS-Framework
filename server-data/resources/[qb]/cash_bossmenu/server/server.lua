QBCore = nil
Accounts = {}
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
CreateThread(function()
    Wait(500)
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "./database.json"))

    if not result then
        return
    end

    for k,v in pairs(result) do
        local k = tostring(k)
        local v = tonumber(v)

        if k and v then
            Accounts[k] = v
        end
    end
end)

RegisterServerEvent("cash_bossmenu:server:withdrawMoney")
AddEventHandler("cash_bossmenu:server:withdrawMoney", function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if Accounts[job] >= amount then
        Accounts[job] = Accounts[job] - amount
        xPlayer.Functions.AddMoney("cash", amount)
    else
        TriggerClientEvent('QBCore:Notify', src, "Montante inválido :/", "error")
        return
    end

    TriggerClientEvent('cash_bossmenu:client:refreshSociety', -1, job, Accounts[job])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent('cash_logs:server:createLog', 'bossmenu', 'Retirar dinheiro', "Retirado com sucesso €" .. amount .. ' (' .. job .. ')', src)
end)

RegisterServerEvent("cash_bossmenu:server:depositMoney")
AddEventHandler("cash_bossmenu:server:depositMoney", function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if xPlayer.Functions.RemoveMoney("cash", amount) then
        Accounts[job] = Accounts[job] + amount
    else
        TriggerClientEvent('QBCore:Notify', src, "Montante inválido :/", "error")
        return
    end

    TriggerClientEvent('cash_bossmenu:client:refreshSociety', -1, job, Accounts[job])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent('cash_logs:server:createLog', 'bossmenu', 'Depositar dinheiro', "Depositado com sucesso €" .. amount .. ' (' .. job .. ')', src)
end)

RegisterServerEvent("cash_bossmenu:server:addAccountMoney")
AddEventHandler("cash_bossmenu:server:addAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end
    
    Accounts[account] = Accounts[account] + amount
    TriggerClientEvent('cash_bossmenu:client:refreshSociety', -1, account, Accounts[account])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("cash_bossmenu:server:removeAccountMoney")
AddEventHandler("cash_bossmenu:server:removeAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end

    if Accounts[account] >= amount then
        Accounts[account] = Accounts[account] - amount
    end

    TriggerClientEvent('cash_bossmenu:client:refreshSociety', -1, account, Accounts[account])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("cash_bossmenu:server:openMenu")
AddEventHandler("cash_bossmenu:server:openMenu", function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job
    --local job2 = xPlayer.PlayerData.job.isboss
    local employees = {}
    if job.isboss == true then
        if not Accounts[job.name] then
            Accounts[job.name] = 0
        end

        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `job` LIKE '%".. job.name .."%'", function(players)
            if players[1] ~= nil then
                for key, value in pairs(players) do
                    local isOnline = QBCore.Functions.GetPlayerByCitizenId(value.citizenid)

                    if isOnline then
                        table.insert(employees, {
                            source = isOnline.PlayerData.citizenid, 
                            grade = isOnline.PlayerData.job.grade,
                            isboss = isOnline.PlayerData.job.isboss,
                            name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                        })
                    else
                        table.insert(employees, {
                            source = value.citizenid, 
                            grade =  json.decode(value.job).grade,
                            isboss = json.decode(value.job).isboss,
                            name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                        })
                    end
                end
            end

            TriggerClientEvent('cash_bossmenu:client:openMenu', src, employees, QBCore.Shared.Jobs[job.name])
            TriggerClientEvent('cash_bossmenu:client:refreshSociety', -1, job.name, Accounts[job.name])
        end)
    else
    TriggerClientEvent('QBCore:Notify', src, "Você não é o chefe, como chegou aqui vadia?!", "error")
    end
end)


RegisterServerEvent('cash_bossmenu:server:fireEmployee')
AddEventHandler('cash_bossmenu:server:fireEmployee', function(data)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xEmployee = QBCore.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob("unemployed", '0') then
            TriggerEvent('cash_logs:server:createLog', 'bossmenu', 'Tirar do emprego', "Disparado com sucesso " .. GetPlayerName(xEmployee.PlayerData.source) .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)

            TriggerClientEvent('QBCore:Notify', src, "Despedido com sucesso!", "success")
            TriggerClientEvent('QBCore:Notify', xEmployee.PlayerData.source , "Você foi demitido.", "success")

            Wait(500)
            local employees = {}
            QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = QBCore.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end
                    TriggerClientEvent('cash_bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, "ERRO.", "error")
        end
    else
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '" .. data.source .. "' LIMIT 1", function(player)
            if player[1] ~= nil then
                xEmployee = player[1]

                local job = {}
	            job.name = "unemployed"
	            job.label = "Desempregado"
	            job.payment = 10
	            job.onduty = true
	            job.isboss = false
	            job.grade = {}
	            job.grade.name = nil
                job.grade.level = 0

                QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `job` = '"..json.encode(job).."' WHERE `citizenid` = '".. data.source .."'")
                TriggerClientEvent('QBCore:Notify', src, "Despedido com sucesso!", "success")
                TriggerEvent('cash_logs:server:createLog', 'bossmenu', 'Despedido', "Disparado com sucesso " .. data.source .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)
                
                Wait(500)
                local employees = {}
                QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = QBCore.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('cash_bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('QBCore:Notify', src, "Erro. Não foi possível encontrar jogador.", "error")
            end
        end)
    end
end)

RegisterServerEvent('cash_bossmenu:server:giveJob')
AddEventHandler('cash_bossmenu:server:giveJob', function(data)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xTarget = QBCore.Functions.GetPlayerByCitizenId(data.source)

    if xPlayer.PlayerData.job.isboss == true then
        if xTarget and xTarget.Functions.SetJob(xPlayer.PlayerData.job.name) then
            TriggerClientEvent('QBCore:Notify', src, "Você recrutou " .. (xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname) .. " para " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerClientEvent('QBCore:Notify', xTarget.PlayerData.source , "Você foi recrutado para " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerEvent('cash_logs:server:createLog', 'bossmenu', 'Recrutado', "Recrutado com sucesso " .. (xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname) .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Você não é o chefe, como chegou aqui vadia?!", "error")
    end
end)

RegisterServerEvent('cash_bossmenu:server:updateGrade')
AddEventHandler('cash_bossmenu:server:updateGrade', function(data)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xEmployee = QBCore.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob(xPlayer.PlayerData.job.name, data.grade) then
            TriggerClientEvent('QBCore:Notify', src, "Promovido com sucesso!", "success")
            TriggerClientEvent('QBCore:Notify', xEmployee.PlayerData.source , "Você acabou de ser promovido [" .. data.grade .."].", "success")

            Wait(500)
            local employees = {}
            QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = QBCore.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end

                    TriggerClientEvent('cash_bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, "Error.", "error")
        end
    else
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '" .. data.source .. "' LIMIT 1", function(player)
            if player[1] ~= nil then
                xEmployee = player[1]
                local job = QBCore.Shared.Jobs[xPlayer.PlayerData.job.name]
                local employeejob = json.decode(xEmployee.job)
                employeejob.grade = job.grades[data.grade]
                QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `job` = '"..json.encode(employeejob).."' WHERE `citizenid` = '".. data.source .."'")
                TriggerClientEvent('QBCore:Notify', src, "Promovido com sucesso!", "success")
                
                Wait(500)
                local employees = {}
                QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = QBCore.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('cash_bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('QBCore:Notify', src, "Erro. Não foi possível encontrar jogador.", "error")
            end
        end)
    end
end)

RegisterServerEvent('cash_bossmenu:server:updateNearbys')
AddEventHandler('cash_bossmenu:server:updateNearbys', function(data)
    local src = source
    local players = {}
    local xPlayer = QBCore.Functions.GetPlayer(src)
    for _, player in pairs(data) do
        local xTarget = QBCore.Functions.GetPlayer(player)
        if xTarget and xTarget.PlayerData.job.name ~= xPlayer.PlayerData.job.name then
            table.insert(players, {
                source = xTarget.PlayerData.citizenid,
                name = xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname
            })
        end
    end

    TriggerClientEvent('cash_bossmenu:client:refreshPage', src, 'recruits', players)
end)

function GetAccount(account)
    return Accounts[account] or 0
end

function tprint (t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            tprint(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end 

