local cc = require "modules/CC"
local Element = require "modules/Element"
local React = require "modules/React"
local UserContext = require "src/context/UserContext"

local BeastOs = function(props)
    local WIDTH = cc.term.getSize()
    local setUserName = React.setContext(UserContext)
    
    return Element.button(
    {
        id="beastos",
        style = {
            paddingRight = 1,
            left = WIDTH - 8,
            height = 1,
            width = 8,
            color = cc.colors.lightBlue
        }, 
        onClick = function(self,event)
            if setUserName then
                setUserName("Garry")
            end
        end,
        content = "BeastUI"
    })
end

return BeastOs