local coords = {
    {891.368,-952.639,43.195,269.914,0xC99F21C4,"s_m_y_dealer_01"}
}

Citizen.CreateThread(function()

    for _,v in pairs(coords) do
      RequestModel(GetHashKey(v[6]))
      while not HasModelLoaded(GetHashKey(v[6])) do
        Wait(1)
      end
  
      RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
      end
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[4])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)