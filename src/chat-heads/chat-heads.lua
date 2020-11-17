local ConversationTypes = AzerothMessenger.Constants.ConversationTypes
local Orientations = AzerothMessenger.Constants.Orientations

local function ForEachChatHead(self, action)
    local i = 1
    local chatHead = self["ChatHeadButton"..i]

    while chatHead ~= nil do
        action(chatHead, i)
        i = i + 1
        chatHead = self["ChatHeadButton"..i]
    end
end

local function OrientationChanged(self, value)
    local ChatHeadMargin = AzerothMessenger.Constants.ChatHeadMargin
    local afterCenter = false

    if value == Orientations.Horizontal then
        ForEachChatHead(self, function(chatHead)
            local childIndex = AzerothMessenger.Components.GetChildIndex(chatHead)
            local relativePoint = select(3, chatHead:GetPoint())

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
    elseif value == Orientations.Vertical then
        ForEachChatHead(self, function(chatHead)
            local childIndex = AzerothMessenger.Components.GetChildIndex(chatHead)
            local relativePoint = select(3, chatHead:GetPoint())

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

-- uses same object structure as Conversations items in Config
local function ItemsChanged(self, value)
    local selectedItem = self:SelectedItem()

    ForEachChatHead(self, function(chatHead, i)
        local item = value and value[i]

        if item then
            chatHead:ConversationIdentifier(item.Identifier)
            chatHead:ConversationType(item.Type)
            chatHead:Color(item.Color)
            chatHead:IsChecked(item == selectedItem)
            chatHead:IsVisible(true)
        else
            chatHead:IsChecked(false)
            chatHead:IsVisible(false)
        end
    end)

    if value then
        for i=1, #value do
            if value[i] == selectedItem then
                -- allow the SelectedItem to remain set even if the selected conversation is not currently displayed as a chat head
                return
            end
        end
    end

    self:SelectedItem(nil)
    self.SelectionChanged:Emit(nil)
end

local function SelectedItemChanged(self, selectedItem)
    local items = self:Items()

    ForEachChatHead(self, function(chatHead, i)
        local item = items[i]
        chatHead:IsChecked(item == selectedItem)
    end)
end

local function ChatHeadClicked(self, button, chatHead)
    if chatHead:IsVisible() then
        if button == "LeftButton" then
            if chatHead:IsChecked() then
                local chatHeadIndex = AzerothMessenger.Components.GetChildIndex(chatHead)
                self:SelectedItem(self:Items()[chatHeadIndex])
            else
                self:SelectedItem(nil)
            end

            self.SelectionChanged:Emit(self:SelectedItem())
        elseif button == "MiddleButton" then
            local chatHeadIndex = AzerothMessenger.Components.GetChildIndex(chatHead)
            local items = self:Items()
            local item = table.remove(items, chatHeadIndex)
            ItemsChanged(self, items)
            self.ItemRemoved:Emit(item)
        end
    end
end

function AM_ChatHeadsFrame_Init(self)
    local Property = AzerothMessenger.Components.Property
    local Event = AzerothMessenger.Components.Event

    self.Orientation        = Property("_orientation", OrientationChanged)
    self.Items              = Property("_items", ItemsChanged)
    self.SelectedItem       = Property("_selectedItem", SelectedItemChanged)

    self.OnDragStart        = Event()
    self.OnDragStop         = Event()
    self.SelectionChanged   = Event()
    self.ItemRemoved        = Event()

    self.ChatHeadClicked = ChatHeadClicked

    self:Orientation(Orientations.Vertical)
    self:Items({
        { Identifier = "Sellorio#1234", Type = ConversationTypes.Battlenet, Color = AzerothMessenger.ChatHeadBackgroundColors[1] },
        { Identifier = "Sellorina-Frostmourne", Type = ConversationTypes.Character, Color = AzerothMessenger.ChatHeadBackgroundColors[2] }
    })

    ForEachChatHead(self, function(chatHead)
        chatHead.OnDragStart:Listen(function() self.OnDragStart:Emit() end)
        chatHead.OnDragStop:Listen(function() self.OnDragStop:Emit() end)
    end)
end