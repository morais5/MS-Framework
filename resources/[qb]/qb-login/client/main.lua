QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code
local _x = 0
local _y = 0

QBLogin.Data = {
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

        for k, v in pairs(QBLogin.Locations) do
            DrawText3Ds(v.coords.ped.x, v.coords.ped.y, v.coords.ped.z, 'PED #'..k)
            DrawText3Ds(v.coords.ped.x, v.coords.ped.y, v.coords.cam.z, 'CAM #'..k)
            SpawnPed(k)

            if not QBLogin.Data.CamData.CamActive then
                QBLogin.Data.CamData.CamActive = true
                QBLogin.Data.CamData.CamKey = 1
                ChangeCam(k)
                print("Watching ped: #"..QBLogin.Data.CamData.CamKey)
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
    TaskPlayAnim(QBLogin.Data.Peds[k], "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.CreateThread(function()
        while QBLogin.Data.CamData.CamActive do
            local CurrentCoords = QBLogin.Locations[QBLogin.Data.CamData.CamKey].coords.ped
            if QBLogin.Data.CamData.CamKey + 1 < #QBLogin.Locations + 1 then
                QBLogin.Data.CamData.CamKey = QBLogin.Data.CamData.CamKey + 1
            else
                QBLogin.Data.CamData.CamKey = 1
            end
            QBLogin.Data.CamData.CurrentCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CurrentCoords.x + 1.55, CurrentCoords.y + 4, CurrentCoords.z + 0.3, 0.0, 0.0, CurrentCoords.h - 180, 55.00, false, 0)
            SetCamActive(QBLogin.Data.CamData.CurrentCam, true)
            RenderScriptCams(true, true, 1, true, true)
            SetCamActiveWithInterp(QBLogin.Data.CamData.CurrentCam, QBLogin.Data.CamData.TempCam, 500, true, true)
            Citizen.Wait(500)
            local TempCoords = QBLogin.Locations[QBLogin.Data.CamData.CamKey].coords.ped
            QBLogin.Data.CamData.TempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", TempCoords.x + 1.55, TempCoords.y + 4, TempCoords.z + 0.3, 0.0, 0.0, TempCoords.h - 180, 55.00, false, 0)
            SetCamActiveWithInterp(QBLogin.Data.CamData.TempCam, QBLogin.Data.CamData.CurrentCam, 500, true, true)
            print("Watching ped: #"..QBLogin.Data.CamData.CamKey)
            if QBLogin.Data.CamData.CamKey == #QBLogin.Locations then
                ClearPedTasksImmediately(QBLogin.Data.Peds[5])
            else
                ClearPedTasksImmediately(QBLogin.Data.Peds[QBLogin.Data.CamData.CamKey - 1])
            end
            loadAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_b@")
            TaskPlayAnim(QBLogin.Data.Peds[QBLogin.Data.CamData.CamKey], "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(2000)
        end
    end)
end

function SpawnPed(k)
    if QBLogin.Data.Peds[k] == nil then
        local coords = QBLogin.Locations[1].coords.ped
        local model = GetHashKey("mp_m_freemode_01")
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(100)
        end
        QBLogin.Data.Peds[k] = CreatePed(2, model, coords.x - _x, coords.y + _y, coords.z - 0.98, coords.h, false, 0)
        QBLogin.Locations[k].coords.ped = {
            x = coords.x - _x,
            y = coords.y + _y,
            z = coords.z,
            h = coords.h,
        }
        _x = _x - 1.33
        _y = _y - 0.44
        FreezeEntityPosition(QBLogin.Data.Peds[k], true)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        for _, ped in pairs(QBLogin.Data.Peds) do
            if ped ~= nil then
                DeletePed(ped)
            end
        end

        if QBLogin.Data.CamData.CurrentCam ~= nil then
            SetCamActive(QBLogin.Data.CamData.CurrentCam, false)
            DestroyCam(QBLogin.Data.CamData.CurrentCam, true)
            RenderScriptCams(false, false, 1, true, true)
            QBLogin.Data.CamData.CurrentCam = nil
        end
    end
end)