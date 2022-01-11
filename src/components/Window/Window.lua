local utils = require "modules/Utils"
local cc = require "modules/CC"
local React = require "modules/React"
local TitleBar = require "src/components/Window/TitleBar"
local WindowContext = require "src/context/WindowContext"
local e = React.createElement
local switch = utils.switch

local Window = function(props)
    local WIDTH,HEIGHT = term.getSize()
    local windowContext = WindowContext(props.windowId)
    local windowState = React.useContext(windowContext)
    local setWindowState = React.setContext(windowContext)
   
    
    return (function()
        if windowState.maximized then
            return  e("div",{
                style = {
                    left = windowState.left,
                    top = windowState.top,
                    width = width,
                    height = height,
                    backgroundColor = colors.gray
                },
                children = TitleBar({width = width})
            })
        else
            return e("div",{
                style = {
                    width=2,
                    height=1,
                    top=HEIGHT-1,
                    left=12,
                    backgroundColor=colors.gray
                },
                children = {}
            })
        end
    end)()
end

return Window