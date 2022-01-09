local cc = require "modules/CC"
local React = require "modules/React"
local StartButton = require "src/components/TaskBar/StartButton"
local BeastOs = require "src/components/TaskBar/BeastOs"
local StartMenu = require "src/components/TaskBar/StartMenu"

e = React.createElement

TaskBar = function(props)
    local menu,updateMenu = React.useState(false)
    local function toggleMenu()
        updateMenu(menu==false)
    end
    local element =  e("div",{
        id = "taskbar",
        style = {
            height = 1,
            width = props.width,
            top = props.height - 1,
            backgroundColor = cc.colors.red,
            textColor = cc.colors.black
        },
        children = (function()
            local chtbl = {}
            chtbl[#chtbl+1] = StartButton({
                toggleMenu = toggleMenu
            })
            if menu then chtbl[#chtbl+1] = StartMenu() end
            chtbl[#chtbl+1] = BeastOs()
            return chtbl
        end)()
    })
   
    return element
end

return TaskBar
