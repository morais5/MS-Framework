
-- DoomsdayAvenger: 520.00000000 4750.00000000 -70.00000000

exports('GetDoomsdayAvengerObject', function()
    return DoomsdayAvenger
end)

DoomsdayAvenger = {
    interiorId = 262145,
    Ipl = {
        Interior = {
            ipl = "xm_x17dlc_int_placement_interior_9_x17dlc_int_01_milo_",
            Load = function() EnableIpl(DoomsdayAvenger.Ipl.Interior.ipl, true) end,
            Remove = function() EnableIpl(DoomsdayAvenger.Ipl.Interior.ipl, false) end
        }
    },
    Colors = {
        utility = 1, expertise = 2, altitude = 3,
        power = 4, authority = 5, influence = 6,
        order = 7, empire = 8, supremacy = 9
    },
    Walls = {
        SetColor = function(color, refresh)
            SetInteriorPropColor(DoomsdayAvenger.interiorId, "shell_tint", color)
            if (refresh) then RefreshInterior(DoomsdayAvenger.interiorId) end
        end
    },
    Turret = {
        none = "", back = "control_1", left = "control_2", right = "control_3",
        Set = function(turret, color, refresh)
            DoomsdayAvenger.Turret.Clear(refresh)
            if (turret ~= nil) then
                SetIplPropState(DoomsdayAvenger.interiorId, turret, true, refresh)
                SetInteriorPropColor(DoomsdayAvenger.interiorId, turret, color)
            else
                if (refresh) then RefreshInterior(DoomsdayAvenger.interiorId) end
            end
        end,
        Clear = function(refresh)
            SetIplPropState(DoomsdayAvenger.interiorId, {DoomsdayAvenger.Turret.back, DoomsdayAvenger.Turret.left, DoomsdayAvenger.Turret.right}, false, refresh)
        end
    },
    WeaponsMod = {
        off = "", on = "weapons_mod",
        Set = function(weap, color, refresh)
            DoomsdayAvenger.WeaponsMod.Clear(refresh)
            if (weap ~= nil) then
                SetIplPropState(DoomsdayAvenger.interiorId, weap, true, refresh)
                SetInteriorPropColor(DoomsdayAvenger.interiorId, weap, color)
            else
                if (refresh) then RefreshInterior(DoomsdayAvenger.interiorId) end
            end
        end,
        Clear = function(refresh)
            SetIplPropState(DoomsdayAvenger.interiorId, DoomsdayAvenger.WeaponsMod.on, false, refresh)
        end
    },
    VehicleMod = {
        off = "", on = "vehicle_mod",
        Set = function(veh, color, refresh)
            DoomsdayAvenger.VehicleMod.Clear(refresh)
            if (veh ~= nil) then
                SetIplPropState(DoomsdayAvenger.interiorId, veh, true, refresh)
                SetInteriorPropColor(DoomsdayAvenger.interiorId, veh, color)
            else
                if (refresh) then RefreshInterior(DoomsdayAvenger.interiorId) end
            end
        end,
        Clear = function(refresh)
            SetIplPropState(DoomsdayAvenger.interiorId, DoomsdayAvenger.VehicleMod.on, false, refresh)
        end
    },
    Details = {
        golden = "gold_bling",
        Enable = function (details, state, refresh)
            SetIplPropState(DoomsdayAvenger.interiorId, details, state, refresh)
        end
    },

    LoadDefault = function()
        DoomsdayAvenger.Ipl.Interior.Load()

        DoomsdayAvenger.Walls.SetColor(2)

        DoomsdayAvenger.Turret.Set(DoomsdayAvenger.Turret.back, 1, false)
        DoomsdayAvenger.WeaponsMod.Set(DoomsdayAvenger.WeaponsMod.on, 1, false)
        DoomsdayAvenger.VehicleMod.Set(DoomsdayAvenger.VehicleMod.on, 1, false)

        DoomsdayAvenger.Details.Enable(DoomsdayAvenger.Details.golden, false, false)

        RefreshInterior(DoomsdayAvenger.interiorId)
    end
}

