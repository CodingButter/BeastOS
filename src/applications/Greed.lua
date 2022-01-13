
local Element = require "modules/Element"
local React = require "modules/React"


local Greed = function(props)
    local elWidth = 15
    return React.createElement("div",{
        style={
            top=3,
            width=elWidth,
            height=8,
            left=props.width/2 - elWidth/2,
            backgroundColor = colors.red,
            color = colors.black
        },
        children ={
            Element.div({
                style={
                    textColor=colors.black
                }
            },"GREED")
        }
    })
end

return Greed