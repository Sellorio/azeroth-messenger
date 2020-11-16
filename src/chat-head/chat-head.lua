local ConversationTypes = AzerothMessenger.Constants.ConversationTypes

local function GetInitials(identifier)
    local initials = ""

    for i=0, #identifier do
        local char = string.sub(identifier, i, i)

        if char == "#" or char == "-" then
            break
        end

        local isUpper = string.match(char, "%u")

        if isUpper then
            initials = initials..char
        end
    end

    local initialsLength = #initials

    if initialsLength == 0 then
        initials = string.sub(identifier, 1, 2)
    elseif initialsLength == 1 then
        initials = initials..string.sub(identifier, 2, 2)
    elseif initialsLength > 2 then
        initials = string.sub(initials, 1, 2)
    end

    return initials
end

local function ColorChanged(self, value)
    self.IconTexture:SetVertexColor(value.Red, value.Green, value.Blue)
end

local function ConversationTypeChanged(self, value)
    local color;

    if value == ConversationTypes.Character then
        color = AzerothMessenger.Constants.Colors.CharacterChat
    elseif value == ConversationTypes.Battlenet then
        color = AzerothMessenger.Constants.Colors.BattlenetChat
    end

    if color then
        self.SelectionTexture:SetVertexColor(color.Red, color.Green, color.Blue)
    end
end

local function ConversationIdentifierChanged(self, value)
    self.InitialsLabel:SetText(value == "" and "" or GetInitials(value))
end

local function IsCheckedChanged(self, value)
    if value then
        self.SelectionTexture:Show()
    else
        self.SelectionTexture:Hide()
    end
end

local function IsVisibleChanged(self, value)
    if value then
        self:SetAlpha(1.0)
    else
        self:SetAlpha(0.0)
    end
end

local function UnreadMessageCountChanged(self, value)
    if value == 0 then
        countText = nil
    elseif value < 10 then
        countText = tostring(value)
    elseif value > 9 then
        countText = "*"
    end

    if countText then
        self.UnreadMessageCountTexture:Show()
        self.UnreadMessageCountLabel:SetText(countText)
    else
        self.UnreadMessageCountTexture:Hide()
        self.UnreadMessageCountLabel:SetText("")
    end
end

function AM_ChatHeadButton_Init(self)
    local Property = AzerothMessenger.Components.Property
    local Event = AzerothMessenger.Components.Event

    self.Color                     = Property("_color", ColorChanged)
    self.ConversationType           = Property("_conversationType", ConversationTypeChanged)
    self.ConversationIdentifier     = Property("_conversationIdentifier", ConversationIdentifierChanged)
    self.IsChecked                  = Property("_isChecked", IsCheckedChanged)
    self.IsVisible                  = Property("_isVisible", IsVisibleChanged)
    self.UnreadMessageCount         = Property("_unreadMessageCount", UnreadMessageCountChanged)

    self.OnDragStart                = Event()
    self.OnDragStop                 = Event()

    self:Color({ Red = 0.3, Green = 0.3, Blue = 0.3 })
    self:ConversationIdentifier("Sellorio-Frostmourne")
    self:ConversationType(ConversationTypes.Character)
    self:IsChecked(false)
    self:IsVisible(true) -- change to false in production
    self:UnreadMessageCount(0)
end
