local Orientations = AzerothMessenger.Constants.Orientations
local AnchorPoints = AzerothMessenger.Constants.AnchorPoints

local IsMoving = false

-- Returns position info based on top-left of the parent to the center of the child
-- x, y, xDecimal, yDecimal
local function GetCenterRelativePosition(self)
    local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint()
    relativeTo = relativeTo or self:GetParent() or UIParent

    local selfWidth, selfHeight = self:GetSize()
    local parentWidth, parentHeight = relativeTo:GetSize()

    local x, y

    if relativePoint == "TOPLEFT" then
        x = 0
        y = 0
    elseif relativePoint == "TOP" then
        x = parentWidth / 2.0
        y = 0
    elseif relativePoint == "TOPRIGHT" then
        x = parentWidth
        y = 0
    elseif relativePoint == "LEFT" then
        x = 0
        y = -(parentHeight / 2.0)
    elseif relativePoint == "CENTER" then
        x = parentWidth / 2.0
        y = -(parentWidth / 2.0)
    elseif relativePoint == "RIGHT" then
        x = parentWidth
        y = -(parentHeight / 2.0)
    elseif relativePoint == "BOTTOMLEFT" then
        x = 0
        y = -parentHeight
    elseif relativePoint == "BOTTOM" then
        x = parentWidth / 2.0
        y = -parentHeight
    elseif relativePoint == "BOTTOMRIGHT" then
        x = parentWidth
        y = -parentHeight
    end

    if point == "TOPLEFT" then
        x = x + selfWidth / 2.0
        y = y - selfHeight / 2.0
    elseif point == "TOP" then
        y = y - selfHeight / 2.0
    elseif point == "BOTTOM" then
        y = y + selfHeight / 2.0
    elseif point == "LEFT" then
        x = x + selfWidth / 2.0
    elseif point == "RIGHT" then
        x = x - selfWidth / 2.0
    end

    x = x + xOffset
    y = y + yOffset

    return x, y, x / parentWidth, -y / parentHeight
end

local function StartMoving(self)
    IsMoving = true
    self:StartMoving()
end

local function StopMoving(self)
    IsMoving = false
    self:StopMovingOrSizing()
    local _, _, relativePoint, x, y = AzerothMessengerFrame:GetPoint()

    local framePosition = AzerothMessengerData.Settings.FramePosition
    framePosition.RelativePoint = relativePoint
    framePosition.X = x
    framePosition.Y = y
end

local function UpdateLayout(self)
    local _, _, xDecimal, yDecimal = GetCenterRelativePosition(AzerothMessengerFrame)

    local magnitudeX = math.abs(xDecimal - 0.5)
    local magnitudeY = math.abs(yDecimal - 0.5)

    if magnitudeX > magnitudeY then
        self.ChatHeads:Orientation(Orientations.Vertical)

        if xDecimal > 0.5 then
            self.Chat:AnchorPoint(AnchorPoints.Right)
            self.Chat:ClearAllPoints()
            self.Chat:SetPoint("RIGHT", self, "LEFT", 0, 0)
        else
            self.Chat:AnchorPoint(AnchorPoints.Left)
            self.Chat:ClearAllPoints()
            self.Chat:SetPoint("LEFT", self, "RIGHT", 0, 0)
        end
    else
        self.ChatHeads:Orientation(Orientations.Horizontal)

        if yDecimal > 0.5 then
            self.Chat:AnchorPoint(AnchorPoints.Bottom)
            self.Chat:ClearAllPoints()
            self.Chat:SetPoint("BOTTOM", self, "TOP", 0, 0)
        else
            self.Chat:AnchorPoint(AnchorPoints.Top)
            self.Chat:ClearAllPoints()
            self.Chat:SetPoint("TOP", self, "BOTTOM", 0, 0)
        end
    end
end

function AzerothMessengerFrame_Init(self)
    self.ChatHeads.OnDragStart:Listen(function() StartMoving(self) end)
    self.ChatHeads.OnDragStop:Listen(function() StopMoving(self) end)
    self.ChatHeads.SelectionChanged:Listen(function(selectedItem) self.Chat:Conversation(selectedItem) end)
end

function AzerothMessengerFrame_OnShow(self)
    UpdateLayout(self)
end

function AzerothMessengerFrame_OnUpdate(self)
    if IsMoving then
        UpdateLayout(self)
    end
end