
local Element = require "modules/Element"
local React = require "modules/React"

local BeastOs = function(props)
    return Element.button(
    {
        id="beastos",
        style = {
            paddingRight = 1,
            left = props.width - 8,
            height = 1,
            width = 8,
            color = colors.lightBlue
        }, 
        content = "BeastUI"
    })
end

return BeastOs