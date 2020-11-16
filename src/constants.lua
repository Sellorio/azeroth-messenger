AzerothMessenger = AzerothMessenger or {}
AzerothMessenger.Constants = {
    ChatHeadSize = 36,
    ChatHeadMargin = 7,
    ConversationTypes = {
        Battlenet = "bn",
        Character = "ch"
    },
    Orientations = {
        Horizontal = "h",
        Vertical = "v"
    },
    Colors = {
        CharacterChat = { Red = 0.98, Green = 0.68, Blue = 0.98 },
        BattlenetChat = { Red = 0.56, Green = 0.85, Blue = 0.89 }
    }
}

AzerothMessenger.Constants.Colors.Darken = function(color)
    return {
        Red = color.Red * 0.6,
        Green = color.Green * 0.6,
        Blue = color.Blue * 0.6
    }
end

AzerothMessenger.Constants.Colors.Lighten = function(color)
    return {
        Red = 1 - (1 - color.Red) * 0.6,
        Green = 1 - (1 - color.Green) * 0.6,
        Blue = 1 - (1 - color.Blue) * 0.6
    }
end

AzerothMessenger.Constants.Colors.Desaturate = function(color)
    local desaturateMagnitide = 0.3
    local desaturateMagnitideInverse = 0.6

    local averageValue = (color.Red + color.Green + color.Blue) / 3
    local addValue = averageValue * desaturateMagnitide

    return {
        Red = color.Red * desaturateMagnitideInverse + addValue,
        Green = color.Green * desaturateMagnitideInverse + addValue,
        Blue = color.Blue * desaturateMagnitideInverse + addValue
    }
end