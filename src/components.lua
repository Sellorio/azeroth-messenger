AzerothMessenger = AzerothMessenger or {}
AzerothMessenger.Components = {}

AzerothMessenger.Components.Property = function(fieldName, onChange)
    return function(self, ...)
        local data = { n = select("#", ...), ... }
        local hasValue = data.n > 0
        local value = data[1]

        if hasValue then
            if value ~= self[fieldName] then
                self[fieldName] = value
                onChange(self, value)
            end
        else
            return self[fieldName]
        end
    end
end

AzerothMessenger.Components.Event = function()
    return {
        _handlers = {},
        Listen = function(self, handler)
            table.insert(self._handlers, handler)
        end,
        Emit = function(self, value)
            for i=1, #self._handlers do
                self._handlers[i](value)
            end
        end
    }
end

AzerothMessenger.Components.GetChildIndex = function(self)
    local parent = self:GetParent()

    if parent then
        local parentChildren = { self:GetParent():GetChildren() }

        for i=1, #parentChildren do
            if parentChildren[i] == self then
                return i
            end
        end
    end
end