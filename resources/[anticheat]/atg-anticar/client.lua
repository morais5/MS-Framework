local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

local function vehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(vehConfig.LoopTime or 15000)
            for veh in vehicles() do
                if vehConfig.blacklist[GetEntityModel(veh)] == true then
                    local ped = GetPedInVehicleSeat(veh, -1)
                    if ped ~= 0 then
                        if IsPedAPlayer(ped) then
                            ClearPedTasksImmediately(ped)
                            while not NetworkHasControlOfEntity(veh) do
                                NetworkRequestControlOfEntity(veh)
                                Citizen.Wait(1)
                            end
                            SetEntityAsMissionEntity(veh, true, true)
                            DeleteVehicle(veh)
                            DeleteEntity(veh)
                        end
                    else
                        while not NetworkHasControlOfEntity(veh) do
                            NetworkRequestControlOfEntity(veh)
                            Citizen.Wait(1)
                        end
                        SetEntityAsMissionEntity(veh, true, true)
                        DeleteVehicle(veh)
                        DeleteEntity(veh)
                    end
                end
                Citizen.Wait(vehConfig.TimeBetween or 5)
            end
        end
    end
)
