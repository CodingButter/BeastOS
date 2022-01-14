
local utils = require "modules/Utils"
local React = require "modules/React"
local WindowManager = require "src/components/Window/WindowManager"
local TaskBar = require "src/components/TaskBar"

App = function()
    local WIDTH, HEIGHT = utils.window.getSize()
    return React.createElement("div",{
        id="main_element",
        style = {
            left = 1,
            top = 1,
            width = WIDTH,
            height = HEIGHT,
            backgroundColor = "transparent"
        },
        children = {
            WindowManager()
        }
    })
end

return App