local React = require "modules/React"
local Element = require "modules/Element"

local Button = function(props)
    return Element.button(props, props.content)
end
return Button
