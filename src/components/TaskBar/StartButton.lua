local cc = require "modules/CC"
local React = require "modules/React"
local Element = require "modules/Element"
local UserContext = require "src/context/UserContext"

local StartButton = function(props)
    local name = React.useContext(UserContext)
    local setUserName = React.setContext(UserContext)
    return  Element.button({
        id = "startBtn",
        style = {
            width = 7,
            height = 1,
            left = 1,
            backgroundColor = colors.lightGray,
            focusedBackgroundColor = colors.lime
        },
        onClick = function(self,event)
            props.toggleMenu()
            if setUserName then
                setUserName("Not Garry")
            end
        end,
    },name)
end

return StartButton