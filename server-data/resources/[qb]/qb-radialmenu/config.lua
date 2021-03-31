Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config = {}

Config.MenuItems = {
    [1] = {
        id = 'citizen',
        title = 'Citizen',
        icon = '#citizen',
        items = {
            {
                id    = 'givenum',
                title = 'Give Contact Details',
                icon = '#nummer',
                type = 'client',
                event = 'qb-phone_new:client:GiveContactDetails',
                shouldClose = true,
            },
            {
                id    = 'billplayer',
                title = 'Bill Player',
                icon = '#general',
                type = 'client',
                event = 'police:client:BillPlayer',
                shouldClose = true,
            },
            {
                id    = 'getintrunk',
                title = 'Get In',
                icon = '#vehiclekey',
                type = 'client',
                event = 'qb-trunk:client:GetIn',
                shouldClose = true,
            },
            {
                id    = 'cornerselling',
                title = 'Sell Herbs',
                icon = '#cornerselling',
                type = 'client',
                event = 'qb-drugs:client:cornerselling',
                shouldClose = true,
            },
            {
                id    = 'togglehotdogsell',
                title = 'Sell hot dogs',
                icon = '#cornerselling',
                type = 'client',
                event = 'qb-hotdogjob:client:ToggleSell',
                shouldClose = true,
            },
            {
                id = 'interactions',
                title = 'Interactions',
                icon = '#illegal',
                items = {
                    {
                        id    = 'handcuff',
                        title = 'Handcuff',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:CuffPlayerSoft',
                        shouldClose = true,
                    },
                    {
                        id    = 'playerinvehicle',
                        title = 'Place in vehicle',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:PutPlayerInVehicle',
                        shouldClose = true,
                    },
                    {
                        id    = 'playerinvehicle',
                        title = 'Place in vehicle',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:PutPlayerInVehicle',
                        shouldClose = true,
                    },
                    {
                        id    = 'stealplayer',
                        title = 'Rob',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:RobPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort',
                        title = 'Kidnap',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:KidnapPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort2',
                        title = 'Escort',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:EscortPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort554',
                        title = 'Take Hostage',
                        icon = '#general',
                        type = 'client',
                        event = 'A5:Client:TakeHostage',
                        shouldClose = true,
                    },
                }
            },
        }
    },
    [2] = {
        id = 'general',
        title = 'General',
        icon = '#general',
        items = {
            {
                id = 'house',
                title = 'House',
                icon = '#house',
                items = {
                    {
                        id    = 'givehousekey',
                        title = 'Give Keys',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:giveHouseKey',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'removehousekey',
                        title = 'Remove Keys',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:removeHouseKey',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'togglelock',
                        title = 'Lock/Unlock',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:toggleDoorlock',
                        shouldClose = true,
                    },
                    {
                        id    = 'decoratehouse',
                        title = 'Decorate',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'qb-houses:client:decorate',
                        shouldClose = true,
                    },            
                    {
                        id = 'houseLocations',
                        title = 'Place Objects',
                        icon = '#house',
                        items = {
                            {
                                id    = 'setstash',
                                title = 'Set Stash',
                                icon = '#vehiclekey',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true,
                            },
                            {
                                id    = 'setoutift',
                                title = 'Set Outfit',
                                icon = '#vehiclekey',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true,
                            },
                            {
                                id    = 'setlogout',
                                title = 'Set Logout',
                                icon = '#vehiclekey',
                                type = 'client',
                                event = 'qb-houses:client:setLocation',
                                shouldClose = true,
                            },
                        }
                    },
                }
            },
        }
    },
    [3] = {
        id = 'vehicle',
        title = 'Vehicle',
        icon = '#vehicle',
        items = {
            {
                id    = 'vehicledoors',
                title = 'Doors',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Driver',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door4',
                        title = 'Hood',
                        icon = '#idkaart',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door1',
                        title = 'Passenger',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door3',
                        title = 'Right rear',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door5',
                        title = 'Trunk',
                        icon = '#idkaart',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door2',
                        title = 'Left rear',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'qb-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                }
            },
            {
                id    = 'vehicleextras',
                title = 'Extra',
                icon = '#plus',
                items = {
                    {
                        id    = 'extra1',
                        title = 'Extra 1',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra2',
                        title = 'Extra 2',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra3',
                        title = 'Extra 3',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra4',
                        title = 'Extra 4',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra5',
                        title = 'Extra 5',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra6',
                        title = 'Extra 6',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra7',
                        title = 'Extra 7',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra8',
                        title = 'Extra 8',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra9',
                        title = 'Extra 9',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:setExtra',
                        shouldClose = false,
                    },                                                                                                                  
                }
            },
            {
                id    = 'vehicleseats',
                title = 'Vehicle Seats',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Driver',
                        icon = '#plus',
                        type = 'client',
                        event = 'qb-radialmenu:client:ChangeSeat',
                        shouldClose = false,
                    },
                }
            },
        }
    },
    [4] = {
        id = 'jobinteractions',
        title = 'Work',
        icon = '#vehicle',
        items = {},
    },
    [5] = {
        id = 'acessoriosroupainteragir',
        title = 'Accessories',
        icon = '#vehicleseat',
        items = {
            {
                id    = 'mascara',
                title = 'Mask',
                icon = '#leftdoor',
                type = 'server',
                event = 'qb-clothing:delbes:radialmenu:mascara',
                shouldClose = false,
            },
            {
                id    = 'oculos',
                title = 'Glasses',
                icon = '#leftdoor',
                type = 'server',
                event = 'qb-clothing:delbes:radialmenu:oculos',
                shouldClose = false,
            },
            {
                id    = 'chapeu',
                title = 'Hat',
                icon = '#leftdoor',
                type = 'server',
                event = 'qb-clothing:delbes:radialmenu:chapeu',
                shouldClose = false,
            },
        }
    },
}

Config.JobInteractions = {
    ["ambulance"] = {
        {
            id    = 'statuscheck',
            title = 'Check Status',
            icon = '#general',
            type = 'client',
            event = 'hospital:client:CheckStatus',
            shouldClose = true,
        },
        {
            id    = 'reviveplayer',
            title = 'Revive',
            icon = '#general',
            type = 'client',
            event = 'hospital:client:RevivePlayer',
            shouldClose = true,
        },
        {
            id    = 'treatwounds',
            title = 'Treat',
            icon = '#general',
            type = 'client',
            event = 'hospital:client:TreatWounds',
            shouldClose = true,
        },
        {
            id    = 'emergencybutton2',
            title = 'Police Emergency',
            icon = '#general',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true,
        },
        {
            id    = 'escort',
            title = 'Escort',
            icon = '#general',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true,
        },
        {
            id = 'brancardoptions',
            title = 'Stretcher',
            icon = '#vehicle',
            items = {
                {
                    id    = 'spawnbrancard',
                    title = 'Use Stretcher',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:TakeBrancard',
                    shouldClose = false,
                },
                {
                    id    = 'despawnbrancard',
                    title = 'Remove Stretcher',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:RemoveBrancard',
                    shouldClose = false,
                },
            },
        },
    },
    ["taxi"] = {
        {
            id    = 'togglemeter',
            title = 'Show/Hide Meter',
            icon = '#general',
            type = 'client',
            event = 'qb-taxi:client:toggleMeter',
            shouldClose = false,
        },
        {
            id    = 'togglemouse',
            title = 'Start/Stop Meter',
            icon = '#general',
            type = 'client',
            event = 'qb-taxi:client:enableMeter',
            shouldClose = true,
        },
        {
            id    = 'npc_mission',
            title = 'NPC Taxi',
            icon = '#general',
            type = 'client',
            event = 'qb-taxi:client:DoTaxiNpc',
            shouldClose = true,
        },
    },
    ["police"] = {
        {
            id    = 'emergencybutton',
            title = 'Police Emergency',
            icon = '#general',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true,
        },
        {
            id    = 'checkvehstatus',
            title = 'Check Veh.Status',
            icon = '#vehiclekey',
            type = 'client',
            event = 'qb-tunerchip:server:TuneStatus',
            shouldClose = true,
        },
        {
            id    = 'resethouse',
            title = 'Reset House Lock',
            icon = '#vehiclekey',
            type = 'client',
            event = 'qb-houses:client:ResetHouse',
            shouldClose = true,
        },
        {
            id    = 'takedriverlicense',
            title = 'Take Driver License',
            icon = '#vehicle',
            type = 'client',
            event = 'police:client:SeizeDriverLicense',
            shouldClose = true,
        },
        {
            id = 'policeinteraction',
            title = 'Police',
            icon = '#house',
            items = {
                {
                    id    = 'statuscheck',
                    title = 'Check Status',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:CheckStatus',
                    shouldClose = true,
                },
                {
                    id    = 'escort',
                    title = 'Escort',
                    icon = '#general',
                    type = 'client',
                    event = 'police:client:EscortPlayer',
                    shouldClose = true,
                },
                {
                    id    = 'searchplayer',
                    title = 'Search Player',
                    icon = '#general',
                    type = 'client',
                    event = 'police:client:SearchPlayer',
                    shouldClose = true,
                },
                {
                    id    = 'jailplayer',
                    title = 'Jail Player',
                    icon = '#general',
                    type = 'client',
                    event = 'police:client:JailPlayer',
                    shouldClose = true,
                },
            }
        },
        {
            id = 'policeobjects',
            title = 'Objects',
            icon = '#house',
            items = {
                {
                    id    = 'spawnpion',
                    title = 'Cone',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnCone',
                    shouldClose = false,
                },
                {
                    id    = 'spawnhek',
                    title = 'Barier',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnBarier',
                    shouldClose = false,
                },
                {
                    id    = 'spawnschotten',
                    title = 'Scote',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnSchotten',
                    shouldClose = false,
                },
                {
                    id    = 'spawntent',
                    title = 'Tent',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnTent',
                    shouldClose = false,
                },
                {
                    id    = 'spawnverlichting',
                    title = 'Light',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnLight',
                    shouldClose = false,
                },
                {
                    id    = 'spikestrip',
                    title = 'Spikestrip',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:SpawnSpikeStrip',
                    shouldClose = false,
                },
                {
                    id    = 'deleteobject',
                    title = 'Remove object',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:deleteObject',
                    shouldClose = false,
                },
            }
        },
    },
}

Config.TrunkClasses = {
    [0]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [1]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sedans  
    [2]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --SUVs  
    [3]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [4]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Muscle  
    [5]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports Classics  
    [6]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports  
    [7]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Super  
    [8]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Motorcycles  
    [9]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Off-road  
    [10] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Industrial  
    [11] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Utility  
    [12] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Vans  
    [13] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Cycles  
    [14] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Boats  
    [15] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Helicopters  
    [16] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Planes  
    [17] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Service  
    [18] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Emergency  
    [19] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Military  
    [20] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Commercial  
    [21] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Trains  
}