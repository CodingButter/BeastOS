local utils = require "modules.Utils"
local Element = require "modules.Element"
local WindowManager = require "src.components.Window.WindowManager"

local App = function()
    local WIDTH, HEIGHT = term.getSize()
    return Element.createElement("div", {
        id = "main_element",
        style = {
            left = 1,
            top = 1,
            width = WIDTH,
            height = HEIGHT,
            backgroundColor = "transparent"
        },
        children = {WindowManager()}
    })
end

return App
