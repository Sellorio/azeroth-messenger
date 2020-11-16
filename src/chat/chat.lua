local ConversationTypes = AzerothMessenger.Constants.ConversationTypes
local Desaturate = AzerothMessenger.Constants.Colors.Desaturate
local Darken = AzerothMessenger.Constants.Colors.Darken
local Lighten = AzerothMessenger.Constants.Colors.Lighten
local AnchorPoints = AzerothMessenger.Constants.AnchorPoints

local function SetThemeColor(self, color)
    local title = Lighten(Lighten(Lighten(color)))
    local border = Darken(Desaturate(color))
    local background = Darken(Darken(border))

    self.TitleLabel:SetVertexColor(title.Red, title.Green, title.Blue, 1.0)
    self.BackgroundTexture:SetVertexColor(background.Red, background.Green, background.Blue, 1.0)
    self.BorderRightTexture:SetVertexColor(border.Red, border.Green, border.Blue, 1.0)
    self.BorderLeftTexture:SetVertexColor(border.Red, border.Green, border.Blue, 1.0)
    self.BorderTopTexture:SetVertexColor(border.Red, border.Green, border.Blue, 1.0)
    self.BorderBottomTexture:SetVertexColor(border.Red, border.Green, border.Blue, 1.0)
end

local function UpdateVisibility(self)
    if self._isVisible and self._conversation then
        self:SetAlpha(1.0)
    else
        self:SetAlpha(0.0)
    end
end

local function AnchorPointChanged(self, value)
    if value == AnchorPoints.Top then
        self.BorderTopTexture:SetSize(222, 3)
        self.BorderBottomTexture:SetSize(222, 1)
        self.BorderLeftTexture:SetSize(1, 250)
        self.BorderRightTexture:SetSize(1, 250)
    elseif value == AnchorPoints.Bottom then
        self.BorderTopTexture:SetSize(222, 1)
        self.BorderBottomTexture:SetSize(222, 3)
        self.BorderLeftTexture:SetSize(1, 250)
        self.BorderRightTexture:SetSize(1, 250)
    elseif value == AnchorPoints.Left then
        self.BorderTopTexture:SetSize(222, 1)
        self.BorderBottomTexture:SetSize(222, 1)
        self.BorderLeftTexture:SetSize(3, 250)
        self.BorderRightTexture:SetSize(1, 250)
    elseif value == AnchorPoints.Right then
        self.BorderTopTexture:SetSize(222, 1)
        self.BorderBottomTexture:SetSize(222, 1)
        self.BorderLeftTexture:SetSize(1, 250)
        self.BorderRightTexture:SetSize(3, 250)
    end
end

local function ConversationChanged(self, value)
    if value then
        if value.Type == ConversationTypes.Battlenet then
            SetThemeColor(self, AzerothMessenger.Constants.Colors.BattlenetChat)
        elseif value.Type == ConversationTypes.Character then
            SetThemeColor(self, AzerothMessenger.Constants.Colors.CharacterChat)
        end

        self.TitleLabel:SetText(value.Identifier)
    end

    UpdateVisibility(self)
end

function AM_ChatFrame_Init(self)
    local Property = AzerothMessenger.Components.Property

    self.AnchorPoint = Property("_anchorPoint", AnchorPointChanged)
    self.Conversation = Property("_conversation", ConversationChanged)
    self.IsVisible = Property("_isVisible", function() UpdateVisibility(self) end)

    self:AnchorPoint(AnchorPoints.Right)
    self:Conversation(nil)
    self:IsVisible(true)
end