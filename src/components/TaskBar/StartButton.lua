
local React = require "modules/React"
local Element = require "modules/Element"

local StartButton = function(props)
    return  Element.button({
        id = "startBtn",
        style = {
            width = 9,
            height = 1,
            left = 0,
            backgroundColor = colors.lightGray,
            focusedBackgroundColor = colors.lime
        },
        onClick = function(self,event)
            props.toggleMenu()
        end
    },"[START]")
end

return StartButton