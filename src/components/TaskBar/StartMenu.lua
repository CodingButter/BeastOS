local cc = require "modules/CC"
local Element = require "modules/Element"
local React = require "modules/React"
local UserContext = require "src/context/UserContext"
local Button = require "src/components/Button"
local e = React.createElement

local StartMenu = function(props)
    return e("div",{
        id = "startmenu",
        style = {
            width = 12,
            height = 5,
            left = 5,
            top = -5,
            backgroundColor = colors.lightGray
        },
        children = Button({
            id="settingsBtn",
            style = {
                paddingTop = 1,
                paddingBottom = 1,
                top = 0,
                left = 0,
                width = 12,
                height = 1,
                backgroundColor = colors.lightBlue,
                focusedBackgroundColor = colors.lime
            },
            onClick = function(event)
                props.toggleMenu()
            end,
            content = "Settings"
        })
    })
end

return StartMenu
