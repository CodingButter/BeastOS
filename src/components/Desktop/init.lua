local utils = require "modules/Utils"
local React = require "modules/React"
local TaskBar = require "src/components/TaskBar"
local Apps = require "src/applications"
local Window = require "src/components/Window"

local Desktop = function(props)
    local WIDTH,HEIGHT = term.getSize()
    return React.createElement("div",{
        style = {
            id = "desktop",
            width = WIDTH,
            height = HEIGHT,
            backgroundColor = colors.green
        },
        children = (function()
            local children = {}
            for i,v in pairs(Apps) do
                
                children[#children+1] = Window({
                    windowId=i,
                    children = v.application,
                    title = v.title
                })
            end
            children[#children+1] = TaskBar()
            return children
        end)()
    })
end

return Desktop