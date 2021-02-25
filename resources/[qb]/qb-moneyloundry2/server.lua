-------------------------------------
------- Created by CODERC-SLO -------
-----------Money Loundry---------------
------------------------------------- 
local CoolDownTimerATM = {}
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
---######################################################---


---------------------------------------------PROCESS MONEY CLEANING-----------------------
local itname1 = 'black_money'
RegisterServerEvent('pulisci:moneblak')
AddEventHandler('pulisci:moneblak', function()
   
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local Item = xPlayer.Functions.GetItemByName(itname1)
    
   
    if Item == nil then
        TriggerClientEvent('QBCore:Notify', source, 'Não tens dinheiro sujo para lavar, burro do crh :/!', "error", 8000)  
    else
        if Item.amount >= Item.amount then

           ----------------elimino dal mio inventario---------------------------------------------------------
           xPlayer.Functions.RemoveItem(itname1, Item.amount)
           TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[itname1], "remove")
		   xPlayer.Functions.AddMoney("cash", Item.amount, "sold-pawn-items")
       
           
        else
            TriggerClientEvent('QBCore:Notify', _source, 'Não tens dinheiro sujo para lavar, burro do crh :/!', "error", 10000)  
           
        end
    end

end)
---------------------------------clean end---------------------------------------------------------------