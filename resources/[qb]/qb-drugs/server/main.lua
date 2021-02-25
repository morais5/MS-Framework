QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

-- Citizen.CreateThread(function()
--     local Hour = (60 * 1000) * 60
--     SetTimeout(math.random((Hour * 1), (Hour * 3)), function()
--         table.insert(Config.Dealers[2]["products"], {
--             name = "weapon_snspistol",
--             price = 5000,
--             amount = 1,
--             info = {
--                 serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
--             },
--             type = "item",
--             slot = 5,
--             minrep = 200,
--         })
--         table.insert(Config.Dealers[3]["products"], {
--             name = "weapon_snspistol",
--             price = 5000,
--             amount = 1,
--             info = {
--                 serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
--             },
--             type = "item",
--             slot = 5,
--             minrep = 200,
--         })
--         TriggerClientEvent('qb-drugs:AddWeapons', -1)
--     end)
-- end)

