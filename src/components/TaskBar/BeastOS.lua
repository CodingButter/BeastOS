local utils = require "modules/Utils"
local Element = require "modules/Element"
local React = require "modules/React"
local BeastOs = function(props)
    local WIDTH, HEIGHT = utils.window.getSize()
    return Element.button({
        id = "beastos",
        style = {
            paddingRight = 1,
            left = WIDTH - 8,
            height = 1,
            width = 8,
            color = colors.lightBlue
        },
        content = "BeastUI"
    })
end

return BeastOs
