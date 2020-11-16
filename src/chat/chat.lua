local function IsVisibleChanged(self, value)
    if value then
        self:SetAlpha(1.0)
    else
        self:SetAlpha(0.0)
    end
end

function AM_ChatFrame_Init(self)
    local Property = AzerothMessenger.Components.Property

    self.IsVisible = Property("_isVisible", IsVisibleChanged)

    self:IsVisible(false)
end