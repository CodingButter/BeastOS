
local utils = require "modules/Utils"
local React = require "modules/React"
local Element = require "modules/Element"
local symbols = require "src/configs/symbols"
local Button = require "src/components/Button"
local useWindowContext = require "src/hooks/useWindowContext"
local WindowManagerContext = require "src/context/WindowManagerContext"
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
        onClick = function(self,event)
            props.dispatch({type="close"})
        end,
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
        onClick = function(self,event)
            props.dispatch({type="maximize"})
        end,
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
        onClick = function(self,event)
            props.dispatch({type="minimize"})
        end,
        content = symbols.minimize
    })
end


local TitleBar = function(props)
    local windowManagerState,windowManagerDispatch = table.unpack(React.useContext(WindowManagerContext))
    return e("div",{
        style = {
            width = props.width,
            height = 1,
            backgroundColor = colors.lightGray
        },
        children = {
            CloseButton({right=props.width,state=windowState,dispatch=windowDispatch}),
            MinimizeButton({right=props.width,state=windowState,dispatch=windowDispatch}),
            MaximizeButton({right=props.width,state=windowState,dispatch=windowDispatch})
        }
    })

end

return TitleBar