local Property = AzerothMessenger.Components.Property

local BorderWidth = 10
local CollapsedBorderWidth = BorderWidth / 2.0
local ChatBubbleWidth = 150


local function ColorChanged(self, value)
    self.BorderTopLeftTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BorderTopRightTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BorderBottomLeftTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BorderBottomRightTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BorderTopTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BorderBottomTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BorderLeftTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BorderRightTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
    self.BackgroundTexture:SetVertexColor(value.Red, value.Green, value.Blue, 1.0)
end

local function CollapseTopChanged(self, value)
    local newBorderWidth = value and CollapsedBorderWidth or BorderWidth

    self.BorderTopLeftTexture:SetSize(newBorderWidth, newBorderWidth)
    self.BorderTopRightTexture:SetSize(newBorderWidth, newBorderWidth)
end

local function CollapseBottomChanged(self, value)
    local newBorderWidth = value and CollapsedBorderWidth or BorderWidth

    self.BorderBottomLeftTexture:SetSize(newBorderWidth, newBorderWidth)
    self.BorderBottomRightTexture:SetSize(newBorderWidth, newBorderWidth)
end

local function TextChanged(self, value)
    self.SimulationLabel:SetText(value)
    local height = self.SimulationLabel:GetStringHeight()
    local topBorder = self._collapseTop and CollapsedBorderWidth or BorderWidth
    local bottomBorder = self._collapseBottom and CollapsedBorderWidth or BorderWidth

    self:SetSize(ChatBubbleWidth, height + topBorder + bottomBorder)
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

function AM_ChatLogBubbleFrame_Init(self)
    self.Color = Property("_color", ColorChanged)
    self.CollapseTop = Property("_collapseTop", CollapseTopChanged)
    self.CollapseBottom = Property("_collapseBottom", CollapseBottomChanged)
    self.Text = Property("_text", TextChanged)

    self:Color({ Red = 0.0, Green = 0.3, Blue = 0.5 })
    self:CollapseTop(false)
    self:CollapseBottom(false)
    self:Text("Test message "..GetSpellLink("Spirit Bomb").." for testing purposes. Hope you enjoy it!")

    self.OnMessageTextChanged = OnMessageTextChanged
    self.OnMessageKeyDown = OnMessageKeyDown
    self.OnMessageKeyUp = OnMessageKeyUp

    InitializeAnchors(self)
end