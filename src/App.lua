
local React = require "modules/React"
local WindowManager = require "src/hooks/WindowManager"
local TaskBar = require "src/components/TaskBar"
local e = React.createElement
App = function()
    local WIDTH, HEIGHT = term.getSize()
    return e("div",{
        id="mainElement",
        style = {
            width = WIDTH,
            height = HEIGHT-1,
            backgroundColor = "transparent"
        },
        children = {
            WindowManager()
        }
    })
end

return App