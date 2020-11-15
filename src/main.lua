local f = CreateFrame("Frame", "MegaMacro_EventFrame", UIParent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

local function OnUpdate(_, elapsed)
end

local function OnPlayerEnteringWorld()
    AzerothMessenger.Config.Initialize()
    f:SetScript("OnUpdate", OnUpdate)
end

f:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_ENTERING_WORLD" then
        OnPlayerEnteringWorld()
    end
end)
