local utils = require "modules.Utils"
local Element = require "modules.Element"
local BeastOs = function(props)
    local WIDTH, HEIGHT = term.getSize()
    return Element.div({
        id = "beastos",
        style = {
            paddingRight = 1,
            left = WIDTH - 8,
            height = 1,
            width = 8,
            color = colors.blue
        },

        children = {}
    }, "BeastUI")
end

return BeastOs
