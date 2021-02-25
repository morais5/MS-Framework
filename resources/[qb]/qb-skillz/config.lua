Config = {}

Config.UpdateFrequency = 300 -- seconds interval between removing values 

Config.Notifications = true -- notification when skill is added

Config.Skills = {
    ["Stamina"] = {
        ["Current"] = 20, -- Default value 
        ["RemoveAmount"] = -0.3, -- % to remove when updating,
        ["Stat"] = "MP0_STAMINA" -- GTA stat hashname
    },

    ["Strength"] = {
        ["Current"] = 10,
        ["RemoveAmount"] = -0.3,
        ["Stat"] = "MP0_STRENGTH"
    },

    ["Lung Capacity"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.1,
        ["Stat"] = "MP0_LUNG_CAPACITY"
    },

    ["Shooting"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.1,
        ["Stat"] = "MP0_SHOOTING_ABILITY"
    },

    ["Driving"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.5,
        ["Stat"] = "MP0_DRIVING_ABILITY"
    },

    ["Wheelie"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.2,
        ["Stat"] = "MP0_WHEELIE_ABILITY"
    }
}
