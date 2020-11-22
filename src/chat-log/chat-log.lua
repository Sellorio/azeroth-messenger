-- https://wow.gamepedia.com/API_EditBox_SetHyperlinksEnabled
-- https://wow.gamepedia.com/API_EditBox_SetCursorPosition

local ALTERNATE = false

function AM_ChatLogFrame_Init(self)

end

function AzMeTest()
    AzerothMessengerFrame.Chat.ChatLog.TestBubble:CollapseTop(ALTERNATE)
    ALTERNATE = not ALTERNATE
end