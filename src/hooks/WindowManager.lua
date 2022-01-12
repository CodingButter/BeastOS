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
        end
    })

    return state
end

local WindowManager = function(props)
    local WIDTH,HEIGHT = term.getSize()
    local windows,dispatch = React.useReducer(reducer,{})

    return e("div",{
        style = {
            width = WIDTH,
            height = HEIGHT-1,
            backgroundColor = colors.blue
        },
        children = WindowManagerContext:Provider({
            value = {windows,dispatch},
            children = {Desktop()}
        })
    })
end

return WindowManager