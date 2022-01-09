local cc = require "modules/CC"
local React = require "modules/React"
local Element = require "modules/Element"
local UserContext = require "src/context/UserContext"

local StartButton = function(props)
    local name = React.useContext(UserContext)
    local setUser = React.setContext(UserContext)
    return  Element.createElement("button",{
        id = "startBtn",
        style = {
            width = 7,
            height = 1,
            left = 1,
            backgroundColor = cc.colors.lightGray,
            focusedBackgroundColor = cc.colors.lime
        },
        onClick = function(self,event)
            props.toggleMenu()
            setUser("Not Garry")
        end,
    },name)
end

return StartButton