pedConfig = {
    blacklist = {
        [GetHashKey("a_m_o_acult_01")] = true,
        [GetHashKey("a_f_m_fatwhite_01")] = true,
        [GetHashKey("s_m_m_autoshop_01")] = true,
        [GetHashKey("a_m_y_surfer_01")] = true,
        [GetHashKey("s_m_y_swat_01")] = true,
        [GetHashKey("ig_wade")] = true,
        [GetHashKey("a_c_deer")] = true,
        [GetHashKey("a_c_boar")] = true,
        [GetHashKey("a_c_killerwhale")] = true,
        [GetHashKey("a_c_sharktiger")] = true,
        [GetHashKey("csb_stripper_01")] = true,
        [GetHashKey("A_C_MtLion")] = true,
        [GetHashKey("mp_f_cocaine_01")] = true,
        [GetHashKey("ig_claypain")] = true,
        [GetHashKey("u_m_m_jesus_01")] = true,
        [GetHashKey("S_M_Y_MARINE_01")] = true,
        [GetHashKey("s_m_m_movalien_01")] = true,
        [GetHashKey("A_C_Rottweiler")] = true,
        [GetHashKey("A_C_Husky")] = true,
        [GetHashKey("S_M_Y_Marine_03")] = true,
        [GetHashKey("CS_MovPremMale")] = true,
        [GetHashKey("G_M_Y_Lost_03")] = true,
        [GetHashKey("G_M_M_ChiCold_01")] = true,
    }
}

-- This is the time IN MILISECONDS (1000 = 1 second!) for each time it looks to delete everything blocked | Default: 15000 (15 Seconds)
pedConfig.LoopTime = 15000

-- This is the time IN MILISECONDS (1000 = 1 second!) in between each vehicle. | Default: 5 (5ms) DO NOT GO UNDER 1! Do NOT go ABOVE 25! |
pedConfig.TimeBetween = 5