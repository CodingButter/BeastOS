local utils = require "modules/Utils"
local pretty = require "cc.pretty"
local Element = require "modules/Element"
local React = require "modules/React"
local WindowManagerContext = require "src/context/WindowManagerContext"
local TitleBar = require "src/components/Window/TitleBar"

local switch = utils.switch

local windowReducer = function(state,action)
    switch(action.type,
    {
        ["fullscreen"] = function()
            state.fullscreen = true
        end,
        ["toggle_fullscreen"] = function()
            if state.fullscreen then state.fullscreen = false
            else state.fullscreen = true end
        end,
        ["minimize"] = function()
            state.maximized = false
        end,
        ["maximize"] = function()
            state.maximized = true
        end,
        ["close"] = function()
            state.open = false
        end,
        ["open"] = function()
            state.open = true
        end,
        ["setDepth"] = function()
            state.depth = action.payload
        end
    })
        return state
end

local Window = function(props)
    
    local windowManagerState,windowManagerDispatch = table.unpack(React.useContext(WindowManagerContext))
    local windowState,windowDispatch = React.useReducer(windowReducer,{title=props.title,depth=props.windowId,windowId=props.windowId,open=false,fullscreen=true,maximized=true,left=0,top=0,width=15,height=15})
    windowManagerDispatch({
        type = "insert",
        payload = {
            windowId = props.windowId,
            windowState = windowState,
            windowDispatch = windowDispatch
        }
    })
    local WIDTH,HEIGHT = term.getSize()
    local width = WIDTH
    local height = HEIGHT - 1
    if windowState.fullscreen == false then
        width = windowState.width
        height = windowState.height
    end
    
    return (function()
        if windowState.maximized and windowState.open then
            return  React.createElement("div",{
                
                children = {
                    Element.div({
                        className="shadow",
                        style = {
                            top = 1,
                            left = 1,
                            width = width,
                            height = height,
                            backgroundColor = colors.black,    
                        }
                    }),
                    React.createElement("div",{
                        id = "window_" .. props.windowId,
                        style = {
                            left = windowState.left,
                            top = windowState.top,
                            width = width,
                            height = height,
                            backgroundColor = colors.blue
                        },
                        children ={
                            props.children({widnowId=windowState.windowId,width=width}),
                            TitleBar({windowId=props.windowId,width=width}) 
                        }
                    })
                }
            })
        else
            return React.createElement("div",{
                style = {
                    width=0,
                    height=0,
                },
                children = {}
            })
        end
    end)()
end

return Window