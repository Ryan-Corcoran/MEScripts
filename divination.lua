local API = require("api")

local startTime = os.time()
local player = API.GetLocalPlayerName()
local startXp = API.GetSkillXP("DIVINATION")
local startTime, afk = os.time(), os.time()
local aioSelect = API.CreateIG_answer()
local aioSelectObj = API.CreateIG_answer()
local aioOptions = {
    {
        label = "Pale Wisps",
        ids = {
            npc = 18150
        }
    },
    {
        label = "Flickering Wisps",
        ids = {
            npc = 18151
        }
    },
    {
        label = "Bright Wisps",
        ids = {
            npc = 18153
        }
    },
    {
        label = "Glowing Wisps",
        ids = {
            npc = 18155
        }
    },
    {
        label = "Sparkling Wisps",
        ids = {
            npc = 18157
        }
    },
    {
        label = "Gleaming Wisps",
        ids = {
            npc = 18159
        }
    },
    {
        label = "Vibrant Wisps",
        ids = {
            npc = 18161
        }
    }
}

local selectedNPC = nil

-- Rounds a number to the nearest integer or to a specified number of decimal places.
local function round(val, decimal)
    if decimal then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

-- Format a number with commas as thousands separator
local function formatNumberWithCommas(amount)
    local formatted = tostring(amount)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

local function formatNumber(num)
    if num >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(num)
    end
end

-- Format script elapsed time to [hh:mm:ss]
local function formatElapsedTime(startTime)
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = elapsedTime % 60
    return string.format("[%02d:%02d:%02d]", hours, minutes, seconds)
end

local function printProgressReport(final)
    local skill = "DIVINATION"
    local currentXp = API.GetSkillXP(skill)
    local elapsedMinutes = (os.time() - startTime) / 60
    local diffXp = math.abs(currentXp - startXp);
    local xpPH = round((diffXp * 60) / elapsedMinutes);
    local time = formatElapsedTime(startTime)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    IGP.radius = 1.0
    IGP.string_value = time .. " | " .. string.lower(skill):gsub("^%l", string.upper) .. ": " .. currentLevel .." | XP/H: " .. formatNumber(xpPH) .. " | XP: " .. formatNumber(diffXp)
end

local function setupGUI()
    IGP = API.CreateIG_answer()
    IGP.box_start = FFPOINT.new(5, 20, 0)
    IGP.box_name = "PROGRESSBAR"
    IGP.colour = ImColor.new(51, 10, 128);
    IGP.string_value = "AIO DIVINATION by JCurtis"
end

local function drawGUI()
    DrawProgressBar(IGP)
end

local function setupBackground()
    

    IG_Back = API.CreateIG_answer();
    IG_Back.box_name = "back";
    IG_Back.box_start = FFPOINT.new(0, 0, 0)
    IG_Back.box_size = FFPOINT.new(440, 140, 0)
    IG_Back.colour = ImColor.new(0,0,0, 160)
    IG_Back.string_value = ""

    IG_Text = API.CreateIG_answer();
    IG_Text.box_start = FFPOINT.new(120, 5, 0)
    IG_Text.box_name = "TXT"
    IG_Text.colour = ImColor.new(51, 10, 128);
    IG_Text.string_value = "AIO Divination by JCurtis"

    API.DrawSquareFilled(IG_Back)
    API.DrawTextAt(IG_Text)
end

local function setupOptions()
    aioSelect.box_name = "AIO"
    aioSelect.box_start = FFPOINT.new(1,60,0)
    aioSelect.stringsArr = {}
    aioSelect.box_size = FFPOINT.new(440, 0, 0)

    table.insert(aioSelect.stringsArr, "Select an option")

    for i, v in ipairs(aioOptions) do
        table.insert(aioSelect.stringsArr, v.label)
    end

    API.DrawComboBox(aioSelect, false)
end

setupBackground()
setupOptions()
setupGUI()

-- main loop
while API.Read_LoopyLoop() do
    drawGUI()

    if (aioSelect.return_click) then
        aioSelect.return_click = false
        
        for i, v in ipairs(aioOptions) do
            if (aioSelect.string_value == v.label) then
                selectedNPC = v.ids.npc
            end
        end
    end

    if selectedNPC ~= nil then
        if API.Invfreecount_() == 0 then
            API.DoAction_Object1(0xc8,0,{ 93489 },50);
            API.DoAction_Object1(0xc8,0,{ 87306 },50);
            API.RandomSleep2(20000, 20050, 20600)
        end
    
        if not API.IsPlayerAnimating_(player, 10) and API.Invfreecount_() ~= 0 then
            print('harvest')
            API.DoAction_NPC(0xc8,3120,{ selectedNPC },50); -- harvest
            API.RandomSleep2(1200, 2100, 2200)
        end

        API.KeyboardPress('d', 60, 100)
        printProgressReport()    
    end

    API.RandomSleep2(100, 200, 200)
end
