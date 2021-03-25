Config = Config or {}

Config.WomanPlayerModels = {
    'mp_m_freemode_01',
    'mp_f_freemode_01',
}
    
Config.ManPlayerModels = {
    'mp_f_freemode_01',
    'mp_m_freemode_01',
}

Config.LoadedManModels = {}
Config.LoadedWomanModels = {}

Config.Stores = {
    [1] =   {shopType = "clothing", x = 1693.32,      y = 4823.48,     z = 41.06},
	[2] =   {shopType = "clothing", x = -712.215881,  y = -155.352982, z = 37.4151268},
	[3] =   {shopType = "clothing", x = -1192.94495,  y = -772.688965, z = 17.3255997},
	[4] =   {shopType = "clothing", x =  425.236,     y = -806.008,    z = 28.491},
	[5] =   {shopType = "clothing", x = -162.658,     y = -303.397,    z = 38.733},
	[6] =   {shopType = "clothing", x = 75.950,       y = -1392.891,   z = 28.376},
	[7] =   {shopType = "clothing", x = -822.194,     y = -1074.134,   z = 10.328},
	[8] =   {shopType = "clothing", x = -1450.711,    y = -236.83,     z = 48.809},
	[9] =   {shopType = "clothing", x = 4.254,        y = 6512.813,    z = 30.877},
	[10] =  {shopType = "clothing", x = 615.180,      y = 2762.933,    z = 41.088},
	[11] =  {shopType = "clothing", x = 1196.785,     y = 2709.558,    z = 37.222},
	[12] =  {shopType = "clothing", x = -3171.453,    y = 1043.857,    z = 19.863},
	[13] =  {shopType = "clothing", x = -1100.959,    y = 2710.211,    z = 18.107},
	[14] =  {shopType = "clothing", x = -1207.65,     y = -1456.88,    z = 4.3784737586975},
    [15] =  {shopType = "clothing", x = 121.76,       y = -224.6,      z = 53.56},
	[16] =  {shopType = "barber",   x = -814.3,       y = -183.8,      z = 36.6},
	[17] =  {shopType = "barber",   x = 136.8,        y = -1708.4,     z = 28.3},
	[18] =  {shopType = "barber",   x = -1282.6,      y = -1116.8,     z = 6.0},
	[19] =  {shopType = "barber",   x = 1931.5,       y = 3729.7,      z = 31.8},
	[20] =  {shopType = "barber",   x = 1212.8,       y = -472.9,      z = 65.2},
	[21] =  {shopType = "barber",   x = -32.9,        y = -152.3,      z = 56.1},
	[22] =  {shopType = "barber",   x = -278.1,       y = 6228.5,      z = 30.7}
}

Config.ClothingRooms = {
    [1] = {requiredJob = "police", x = 454.45, y = -988.93, z = 30.68, cameraLocation = {x = 454.51, y = -990.36, z = 30.68, h = 3.5}},
    [2] = {requiredJob = "doctor", x = 300.16, y = -598.93, z = 43.28, cameraLocation = {x = 301.09, y = -596.09, z = 43.28, h = 157.5}},
    [3] = {requiredJob = "ambulance", x = 300.16, y = -598.93, z = 43.28, cameraLocation = {x = 301.09, y = -596.09, z = 43.28, h = 157.5}},
    [4] = {requiredJob = "police", x = -451.46, y = 6014.25, z = 31.72, cameraLocation = {x = -451.46, y = 6014.25, z = 31.72}},
    [5] = {requiredJob = "ambulance", x = -250.5, y = 6323.98, z = 32.32, cameraLocation = {x = -250.5, y = 6323.98, z = 32.32, h = 315.5}},    
    [5] = {requiredJob = "doctor", x = -250.5, y = 6323.98, z = 32.32, cameraLocation = {x = -250.5, y = 6323.98, z = 32.32, h = 315.5}}, 
}

Config.Outfits = {
    ["police"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "PSP Cadete",
                outfitData = {
                    ["pants"]       = { item = 59, texture = 0},  -- Broek
                    ["arms"]        = { item = 19, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 56, texture = 0},  -- T Shirt
            --      ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 74, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 1, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 3},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [2] = {
                outfitLabel = "PSP Agente",
                outfitData = {
                    ["pants"]       = { item = 59, texture = 0},  -- Broek
                    ["arms"]        = { item = 19, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 56, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 12, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 74, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 1, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = 3},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [3] = {
                outfitLabel = "PSP Agente Casaco",
                outfitData = {
                    ["pants"]       = { item = 59, texture = 0},  -- Broek
                    ["arms"]        = { item = 20, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 72, texture = 0},  -- T Shirt
            --      ["vest"]        = { item = 7, texture = 1},  -- Body Vest
                    ["torso2"]      = { item = 156, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = -1},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [4] = {
                outfitLabel = "PSP Agente Casco Inverno",
                outfitData = {
                    ["pants"]       = { item = 59, texture = 0},  -- Broek
                    ["arms"]        = { item = 20, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 72, texture = 0},  -- T Shirt
            --      ["vest"]        = { item = 7, texture = 1},  -- Body Vest
                    ["torso2"]      = { item = 154, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = -1},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [5] = {
                outfitLabel = "PSP Agente Cerimonias",
                outfitData = {
                    ["pants"]       = { item = 35, texture = 0},  -- Broek
                    ["arms"]        = { item = 20, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 56, texture = 0},  -- T Shirt
            --      ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 200, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 36, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 46, texture = -1},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [6] = {
                outfitLabel = "PSP Chefe",
                outfitData = {
                    ["pants"]       = { item = 59, texture = 0},  -- Broek
                    ["arms"]        = { item = 20, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 72, texture = 0},  -- T Shirt
            --      ["vest"]        = { item = 7, texture = 2},  -- Body Vest
                    ["torso2"]      = { item = 35, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 10, texture = 3},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
            [7] = {
                outfitLabel = "PSP Comissario",
                outfitData = {
                    ["pants"]       = { item = 59, texture = 0},  -- Broek
                    ["arms"]        = { item = 19, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 56, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 12, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 74, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 1, texture = 0},  -- Nek / Das
            --      ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 28, texture = 0},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]         = { item = 0, texture = 0},  -- Masker
                },
            },
        },
        ["female"] = {
            [1] = {
                outfitLabel = "Test",
                outfitData = {
                    ["pants"]       = { item = 0, texture = 0},  -- Broek
                    ["arms"]        = { item = 0, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 0, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 0, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 0, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 0, texture = 0},  -- Pet
            --      ["glass"]       = { item = 0, texture = 0},  -- Bril
            --      ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
                },
            },
        }
    },
    ["ambulance"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "Inem",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 54, texture = 0},  -- T Shirt
            --      ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 102, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
             --       ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
                },
            },
            [2] = {
                outfitLabel = "Inem Enfermeiro",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 54, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 102, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
              --    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
                },
            },
			[3] = {
                outfitLabel = "Inem Medico",
                outfitData = {
                    ["pants"]       = { item = 59,texture = 5},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 4},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker	
				},
			},
			[4] = {
                outfitLabel = "Inem Casaco",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 88, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 54, texture = 0},  -- T Shirt
                --  ["vest"]        = { item = 18, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 53, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
				},
			},
			[5] = {
                outfitLabel = "Inem Hoodie",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 90, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                --  ["vest"]        = { item = 18, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 249, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 0, texture = 0},  -- Masker
                },
            },
            [6] = {
                outfitLabel = "Inem Mota",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 90, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                --  ["vest"]        = { item = 18, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 249, texture = 0},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 16, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
                },
            },
        },
        ["female"] = {},
    },
    ["doctor"] = {
        ["male"] = {
            [1] = {
                outfitLabel = "Coat For Doctors",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 88, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 118, texture = 7},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
			},
			[2] = {
                outfitLabel = "T-Shirt Heavy Vest",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 0},  -- Broek
                    ["arms"]        = { item = 85, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 88, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 18, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 32, texture = 6},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
			},			
			[3] = {
                outfitLabel = "OVD-G",
                outfitData = {
                    ["pants"]       = { item = 49,texture = 4},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 51, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 2},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = -1},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
			},
			[4] = {
                outfitLabel = "MMT Pilot",
                outfitData = {
                    ["pants"]       = { item = 59,texture = 5},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 3},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker	
				},
			},
			[5] = {
                outfitLabel = "MMT Doctor",
                outfitData = {
                    ["pants"]       = { item = 59,texture = 5},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 5},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker	
				},
			},
			[6] = {
                outfitLabel = "MMT Nurse",
                outfitData = {
                    ["pants"]       = { item = 59,texture = 5},  -- Broek
                    ["arms"]        = { item = 86, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 135, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 151, texture = 4},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = 79, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker	
				},
			},		
		},		
        ["female"] = {
            [1] = {
                outfitLabel = "Female Outfit",
                outfitData = {
                    ["pants"]       = { item = 3,texture = 1},  -- Broek
                    ["arms"]        = { item = 14, texture = 0},  -- Armen
                    ["t-shirt"]     = { item = 3, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 14, texture = 1},  -- Jas / Vesten
                    ["shoes"]       = { item = 25, texture = 0},  -- Schoenen
                    ["decals"]      = { item = 0, texture = 0},  -- Decals
                    ["accessory"]   = { item = 0, texture = 0},  -- Nek / Das
                    ["bag"]         = { item = 0, texture = 0},  -- Tas
                    ["hat"]         = { item = -1, texture = 0},  -- Pet
                    ["glass"]       = { item = 0, texture = 0},  -- Bril
                    ["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                    ["mask"]        = { item = 121, texture = 0},  -- Masker
				},
            },
        },
    },
}