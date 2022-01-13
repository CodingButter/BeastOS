
local React = require "modules/React"
local WindowManager = require "src/hooks/WindowManager"
local TaskBar = require "src/components/TaskBar"

App = function()
    local WIDTH, HEIGHT = term.getSize()
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