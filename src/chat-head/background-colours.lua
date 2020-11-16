AzerothMessenger = AzerothMessenger or {}

local function Color(r, g, b)
    return { Red = r / 255.0, Green = g / 255.0, Blue = b / 255.0 }
end

AzerothMessenger.ChatHeadBackgroundColors = {
    Color(0, 134, 0),       -- dark green
    Color(83, 105, 179),    -- desaturated blue
    Color(213, 199, 0),     -- dark yellow
    Color(67, 173, 185),    -- desaturated cyan
    Color(155, 98, 159),    -- desaturated magenta
    Color(0, 203, 210),     -- dark cyan
    Color(216, 107, 132),   -- desaturated pink
    Color(112, 196, 171),   -- desaturated aquamarine
    Color(145, 0, 145),     -- dark magenta
    Color(202, 114, 0),     -- dark orange
    Color(86, 151, 95),     -- desaturated green
    Color(150, 106, 183),   -- desaturated purple
    Color(153, 181, 62),    -- desaturated lime
    Color(195, 76, 80),     -- desaturated red
    Color(10, 26, 176),     -- dark blue
    Color(163, 169, 74),    -- desaturated yellow
    Color(90, 90, 90),      -- dark grey
    Color(199, 138, 69),    -- desaturated orange
    Color(145, 0, 0),       -- dark red
}