print("Run Lua script Cooker.");

local API = require("api")

local item1 = 0;
local loopprotect1 = 0;
local loopprotect2 = 0;

local Cselect = API.ScriptDialogWindow2("Cooking", {
    "Raw lobster", "Raw swordfish", "Raw shark", "Raw monkfish", "Raw sea turtle", "Raw manta ray", "Raw great shark",
    "Raw rocktail", "Raw cavefish",
    "Raw blue jelly", "Raw green jelly", "Raw sailfish",
    "Raw desert sole", "Raw catfish", "Raw beltfish",
    },"Start", "Close").Name;

--Assign stuff here
if "Raw lobster" == Cselect then
    ScripCuRunning1 = "Cook lobster";
    item1 = 377;
end
if "Raw swordfish" == Cselect then
    ScripCuRunning1 = "Cook swordfish";
    item1 = 371;
end
if "Raw shark" == Cselect then
    ScripCuRunning1 = "Cook shark";
    item1 = 383;
end
if "Raw monkfish" == Cselect then
    ScripCuRunning1 = "Cook monkfish";
    item1 = 7944;
end
if "Raw sea turtle" == Cselect then
    ScripCuRunning1 = "Cook turtle";
    item1 = 395;
end
if "Raw manta ray" == Cselect then
    ScripCuRunning1 = "Cook manta";
    item1 = 389;
end
if "Raw great shark" == Cselect then
    ScripCuRunning1 = "Cook shark";
    item1 = 34727;
end
if "Raw rocktail" == Cselect then
    ScripCuRunning1 = "Cook rocktail";
    item1 = 15270;
end
if "Raw cavefish" == Cselect then
    ScripCuRunning1 = "Cook cavefish";
    item1 = 15264;
end
if "Raw green jelly" == Cselect then
    ScripCuRunning1 = "Cook green jelly";
    item1 = 42256;
end
if "Raw blue jelly" == Cselect then
    ScripCuRunning1 = "Cook blue jelly";
    item1 = 42265;
end
if "Raw sailfish" == Cselect then
    ScripCuRunning1 = "Cook sailfish";
    item1 = 42249;
end
if "Raw desert sole" == Cselect then
    ScripCuRunning1 = "Cook desert";
    item1 = 40287;
end
if "Raw catfish" == Cselect then
    ScripCuRunning1 = "Cook catfish";
    item1 = 40289;
end
if "Raw beltfish" == Cselect then
    ScripCuRunning1 = "Cook beltfish";
    item1 = 40291;
end

print("Starting with:", ScripCuRunning1, item1);

--default parameters don't work.
--somefunctions behave differently than expected.
--overloading issues.

textdata = API.CreateIG_answer();
textdata.box_name = "test_text";
textdata.box_start = FFPOINT.new(66,77,0);
textdata.colour = ImColor.new(0,255,0);
API.DrawTextAt(textdata);
textdata_tick = API.CreateIG_answer();
textdata_tick.box_name = "STUFF IS TICKED"--this will be used this time
textdata_tick.box_start =  FFPOINT.new(20,50,0);
API.DrawCheckbox(textdata_tick);

--ticks
function R(min,max)
    return min + API.Math_RandomNumber(max)-1
 end

local previus_t = API.Get_tick() --outside of LoopyLoop
--main loop
API.Write_LoopyLoop(true);
API.Write_Doaction_paint(true);
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
    API.RandomEvents();

    print("Running.");

    if (textdata_tick.box_ticked) then
        textdata.string_value = "TESTING STUFF"
    else
        --textdata.remove = true; --removes totally, one needs push it again :S
        textdata.string_value = "" --easier
    end
    
    if (API.Get_tick() - previus_t > 3 ) then -- 4x600ms has passed
        previus_t = API.Get_tick()
        --do something some ability or something
            print("Ready");
    end

    if (loopprotect1) > 4 then API.Write_LoopyLoop(false); end
    if (loopprotect2) > 4 then API.Write_LoopyLoop(false); end

    if (API.Math_RandomNumber(1000) > 993) then
        API.PIdle1();
    end

    if (API.Math_RandomNumber(1000) > 998) then
        API.PIdle2();
    end

    if API.Container_Get_s(93,50510).item_id > 0 then
        API.DoAction_Inventory1(50510,0,1,API.OFF_ACT_GeneralInterface_route)
        print("Open Volatile effigy")
        API.Sleep_tick(R(1,4))
        ::continue::
    end
    if API.Container_Get_s(93,50528).item_id > 0 then
        API.DoAction_Inventory1(50528,0,1,API.OFF_ACT_GeneralInterface_route)
        print("Open Effigy lamp")
        API.Sleep_tick(R(1,4))
        if API.Compare2874Status(18) then
            --wc 48, cooking 36
            API.DoAction_Interface(0xffffffff,0xffffffff,1,1263,48,-1,API.OFF_ACT_GeneralInterface_route)
            API.Sleep_tick(R(1,4))
            API.DoAction_Interface(0xffffffff,0xffffffff,0,1263,74,18,API.OFF_ACT_GeneralInterface_Choose_option)
            API.Sleep_tick(R(1,4))
            ::continue::
        end
    end
    if API.Container_Get_s(93,18782).item_id > 0 then
        API.DoAction_Inventory1(18782,0,1,API.OFF_ACT_GeneralInterface_route)
        print("Open Dragonkin lamp")
        API.Sleep_tick(R(1,4))
        if API.Compare2874Status(18) then
            --wc 48, cooking 36
            API.DoAction_Interface(0xffffffff,0xffffffff,1,1263,48,-1,API.OFF_ACT_GeneralInterface_route)
            API.Sleep_tick(R(1,4))
            API.DoAction_Interface(0xffffffff,0xffffffff,0,1263,74,18,API.OFF_ACT_GeneralInterface_Choose_option)
            API.Sleep_tick(R(1,4))
            ::continue::
        end
    end
    if API.Container_Get_s(93,50513).item_id > 0 then
        API.DoAction_Inventory1(50513,0,1,API.OFF_ACT_GeneralInterface_route)
        print("Open Expl effigy")
        API.Sleep_tick(R(1,4))
        ::continue::
    end
    if API.Container_Get_s(93,50530).item_id > 0 then
        API.DoAction_Inventory1(50530,0,1,API.OFF_ACT_GeneralInterface_route)
        print("Open Effigy star")
        API.Sleep_tick(R(1,4))
        if API.Compare2874Status(18) then
            --wc 48, cooking 36, mining 18, fish 30
            API.DoAction_Interface(0xffffffff,0xffffffff,1,1263,48,-1,API.OFF_ACT_GeneralInterface_route)
            API.Sleep_tick(R(1,4))
            API.DoAction_Interface(0xffffffff,0xffffffff,0,1263,74,18,API.OFF_ACT_GeneralInterface_Choose_option)
            API.Sleep_tick(R(1,4))
            ::continue::
        end
    end
    if API.Container_Get_s(93,50532).item_id > 0 then
        API.DoAction_Inventory1(50532,0,1,API.OFF_ACT_GeneralInterface_route)
        print("Open Dragonkin star")
        API.Sleep_tick(R(1,4))
        if API.Compare2874Status(18) then
            --wc 48, cooking 36
            API.DoAction_Interface(0xffffffff,0xffffffff,1,1263,48,-1,API.OFF_ACT_GeneralInterface_route)
            API.Sleep_tick(R(1,4))
            API.DoAction_Interface(0xffffffff,0xffffffff,0,1263,74,18,API.OFF_ACT_GeneralInterface_Choose_option)
            API.Sleep_tick(R(1,4))
            ::continue::
        end
    end

    if (not API.CheckAnim(100)) then
        ScripCuRunning2 = "Searching";
        if (API.OpenInventoryInterface2()) then
            if (API.CheckInvStuff1(item1,0)) then
                loopprotect1 = loopprotect1 + 1;
                loopprotect2 = 0;
                ScripCuRunning2 = "Looking for portable range";
                if (API.DoPortables0(89768, "Cook")) then
                    ScripCuRunning2 = "Cooking";
                    API. RandomSleep2(1500, 4050, 12000);
                else
                    --range was not found, stall
                    ScripCuRunning2 = "Stalling";
                    loopprotect1 = 0;
                end
            else           
                loopprotect2 = loopprotect2 + 1;
                loopprotect1 = 0;
                ScripCuRunning2 = "Looking for lumby bank chest";
                API.OpenBankChest0(79036, '1');
                API.OpenBankChest0(125115, '1');
            end
        else
            ScripCuRunning1 = "Inventory not open";
        end
    end
    API.RandomSleep2(500, 2050, 5000);
end-----------------------------------------------------------------------------------




