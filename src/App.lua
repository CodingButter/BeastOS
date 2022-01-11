local cc = require "modules/CC"
local React = require "modules/React"
local UserContext = require "src/context/UserContext"
local TaskBar = require "src/components/TaskBar/TaskBar"
local WindowManager = require "src/components/Window/WindowManager"
local e = React.createElement
App = function()
    local WIDTH,HEIGHT = term.getSize()
    local user,setUser = React.useState("bob")
    return e("div",{
        style = {
            width = WIDTH,
            height = HEIGHT-1,
            backgroundColor = colors.lime
        },
        id="mainElement",
        children = UserContext:Provider({
            value=user,
            updater=setUser,
            children = {
                WindowManager(),
                TaskBar({setUser=setUser,width=WIDTH,height=HEIGHT})
            }
        })
    })
end

return App