local pretty = require "cc.pretty"
local utils = require "modules/Utils"
local React = require "modules/React"
local WindowManagerContext = require "src/context/WindowManagerContext"
local Apps = require "src/applications"
local Desktop = require "src/components/Desktop"

local switch = utils.switch
local reducer = function(state,action)
    switch(action.type,{
        ["insert"] = function()
            state[action.payload.windowId] = {
                action.payload.windowState,
                action.payload.windowDispatch
            }
        end,
        ["remove"] = function()
            state[action.payload.windowId] = nil
        end,
        ["setDepth"] = function()
            for k,v in pairs(state) do
                local windowState,dispatch = table.unpack(v)
                local _type = "setDepth"
                local level = #state
                if windowState.windowId ~= action.payload then 
                    level = windowState.depth - 1 
                end
                dispatch({type=_type,payload=level})
            end
        end
    })

    return state
end

local WindowManager = function(props)
    local WIDTH,HEIGHT = term.getSize()
    local windows,dispatch = React.useReducer(reducer,{})

    table.sort(windows,function(a,b)
        return a[1].depth<b[1].depth
    end)
    local windowApps = utils.table.map(windows,function(window,i)
        return window[1]
    end)
    return React.createElement("div",{
        id = "window_manager",
        style = {
            width = WIDTH,
            height = HEIGHT-2,
            backgroundColor = colors.blue
        },
        children = WindowManagerContext:Provider({
            value = {windows,dispatch},
            children = {Desktop({
                children = #windowApps>0 and windowApps or Apps
            })}
        })
    })
end

return WindowManager