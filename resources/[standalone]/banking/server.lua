QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local BankStatus = {}

RegisterServerEvent('qb-banking:server:SetBankClosed')
AddEventHandler('qb-banking:server:SetBankClosed', function(BankId, bool)
  print(BankId)
  BankStatus[BankId] = bool
  TriggerClientEvent('qb-banking:client:SetBankClosed', -1, BankId, bool)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local bankamount = ply.PlayerData.money["bank"]
    local amount = tonumber(amount)
    if bankamount >= amount and amount > 0 then
      ply.Functions.RemoveMoney('bank', amount, "Tirar Dinheiro Do Banco")
      TriggerEvent("qb-log:server:CreateLog", "banking", "Retirar", "red", "**"..GetPlayerName(src) .. "** retirou €"..amount.." de sua conta bancária.")
      ply.Functions.AddMoney('cash', amount, "Tirar Dinheiro Do Banco")
    else
      TriggerClientEvent('QBCore:Notify', src, 'Não tens dinheiro suficiente no banco :(', 'error')
    end
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local cashamount = ply.PlayerData.money["cash"]
    local amount = tonumber(amount)
    if cashamount >= amount and amount > 0 then
      ply.Functions.RemoveMoney('cash', amount, "Depósito bancário")
      TriggerEvent("qb-log:server:CreateLog", "banking", "Depositar", "green", "**"..GetPlayerName(src) .. "** depositou €"..amount.." na sua conta bancária.")
      ply.Functions.AddMoney('bank', amount, "Depósito bancário")
    else
      TriggerClientEvent('QBCore:Notify', src, 'Não tens dinheiro suficiente para depositar :(', 'error')
    end
end)

QBCore.Commands.Add("dardinheiro", "Dê algum dinheiro a um jogador", {{name="id", help="Id do player"},{name="amount", help="Quantia de dinheiro"}}, true, function(source, args)
  local Player = QBCore.Functions.GetPlayer(source)
  local TargetId = tonumber(args[1])
  local Target = QBCore.Functions.GetPlayer(TargetId)
  local amount = tonumber(args[2])
  
  if Target ~= nil then
    if amount ~= nil then
      if amount > 0 then
        if Player.PlayerData.money.cash >= amount and amount > 0 then
          if TargetId ~= source then
            TriggerClientEvent('banking:client:CheckDistance', source, TargetId, amount)
          else
            TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Não podes dar dinheiro para ti mesmo.")     
          end
        else
          TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Não tens dinheiro suficiente.")
        end
      else
        TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "O valor deve ser maior que 0.")
      end
    else
      TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Insira um valor.")
    end
  else
    TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "O jogador não está online.")
  end    
end)

RegisterServerEvent('banking:server:giveCash')
AddEventHandler('banking:server:giveCash', function(trgtId, amount)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local Target = QBCore.Functions.GetPlayer(trgtId)

  print(src)
  print(trgtId)

  if src ~= trgtId then
    Player.Functions.RemoveMoney('cash', amount, "Dinheiro dado a "..Player.PlayerData.citizenid)
    Target.Functions.AddMoney('cash', amount, "Dinheiro recebido de "..Target.PlayerData.citizenid)

    TriggerEvent("qb-log:server:CreateLog", "banking", "Dê dinheiro", "blue", "**"..GetPlayerName(src) .. "** tem dado €"..amount.." para **" .. GetPlayerName(trgtId) .. "**")
    
    TriggerClientEvent('QBCore:Notify', trgtId, "Você recebeu €"..amount.." from "..Player.PlayerData.charinfo.firstname.."!", 'success')
    TriggerClientEvent('QBCore:Notify', src, "Você deu €"..amount.." para "..Target.PlayerData.charinfo.firstname.."!", 'success')
  else
    TriggerEvent("qb-anticheat:server:banPlayer", "Cheating")
    TriggerEvent("qb-log:server:CreateLog", "anticheat", "Jogador banido! (Na verdade não é um teste, duhhhhh)", "red", "** @everyone " ..GetPlayerName(player).. "** tentei dar **"..amount.." para ele mesmo")  
  end
end)
