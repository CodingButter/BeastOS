local React = require "modules/React"
local WindowManagerContext = require "src/context/WindowManagerContext"
local utils = require "modules/Utils"
local useWindowContext = function(windowId)

    local windows = React.useContext(WindowManagerContext)[1]
    local window = windows[windowId]
    if window[1] and window[2] then
        return window[1], window[2]
    end
    return table.unpack({{}, function()
    end})
end

return useWindowContext
