
local Element = require "modules/Element"
local React = require "modules/React"
local e = React.createElement

local Greed = function(props)
    return e("div",{
            style={
                width=10,
                height=10,
                backgroundColor = colors.red
            }
        })
end

return Greed