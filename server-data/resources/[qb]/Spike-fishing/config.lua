Config = {}

Config.Debug = false
Config.JobBusy = false

Config.MarkerData = {
    ["type"] = 6,
    ["size"] = vector3(2.0, 2.0, 2.0),
    ["color"] = vector3(0, 255, 150)
}

Config.FishingRestaurant = {
    ["name"] = "Restaurante de peixe - La Spada",
    ["blip"] = {
        ["sprite"] = 628,
        ["color"] = 3
    },
    ["ped"] = {
        ["model"] = 0xED0CE4C6,
        ["position"] = vector3(-1038.4545898438, -1397.0551757813, 5.553192615509),
        ["heading"] = 75.0
    }
}

Config.FishingItems = {
    ["rod"] = {
        ["name"] = "fishingrod",
        ["label"] = "Cana de pesca"
    },
    ["bait"] = {
        ["name"] = "fishingbait",
        ["label"] = "Isca de pesca"
    },
    ["fish"] = {
        ["price"] = 25 
    },
    ["stripedbass"] = {
        ["price"] = 50
    },
    ["bluefish"] = {
        ["price"] = 50
    },
    ["redfish"] = {
        ["price"] = 100 
    },
    ["pacifichalibut"] = {
        ["price"] = 100 
    },
    ["goldfish"] = {
        ["price"] = 100
    },
    ["largemouthbass"] = {
        ["price"] = 500
    },
    ["salmon"] = {
        ["price"] = 500
    },
    ["catfish"] = {
        ["price"] = 500
    },
    ["tigersharkmeat"] = {
        ["price"] = 500
    },
    ["stingraymeat"] = {
        ["price"] = 1000
    },
    ["killerwhalemeat"] = {
        ["price"] = 1000
    },
}

Config.FishingZones = {
    {
        ["name"] = "Pesca na praia",
        ["coords"] = vector3(-1948.1279296875, -749.79125976563, 2.5400819778442),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Pesca de areia 1",
        ["coords"] = vector3(1311.5769042969, 4228.833984375, 33.915531158447),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Pesca de areia 2",
        ["coords"] = vector3(1525.0518798828, 3908.9050292969, 30.799766540527),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Pesca de areia 3",
        ["coords"] = vector3(2223.6940917969, 4575.70703125, 31.233570098877),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Pesca de areia 4",
        ["coords"] = vector3(31.989250183105, 4294.7797851563, 31.231893539429),
        ["radius"] = 50.0,
    },
    {
        ["name"] = "Pesca oceânica 1",
        ["coords"] = vector3(-1835.0385742188, -1820.4168701172, 3.6758048534393),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "Pesca oceânica 2",
        ["coords"] = vector3(-722.52124023438, 7188.6108398438, 1.8514842987061),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "Pesca oceânica 3",
        ["coords"] = vector3(3469.1770019531, 1271.2962646484, 1.366447687149),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "Pesca oceânica 4",
        ["coords"] = vector3(-3277.4191894531, 2613.3405761719, 1.6248697042465),
        ["radius"] = 200.0,
    },
    {
        ["name"] = "special0",
        ["coords"] = vector3(7040.34, 8172.63, 204.435),
        ["radius"] = 500.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special1",
        ["coords"] = vector3(3194.11121337885, 906.8347851562501, 442.03224151611005),
        ["radius"] = 10.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special2",
        ["coords"] = vector3(-3081.5139697266004, 4007.4116894532, 201.00122415304185),
        ["radius"] = 10.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special3",
        ["coords"] = vector3(-2523.3720629883, 7160.87897460945, 200.27662748873234),
        ["radius"] = 10.0,
        ["secret"] = true,
    },
    {
        ["name"] = "special4",
        ["coords"] = vector3(250.32162254333554, 1483.387672119135, 496.65704315185496),
        ["radius"] = 10.0,
        ["secret"] = true,
    }
}
