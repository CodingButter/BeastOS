local React = require "modules.React"
local Element = require "modules.Element"

local StartButton = function(props)
    return Element.div({
        id = "startBtn",
        style = {
            width = 9,
            height = 1,
            left = 0,
            backgroundColor = colors.lightGray,
            focusedBackgroundColor = colors.lime,
            color = colors.yellow
        },
        onClick = function(self, event)
            props.toggleMenu()
        end,
        children = {}
    }, "[START]")
end

return StartButton
