msHud = {}
msHud.Show = true

msHud.Money = {}
msHud.Money.ShowConstant = false -- Show money constantly

msHud.MaxOxygen = 25.00 --must be a float, preferrably 100.0 or below. 100 even feels superhuman. 25.00 feels about right and rounds nicely.

msHud.Strings = {
	ExitVehicle = "Get out / off to refuel",
	EToRefuel = "[~g~E~w~] To refuel vehicle ",
	JerryCanEmpty = "Jerry can is empty",
	FullTank = "Fuel tank is full",
	--PurchaseJerryCan = "Press ~g~E ~w~to purchase a jerry can for ~g~$" .. Config.JerryCanCost,
    CancelFuelingPump = "[~g~E~w~] To stop refueling",
    Refueling = "Refueling the vehicle",
	CancelFuelingJerryCan = "Press ~g~E ~w~to cancel the fueling",
	NotEnoughCash = "You don't have enough money",
	RefillJerryCan = "Press ~g~E ~w~ to refill the jerry can for ",
	NotEnoughCashJerryCan = "Not enough cash to refill jerry can",
	JerryCanFull = "Jerry can is full",
	TotalCost = "Costs",
}

msHud.MaxOxygen = 25.00 --must be a float, preferrably 100.0 or below. 100 even feels superhuman. 25.00 feels about right and rounds nicely.

msHud.Intensity = {
    ["shake"] = {
        [1] = {
            min = 50,
            max = 60,
            intensity = 0.12,
        },
        [2] = {
            min = 60,
            max = 70,
            intensity = 0.17,
        },
        [3] = {
            min = 70,
            max = 80,
            intensity = 0.22,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 0.28,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 0.32,
        },
    }
}

msHud.MinimumStress = 50
msHud.MinimumSpeed = 150 --mph at which player will accumulate stress, every 30 secs

msHud.EffectInterval = {
    [1] = {
        min = 50,
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