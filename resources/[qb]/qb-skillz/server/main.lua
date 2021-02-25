QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


QBCore.Functions.CreateCallback('skillsystem:fetchStatus', function(source, cb)
     local Player = QBCore.Functions.GetPlayer(source)
 
      if Player then
            exports['ghmattimysql']:execute('SELECT skills FROM players WHERE citizenid = @citizenid', {
                ['@citizenid'] = Player.PlayerData.citizenid
           }, function(status)
               if status ~= nil then
                    cb(json.decode(status))
               else
                    cb(nil)
               end
           end)
      else
           cb()
      end
 end)




RegisterServerEvent('skillsystem:update')
AddEventHandler('skillsystem:update', function (data)
     local Player = QBCore.Functions.GetPlayer(source)
     --print(data)

	exports['ghmattimysql']:execute('UPDATE players SET skills = @skills WHERE citizenid = @citizenid', {
		['@skills'] = data,
		['@citizenid'] = Player.PlayerData.citizenid
	})
end)
