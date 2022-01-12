
local utils = require "modules/Utils"
local Element = require "modules/Element"
local React = require "modules/React"
local Button = require "src/components/Button"
local WindowManagerContext = require "src/context/WindowManagerContext"

local e = React.createElement

local StartMenu = function(props)
    local windows,dispatch = React.useContext(WindowManagerContext)
    utils.debugger.print(utils.table.serialize(windows))
    return e("div",{
        id = "startmenu",
        style = {
            width = 10,
            height = #windows,
            left = 2,
            top = -#windows,
            backgroundColor = colors.lightGray
        },
        children = utils.table.map(windows,function(window,i)
                local windowState,windowDispatch = table.unpack(window)
                return Button({
                id="window-"..i,
                style = {
                    top = i,
                    left = 0,
                    width = 12,
                    height = 1,
                    backgroundColor = colors.lightBlue,
                    focusedBackgroundColor = colors.lime
                },
                onClick = function(event)
                    windowDispatch({type="open"})
                end,
                content = windowState.title   
            })
        end)
    })
end

return StartMenu
