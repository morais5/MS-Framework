-------------------------------------
------- Created by CODERC-SLO -------
-----------Roberry ATM---------------
------------------------------------- 

--put the resource in your resources folder
--in the resource.lua file -- start qb-moneyloundry


### Installation
Insert the item into your file shared.lua
["black_money"] = {
        ["name"] = "black_money",
        ["label"] = "black_money",
        ["weight"] = 10,
        ["type"] = "item",
        ["image"] = "black_money.png",
        ["unique"] = false,
        ["useable"] = true,
        ["shouldClose"] = true,
        ["combinable"] = nil,
        ["description"] = "black_money"
	},

###############################################
### Enter the code in the brawl where you want to receive the dirty money
-Insert the localeì at the beginning of your file
local itemcraft = 'black_money'

--put the code in your script m instead of receiving the money you will have to receive the dirty money
cancella nel tuo script la parte di codice dove ricevi come in esempio.
######################################################
Player.Functions.AddItem(NOMEITEM, IMPORTO)
TriggerClientEvent("inventory:client:ItemBox", src, CashoutCore.Shared.Items[NOMEITEM], "add")
######################################################


example: In the example I explain how to get the dirty money in the drug script. Weed.
Find the code like here

---------------------------------------------------selldrug ok

RegisterServerEvent('xd_drugs_weed:selld')
AddEventHandler('xd_drugs_weed:selld', function()
	local src = source
	local Player = CashoutCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('weed_bag')
   
	
      
	
	if Item.amount >= 1 then
	if Player.Functions.GetItemByName('weed_bag') then
		local chance2 = math.random(1, 8)
		if chance2 == 1 or chance2 == 2 or chance2 == 3 or chance2 == 4 or chance2 == 5 or chance2 == 6 or chance2 == 7 or chance2 == 8 then
			Player.Functions.RemoveItem('weed_bag', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, CashoutCore.Shared.Items['weed_bag'], "remove")
		
			---------------comment or remove the code as in the example
			--Player.Functions.AddMoney("cash", Config.Pricesell, "sold-pawn-items")
			--TriggerClientEvent('CashoutCore:Notify', src, 'you sold to the pusher', "success")  

			---------------enter the code above
			Player.Functions.AddItem(itemcraft, Config.Pricesell)
			TriggerClientEvent("inventory:client:ItemBox", src, CashoutCore.Shared.Items[itemcraft], "add")

		else
			--Player.Functions.RemoveItem('cannabis', 1)----change this
			--Player.Functions.RemoveItem('empty_weed_bag', 1)----change this
			--TriggerClientEvent("inventory:client:ItemBox", source, CashoutCore.Shared.Items['cannabis'], "remove")
			--TriggerClientEvent("inventory:client:ItemBox", source, CashoutCore.Shared.Items['empty_weed_bag'], "remove")
			--TriggerClientEvent('CashoutCore:Notify', src, 'You messed up and got nothing', "error") 
		end 
	else
		TriggerClientEvent('CashoutCore:Notify', src, 'You don\'t have the right items', "error") 
	end
else
	TriggerClientEvent('CashoutCore:Notify', src, 'You don\'t have the right items', "error") 
	
end
end)

----------------------------------------------------------------------------------------------------------------------------------

save and restart the resource .. from this moment instead of receiving the clean money you will receive the dirty money, you will have to go and clean it to receive the clean ones !!!!


