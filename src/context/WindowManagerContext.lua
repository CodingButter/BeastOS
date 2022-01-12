local React = require "modules/React"

local windowContext = React.createContext({{{title="window",isActive=false,windowId=1,opened=false,fullscreen=true,maximized=true,left=0,top=0,width=15,height=15},function()end},function()end})
return windowContext