local React = require "modules/React"
local TaskBar = require "src/components/TaskBar"
local Apps = require "src/applications"
local Window = require "src/components/Window"
local e = React.createElement
local Desktop = function(props)
    local WIDTH,HEIGHT = term.getSize()
    return e("div",{
        style = {
            width = WIDTH,
            height = HEIGHT-1,
            backgroundColor = colors.green
        },
        children = (function()
            local children = {}
            for i,v in pairs(Apps) do
                children[#children+1] = Window({
                    windowId=i,
                    children = v
                })
            end
            children[#children+1] = TaskBar()
            return children
        end)()
    })
end

return Desktop