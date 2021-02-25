local Radio = {
    Has = false,
    Open = false,
    On = false,
    Enabled = true,
    Handle = nil,
    Prop = `prop_cs_hand_radio`,
    Bone = 28422,
    Offset = vector3(0.0, 0.0, 0.0),
    Rotation = vector3(0.0, 0.0, 0.0),
    Dictionary = {
        "cellphone@",
        "cellphone@in_car@ds",
        "cellphone@str",    
        "random@arrests",  
    },
    Animation = {
        "cellphone_text_in",
        "cellphone_text_out",
        "cellphone_call_listen_a",
        "generic_radio_chatter",
    },
    Clicks = true, -- Radio clicks
}
Radio.Labels = {        
    { "FRZL_RADIO_HELP", "~s~" .. (radioConfig.Controls.Secondary.Enabled and "~" .. radioConfig.Controls.Secondary.Name .. "~ + ~" .. radioConfig.Controls.Activator.Name .. "~" or "~" .. radioConfig.Controls.Activator.Name .. "~") .. " para Fechar.~n~~" .. radioConfig.Controls.Toggle.Name .. "~ para ~g~ligar~s~ o radio.~n~~" .. radioConfig.Controls.Decrease.Name .. "~ ou ~" .. radioConfig.Controls.Increase.Name .. "~ para alterar a frequencia~n~~" .. radioConfig.Controls.Input.Name .. "~ para escolher a frequencia~n~~" .. radioConfig.Controls.ToggleClicks.Name .. "~ para ~a~ sons interativos~n~Frequencia: ~1~ MHz" },
    { "FRZL_RADIO_HELP2", "~s~" .. (radioConfig.Controls.Secondary.Enabled and "~" .. radioConfig.Controls.Secondary.Name .. "~ + ~" .. radioConfig.Controls.Activator.Name .. "~" or "~" .. radioConfig.Controls.Activator.Name .. "~") .. " para Fechar.~n~~" .. radioConfig.Controls.Toggle.Name .. "~ para ~r~desligar~s~ o radio.~n~~" .. radioConfig.Controls.Broadcast.Name .. "~ para comunicar.~n~Frequencia: ~1~ MHz" },
    { "FRZL_RADIO_INPUT", "Entrar na Frequencia" },
}
Radio.Commands = {
    {
        Enabled = true, -- Add a command to be able to open/close the radio
        Name = "radio", -- Command name
        Help = "Toggle hand radio", -- Command help shown in chatbox when typing the command
        Params = {},
        Handler = function(src, args, raw)
            local playerPed = PlayerPedId()
            local isFalling = IsPedFalling(playerPed)
            local isDead = IsEntityDead(playerPed)

            if not isFalling and Radio.Enabled and Radio.Has and not isDead then
                Radio:Toggle(not Radio.Open)
            elseif (Radio.Open or Radio.On) and ((not Radio.Enabled) or (not Radio.Has) or isDead) then
                Radio:Toggle(false)
                Radio.On = false
                Radio:Remove()
                exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false)
            elseif Radio.Open and isFalling then
                Radio:Toggle(false)
            end            
        end,
    },
    {
        Enabled = true, -- Add a command to choose radio frequency
        Name = "frequency", -- Command name
        Help = "Muda a frequencia da Radio", -- Command help shown in chatbox when typing the command
        Params = {
            {name = "number", "Digita uma frequencia"}
        },
        Handler = function(src, args, raw)
            if Radio.Has then
                if args[1] then
                    local newFrequency = tonumber(args[1])
                    if newFrequency then
                        local minFrequency = radioConfig.Frequency.List[1]
                        if newFrequency >= minFrequency and newFrequency <= radioConfig.Frequency.List[#radioConfig.Frequency.List] and newFrequency == math.floor(newFrequency) then
                            if not radioConfig.Frequency.Private[newFrequency] or radioConfig.Frequency.Access[newFrequency] then
                                local idx = nil
                    
                                for i = 1, #radioConfig.Frequency.List do
                                    if radioConfig.Frequency.List[i] == newFrequency then
                                        idx = i
                                        break
                                    end
                                end
                    
                                if idx ~= nil then
                                    if Radio.Enabled then
                                        Radio:Remove()
                                    end

                                    radioConfig.Frequency.CurrentIndex = idx
                                    radioConfig.Frequency.Current = newFrequency

                                    if Radio.On then
                                        Radio:Add(radioConfig.Frequency.Current)
                                    end
                                end
                            end
                        end
                    end
                end                    
            end
        end,
    },
}

-- Setup each radio command if enabled
for i = 1, #Radio.Commands do
    if Radio.Commands[i].Enabled then
        RegisterCommand(Radio.Commands[i].Name, Radio.Commands[i].Handler, false)
        TriggerEvent("chat:addSuggestion", "/" .. Radio.Commands[i].Name, Radio.Commands[i].Help, Radio.Commands[i].Params)
    end
end

-- Create/Destroy handheld radio object
function Radio:Toggle(toggle)
    local playerPed = PlayerPedId()
    local count = 0

    if not self.Has or IsEntityDead(playerPed) then
        self.Open = false
        
        DetachEntity(self.Handle, true, false)
        DeleteEntity(self.Handle)
        
        return
    end

    if self.Open == toggle then
        return
    end

    self.Open = toggle

    if self.On and not radioConfig.AllowRadioWhenClosed then
        exports["mumble-voip"]:SetMumbleProperty("radioEnabled", toggle)
    end

    local dictionaryType = 1 + (IsPedInAnyVehicle(playerPed, false) and 1 or 0)
    local animationType = 1 + (self.Open and 0 or 1)
    local dictionary = self.Dictionary[dictionaryType]
    local animation = self.Animation[animationType]

    RequestAnimDict(dictionary)

    while not HasAnimDictLoaded(dictionary) do
        Citizen.Wait(150)
    end

    if self.Open then
        RequestModel(self.Prop)

        while not HasModelLoaded(self.Prop) do
            Citizen.Wait(150)
        end

        self.Handle = CreateObject(self.Prop, 0.0, 0.0, 0.0, true, true, false)

        local bone = GetPedBoneIndex(playerPed, self.Bone)

        SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
        AttachEntityToEntity(self.Handle, playerPed, bone, self.Offset.x, self.Offset.y, self.Offset.z, self.Rotation.x, self.Rotation.y, self.Rotation.z, true, false, false, false, 2, true)

        SetModelAsNoLongerNeeded(self.Handle)

        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)
    else
        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)

        Citizen.Wait(700)

        StopAnimTask(playerPed, dictionary, animation, 1.0)

        NetworkRequestControlOfEntity(self.Handle)

		while not NetworkHasControlOfEntity(self.Handle) and count < 5000 do
            Citizen.Wait(0)
            count = count + 1
        end
        
        DetachEntity(self.Handle, true, false)
        DeleteEntity(self.Handle)
    end
end

-- Add player to radio channel
function Radio:Add(id)
    exports["mumble-voip"]:SetRadioChannel(id)
end

-- Remove player from radio channel
function Radio:Remove()
    exports["mumble-voip"]:SetRadioChannel(0)
end

-- Increase radio frequency
function Radio:Decrease()
    if self.On then
        if radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] == radioConfig.Frequency.Current then
            self:Remove(radioConfig.Frequency.Current)
            radioConfig.Frequency.CurrentIndex = #radioConfig.Frequency.List
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
            self:Add(radioConfig.Frequency.Current)
        elseif radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] ~= radioConfig.Frequency.Current then
            self:Remove(radioConfig.Frequency.Current)
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
            self:Add(radioConfig.Frequency.Current)
        else
            self:Remove(radioConfig.Frequency.Current)
            radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex - 1
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
            self:Add(radioConfig.Frequency.Current)
        end
    else
        if radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] == radioConfig.Frequency.Current then
            radioConfig.Frequency.CurrentIndex = #radioConfig.Frequency.List
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
        elseif radioConfig.Frequency.CurrentIndex - 1 < 1 and radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] ~= radioConfig.Frequency.Current then
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
        else
            radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex - 1

            if radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex] == radioConfig.Frequency.Current then
                radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex - 1
            end

            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
        end
    end
end

-- Decrease radio frequency
function Radio:Increase()
    if self.On then
        if radioConfig.Frequency.CurrentIndex + 1 > #radioConfig.Frequency.List then
            self:Remove(radioConfig.Frequency.Current)
            radioConfig.Frequency.CurrentIndex = 1
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
            self:Add(radioConfig.Frequency.Current)
        else
            self:Remove(radioConfig.Frequency.Current)
            radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex + 1
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
            self:Add(radioConfig.Frequency.Current)
        end
    else
        if #radioConfig.Frequency.List == radioConfig.Frequency.CurrentIndex + 1 then            
            if radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex + 1] == radioConfig.Frequency.Current then
                radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex + 1
            end
        end
        
        if radioConfig.Frequency.CurrentIndex + 1 > #radioConfig.Frequency.List then
            radioConfig.Frequency.CurrentIndex = 1
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
        else
            radioConfig.Frequency.CurrentIndex = radioConfig.Frequency.CurrentIndex + 1
            radioConfig.Frequency.Current = radioConfig.Frequency.List[radioConfig.Frequency.CurrentIndex]
        end
    end
end

-- Generate list of available frequencies
function GenerateFrequencyList()
    radioConfig.Frequency.List = {}

    for i = radioConfig.Frequency.Min, radioConfig.Frequency.Max do
        if not radioConfig.Frequency.Private[i] or radioConfig.Frequency.Access[i] then
            radioConfig.Frequency.List[#radioConfig.Frequency.List + 1] = i
        end
    end
end

-- Check if radio is open
function IsRadioOpen()
    return Radio.Open
end

-- Check if radio is switched on
function IsRadioOn()
    return Radio.On
end

-- Check if player has radio
function IsRadioAvailable()
    return Radio.Has
end

-- Check if radio is enabled or not
function IsRadioEnabled()
    return not Radio.Enabled
end

-- Check if radio can be used
function CanRadioBeUsed()
    return Radio.Has and Radio.On and Radio.Enabled
end

-- Set if the radio is enabled or not
function SetRadioEnabled(value)
    if type(value) == "string" then
        value = value == "true"
    elseif type(value) == "number" then
        value = value == 1
    end
    
    Radio.Enabled = value and true or false
end

-- Set if player has a radio or not
function SetRadio(value)
    if type(value) == "string" then
        value = value == "true"
    elseif type(value) == "number" then
        value = value == 1
    end

    Radio.Has = value and true or false
end

-- Set if player has access to use the radio when closed
function SetAllowRadioWhenClosed(value)
    radioConfig.Frequency.AllowRadioWhenClosed = value

    if Radio.On and not Radio.Open and radioConfig.AllowRadioWhenClosed then
        exports["mumble-voip"]:SetMumbleProperty("radioEnabled", true)
    end
end

-- Add new frequency
function AddPrivateFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if not radioConfig.Frequency.Private[frequency] then -- Only add new frequencies
            radioConfig.Frequency.Private[frequency] = true

            GenerateFrequencyList()
        end
    end
end

-- Remove private frequency
function RemovePrivateFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if radioConfig.Frequency.Private[frequency] then -- Only remove existing frequencies
            radioConfig.Frequency.Private[frequency] = nil

            GenerateFrequencyList()
        end
    end
end

-- Give access to a frequency
function GivePlayerAccessToFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if radioConfig.Frequency.Private[frequency] then -- Check if frequency exists
            if not radioConfig.Frequency.Access[frequency] then -- Only add new frequencies
                radioConfig.Frequency.Access[frequency] = true

                GenerateFrequencyList()
            end
        end
    end 
end

-- Remove access to a frequency
function RemovePlayerAccessToFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if radioConfig.Frequency.Access[frequency] then -- Check if player has access to frequency
            radioConfig.Frequency.Access[frequency] = nil

            GenerateFrequencyList()
        end
    end 
end

-- Give access to multiple frequencies
function GivePlayerAccessToFrequencies(...)
    local frequencies = { ... }
    local newFrequencies = {}
    
    for i = 1, #frequencies do
        local frequency = tonumber(frequencies[i])

        if frequency ~= nil then
            if radioConfig.Frequency.Private[frequency] then -- Check if frequency exists
                if not radioConfig.Frequency.Access[frequency] then -- Only add new frequencies
                    newFrequencies[#newFrequencies + 1] = frequency
                end
            end
        end
    end

    if #newFrequencies > 0 then
        for i = 1, #newFrequencies do
            radioConfig.Frequency.Access[newFrequencies[i]] = true
        end

        GenerateFrequencyList()
    end
end

-- Remove access to multiple frequencies
function RemovePlayerAccessToFrequencies(...)
    local frequencies = { ... }
    local removedFrequencies = {}

    for i = 1, #frequencies do
        local frequency = tonumber(frequencies[i])

        if frequency ~= nil then
            if radioConfig.Frequency.Access[frequency] then -- Check if player has access to frequency
                removedFrequencies[#removedFrequencies + 1] = frequency
            end
        end
    end

    if #removedFrequencies > 0 then
        for i = 1, #removedFrequencies do
            radioConfig.Frequency.Access[removedFrequencies[i]] = nil
        end

        GenerateFrequencyList()
    end
end

-- Define exports
exports("IsRadioOpen", IsRadioOpen)
exports("IsRadioOn", IsRadioOn)
exports("IsRadioAvailable", IsRadioAvailable)
exports("IsRadioEnabled", IsRadioEnabled)
exports("CanRadioBeUsed", CanRadioBeUsed)
exports("SetRadioEnabled", SetRadioEnabled)
exports("SetRadio", SetRadio)
exports("SetAllowRadioWhenClosed", SetAllowRadioWhenClosed)
exports("AddPrivateFrequency", AddPrivateFrequency)
exports("RemovePrivateFrequency", RemovePrivateFrequency)
exports("GivePlayerAccessToFrequency", GivePlayerAccessToFrequency)
exports("RemovePlayerAccessToFrequency", RemovePlayerAccessToFrequency)
exports("GivePlayerAccessToFrequencies", GivePlayerAccessToFrequencies)
exports("RemovePlayerAccessToFrequencies", RemovePlayerAccessToFrequencies)

Citizen.CreateThread(function()
    -- Add Labels
    for i = 1, #Radio.Labels do
        AddTextEntry(Radio.Labels[i][1], Radio.Labels[i][2])
    end

    GenerateFrequencyList()

    while true do
        Citizen.Wait(0)
        -- Init local vars
        local playerPed = PlayerPedId()
        local isActivatorPressed = IsControlJustPressed(0, radioConfig.Controls.Activator.Key)
        local isSecondaryPressed = (radioConfig.Controls.Secondary.Enabled == false and true or IsControlPressed(0, radioConfig.Controls.Secondary.Key))
        local isFalling = IsPedFalling(playerPed)
        local isDead = IsEntityDead(playerPed)
        local minFrequency = radioConfig.Frequency.List[1]
        local broadcastType = 3 + (radioConfig.AllowRadioWhenClosed and 1 or 0) + ((Radio.Open and radioConfig.AllowRadioWhenClosed) and -1 or 0)
        local broadcastDictionary = Radio.Dictionary[broadcastType]
        local broadcastAnimation = Radio.Animation[broadcastType]
        local isBroadcasting = IsControlPressed(0, radioConfig.Controls.Broadcast.Key)
        local isPlayingBroadcastAnim = IsEntityPlayingAnim(playerPed, broadcastDictionary, broadcastAnimation, 3)

        -- Open radio settings
        if isActivatorPressed and isSecondaryPressed and not isFalling and Radio.Enabled and Radio.Has and not isDead then
            Radio:Toggle(not Radio.Open)
        elseif (Radio.Open or Radio.On) and ((not Radio.Enabled) or (not Radio.Has) or isDead) then
            Radio:Remove()
            exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false)
            Radio:Toggle(false)
            Radio.On = false
        elseif Radio.Open and isFalling then
            Radio:Toggle(false)
        end
        
        -- Remove player from private frequency that they don't have access to
        if not radioConfig.Frequency.Access[radioConfig.Frequency.Current] and radioConfig.Frequency.Private[radioConfig.Frequency.Current] and Radio.On then
            Radio:Remove()
            radioConfig.Frequency.CurrentIndex = 1
            radioConfig.Frequency.Current = minFrequency
            Radio:Add(radioConfig.Frequency.Current)
        end

        -- Check if player is holding radio
        if Radio.Open then
            local dictionaryType = 1 + (IsPedInAnyVehicle(playerPed, false) and 1 or 0)
            local openDictionary = Radio.Dictionary[dictionaryType]
            local openAnimation = Radio.Animation[1]
            local isPlayingOpenAnim = IsEntityPlayingAnim(playerPed, openDictionary, openAnimation, 3)
            local hasWeapon, currentWeapon = GetCurrentPedWeapon(playerPed, 1)

            -- Remove weapon in hand as we are using the radio
            if currentWeapon ~= `weapon_unarmed` then
                SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
            end

            -- Display help text
            BeginTextCommandDisplayHelp(Radio.Labels[Radio.On and 2 or 1][1])

            if not Radio.On then
                AddTextComponentSubstringPlayerName(Radio.Clicks and "~r~desativa~w~" or "~g~ativa~w~")
            end

            AddTextComponentInteger(radioConfig.Frequency.Current)
            EndTextCommandDisplayHelp(false, false, false, -1)

            -- Play animation if player is broadcasting to radio
            if Radio.On then
                if isBroadcasting and not isPlayingBroadcastAnim then
                    RequestAnimDict(broadcastDictionary)
        
                    while not HasAnimDictLoaded(broadcastDictionary) do
                        Citizen.Wait(150)
                    end
        
                    TaskPlayAnim(playerPed, broadcastDictionary, broadcastAnimation, 8.0, -8, -1, 49, 0, 0, 0, 0)
                elseif not isBroadcasting and isPlayingBroadcastAnim then
                    StopAnimTask(playerPed, broadcastDictionary, broadcastAnimation, -4.0)
                end
            end

            -- Play default animation if not broadcasting
            if not isBroadcasting and not isPlayingOpenAnim then
                RequestAnimDict(openDictionary)
    
                while not HasAnimDictLoaded(openDictionary) do
                    Citizen.Wait(150)
                end

                TaskPlayAnim(playerPed, openDictionary, openAnimation, 4.0, -1, -1, 50, 0, false, false, false)
            end

            -- Turn radio on/off
            if IsControlJustPressed(0, radioConfig.Controls.Toggle.Key) then
                Radio.On = not Radio.On

                exports["mumble-voip"]:SetMumbleProperty("radioEnabled", Radio.On)

                if Radio.On then
                    SendNUIMessage({ sound = "audio_on", volume = 0.3})
                    Radio:Add(radioConfig.Frequency.Current)
                else
                    SendNUIMessage({ sound = "audio_off", volume = 0.5})
                    Radio:Remove()
                end
            end

            -- Change radio frequency
            if not Radio.On then
                DisableControlAction(0, radioConfig.Controls.ToggleClicks.Key, false)

                if not radioConfig.Controls.Decrease.Pressed then
                    if IsControlJustPressed(0, radioConfig.Controls.Decrease.Key) then
                        radioConfig.Controls.Decrease.Pressed = true
                        Citizen.CreateThread(function()
                            while IsControlPressed(0, radioConfig.Controls.Decrease.Key) do
                                Radio:Decrease()
                                Citizen.Wait(125)
                            end

                            radioConfig.Controls.Decrease.Pressed = false
                        end)
                    end
                end

                if not radioConfig.Controls.Increase.Pressed then
                    if IsControlJustPressed(0, radioConfig.Controls.Increase.Key) then
                        radioConfig.Controls.Increase.Pressed = true
                        Citizen.CreateThread(function()
                            while IsControlPressed(0, radioConfig.Controls.Increase.Key) do
                                Radio:Increase()
                                Citizen.Wait(125)
                            end

                            radioConfig.Controls.Increase.Pressed = false
                        end)
                    end
                end

                if not radioConfig.Controls.Input.Pressed then
                    if IsControlJustPressed(0, radioConfig.Controls.Input.Key) then
                        radioConfig.Controls.Input.Pressed = true
                        Citizen.CreateThread(function()
                            DisplayOnscreenKeyboard(1, Radio.Labels[3][1], "", radioConfig.Frequency.Current, "", "", "", 3)

                            while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                                Citizen.Wait(150)
                            end

                            local input = nil

                            if UpdateOnscreenKeyboard() ~= 2 then
                                input = GetOnscreenKeyboardResult()
                            end

                            Citizen.Wait(500)
                            
                            input = tonumber(input)

                            if input ~= nil then
                                if input >= minFrequency and input <= radioConfig.Frequency.List[#radioConfig.Frequency.List] and input == math.floor(input) then
                                    if not radioConfig.Frequency.Private[input] or radioConfig.Frequency.Access[input] then
                                        local idx = nil

                                        for i = 1, #radioConfig.Frequency.List do
                                            if radioConfig.Frequency.List[i] == input then
                                                idx = i
                                                break
                                            end
                                        end

                                        if idx ~= nil then
                                            radioConfig.Frequency.CurrentIndex = idx
                                            radioConfig.Frequency.Current = input
                                        end
                                    end
                                end
                            end
                            
                            radioConfig.Controls.Input.Pressed = false
                        end)
                    end
                end
                
                -- Turn radio mic clicks on/off
                if IsDisabledControlJustPressed(0, radioConfig.Controls.ToggleClicks.Key) then
                    Radio.Clicks = not Radio.Clicks

                    SendNUIMessage({ sound = "audio_off", volume = 0.5})
                    
                    exports["mumble-voip"]:SetMumbleProperty("micClicks", Radio.Clicks)
                end
            end
        else
            -- Play emergency services radio animation
            if radioConfig.AllowRadioWhenClosed then
                if Radio.Has and Radio.On and isBroadcasting and not isPlayingBroadcastAnim then
                    RequestAnimDict(broadcastDictionary)
    
                    while not HasAnimDictLoaded(broadcastDictionary) do
                        Citizen.Wait(150)
                    end
        
                    TaskPlayAnim(playerPed, broadcastDictionary, broadcastAnimation, 8.0, 0.0, -1, 49, 0, 0, 0, 0)                    
                elseif not isBroadcasting and isPlayingBroadcastAnim then
                    StopAnimTask(playerPed, broadcastDictionary, broadcastAnimation, -4.0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
            exports["mumble-voip"]:SetMumbleProperty("radioClickMaxChannel", radioConfig.Frequency.Max) -- Set radio clicks enabled for all radio frequencies
            exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false) -- Disable radio control
			return
		end
	end
end)

RegisterNetEvent("Radio.Toggle")
AddEventHandler("Radio.Toggle", function()
    local playerPed = PlayerPedId()
    local isFalling = IsPedFalling(playerPed)
    local isDead = IsEntityDead(playerPed)
    
    if not isFalling and not isDead and Radio.Enabled and Radio.Has then
        Radio:Toggle(not Radio.Open)
    end
end)

RegisterNetEvent("Radio.Set")
AddEventHandler("Radio.Set", function(value)
    if type(value) == "string" then
        value = value == "true"
    elseif type(value) == "number" then
        value = value == 1
    end

    Radio.Has = value and true or false
end)
