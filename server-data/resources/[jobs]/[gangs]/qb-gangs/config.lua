Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}

-- Config --

Config.gang = "bloods"
Config.stashname = "bloodstash" --Always Keep It Like vagostash,gsfstash,mafiastash

Config.Locations = {

    -- Bloods

    ["ogcarspawnbloods"] = {
        label = "Gagarem Spawn",
        coords = {x =-179.09, y =-1623.75, z =33.31, h =4.39},
    },
    ["stashbloods"] = {
        label = "Bloods Armario",
        coords = {x =-161.15, y =-1638.55, z =34.03},
    },

    -- Vanilla

    ["ogcarspawnvanilla"] = {
        label = "Gagarem Spawn",
        coords = {x =137.2, y =-1306.94, z =28.92, h =311.44},
    },
    ["stashvanilla"] = {
        label = "Vanilla Armario",
        coords = {x =93.48, y =-1288.32, z =29.26},
    },

    -- Bahamas
    ["ogcarspawnvbahamas"] = {
        label = "Gagarem Spawn",
        coords = {x =-1402.6, y =-586.45, z =30.28, h =124.04},
    },
    ["stashbahamas"] = {
        label = "Bahamas Armario",
        coords = {x =1386.22, y =-627.45, z =30.82},
    },

    -- Hyper
    ["ogcarspawnhyper"] = {
        label = "Gagarem Spawn",
        coords = {x =-30.95, y =-1382.81, z =29.3, h =354.19},
    },
    ["stashhyper"] = {
        label = "Hyper Armario",
        coords = {x =-31.3, y =-1395.71, z =29.51},
    },

    -- Groove
    ["ogcarspawnGroove"] = {
        label = "Gagarem Spawn",
        coords = {x =88.33, y =-1968.8, z =20.75, h =136.05},
    },
    ["stashGroove"] = {
        label = "Groove Armario",
        coords = {x =84.92, y =-1967.06, z =20.75, h =75.97},
    },

    -- Mafia 
    ["ogcarspawnMafia"] = {
        label = "Gagarem Spawn",
        coords = {x =-1893.24, y =2033.98, z =140.74, h =147.25},
    },
    ["stashMafia"] = {
        label = "Mafia Armario",
        coords = {x =-1869.8, y =2059.57, z =135.43, h =70.47},
    },

    -- Cartel
    ["ogcarspawnCartel"] = {
        label = "Gagarem Spawn",
        coords = {x =1370.48, y =1146.75, z =113.76, h =350.6},
    },
    ["stashCartel"] = {
        label = "Cartel Armario",
        coords = {x =1392.55, y =1139.09, z =114.44, h =268.95},
    },
}

Config.Vehicles = {
    ["buffalo2"] = "Buffalo Sport",
    ["rumpo3"] = "RumpoXL",
    ["manchez"] = "Manchez",
    ["chino2"] = "Lowrider",

}

Config.VehiclesMafia = {
    ["g65amg"] = "Mercedes Benz G65AMG",

}

Config.VehiclesCartel = {
    ["g65amg"] = "Mercedes Benz G65AMG",

}

Config.VehiclesVanilla = {
    ["g65amg"] = "Mercedes Benz G65AMG",

}

Config.VehiclesBahamas = {
    ["g65amg"] = "Mercedes Benz G65AMG",

}

Config.VehiclesHyper = {
    ["g65amg"] = "Mercedes Benz G65AMG",

}