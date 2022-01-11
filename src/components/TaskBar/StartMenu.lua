
local utils = require "modules/Utils"
local Element = require "modules/Element"
local React = require "modules/React"
local Button = require "src/components/Button"
local WindowManagerContext = require "src/context/WindowManagerContext"

local e = React.createElement

local StartMenu = function(props)
    local windows,dispatch = table.unpack(React.useContext(WindowManagerContext))
    return e("div",{
        id = "startmenu",
        style = {
            width = 12,
            height = 5,
            left = 5,
            top = -5,
            backgroundColor = colors.lightGray
        },
        children = (function()
            return utils.table.map(windows,function(window,i)
                local windowState,windowDispatch = table.unpack(window)
                return Button({
                id="window-"..i,
                style = {
                    top = i-1,
                    left = 0,
                    width = 12,
                    height = 1,
                    backgroundColor = colors.lightBlue,
                    focusedBackgroundColor = colors.lime
                },
                onClick = function(event)
                    windowDispatch({type="open"})
                end,
                content = App
            })
        end)
    end)()
    })
end

return StartMenu
