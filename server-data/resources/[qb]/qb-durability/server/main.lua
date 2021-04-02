QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local WeaponAmmo = {}

QBCore.Functions.CreateCallback("weapons:server:GetConfig", function(source, cb)
    cb(Config.WeaponRepairPoints)
end)

-- RegisterServerEvent("weapons:server:LoadWeaponAmmo")
-- AddEventHandler('weapons:server:LoadWeaponAmmo', function()
-- 	local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     WeaponAmmo[Player.PlayerData.citizenid] = {}
--     QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playerammo` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
--         if result[1] ~= nil then
--             local ammo = json.decode(result[1].ammo)
--             if ammo ~= nil then
--                 for ammotype, amount in pairs(ammo) do 
--                     WeaponAmmo[Player.PlayerData.citizenid][ammotype] = amount
--                 end
--             end
--         end
-- 	end)
-- end)

RegisterServerEvent("weapons:server:AddWeaponAmmo")
AddEventHandler('weapons:server:AddWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = tonumber(amount)

    if CurrentWeaponData ~= nil then
        if Player.PlayerData.items[CurrentWeaponData.slot] ~= nil then
            Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterServerEvent("weapons:server:UpdateWeaponAmmo")
AddEventHandler('weapons:server:UpdateWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = tonumber(amount)
    if CurrentWeaponData ~= nil then
        if Player.PlayerData.items[CurrentWeaponData.slot] ~= nil then
            Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

QBCore.Functions.CreateCallback("weapon:server:GetWeaponAmmo", function(source, cb, WeaponData)
    local Player = QBCore.Functions.GetPlayer(source)
    local retval = 0
    if WeaponData ~= nil then
        if Player ~= nil then
            local ItemData = Player.Functions.GetItemBySlot(WeaponData.slot)
            if ItemData ~= nil then
                retval = ItemData.info.ammo ~= nil and ItemData.info.ammo or 0
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateUseableItem("pistol_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_PISTOL", 12, item)
end)

QBCore.Functions.CreateUseableItem("rifle_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_RIFLE", 30, item)
end)

QBCore.Functions.CreateUseableItem("smg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SMG", 20, item)
end)

QBCore.Functions.CreateUseableItem("shotgun_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SHOTGUN", 10, item)
end)

QBCore.Functions.CreateUseableItem("mg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_MG", 30, item)
end)

function IsWeaponBlocked(WeaponName)
    local retval = false
    for _, name in pairs(Config.DurabilityBlockedWeapons) do
        if name == WeaponName then
            retval = true
            break
        end 
    end
    return retval
end

RegisterServerEvent('weapons:server:UpdateWeaponQuality')
AddEventHandler('weapons:server:UpdateWeaponQuality', function(data, RepeatAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local WeaponData = QBCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.UseMultiplier[data.name]

    if WeaponSlot ~= nil then
        if not IsWeaponBlocked(WeaponData.name) then
            if WeaponSlot.info.quality ~= nil then
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('QBCore:Notify', src, "Your weapon is broken, u need to repair it before u can use it again.", "error")
                        break
                    end
                end
            else
                WeaponSlot.info.quality = 100
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('QBCore:Notify', src, "Your weapon is broken, u need to repair it before u can use it again.", "error")
                        break
                    end
                end
            end
        end
    end

    Player.Functions.SetInventory(Player.PlayerData.items)
end)

RegisterServerEvent('weapons:server:UpdateItemQuality')
AddEventHandler('weapons:server:UpdateItemQuality', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ItemSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.UseMultiplier[data.name]
    local date = os.time(os.date("!*t"))

    if Config.UseMultiplier[data.name] ~= nil then
        if ItemSlot.info.quality ~= nil then
            if ItemSlot.info.quality - DecreaseAmount > 0 then
                ItemSlot.info.quality = ItemSlot.info.quality - DecreaseAmount / ItemSlot.amount
            else
                ItemSlot.info.quality = 0
                TriggerClientEvent('inventory:client:UseItem', src, data)
                TriggerClientEvent('QBCore:Notify', src, "Your item is broken and cant be used..", "error")
            end
        end
    end
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

QBCore.Commands.Add("repairweapon", "Repair weapon command for staf", {{name="hp", help="HP of your weapon"}}, true, function(source, args)
    TriggerClientEvent('weapons:client:SetWeaponQuality', source, tonumber(args[1]))
end, "god")

QBCore.Commands.Add("setdurability", "Set durability command for staf", {{name="slot", help="Slot of the item"}, {name="hp", help="HP of your weapon"}}, true, function(source, args)
    TriggerClientEvent('weapons:client:SetItemQuality', source, tonumber(args[1]), tonumber(args[2]))
end, "god")

RegisterServerEvent("weapons:server:SetWeaponQuality")
AddEventHandler("weapons:server:SetWeaponQuality", function(data, hp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local WeaponData = QBCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.UseMultiplier[data.name]
    WeaponSlot.info.quality = hp
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

RegisterServerEvent("weapons:server:SetItemQuality")
AddEventHandler("weapons:server:SetItemQuality", function(data, hp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemSlot = Player.Functions.GetItemBySlot(slot)
    local DecreaseAmount = Config.UseMultiplier[data.name]
    itemSlot = slot
    itemSlot.info.quality = hp
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

QBCore.Functions.CreateCallback("weapons:server:RepairWeapon", function(source, cb, RepairPoint, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local minute = 60 * 1000
    local Timeout = math.random(5 * minute, 10 * minute)
    local WeaponData = QBCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponClass = (QBCore.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()

    if Player.PlayerData.items[data.slot] ~= nil then
        if Player.PlayerData.items[data.slot].info.quality ~= nil then
            if Player.PlayerData.items[data.slot].info.quality ~= 100 then
                if Player.Functions.RemoveMoney('cash', Config.WeaponRepairCotsts[WeaponClass]) then
                    Config.WeaponRepairPoints[RepairPoint].IsRepairing = true
                    Config.WeaponRepairPoints[RepairPoint].RepairingData = {
                        CitizenId = Player.PlayerData.citizenid,
                        WeaponData = Player.PlayerData.items[data.slot],
                        Ready = false,
                    }
                    Player.Functions.RemoveItem(data.name, 1, data.slot)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.name], "remove")
                    TriggerClientEvent("inventory:client:CheckWeapon", src, data.name)
                    TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)

                    SetTimeout(Timeout, function()
                        Config.WeaponRepairPoints[RepairPoint].IsRepairing = false
                        Config.WeaponRepairPoints[RepairPoint].RepairingData.Ready = true
                        TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)
                        TriggerEvent('qb-phone:server:sendNewMailToOffline', Player.PlayerData.citizenid, {
                            sender = "Tyrone",
                            subject = "Reperatie",
                            message = "Your "..WeaponData.label.." is repaired, you can pick it up at the location. <br><br> Peace out madafaka"
                        })
                        SetTimeout(7 * 60000, function()
                            if Config.WeaponRepairPoints[RepairPoint].RepairingData.Ready then
                                Config.WeaponRepairPoints[RepairPoint].IsRepairing = false
                                Config.WeaponRepairPoints[RepairPoint].RepairingData = {}
                                TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)
                            end
                        end)
                    end)
                    cb(true)
                else
                    cb(false)
                end
            else
                TriggerClientEvent("QBCore:Notify", src, "This weapon is not dammaged..", "error")
                cb(false)
            end
        else
            TriggerClientEvent("QBCore:Notify", src, "This weapon is not dammaged..", "error")
            cb(false)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You diddent have a weapon in ur hands..", "error")
        TriggerClientEvent('weapons:client:SetCurrentWeapon', src, {}, false)
        cb(false)
    end
end)

RegisterServerEvent("weapons:server:TakeBackWeapon")
AddEventHandler("weapons:server:TakeBackWeapon", function(k, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemdata = Config.WeaponRepairPoints[k].RepairingData.WeaponData

    itemdata.info.quality = 100
    Player.Functions.AddItem(itemdata.name, 1, false, itemdata.info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemdata.name], "add")
    Config.WeaponRepairPoints[k].IsRepairing = false
    Config.WeaponRepairPoints[k].RepairingData = {}
    TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[k], k)
end)

-- Pistols

QBCore.Functions.CreateUseableItem("pistol_suppressor", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

QBCore.Functions.CreateUseableItem("pistol_extendedclip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

QBCore.Functions.CreateUseableItem("pistol_flashlight", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "flashlight")
end)

-- Submachine Guns

QBCore.Functions.CreateUseableItem("smg_suppressor", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

QBCore.Functions.CreateUseableItem("smg_extendedclip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

QBCore.Functions.CreateUseableItem("smg_drummag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "drummag")
end)

QBCore.Functions.CreateUseableItem("smg_flashlight", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "flashlight")
end)

QBCore.Functions.CreateUseableItem("smg_scope", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "scope")
end)

-- Shotguns

QBCore.Functions.CreateUseableItem("shotgun_suppressor", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

QBCore.Functions.CreateUseableItem("shotgun_flashlight", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "flashlight")
end)

QBCore.Functions.CreateUseableItem("shotgun_extendedclip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

QBCore.Functions.CreateUseableItem("shotgun_drummag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "drummag")
end)

-- Rifles

QBCore.Functions.CreateUseableItem("rifle_extendedclip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

QBCore.Functions.CreateUseableItem("rifle_drummag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "drummag")
end)

QBCore.Functions.CreateUseableItem("rifle_scope", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "scope")
end)

QBCore.Functions.CreateUseableItem("rifle_flashlight", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "flashlight")
end)

QBCore.Functions.CreateUseableItem("rifle_suppressor", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

QBCore.Functions.CreateUseableItem("rifle_grip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "grip")
end)

-- Snoppers

QBCore.Functions.CreateUseableItem("sniper_flashlight", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "flashlight")
end)

QBCore.Functions.CreateUseableItem("sniper_extendedclip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

QBCore.Functions.CreateUseableItem("sniper_advscope", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "advscope")
end)

QBCore.Functions.CreateUseableItem("sniper_scope", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "scope")
end)

QBCore.Functions.CreateUseableItem("sniper_suppressor", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

-- Camo

QBCore.Functions.CreateUseableItem("camo", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "camo")
end)

function HasAttachment(component, attachments)
    local retval = false
    local key = nil
    for k, v in pairs(attachments) do
        if v.component == component then
            key = k
            retval = true
        end
    end
    return retval, key
end

function GetAttachmentItem(weapon, component)
    local retval = nil
    for k, v in pairs(Config.WeaponAttachments[weapon]) do
        if v.component == component then
            retval = v.item
        end
    end
    return retval
end

RegisterServerEvent("weapons:server:EquipAttachment")
AddEventHandler("weapons:server:EquipAttachment", function(ItemData, CurrentWeaponData, AttachmentData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local GiveBackItem = nil
    if Inventory[CurrentWeaponData.slot] ~= nil then
        if Inventory[CurrentWeaponData.slot].info.attachments ~= nil and next(Inventory[CurrentWeaponData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentData.component, Inventory[CurrentWeaponData.slot].info.attachments)
            local HasCamo, key = HasAttachment(AttachmentData.component, Inventory[CurrentWeaponData.slot].info.camo)
            if not HasAttach then
                if not HasCamo then
                    if CurrentWeaponData.name == "weapon_compactrifle" then
                        local component = "COMPONENT_COMPACTRIFLE_CLIP_03"
                        if AttachmentData.component == "COMPONENT_COMPACTRIFLE_CLIP_03" then
                            component = "COMPONENT_COMPACTRIFLE_CLIP_02"
                        end
                        for k, v in pairs(Inventory[CurrentWeaponData.slot].info.attachments) do
                            if v.component == component then
                                local has, key = HasAttachment(component, Inventory[CurrentWeaponData.slot].info.attachments)
                                local item = GetAttachmentItem(CurrentWeaponData.name:upper(), component)
                                GiveBackItem = tostring(item):lower()
                                table.remove(Inventory[CurrentWeaponData.slot].info.attachments, key)
                                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
                            end
                        end
                    end
                    if AttachmentData.label == "Camo" then
                        table.insert(Inventory[CurrentWeaponData.slot].info.camo, {
                            component = AttachmentData.component,
                            label = AttachmentData.label,
                        })
                        TriggerClientEvent("addAttachment", src, AttachmentData.component)
                    else
                        table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                            component = AttachmentData.component,
                            label = AttachmentData.label,
                        })
                        TriggerClientEvent("addAttachment", src, AttachmentData.component)
                    end
                    Player.Functions.SetInventory(Player.PlayerData.items)
                    Player.Functions.RemoveItem(ItemData.name, 1)
                    SetTimeout(1000, function()
                        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
                    end)
                else
                    TriggerClientEvent("QBCore:Notify", src, "You already have a "..AttachmentData.label:lower().." on your weapon.", "error", 3500)
                end
            else
                TriggerClientEvent("QBCore:Notify", src, "You already have a "..AttachmentData.label:lower().." on your weapon.", "error", 3500)
            end
        else
            Inventory[CurrentWeaponData.slot].info.attachments = {}
            Inventory[CurrentWeaponData.slot].info.camo = {}
            if AttachmentData.label == "Camo" then
                table.insert(Inventory[CurrentWeaponData.slot].info.camo, {
                    component = AttachmentData.component,
                    label = AttachmentData.label,
                })
                TriggerClientEvent("addAttachment", src, AttachmentData.component)
            else
                table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                    component = AttachmentData.component,
                    label = AttachmentData.label,
                })
                TriggerClientEvent("addAttachment", src, AttachmentData.component)
            end
            Player.Functions.SetInventory(Player.PlayerData.items)
            Player.Functions.RemoveItem(ItemData.name, 1)
            SetTimeout(1000, function()
                TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
            end)
        end
    end

    if GiveBackItem ~= nil then
        Player.Functions.AddItem(GiveBackItem, 1, false)
        GiveBackItem = nil
    end
end)

QBCore.Functions.CreateCallback('weapons:server:RemoveAttachment', function(source, cb, AttachmentData, ItemData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local AttachmentComponent = Config.WeaponAttachments[ItemData.name:upper()][AttachmentData.attachment]

    if Inventory[ItemData.slot] ~= nil then
        if Inventory[ItemData.slot].info.attachments ~= nil and next(Inventory[ItemData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentComponent.component, Inventory[ItemData.slot].info.attachments)
            if HasAttach then
                table.remove(Inventory[ItemData.slot].info.attachments, key)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.AddItem(AttachmentComponent.item, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[AttachmentComponent.item], "add")
                TriggerClientEvent("QBCore:Notify", src, "You removed a "..AttachmentComponent.label.." from your weapon!", "error")
                cb(Inventory[ItemData.slot].info.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)