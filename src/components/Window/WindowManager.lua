local pretty = require "cc.pretty"
local utils = require "modules/Utils"
local React = require "modules/React"
local WindowManagerContext = require "src/context/WindowManagerContext"
local Apps = require "src/applications"
local Desktop = require "src/components/Desktop"

local switch = utils.switch
local reducer = function(state, action)
    local runningWindows = utils.table.filter(state, function(tbl, i)
        return tbl[1].open
    end)
    switch(action.type, {
        ["insert"] = function()
            state[action.payload.windowId] = {action.payload.windowState, action.payload.windowDispatch}
        end,
        ["remove"] = function()
            state[action.payload.windowId] = nil
        end,
        ["setActive"] = function()
            for k, v in pairs(state) do
                local windowState, dispatch = table.unpack(v)
                local _type = "setDepth"
                local level = #runningWindows
                if windowState.windowId ~= action.payload then
                    level = windowState.depth - 1
                end
                dispatch({
                    type = _type,
                    payload = level
                })
                -- utils.debugger.print("setActive depth of id:(".. windowState.windowId ..") " .. windowState.title .." to " .. level)
            end
        end,
        ["setInactive"] = function()
            for k, v in pairs(state) do
                local windowState, dispatch = table.unpack(v)
                local _type = "setDepth"
                local level = 1
                if windowState.windowId ~= action.payload then
                    level = windowState.depth < #runningWindows and windowState.depth + 1 or #runningWindows
                end
                dispatch({
                    type = _type,
                    payload = level
                })
                -- utils.debugger.print("setInactive depth of id:(".. windowState.windowId ..") " .. windowState.title .." to " .. level)
            end
        end
    })

    return state
end

local WindowManager = function(props)
    local WIDTH, HEIGHT = utils.window.getSize()
    local windows, dispatch = React.useReducer(reducer, {})

    return React.createElement("div", {
        id = "window_manager",
        style = {
            width = WIDTH,
            height = HEIGHT - 2,
            backgroundColor = colors.blue
        },
        children = WindowManagerContext:Provider({
            value = {windows, dispatch},
            children = {Desktop({
                children = Apps
            })}
        })
    })
end

return WindowManager
