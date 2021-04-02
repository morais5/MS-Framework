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

Config.Timeout = 30 * (60 * 1000)

Config.RequiredCops = 4

Config.JewelleryLocation = {
    ["coords"] = {
        ["x"] = -630.5,
        ["y"] = -237.13,
        ["z"] = 38.08,
    }
}

Config.WhitelistedWeapons = {
    [GetHashKey("weapon_assaultrifle")] = {
        ["timeOut"] = 25000
    },
    [GetHashKey("weapon_carbinerifle")] = {
        ["timeOut"] = 26000
    },
    [GetHashKey("weapon_pumpshotgun")] = {
        ["timeOut"] = 27000
    },
    [GetHashKey("weapon_sawnoffshotgun")] = {
        ["timeOut"] = 28000
    },
    [GetHashKey("weapon_compactrifle")] = {
        ["timeOut"] = 29000
    },
    [GetHashKey("weapon_microsmg")] = {
        ["timeOut"] = 30000
    },
    [GetHashKey("weapon_autoshotgun")] = {
        ["timeOut"] = 31000
    },
}

Config.VitrineRewards = {
    [1] = {
        ["item"] = "rolex",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 5
        },
    },
    [2] = {
        ["item"] = "diamond_ring",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 5
        },
    },
    [3] = {
        ["item"] = "goldchain",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 5
        },
    },
}

Config.Locations = {
    [1] = {
        ["coords"] = {
            ["x"] = -626.83, 
            ["y"] = -235.35, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [2] = {
        ["coords"] = {
            ["x"] = -625.81, 
            ["y"] = -234.7, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [3] = {
        ["coords"] = {
            ["x"] = -626.95, 
            ["y"] = -233.14, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [4] = {
        ["coords"] = {
            ["x"] = -628.0, 
            ["y"] = -233.86, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [5] = {
        ["coords"] = {
            ["x"] = -625.7, 
            ["y"] = -237.8, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [6] = {
        ["coords"] = {
            ["x"] = -626.7, 
            ["y"] = -238.58, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [7] = {
        ["coords"] = {
            ["x"] = -624.55, 
            ["y"] = -231.06, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [8] = {
        ["coords"] = {
            ["x"] = -623.13, 
            ["y"] = -232.94, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [9] = {
        ["coords"] = {
            ["x"] = -620.29, 
            ["y"] = -234.44, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [10] = {
        ["coords"] = {
            ["x"] = -619.15, 
            ["y"] = -233.66, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [11] = {
        ["coords"] = {
            ["x"] = -620.19, 
            ["y"] = -233.44, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [12] = {
        ["coords"] = {
            ["x"] = -617.63, 
            ["y"] = -230.58, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [13] = {
        ["coords"] = {
            ["x"] = -618.33, 
            ["y"] = -229.55, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [14] = {
        ["coords"] = {
            ["x"] = -619.7, 
            ["y"] = -230.33, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [15] = {
        ["coords"] = {
            ["x"] = -620.95, 
            ["y"] = -228.6, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [16] = {
        ["coords"] = {
            ["x"] = -619.79, 
            ["y"] = -227.6, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [17] = {
        ["coords"] = {
            ["x"] = -620.42, 
            ["y"] = -226.6, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [18] = {
        ["coords"] = {
            ["x"] = -623.94, 
            ["y"] = -227.18, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [19] = {
        ["coords"] = {
            ["x"] = -624.91, 
            ["y"] = -227.87, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [20] = {
        ["coords"] = {
            ["x"] = -623.94, 
            ["y"] = -228.05, 
            ["z"] = 38.05,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }
}

Config.MaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [26] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
}

Config.FemaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
}