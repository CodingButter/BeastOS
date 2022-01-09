local cc = require "modules/CC"
local Element = require "modules/Element"
local React = require "modules/React"
local UserContext = require "src/context/UserContext"
local e = React.createElement

local StartMenu = function(props)
    return e("div",{
        id = "startmenu",
        style = {
            width = 12,
            height = 5,
            left = 5,
            top = -5,
            backgroundColor = cc.colors.lightGray
        },
        children = Element.button({
            id="settingsBtn",
            style = {
                paddingTop = 1,
                paddingBottom = 1,
                top = 1,
                left = 0,
                width = 12,
                height = 1,
                backgroundColor = cc.colors.lightBlue,
                focusedBackgroundColor = cc.colors.lime
            },
            onClick = function(event)
                
            end
        },"Settings")
    })
end

return StartMenu
