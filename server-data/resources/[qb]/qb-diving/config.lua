QBBoatshop = QBBoatshop or {}
QBDiving = QBDiving or {}

QBBoatshop.PoliceBoat = {
    x = -800.67, 
    y = -1494.54, 
    z = 1.59,
}

QBBoatshop.PoliceBoatSpawn = {
    x = -793.58, 
    y = -1501.4, 
    z = 0.12,
    h = 111.5,
}

QBBoatshop.PoliceBoat2 = {
    x = -279.41, 
    y = 6635.09, 
    z = 7.51,
}

QBBoatshop.PoliceBoatSpawn2 = {
    x = -293.10, 
    y = 6642.69, 
    z = 0.15,
    h = 65.5,
}

QBBoatshop.Docks = {
    ["lsymc"] = {
        label = "LSYMC Boat house",
        coords = {
            take = {
                x = -794.66, 
                y = -1510.83, 
                z = 1.59,
            },
            put = {
                x = -793.58, 
                y = -1501.4, 
                z = 0.12,
                h = 111.5,
            }
        }
    },
    ["paletto"] = {
        label = "Paleto Boat house",
        coords = {
            take = {
                x = -277.46, 
                y = 6637.2, 
                z = 7.48,
            },
            put = {
                x = -289.2, 
                y = 6637.96, 
                z = 1.01,
                h = 45.5,
            }
        }
    },    
    ["millars"] = {
        label = "Millars Boat house",
        coords = {
            take = {
                x = 1299.24, 
                y = 4216.69, 
                z = 33.9, 
            },
            put = {
                x = 1297.82, 
                y = 4209.61, 
                z = 30.12, 
                h = 253.5,
            }
        }
    },
}

QBBoatshop.Depots = {
    [1] = {
        label = "LSYMC Impound",
        coords = {
            take = {
                x = -772.98, 
                y = -1430.76, 
                z = 1.59, 
            },
            put = {
                x = -729.77, 
                y = -1355.49, 
                z = 1.19, 
                h = 142.5,
            }
        }
    },
}

QBBoatshop.Locations = {
    ["berths"] = {
        [1] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -727.05,
                    ["y"] = -1326.59,
                    ["z"] = 1.06,
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -723.3,
                    ["y"] = -1323.61,
                    ["z"] = 1.59,
                }
            },
            ["inUse"] = false
        },
        [2] = {
            ["boatModel"] = "speeder",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -732.84, 
                    ["y"] = -1333.5, 
                    ["z"] = 1.59, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -729.19, 
                    ["y"] = -1330.58, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [3] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -737.84, 
                    ["y"] = -1340.83, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -734.98, 
                    ["y"] = -1337.42, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [4] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -743.53, 
                    ["y"] = -1347.7, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -740.62, 
                    ["y"] = -1344.28, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [5] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -749.59, 
                    ["y"] = -1354.88, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -746.6, 
                    ["y"] = -1351.36, 
                    ["z"] = 1.59, 
                },
            },
            ["inUse"] = false
        },
        [6] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -755.39, 
                    ["y"] = -1361.76, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -752.49,
                    ["y"] = -1358.28,
                    ["z"] = 1.59,
                },
            },
            ["inUse"] = false
        },
        -- [7] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -769.06, 
        --             ["y"] = -1377.97, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [8] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -774.99, 
        --             ["y"] = -1385.0, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [9] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -780.66, 
        --             ["y"] = -1391.73, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [10] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -786.47, 
        --             ["y"] = -1398.6, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [11] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -792.27, 
        --             ["y"] = -1405.48, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [12] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -798.33, 
        --             ["y"] = -1412.67, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
    }
}

QBBoatshop.ShopBoats = {
    ["dinghy"] = {
        ["model"] = "dinghy",
        ["label"] = "Dinghy",
        ["price"] = 40000
    },
    ["speeder"] = {
        ["model"] = "speeder",
        ["label"] = "Speeder",
        ["price"] = 60000
    }
}

QBBoatshop.SpawnVehicle = {
    x = -729.77, 
    y = -1355.49, 
    z = 1.19, 
    h = 142.5,
}

QBDiving.Locations = {
    [1] = {
        label = "Location 1",
        coords = {
            Area = {
                x = -2838.8, 
                y = -376.1, 
                z = 3.55
            },
            Coral = {
                [1] = {
                    coords = {
                        x = -2849.25, 
                        y = -377.58, 
                        z = -40.23
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = -2838.43, 
                        y = -363.63, 
                        z = -39.45
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = -2887.04, 
                        y = -394.87, 
                        z = -40.91
                    },
                    PickedUp = false
                },
                [4] = {
                    coords = {
                        x = -2808.99, 
                        y = -385.56, 
                        z = -39.32
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
    [2] = {
        label = "location 2",
        coords = {
            Area = {
                x = -3288.2, 
                y = -67.58,
                z = 2.79,
            },
            Coral = {
                [1] = {
                    coords = {
                        x = -3275.03, 
                        y = -38.58, 
                        z = -19.21,
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = -3273.73, 
                        y = -76.0, 
                        z = -26.81,
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = -3346.53, 
                        y = -50.4, 
                        z = -35.84
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 3,
        TotalCoral = 3,
    },
    [3] = {
        label = "location 3",
        coords = {
            Area = {
                x = -3367.24, 
                y = 1617.89, 
                z = 1.39,
            },
            Coral = {
                [1] = {
                    coords = {
                        x = -3388.01, 
                        y = 1635.88, 
                        z = -39.41,
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = -3354.19, 
                        y = 1549.3, 
                        z = -38.21,
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = -3326.04, 
                        y = 1636.43, 
                        z = -40.98
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 3,
        TotalCoral = 3,
    },
    [4] = {
        label = "location 4",
        coords = {
            Area = {
                x = 3002.5, 
                y = -1538.28, 
                z = -27.36, 
            },
            Coral = {
                [1] = {
                    coords = {
                        x = 2978.05, 
                        y = -1509.07, 
                        z = -24.96, 
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = 3004.42, 
                        y = -1576.95, 
                        z = -29.36, 
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = 2951.65, 
                        y = -1560.69, 
                        z = -28.36, 
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 3,
        TotalCoral = 3,
    },
    [5] = {
        label = "location 5",
        coords = {
            Area = {
                x = 3421.58, 
                y = 1975.68, 
                z = 0.86, 
            },
            Coral = {
                [1] = {
                    coords = {
                        x = 3421.69, 
                        y = 1976.54, 
                        z = -50.64, 
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = 3424.07, 
                        y = 1957.46, 
                        z = -53.04, 
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = 3434.65, 
                        y = 1993.73, 
                        z = -49.84, 
                    },
                    PickedUp = false
                },
                [4] = {
                    coords = {
                        x = 3415.42, 
                        y = 1965.25, 
                        z = -52.04,
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
    [6] = {
        label = "location 6",
        coords = {
            Area = {
                x = 2720.14, 
                y = -2136.28, 
                z = 0.74, 
            },
            Coral = {
                [1] = {
                    coords = {
                        x = 2724.0, 
                        y = -2134.95, 
                        z = -19.33, 
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = 2710.68, 
                        y = -2156.06, 
                        z = -18.63, 
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = 2702.84, 
                        y = -2139.29, 
                        z = -18.51, 
                    },
                    PickedUp = false
                },
                [4] = {
                    coords = {
                        x = 2736.27, 
                        y = -2153.91, 
                        z = -20.88, 
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
    [7] = {
        label = "location 7",
        coords = {
            Area = {
                x = 536.69, 
                y = 7253.75, 
                z = 1.69, 
            },
            Coral = {
                [1] = {
                    coords = {
                        x = 542.31, 
                        y = 7245.37, 
                        z = -30.01, 
                    },
                    PickedUp = false
                },
                [2] = {
                    coords = {
                        x = 528.21, 
                        y = 7223.26, 
                        z = -29.51, 
                    },
                    PickedUp = false
                },
                [3] = {
                    coords = {
                        x = 510.36, 
                        y = 7254.97, 
                        z = -32.11, 
                    },
                    PickedUp = false
                },
                [4] = {
                    coords = {
                        x = 525.37, 
                        y = 7259.12, 
                        z = -30.51, 
                    },
                    PickedUp = false
                },
            }
        },
        DefaultCoral = 4,
        TotalCoral = 4,
    },
}

QBDiving.CoralTypes = {
    [1] = {
        item = "dendrogyra_coral",
        maxAmount = math.random(2, 7),
        price = math.random(400, 500),
    },
    [2] = {
        item = "antipatharia_coral",
        maxAmount = math.random(2, 7),
        price = math.random(300, 450),
    }
}

QBDiving.SellLocations = {
    [1] = {
        ["coords"] = {
            ["x"] = -1686.9, 
            ["y"] = -1072.23, 
            ["z"] = 13.15
        }
    }
}