Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(0.2) --Seleciona densidade do trafico
	SetPedDensityMultiplierThisFrame(0.1) --seleciona a densidade de Npc
	SetRandomVehicleDensityMultiplierThisFrame(0.3) --seleciona a densidade de viaturas estacionadas a andar etc
	SetParkedVehicleDensityMultiplierThisFrame(0.3) --seleciona a densidade de viaturas estacionadas
	SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0) --seleciona a densidade de Npc a andar pela cidade
	SetGarbageTrucks(false) --Desactiva os Camioes do Lixo de dar Spawn Aleatoriamente
	SetRandomBoats(false) --Desactiva os Barcos de dar Spawn na agua
        SetCreateRandomCops(false) --Desactiva a Policia a andar pela cidade
	SetCreateRandomCopsNotOnScenarios(false) --Para o Spanw Aleatorio de Policias Fora do Cenario
	SetCreateRandomCopsOnScenarios(false) --Para o Spanw Aleatorio de Policias no Cenario
        DisablePlayerVehicleRewards(PlayerId()) --Nao mexer --> Impossibilita que os players possam ganhar armas nas viaturas da policia e ems
        RemoveAllPickupsOfType(0xDF711959) --Carbine rifle
        RemoveAllPickupsOfType(0xF9AFB48F) --Pistol
        RemoveAllPickupsOfType(0xA9355DCD) --Pumpshotgun
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
	RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
        --HideHudComponentThisFrame(14)-- Remover Mira
        RemoveMultiplayerHudCash(0x968F270E39141ECA) -- Remove o Dinheiro Original do Gta
        RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0) --Remove o Dinheiro Original do Gta Que esta no Banco
	for i = 1, 15 do
        EnableDispatchService(i, false)-- Disabel Dispatch
      end
   end
end)