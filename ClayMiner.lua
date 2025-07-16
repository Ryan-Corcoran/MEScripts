--[[
# Script Name:   Dead's Prifddinas Soft Clay Miner
# Description:  <Mines clay at Prifddinas.>
# Autor:        <Dead (dea.d - Discord)>
# Version:      <2.0>
# Datum:        <2024.02.01>
--]]

print("Run Priff Clay Miner.")
local version = "2.0"

-- INCLUDES_START
local API = require("api")
local LODESTONES = require("lodestones")
local UTILS = require("utils")
-- INCLUDES_END

API.SetDrawTrackedSkills(true)
API.SetDrawLogs(true)
-- VARIABLES_START
local bankPresetKeyCode = 0x76 -- https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
local firstRun = true
local runs = 0
local clayMined = 0
local scriptStartTime = os.time()
local runStartTime = os.time()
local lastRunTime = 0
local avgRunTime = 0

-- The X1,X2,Y1,Y2 coords of the rectangle that we consider to be the area in which clay is interactable.
local clayArea = { 2137, 2156, 3334, 3354 }

-- We update this value based on the state transitions
local STATE = 0

-- All the states that we want to track
local STATES = {
    GOTO_CLAY = 0,
    MINE_CLAY = 1,
    EMPTY_BAGS = 3,
    GOTO_PRIFF = 4
}
-- Draws the black background
local imguiBackground = API.CreateIG_answer();
imguiBackground.box_name = "ImguiBackground"
imguiBackground.box_start = FFPOINT.new(20, 40, 0)
imguiBackground.box_size = FFPOINT.new(220, 140, 0)
imguiBackground.colour = ImColor.new(10, 13, 29)

local ImGuiTitle = API.CreateIG_answer()
ImGuiTitle.box_start = FFPOINT.new(25, 45, 0)
ImGuiTitle.colour = ImColor.new(37, 194, 160)
ImGuiTitle.string_value = "Dead's Prif Clay Miner " .. version

-- imgui object for the number of tips
local imguiRuns = API.CreateIG_answer();
imguiRuns.box_name = "imguiRuns";
imguiRuns.colour = ImColor.new(37, 194, 160)
imguiRuns.box_start = FFPOINT.new(25, 75, 0);

-- imgui object for the number of clay mined
local imguiClayMined = API.CreateIG_answer();
imguiClayMined.box_name = "imguiClayMined";
imguiClayMined.colour = ImColor.new(37, 194, 160)
imguiClayMined.box_start = FFPOINT.new(25, 90, 0);

-- imgui object for runs per hour
local imguiRunsPerHr = API.CreateIG_answer();
imguiRunsPerHr.box_name = "imguiRunsPerHr";
imguiRunsPerHr.colour = ImColor.new(37, 194, 160)
imguiRunsPerHr.box_start = FFPOINT.new(25, 105, 0);

-- imgui object for runtime
local imguiLastRunTime = API.CreateIG_answer();
imguiLastRunTime.box_name = "imguiLastRunTime";
imguiLastRunTime.colour = ImColor.new(37, 194, 160)
imguiLastRunTime.box_start = FFPOINT.new(25, 120, 0);

-- VARIABLES_END

-- METHODS_START
-- Updates all the values we want to track metrics for
local function calculateMetrics()
    lastRunTime = os.difftime(os.time(), runStartTime)
    runs = runs + 1
    clayMined = clayMined + API.InvItemcount_1(1761)
    avgRunTime = math.floor(os.difftime(os.time(), scriptStartTime) / runs)
    runStartTime = os.time()
    print()
    print("------------------------------------------------")
    print("Runs: " .. runs)
    print("Clay Mined: " .. clayMined)
    print("Avg runtime: " .. avgRunTime)
    print("Runs/Hr: " .. math.floor(3600 / avgRunTime))
    print("Runtime: " .. math.floor(os.difftime(os.time(), scriptStartTime) / 60) .. " minutes")
end

-- Draws the imgui objects to the screen
local function drawMetrics()
    imguiClayMined.string_value = "Clay Mined: " .. clayMined
    imguiRuns.string_value = "Trips:      " .. runs
    imguiLastRunTime.string_value = "Last Trip:  " .. math.floor(lastRunTime) .. "s " .. " Avg: " .. avgRunTime .. "s"
    imguiRunsPerHr.string_value = "Trips/HR:   " .. math.floor(3600 / avgRunTime)
    ImGuiTitle.string_value = "Dead's Prif Clay Miner " .. version .. "\n" .. API.ScriptRuntimeString()
    API.DrawSquareFilled(imguiBackground)
    API.DrawTextAt(imguiRuns)
    API.DrawTextAt(imguiLastRunTime)
    API.DrawTextAt(imguiRunsPerHr)
    API.DrawTextAt(imguiClayMined)
    API.DrawTextAt(ImGuiTitle)
end


-- StartUp function. It runs once at the start of the script. Do stuff like doing to where you need to be and loading equipment presets here.
local function onStart()
    print('on start')
    local priffLodestone = LODESTONES.LODESTONE.PRIFDDINAS.loc
    local playerXYZ = API.PlayerCoord()
    if not API.PInArea21(clayArea[1], clayArea[2], clayArea[3], clayArea[4]) and (API.Math_DistanceW(priffLodestone, playerXYZ) > 50) then
        print('Not at clay area or in PRIFDDINAS')
        STATE = STATES.GOTO_PRIFF
    else
        print('Already near PRIFDDINAS lodestone')
        STATE = STATES.GOTO_CLAY
    end
end

local function gotoPriff()
    LODESTONES.Prifddinas()
    STATE = STATES.GOTO_CLAY
end

local function gotoClay()
    if not API.PInArea21(clayArea[1], clayArea[2], clayArea[3], clayArea[4]) then
        API.DoAction_WalkerW(WPOINT.new(2154, 3340, 1))
    end
end

local function mineClay()
    local hoverProgress = API.LocalPlayer_HoverProgress()
    math.randomseed(os.time())
    if hoverProgress < 60 + math.random(30, 60) or not API.CheckAnim(20) then
        API.DoAction_Object_string1(0x3a, API.OFF_ACT_GeneralObject_route0, { "Soft clay rock" }, 50, true)
        UTILS.countTicks(2)
        API.WaitUntilMovingEnds()
    end
end

local function loadPreset()
    API.DoAction_Object_string1(0x2e, API.OFF_ACT_GeneralObject_route1, { "Bank chest" }, 50, true)
    UTILS.countTicks(2)
    API.WaitUntilMovingEnds()
    API.KeyboardPress2(bankPresetKeyCode, 50, 200)
    UTILS.countTicks(1)
end

local function emptyBags()
    calculateMetrics()
    API.DoAction_Object_string1(0x33, API.OFF_ACT_GeneralObject_route3, { "Bank chest" }, 50, true)
    UTILS.countTicks(2)
    API.WaitUntilMovingEnds()
    STATE = STATES.MINE_CLAY
end

local function checkStates()
    UTILS:gameStateChecks()
    UTILS:antiIdle()
    if not API.PInArea21(clayArea[1], clayArea[2], clayArea[3], clayArea[4]) then
        STATE = STATES.GOTO_CLAY
    elseif firstRun then
        loadPreset()
        firstRun = false
    elseif API.InvFull_() then
        STATE = STATES.EMPTY_BAGS
    else
        STATE = STATES.MINE_CLAY
    end
end

local function priffClayMiner()
    drawMetrics()
    API.DoRandomEvents()
    if STATE == STATES.GOTO_PRIFF then
        gotoPriff()
    elseif STATE == STATES.GOTO_CLAY then
        gotoClay()
    elseif STATE == STATES.MINE_CLAY then
        mineClay()
    elseif STATE == STATES.EMPTY_BAGS then
        emptyBags()
    end
    UTILS.randomSleep(600)
    checkStates()
end

-- METHODS END

-- Main Loop
API.Write_LoopyLoop(true)
API.logWarn("Dead's Priff ClayMiner Started!")
onStart()
while API.Read_LoopyLoop() do
    priffClayMiner()
end

API.logWarn("Dead's Priff ClayMiner Done!")
API.SetDrawTrackedSkills(false)