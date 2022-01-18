local Element = require "modules.Element"
local React = require "modules.React"

local BulletinBoard = function(props)
    local elWidth = 16
    return Element.createElement("div", {
        style = {
            left = props.width / 2 - elWidth / 2,
            width = elWidth,
            height = 4,
            top = 2,
            backgroundColor = colors.green
        },
        children = {Element.div({
            style = {
                top = 1
            }
        }, "Bulletin Board")}
    })
end

return BulletinBoard
