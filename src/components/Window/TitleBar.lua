
local utils = require "modules/Utils"
local React = require "modules/React"
local Element = require "modules/Element"
local symbols = require "src/configs/symbols"
local Button = require "src/components/Button"
local useWindowContext = require "src/hooks/useWindowContext"
local e = React.createElement

local CloseButton = function(props)
    --utils.debugger.debugPrint(props.dispatch)
    return Button({
        id = "close_btn",
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
        id = "maximize_btn",
        style = {
            left=props.right - 6,
            top=0,
            width = 3,
            height =1,
            backgroundColor = colors.lightBlue,
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
        id = "minimize_btn",
        style = {
            left = props.right - 9,
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
    local WIDTH , HEIGHT = term.getSize()
    local windowState,windowDispatch = useWindowContext(props.windowId)
    return e("div",{
        id = "title_bar",
        style = {
            width = WIDTH,
            height = 1,
            top =0,
            backgroundColor = colors.lightGray
        },
        children = {
            CloseButton({right=WIDTH,state=windowState,dispatch=windowDispatch}),
            MinimizeButton({right=WIDTH,state=windowState,dispatch=windowDispatch}),
            MaximizeButton({right=WIDTH,state=windowState,dispatch=windowDispatch})
        }
    })

end

return TitleBar