local Property = AzerothMessenger.Components.Property

local BorderWidth = 8
local CollapsedBorderWidth = BorderWidth / 2.0
local ChatBubbleWidth = 200


local function InitializeAnchors(self)
    self.BorderTopTexture:ClearAllPoints()
    self.BorderTopTexture:SetPoint("TOPLEFT", self.BorderTopLeftTexture, "TOPRIGHT", 0, 0)
    self.BorderTopTexture:SetPoint("BOTTOMRIGHT", self.BorderTopRightTexture, "BOTTOMLEFT", 0, 0)

    self.BorderBottomTexture:ClearAllPoints()
    self.BorderBottomTexture:SetPoint("TOPLEFT", self.BorderBottomLeftTexture, "TOPRIGHT", 0, 0)
    self.BorderBottomTexture:SetPoint("BOTTOMRIGHT", self.BorderBottomRightTexture, "BOTTOMLEFT", 0, 0)

    self.BorderLeftTexture:ClearAllPoints()
    self.BorderLeftTexture:SetPoint("TOPLEFT", self.BorderTopLeftTexture, "BOTTOMLEFT", 0, 0)
    self.BorderLeftTexture:SetPoint("BOTTOMRIGHT", self.BorderBottomLeftTexture, "TOPRIGHT", 0, 0)

    self.BorderRightTexture:ClearAllPoints()
    self.BorderRightTexture:SetPoint("TOPLEFT", self.BorderTopRightTexture, "BOTTOMLEFT", 0, 0)
    self.BorderRightTexture:SetPoint("BOTTOMRIGHT", self.BorderBottomRightTexture, "TOPRIGHT", 0, 0)

    self.BackgroundTexture:ClearAllPoints()
    self.BackgroundTexture:SetPoint("TOPLEFT", self.BorderTopLeftTexture, "BOTTOMRIGHT", 0, 0)
    self.BackgroundTexture:SetPoint("TOPRIGHT", self.BorderTopRightTexture, "BOTTOMLEFT", 0, 0)
    self.BackgroundTexture:SetPoint("BOTTOMRIGHT", self.BorderBottomLeftTexture, "TOPLEFT", 0, 0)
    self.BackgroundTexture:SetPoint("BOTTOMRIGHT", self.BorderBottomRightTexture, "TOPLEFT", 0, 0)
end

local function SetColor(self, color)
    self.BorderTopLeftTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BorderTopRightTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BorderBottomLeftTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BorderBottomRightTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BorderTopTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BorderBottomTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BorderLeftTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BorderRightTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
    self.BackgroundTexture:SetVertexColor(color.Red, color.Green, color.Blue, color.Alpha or 1.0)
end

local function UpdateAppearance(self)
    local topBorder, bottomBorder

    if self._isSystemMessage then
        topBorder = 1
        bottomBorder = 1

        SetColor(self, { Red = 0, Green = 0, Blue = 0, Alpha = 0 })
        self.MessageText:SetFontObject("AM_Font_ChatSystem")

    else
        topBorder = self._collapseTop and CollapsedBorderWidth or BorderWidth
        bottomBorder = self._collapseBottom and CollapsedBorderWidth or BorderWidth

        SetColor(self, self._color)
        self.MessageText:SetFontObject("AM_Font_Chat")
    end

    self.BorderTopLeftTexture:SetSize(topBorder, topBorder)
    self.BorderTopRightTexture:SetSize(topBorder, topBorder)
    self.BorderBottomLeftTexture:SetSize(bottomBorder, bottomBorder)
    self.BorderBottomRightTexture:SetSize(bottomBorder, bottomBorder)
    self.Wrapper:SetSize(ChatBubbleWidth, self.SimulationLabel:GetStringHeight() + topBorder + bottomBorder)
end

local function ColorChanged(self, value)
    if not self._isSystemMessage then
        SetColor(self, value)
    end
end

local function CollapseTopChanged(self)
    UpdateAppearance(self)
end

local function CollapseBottomChanged(self)
    UpdateAppearance(self)
end

local function TextChanged(self, value)
    self.SimulationLabel:SetText(value)
    local height = self.SimulationLabel:GetStringHeight()
    local topBorder = self._collapseTop and CollapsedBorderWidth or BorderWidth
    local bottomBorder = self._collapseBottom and CollapsedBorderWidth or BorderWidth

    self.Wrapper:SetSize(ChatBubbleWidth, height + topBorder + bottomBorder)
    self.MessageText:SetText(value)

    if self._lastCursorPosition ~= nil then
        self._lastCursorPosition = math.min(self._lastCursorPosition, #value)
    end
end

local function OnMessageTextChanged(self)
    local text = self.MessageText:GetText()

    if text ~= self._text then
        self.MessageText:SetText(self._text)
    end
end

local function OnMessageKeyDown(self, key)
    local ignoredKeys = {
        "LSHIFT",
        "RSHIFT",
        "LEFT",
        "RIGHT",
        "UP",
        "DOWN",
        "LALT",
        "RALT",
        "LCTRL",
        "RCTRL"
    }

    for i=1, #ignoredKeys do
        if key == ignoredKeys[i] then
            return
        end
    end

    self.MessageText:ClearFocus()
end

local function IsSystemMessageChanged(self)
    UpdateAppearance(self)
end

local function AlignmentChanged(self, value)
    self.Wrapper:ClearAllPoints()

    if value == "left" then
        self.Wrapper:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
    elseif value == "right" then
        self.Wrapper:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
    elseif value == "center" then
        self.Wrapper:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
    end
end

function AM_ChatLogMessageFrame_Init(self)
    self.Color = Property("_color", ColorChanged)
    self.CollapseTop = Property("_collapseTop", CollapseTopChanged)
    self.CollapseBottom = Property("_collapseBottom", CollapseBottomChanged)
    self.Text = Property("_text", TextChanged)
    self.IsSystemMessage = Property("_isSystemMessage", IsSystemMessageChanged)
    self.Alignment = Property("_alignment", AlignmentChanged)

    self:Color({ Red = 0.0, Green = 0.3, Blue = 0.5 })
    self:CollapseTop(false)
    self:CollapseBottom(false)
    self:Text("Test message "..GetSpellLink("Spirit Bomb").." for testing purposes. Hope you enjoy it!")
    self:IsSystemMessage(false)
    self:Alignment("right")

    self.OnMessageTextChanged = OnMessageTextChanged
    self.OnMessageKeyDown = OnMessageKeyDown

    InitializeAnchors(self)
end