MSCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if MSCore == nil then
            TriggerEvent('MSCore:GetObject', function(obj) MSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code
local _x = 0
local _y = 0

msLogin.Data = {
    ChoosingCharacter = false,
    Peds = {},
    CamData = {
        CamActive = false,
        CurrentCam = nil,
        TempCam = nil,
        CamKey = 0,
    }
}

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do

        for k, v in pairs(msLogin.Locations) do
            DrawText3Ds(v.coords.ped.x, v.coords.ped.y, v.coords.ped.z, 'PED #'..k)
            DrawText3Ds(v.coords.ped.x, v.coords.ped.y, v.coords.cam.z, 'CAM #'..k)
            SpawnPed(k)

            if not msLogin.Data.CamData.CamActive then
                msLogin.Data.CamData.CamActive = true
                msLogin.Data.CamData.CamKey = 1
                ChangeCam(k)
                print("Watching ped: #"..msLogin.Data.CamData.CamKey)
            end

            ClearArea(v.coords.ped.x, v.coords.ped.y, v.coords.ped.z, 100.0, false, false, false, false)
        end

        Citizen.Wait(1)
    end
end)


function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end 


function ChangeCam(k)
    loadAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_b@")
    TaskPlayAnim(msLogin.Data.Peds[k], "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.CreateThread(function()
        while msLogin.Data.CamData.CamActive do
            local CurrentCoords = msLogin.Locations[msLogin.Data.CamData.CamKey].coords.ped
            if msLogin.Data.CamData.CamKey + 1 < #msLogin.Locations + 1 then
                msLogin.Data.CamData.CamKey = msLogin.Data.CamData.CamKey + 1
            else
                msLogin.Data.CamData.CamKey = 1
            end
            msLogin.Data.CamData.CurrentCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CurrentCoords.x + 1.55, CurrentCoords.y + 4, CurrentCoords.z + 0.3, 0.0, 0.0, CurrentCoords.h - 180, 55.00, false, 0)
            SetCamActive(msLogin.Data.CamData.CurrentCam, true)
            RenderScriptCams(true, true, 1, true, true)
            SetCamActiveWithInterp(msLogin.Data.CamData.CurrentCam, msLogin.Data.CamData.TempCam, 500, true, true)
            Citizen.Wait(500)
            local TempCoords = msLogin.Locations[msLogin.Data.CamData.CamKey].coords.ped
            msLogin.Data.CamData.TempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", TempCoords.x + 1.55, TempCoords.y + 4, TempCoords.z + 0.3, 0.0, 0.0, TempCoords.h - 180, 55.00, false, 0)
            SetCamActiveWithInterp(msLogin.Data.CamData.TempCam, msLogin.Data.CamData.CurrentCam, 500, true, true)
            print("Watching ped: #"..msLogin.Data.CamData.CamKey)
            if msLogin.Data.CamData.CamKey == #msLogin.Locations then
                ClearPedTasksImmediately(msLogin.Data.Peds[5])
            else
                ClearPedTasksImmediately(msLogin.Data.Peds[msLogin.Data.CamData.CamKey - 1])
            end
            loadAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_b@")
            TaskPlayAnim(msLogin.Data.Peds[msLogin.Data.CamData.CamKey], "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(2000)
        end
    end)
end

function SpawnPed(k)
    if msLogin.Data.Peds[k] == nil then
        local coords = msLogin.Locations[1].coords.ped
        local model = GetHashKey("mp_m_freemode_01")
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(100)
        end
        msLogin.Data.Peds[k] = CreatePed(2, model, coords.x - _x, coords.y + _y, coords.z - 0.98, coords.h, false, 0)
        msLogin.Locations[k].coords.ped = {
            x = coords.x - _x,
            y = coords.y + _y,
            z = coords.z,
            h = coords.h,
        }
        _x = _x - 1.33
        _y = _y - 0.44
        FreezeEntityPosition(msLogin.Data.Peds[k], true)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        for _, ped in pairs(msLogin.Data.Peds) do
            if ped ~= nil then
                DeletePed(ped)
            end
        end

        if msLogin.Data.CamData.CurrentCam ~= nil then
            SetCamActive(msLogin.Data.CamData.CurrentCam, false)
            DestroyCam(msLogin.Data.CamData.CurrentCam, true)
            RenderScriptCams(false, false, 1, true, true)
            msLogin.Data.CamData.CurrentCam = nil
        end
    end
end)