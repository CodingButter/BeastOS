local React = require "modules.React"
local Element = require "modules.Element"

local Button = function(props)
    return Element.button(props, props.text)
end
return Button
