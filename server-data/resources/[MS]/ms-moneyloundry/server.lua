-------------------------------------
------- Created by CODERC-SLO -------
-----------Money Loundry---------------
------------------------------------- 
local CoolDownTimerATM = {}
MSCore = nil
TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)
---######################################################---


---------------------------------------------PROCESS MONEY CLEANING-----------------------
local itname1 = 'black_money'
RegisterServerEvent('pulisci:moneblak')
AddEventHandler('pulisci:moneblak', function()
   
    local _source = source
    local xPlayer = MSCore.Functions.GetPlayer(_source)
    local Item = xPlayer.Functions.GetItemByName(itname1)
    
   
    if Item == nil then
        TriggerClientEvent('MSCore:Notify', source, 'You dont have dirty money to clean :/!', "error", 8000)  
    else
        if Item.amount >= Item.amount then

           ----------------elimino dal mio inventario---------------------------------------------------------
           xPlayer.Functions.RemoveItem(itname1, Item.amount)
           TriggerClientEvent("inventory:client:ItemBox", source, MSCore.Shared.Items[itname1], "remove")
		   xPlayer.Functions.AddMoney("cash", Item.amount, "sold-pawn-items")
       
           
        else
            TriggerClientEvent('MSCore:Notify', _source, 'You dont have dirty money to clean :/!', "error", 10000)  
           
        end
    end

end)
---------------------------------clean end---------------------------------------------------------------