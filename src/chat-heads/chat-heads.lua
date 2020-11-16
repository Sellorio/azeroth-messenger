local function ForEachChatHead(self, action)
    local i = 1
    local chatHead = self["ChatHeadButton"..i]

    while chatHead ~= nil do
        action(chatHead)
        i = i + 1
        chatHead = self["ChatHeadButton"..i]
    end
end

local function OrientationChanged(self, value)
    local ChatHeadMargin = AzerothMessenger.Constants.ChatHeadMargin
    local afterCenter = false

    if value == "horizontal" then
        ForEachChatHead(self, function(chatHead)
            local childIndex = AzerothMessenger.Components.GetChildIndex(chatHead)
            local relativePoint = select(3, chatHead:GetPoint())
            print(tostring(childIndex)..":")
            print(chatHead:GetPoint())
            if relativePoint == "CENTER" then
                afterCenter = true
                chatHead:ClearAllPoints()
                chatHead:SetPoint("CENTER", self:GetParent(), "CENTER", 0, 0)
            elseif afterCenter then
                chatHead:ClearAllPoints()
                chatHead:SetPoint("LEFT", self["ChatHeadButton"..(childIndex - 1)], "RIGHT", ChatHeadMargin, 0)
            else
                chatHead:ClearAllPoints()
                chatHead:SetPoint("RIGHT", self["ChatHeadButton"..(childIndex + 1)], "LEFT", -ChatHeadMargin, 0)
            end
        end)
    elseif value == "vertical" then
        ForEachChatHead(self, function(chatHead)
            local childIndex = AzerothMessenger.Components.GetChildIndex(chatHead)
            local relativePoint = select(3, chatHead:GetPoint())
            print(tostring(childIndex)..":")
            print(chatHead:GetPoint())
            if relativePoint == "CENTER" then
                afterCenter = true
                chatHead:ClearAllPoints()
                chatHead:SetPoint("CENTER", self:GetParent(), "CENTER", 0, 0)
            elseif afterCenter then
                chatHead:ClearAllPoints()
                chatHead:SetPoint("TOP", self["ChatHeadButton"..(childIndex - 1)], "BOTTOM", 0, -ChatHeadMargin)
            else
                chatHead:ClearAllPoints()
                chatHead:SetPoint("BOTTOM", self["ChatHeadButton"..(childIndex + 1)], "TOP", 0, ChatHeadMargin)
            end
        end)
    end
end

function AM_ChatHeadsFrame_Init(self)
    local Property = AzerothMessenger.Components.Property
    local Event = AzerothMessenger.Components.Event

    self.Orientation    = Property("_orientation", OrientationChanged)

    self.OnDragStart    = Event()
    self.OnDragStop     = Event()

    self:Orientation("vertical")

    ForEachChatHead(self, function(chatHead)
        chatHead.OnDragStart:Listen(function() self.OnDragStart:Emit() end)
        chatHead.OnDragStop:Listen(function() self.OnDragStop:Emit() end)
    end)
end