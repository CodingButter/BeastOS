local cc = require "modules/CC"
local Element = require "modules/Element"
local React = require "modules/React"
local Window = require "src/components/Window/Window"
local e = React.createElement

local Greed = function(props)
    return  Window({
        windowId = props.windowId,
        children = Element.div({
            style={
                width=10,
                height=10,
                backgroundColor = colors.blue
            }
        })
    })
end

return Greed