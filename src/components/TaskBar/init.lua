local utils = require "modules/Utils"
local React = require "modules/React"
local StartButton = require "src/components/TaskBar/StartButton"
local WindowManagerContext = require "src/context/WindowManagerContext"
local BeastOs = require "src/components/TaskBar/BeastOs"
local Running = require "src/components/TaskBar/Running"
local StartMenu = require "src/components/TaskBar/StartMenu"

local TaskBar = function(props)
    local windows, dispatch = table.unpack(React.useContext(WindowManagerContext))
    local WIDTH, HEIGHT = utils.window.getSize()
    local menuState, updateMenu = React.useState(false)
    local function toggleMenu()
        updateMenu(not menuState and true or false)
    end
    return React.createElement("div", {
        id = "taskbar",
        style = {
            height = 1,
            width = WIDTH,
            top = HEIGHT - 1,
            backgroundColor = colors.red,
            textColor = colors.black
        },
        children = {StartMenu({
            menuState = menuState,
            toggleMenu = toggleMenu,
            loseFocus = toggleMenu
        }), StartButton({
            toggleMenu = toggleMenu
        }), Running(), BeastOs()}
    })
end
return TaskBar
