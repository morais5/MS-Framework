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

local function peds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(pedConfig.LoopTime or 15000)
            for ped in peds() do
                local pedModel = GetEntityModel(ped) or "cockandballs";
                if pedConfig.blacklist[pedModel] == true then
                    if not IsPedAPlayer(ped) then
                        ClearPedTasksImmediately(ped)
                        while not NetworkHasControlOfEntity(ped) do
                            NetworkRequestControlOfEntity(ped)
                            Citizen.Wait(1)
                        end
                        SetEntityAsMissionEntity(ped, true, true)
                        DeletePed(ped)
                        DeleteEntity(ped)
                    end
                end
                Citizen.Wait(pedConfig.TimeBetween or 5)
            end
        end
    end
)
