local utils = require "modules.Utils"
local React = require "modules.React"
local Element = require "modules.Element"
local symbols = require "src.configs.symbols"
local Button = require "src.components.Button"
local WindowManagerContext = require "src.context.WindowManagerContext"

local CloseButton = function(props)
    return Button({
        id = "close_btn",
        style = {
            left = props.right - 3,
            top = 0,
            width = 3,
            height = 1,
            backgroundColor = colors.red,
            textColor = colors.white
        },
        onClick = function(self, event)
            if props.state.depth == #props.windows then
                props.dispatch({
                    type = "close"
                })
            end
        end,
        text = symbols.close
    })
end

local MaximizeButton = function(props)
    return Button({
        id = "full_screen",
        style = {
            left = props.right - 6,
            top = 0,
            width = 3,
            height = 1,
            backgroundColor = colors.lightBlue,
            textColor = colors.white
        },
        onClick = function(self, event)
            if props.state.depth == #props.windows then
                props.dispatch({
                    type = "toggle_fullscreen"
                })
            end
        end,
        text = props.state.fullscreen and symbols.windowed or symbols.fullscreen
    })
end
local MinimizeButton = function(props)
    return Button({
        id = "minimize_btn",
        style = {
            left = props.right - 9,
            top = 0,
            width = 3,
            height = 1,
            backgroundColor = colors.orange,
            textColor = colors.white
        },
        onClick = function(self, event)
            if props.state.depth == #props.windows then
                props.dispatch({
                    type = "minimize"
                })
            end
        end,
        text = symbols.minimize
    })
end

local TitleBar = function(props)
    local windows, windowsDispatch = table.unpack(React.useContext(WindowManagerContext))
    local windowState, windowDispatch = table.unpack(windows[props.windowId] or {{}, function()
    end})
    local runningWindows = utils.table.filter(windows, function(window)
        local windowState, windowDispatch = table.unpack(window)
        return windowState.open
    end)
    return Element.createElement("div", {
        id = "title_bar",
        style = {
            width = props.width,
            height = 1,
            top = -1,
            backgroundColor = colors.lightGray
        },
        children = {CloseButton({
            right = props.width,
            windows = runningWindows,
            state = windowState,
            dispatch = windowDispatch
        }), MinimizeButton({
            right = props.width,
            windows = runningWindows,
            state = windowState,
            dispatch = windowDispatch
        }), MaximizeButton({
            right = props.width,
            windows = runningWindows,
            state = windowState,
            dispatch = windowDispatch
        })},
        onClick = function(event)
            if windowState.depth < #runningWindows then
                windowsDispatch({
                    type = "setActive",
                    payload = windowState.windowId
                })
            end
        end
    })

end

return TitleBar
