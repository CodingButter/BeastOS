local React = require "modules/React"
local UserContext = require "src/context/UserContext"
local TaskBar = require "src/components/TaskBar/TaskBar"
App = function()
    local user,setUser = React.useState("bob")
    return UserContext:Provider({
        value=user,
        updater=setUser,
        children = TaskBar({setUser=setUser})
    })
end

return App