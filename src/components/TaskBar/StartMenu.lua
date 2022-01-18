local utils = require "modules.Utils"
local Element = require "modules.Element"
local React = require "modules.React"
local Button = require "src.components.Button"
local WindowManagerContext = require "src.context.WindowManagerContext"

local StartMenu = function(props)
    local windowManagerState, windowManagerDispatch = table.unpack(React.useContext(WindowManagerContext))
    return Element.createElement("ul", {
        id = "startmenu",
        style = {
            display = props.menuState and "block" or "none",
            width = 10,
            height = #windowManagerState,
            left = 2,
            top = -#windowManagerState,
            backgroundColor = colors.lightGray
        },
        loseFocus = props.loseFocus,
        children = utils.table.map(windowManagerState, function(window, i)
            local windowState, windowDispatch = table.unpack(window)
            return Button({
                id = "window-" .. i,
                style = {
                    top = i - 1,
                    left = 0,
                    width = 12,
                    height = 1,
                    backgroundColor = colors.lightBlue,
                    focusedBackgroundColor = colors.lime
                } or {},
                onClick = function(event)
                    windowDispatch({
                        type = "open"
                    })
                    windowManagerDispatch({
                        type = "setActive",
                        payload = windowState.windowId
                    })
                end,
                text = windowState.title
            })
        end)
    })
end
return StartMenu
