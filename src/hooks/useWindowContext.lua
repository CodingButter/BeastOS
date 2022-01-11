local React = require "modules/React"
local WindowManagerContext = require "src/context/WindowManagerContext"
local utils = require "modules/Utils"
local useWindowContext = function(windowId)
    local windowManagerState,windowManagerDispatch = table.unpack(React.useContext(WindowManagerContext))
    return windowManagerState[windowId]
end

return useWindowContext