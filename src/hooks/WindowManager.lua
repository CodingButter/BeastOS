local pretty = require "cc.pretty"
local utils = require "modules/Utils"
local React = require "modules/React"
local WindowManagerContext = require "src/context/WindowManagerContext"
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
    local windows,dispatch = React.useReducer(reducer,{{{title="window",isActive=false,windowId=1,open=false,fullscreen=true,maximized=true,left=0,top=0,width=15,height=15},function()end}})

    return React.createElement("div",{
        id = "window_manager",
        style = {
            width = WIDTH,
            height = HEIGHT-2,
            backgroundColor = colors.blue
        },
        children = WindowManagerContext:Provider({
            value = {windows,dispatch},
            children = {Desktop()}
        })
    })
end

return WindowManager