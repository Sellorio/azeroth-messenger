AzerothMessenger = AzerothMessenger or {}
AzerothMessenger.Config = AzerothMessenger.Config or {}

AzerothMessenger.Config.Initialize = function()
    AzerothMessengerData = AzerothMessengerData or {
        Settings = {
            ChatHeadCount = 5,
            FramePosition = {
                X = -12,
                Y = 0,
                RelativePoint = "RIGHT"
            }
        },
        Conversations = {
            -- {
            --     Identifier = "battletag#1234" or "Character-Realm",
            --     Messages = {
            --         {
            --             CreatedAt = time(), -- numerical absolute time in seconds
            --             MessageSource = "you" or "them" or "system",
            --             FromText = "You" or "Character-Realm" or "System", -- only use "You" for battle.net conversations, use current character name for character conversations
            --             Content = "text"
            --         }
            --     },
            --     Colour = { Red = 1.0, Green = 1.0, Blue = 1.0 }
            -- }
        },
        ActiveConversations = {
            -- "battletag#1234" or "Character-Realm"
        }
    }
end