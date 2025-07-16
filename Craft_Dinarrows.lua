local API = require("api")
local MAX_IDLE_TIME_MINUTES = 10
local startTime, afk = os.time(), os.time()
local processingTimeout = 250
local headlessComps = {53083, 53073}
local dinarrowsComps = {53093, 53033}


local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    if timeDiff > math.random(MAX_IDLE_TIME_MINUTES * 0.6 * 60, MAX_IDLE_TIME_MINUTES * 0.9 * 60) then
        API.PIdle2()
        afk = os.time()
    end
end

function waitUntil(x, timeout)
    local start = os.time()
    while not x() and start + timeout > os.time() do
        API.RandomSleep2(600, 200, 200)
    end
    return start + timeout > os.time()
end

function getCreationInterfaceSelectedItemID()
    return API.VB_FindPSett(2229, 0).SumOfstate
end

function creationInterfaceOpen() 
    return getCreationInterfaceSelectedItemID() ~= -1
end

local function waitWhileProcessing(timeout)
    local startTime = os.time()
    print("Waiting for items to be processed")
    while os.time() - startTime < timeout do
        if not isProcessing() then
            return true
        end
        API.DoRandomEvents()
        API.RandomSleep2(600, 200, 200)
    end
    return false
end

local function checkHeadlessItems()
    for _, itemId in ipairs(headlessComps) do
        local quantity = API.InvStackSize(itemId)
        if quantity <= 14 then
            return true
        end
    end
    return false
end

local function checkDinarrowItems()
    for _, itemId in ipairs(dinarrowsComps) do
        local quantity = API.InvStackSize(itemId)
        if quantity <= 14 then
            return true
        end
    end
    return false
end

local function craftHeadless()
    API.DoAction_Inventory3("fungal shaft", 0, 1, API.OFF_ACT_GeneralInterface_route)
    API.RandomSleep2(800,600,600)
end

local function craftDinarrows()
    API.DoAction_Inventory3("Sharp shell", 0, 1, API.OFF_ACT_GeneralInterface_route)
    API.RandomSleep2(800,600,600)
end

while API.Read_LoopyLoop() do
    idleCheck()
    API.DoRandomEvents()
    craftHeadless()
    print("Waiting for creation interface")
    if waitUntil(creationInterfaceOpen, 5) then
        API.KeyboardPress32(0x20, 0)
        print("Waiting for processing to begin")
        if waitUntil(API.isProcessing, 5) then
            waitWhileProcessing(processingTimeout)
        end
    end
    
    if checkHeadlessItems() then
        craftDinarrows()
        print("Waiting for creation interface")
        if waitUntil(creationInterfaceOpen, 5) then
            API.KeyboardPress32(0x20, 0)
            print("Waiting for processing to begin")
            if waitUntil(API.isProcessing, 5) then
                waitWhileProcessing(processingTimeout)
            end
        end
    end
    if checkDinarrowItems() then
        API.Read_LoopyLoop(false)
        print("No more Dinarrow items, stopping loop.")
        break
    end
end
