local React = require "modules.React"

local windowContext = React.createContext({{}, function()
end})
return windowContext
