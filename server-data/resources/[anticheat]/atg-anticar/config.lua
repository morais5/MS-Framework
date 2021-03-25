vehConfig = {
    blacklist = {
        [GetHashKey("cargoplane")] = true,
        [GetHashKey("jet")] = true,
        [GetHashKey("tug")] = true,
        [GetHashKey("bus")] = true,
        [GetHashKey("dump")] = true,
        [GetHashKey("blimp")] = true,
        [GetHashKey("lazer")] = true,
        [GetHashKey("tanker")] = true
    }
}

-- This is the time IN MILISECONDS (1000 = 1 second!) for each time it looks to delete everything blocked | Default: 15000 (15 Seconds)
vehConfig.LoopTime = 15000

-- This is the time IN MILISECONDS (1000 = 1 second!) in between each vehicle. | Default: 5 (5ms) DO NOT GO UNDER 1! Do NOT go ABOVE 25! |
vehConfig.TimeBetween = 5