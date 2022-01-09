local cc = require "modules/CC"
local Element = require "modules/Element"
local React = require "modules/React"
local UserContext = require "src/context/UserContext"
local e = React.createElement

local StartMenu = function(props)
    return Element.div({
        id = "startmenu",
        style = {
            width = 12,
            height = 5,
            left = 3,
            top = -5,
            backgroundColor = cc.colors.lightGray
        },
        children = 
            Element.button({
                top = 1,
                left = 1,
                width = 12,
                height = 1
            },"Settings")
    })
end

return StartMenu
