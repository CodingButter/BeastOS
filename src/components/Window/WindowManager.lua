debugger.stop()
local utils = require "modules/Utils"
local React = require "modules/React"
local WindowContext = require "src/context/WindowContext"
local Applications = require "src/applications"
local switch = utils.switch

local windowReducer = function(state,action)
    switch(action.type,
    {
        ["toggle"] = function()
            if state.fullscreen then state.fullscreen = false
            else state.fullscreen = true end
        end,
        ["minimize"] = function()
            state.maximized = false
        end,
        ["maximize"] = function()
            state.maximized = true
        end
    })
        return state
end



local WindowManager = function(props)
    local WIDTH,HEIGHT = term.getSize()
    local windows = utils.table.map(Applications,function(app,i)
        local windowState,windowDispatch = React.useReducer(windowReducer,{windowId=i,opened=false,fullscreen=true,maximized=false,left=0,top=0,width=15,height=15})
        local Context = WindowContext[i]
        return {
            Provider = Context.Provider,
            windowId = i,
            app = app,
            windowState = windowState,
            windowDispatch = windowDispatch
        }
    end)
    return e("div",{
        style = {},
        children = utils.table.map(windows,function(window,i)
            return window:Provider({
                value = window.windowState,
                updater = window.windowDispatch,
                children = window.app({windowId=window.windowId})
            })
        end)
    })
end

return WindowManager