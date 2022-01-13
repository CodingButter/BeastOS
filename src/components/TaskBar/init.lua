
local utils = require "modules/Utils"
local React = require "modules/React"
local StartButton = require "src/components/TaskBar/StartButton"
local WindowManagerContext = require "src/context/WindowManagerContext"
local BeastOs = require "src/components/TaskBar/BeastOs"
local Running = require "src/components/TaskBar/Running"
local StartMenu = require "src/components/TaskBar/StartMenu"


local TaskBar = function(props)
    local windows,dispatch = table.unpack(React.useContext(WindowManagerContext))
    
    local WIDTH, HEIGHT = term.getSize()
    local menu,updateMenu = React.useState(false)
    local function toggleMenu()
        local newVal = true
        if menu then newVal = false else newVal = true end
        updateMenu(newVal)
    end
    local element =  React.createElement("div",{
        id = "taskbar",
        style = {
            height = 1,
            width = WIDTH,
            top = HEIGHT - 1,
            backgroundColor = colors.red,
            textColor = colors.black
        },
        children = (function()
            local chtbl = {}
            if menu then chtbl[#chtbl+1] = StartMenu({toggleMenu = toggleMenu,loseFocus=toggleMenu}) end
            chtbl[#chtbl+1] = StartButton({
                toggleMenu = toggleMenu,
            })
            chtbl[#chtbl+1] = Running()
            chtbl[#chtbl+1] = BeastOs({width=WIDTH})
            return chtbl
        end)()
    })
   
    return element
end

return TaskBar
