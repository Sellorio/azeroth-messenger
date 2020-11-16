local Orientations = AzerothMessenger.Constants.Orientations

local IsMoving = false

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
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()
    local _, _, _, x, y = AzerothMessengerFrame:GetPoint()

    y = -y -- offset is from top left, so lets get the positive value of y

    local magnitudeX = math.abs(x / screenWidth - 0.5)
    local magnitudeY = math.abs(y / screenHeight - 0.5)

    if magnitudeX > magnitudeY then
        self.ChatHeads:Orientation(Orientations.Vertical)
    else
        self.ChatHeads:Orientation(Orientations.Horizontal)
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