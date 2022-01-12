local React = require "modules/React"
local WindowManagerContext = require "src/context/WindowManagerContext"
local utils = require "modules/Utils"
local useWindowContext = function(windowId)

    local windows = React.useContext(WindowManagerContext)
    if windows[1] then
        local window = windows[1][windowId]
        return window[1],window[1]
    end
    return {},function()end
end

return useWindowContext