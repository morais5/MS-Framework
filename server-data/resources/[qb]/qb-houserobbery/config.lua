Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config = {}

Config.MinZOffset = 45

Config.MinimumHouseRobberyPolice = 3

Config.MinimumTime = 0
Config.MaximumTime = 5

Config.Rewards = {
    [1] = {
        ["cabin"] = {
            "plastic",
            "diamond_ring",
            "goldchain",
        },
        ["kitchen"] = {
            "tosti",
            "sandwich",
            "goldchain",
        },
        ["chest"] = {
            "plastic",
            "rolex",
            "diamond_ring",
            "goldchain",
        },
    }
}

Config.Houses = {
    ["grovestreet1"] = { -- Moved 28-1-2020
        ["coords"] = {
            ["x"] = 500.75,
            ["y"] = -1697.16,
            ["z"] = 29.78,
            ["h"] = 326.5,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["geilhuisje"] = {
        ["coords"] = {
            ["x"] = 46.46,
            ["y"] = -30.96,
            ["z"] = 73.68,
            ["h"] = 229.5,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["kechie"] = {
        ["coords"] = {
            ["x"] = -784.45,
            ["y"] = 459.3,
            ["z"] = 100.17,
            ["h"] = 229.5,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["needasniks"] = {
        ["coords"] = {
            ["x"] = -536.63,
            ["y"] = 818.51,
            ["z"] = 197.51,
            ["h"] = 229.5,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["12345"] = {
        ["coords"] = {
            ["x"] = 1229.64, 
            ["y"] = -725.33, 
            ["z"] = 60.95, 
            ["h"] = 97.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["12sdgsd345"] = {
        ["coords"] = {
            ["x"] = 808.83, 
            ["y"] = -163.65, 
            ["z"] = 75.87, 
            ["h"] = 331.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house1"] = {
        ["coords"] = {
            ["x"] = 5.76, 
            ["y"] = -9.49, 
            ["z"] = 70.3, 
            ["h"] = 159.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house2"] = { -- Moved 28-1-20
        ["coords"] = {
            ["x"] = 1010.41, 
            ["y"] = -423.39, 
            ["z"] = 65.34, 
            ["h"] = 133.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house3"] = { -- Moved 28-1-2020
        ["coords"] = {
            ["x"] = -678.96, 
            ["y"] = 512.12, 
            ["z"] = 113.52, 
            ["h"] = 18.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house4"] = {
        ["coords"] = {
            ["x"] = -1308.13, 
            ["y"] = 448.89, 
            ["z"] = 100.96, 
            ["h"] = 172.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house5"] = {
        ["coords"] = {
            ["x"] = -1413.59, 
            ["y"] = 462.1, 
            ["z"] = 109.2, 
            ["h"] = 164.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house6"] = {
        ["coords"] = {
            ["x"] = -2015.01, 
            ["y"] = 499.84, 
            ["z"] = 107.17, 
            ["h"] = 85.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house7"] = {
        ["coords"] = {
            ["x"] = 329.37, 
            ["y"] = -1845.84, 
            ["z"] = 27.74, 
            ["h"] = 236.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house8"] = {
        ["coords"] = {
            ["x"] = 489.64, 
            ["y"] = -1714.1, 
            ["z"] = 29.7, 
            ["h"] = 49.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house9"] = {
        ["coords"] = {
            ["x"] = 1312.14, 
            ["y"] = -1697.35, 
            ["z"] = 58.22, 
            ["h"] = 11.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house10"] = {
        ["coords"] = {
            ["x"] = 1379.2, 
            ["y"] = -1514.89, 
            ["z"] = 58.43, 
            ["h"] = 30.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house11"] = {
        ["coords"] = {
            ["x"] = -246.14, 
            ["y"] = 6414.11, 
            ["z"] = 31.46, 
            ["h"] = 310.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
    ["house12"] = {
        ["coords"] = {
            ["x"] = -407.22, 
            ["y"] = 6313.92, 
            ["z"] = 28.94, 
            ["h"] = 41.5,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar armario da cozinha"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar baú"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Vasculhar mesinha"
            },
        }
    },
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
    [16] = true,
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