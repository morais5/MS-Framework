msHud = {}

msHud.Show = true

msHud.Money = {}
msHud.Money.ShowConstant = false -- Show money constantly

msHud.Radar = {}
msHud.Radar.NoRadarVehicles = {
    "bmx",
    "cruiser",
    "fixter",
    "scorcher",
    "tribike",
    "tribike2",
    "tribike3",
}

QBStress = {}

QBStress.Intensity = {
    ["shake"] = {
        [1] = {
            min = 10,
            max = 60,
            intensity = 0.20,
        },
        [2] = {
            min = 60,
            max = 70,
            intensity = 0.27,
        },
        [3] = {
            min = 70,
            max = 80,
            intensity = 0.32,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 0.38,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 0.42,
        },
    }
}

QBStress.MinimumStress = 10
QBStress.MinimumSpeed = 250

QBStress.EffectInterval = {
    [1] = {
        min = 10,
        max = 60,
        timeout = math.random(50000, 60000)
    },
    [2] = {
        min = 60,
        max = 70,
        timeout = math.random(40000, 50000)
    },
    [3] = {
        min = 70,
        max = 80,
        timeout = math.random(30000, 40000)
    },
    [4] = {
        min = 80,
        max = 90,
        timeout = math.random(20000, 30000)
    },
    [5] = {
        min = 90,
        max = 100,
        timeout = math.random(15000, 20000)
    }
}