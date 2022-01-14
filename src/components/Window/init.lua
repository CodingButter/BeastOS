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
        ["setActive"] = function()
            state.depth = action.payload
        end,
        ["setWindowId"] = function()
            state.windowId = action.payload
        end
    })
        return state
end

local Window = function(props)
   local windowManagerState,windowManagerDispatch = table.unpack(React.useContext(WindowManagerContext))
    local windowState,windowDispatch = React.useReducer(windowReducer,{application=props.children,title=props.title,depth=props.windowId,windowId=props.windowId,open=false,fullscreen=true,maximized=true,left=0,top=0,width=15,height=15})
    windowManagerDispatch({
        type = "insert",
        payload = {
            windowId = windowState.windowId,
            windowState = windowState,
            windowDispatch = windowDispatch
        }
    })

    local WIDTH,HEIGHT = utils.window.getSize()
    local width = WIDTH
    local height = HEIGHT - 1
    if windowState.fullscreen == false then
        width = windowState.width
        height = windowState.height
    end
    
    return (function()
        if windowState.maximized and windowState.open then
            return  React.createElement("div",{
                id = 'window_'..windowState.title .. "_" .. windowState.windowId,
                style = {
                    zIndex = windowState.depth
                },
                render = function(self)
                    utils.debugger.print(self.id .. " has a z of "..self.style.zIndex .. " depth of "..windowState.depth)
                    self.super.render(self)
                end,
                children = {
                    React.createElement("div",{
                        id = "window_" .. windowState.windowId,
                        children ={ 
                            Element.div({
                                id = "shadow_"..windowState.title.."_"..windowState.windowId,
                                className="shadow",
                                style = {
                                    top = 1,
                                    left = 1,
                                    width = width,
                                    height = height,
                                    backgroundColor = colors.black,    
                                }
                            }),
                            props.children({windowState=windowState.windowId,width=width}),
                            TitleBar({windowId=windowState.windowId,width=width}) 
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