local cc = require "modules/CC"
local React = require "modules/React"
local Element = require "modules/Element"
local symbols = require "src/configs/symbols"
local Button = require "src/components/Button"
local e = React.createElement

local CloseButton = function(props)
    return Button({
        style = {
            left = props.right - 3,
            top = 0,
            width = 3,
            height =1,
            backgroundColor = colors.red,
            textColor = colors.white
        },
        content = symbols.close
    })
end

local MaximizeButton = function(props)
    return Button({
        style = {
            left=props.right - 7,
            top=0,
            width = 3,
            height =1,
            backgroundColor = colors.blue,
            textColor = colors.white
        },
        content = symbols.maximize
    })
end
local MinimizeButton = function(props)
    return Button({
        style = {
            left = props.right - 10,
            top = 0,
            width = 3,
            height =1,
            backgroundColor = colors.orange,
            textColor = colors.white
        },
        content = symbols.minimize
    })
end


local TitleBar = function(props)
    return Element.div({
        style = {
            width = props.width,
            height = 1,
            backgroundColor = colors.lightGray
        },
        children = {
            CloseButton({right=props.width}),
            MinimizeButton({right=props.width}),
            MaximizeButton({right=props.width})
        }
    })

end

return TitleBar