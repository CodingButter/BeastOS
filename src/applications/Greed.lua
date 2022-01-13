
local Element = require "modules/Element"
local React = require "modules/React"


local Greed = function(props)
    local elWidth = 15
    return React.createElement("div",{
        style={
            width=elWidth,
            height=5,
            left=props.width/2 - elWidth/2,
            backgroundColor = colors.red
        },
        children ={}
    })
end

return Greed