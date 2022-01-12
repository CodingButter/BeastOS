
local utils = require "modules/Utils"
local Element = require "modules/Element"
local React = require "modules/React"
local Button = require "src/components/Button"

local e = React.createElement

local StartMenu = function(props)



    
    return e("div",{
        id = "startmenu",
        style = {
            width = 10,
            height = #props.windows,
            left = 2,
            top = -#props.windows,
            backgroundColor = colors.lightGray
        },
        children = utils.table.map(props.windows,function(window,i)
                local windowState,windowDispatch = table.unpack(window)
                return Button({
                id="window-"..i,
                style = {
                    top = i-1,
                    left = 0,
                    width = 12,
                    height = 1,
                    backgroundColor = colors.lightBlue,
                    focusedBackgroundColor = colors.lime
                },
                onClick = function(event)
                    windowDispatch({type="open"})
                end,
                content = windowState.title   
            })
        end)
    })
end

return StartMenu
