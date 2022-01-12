local React = require "modules/React"
local utils = require "modules/Utils"
local Button = require "src/components/Button"
local Minimized = function(props)
    
    utils.debugger.print("minimize windows" ..utils.table.serialize(props.windows))
    return e("div",{
        style = {
            left = 12,
            height = 1
        },
        children = utils.table.map(props.windows,function(window,i)
            utils.debugger.print("minimize window" ..utils.table.serialize(window))
           
            local windowState = window[1]
            local windowDispatch = window[2]
           
           return Button({
            content = windowState.title,
            style = {
                top = 0,
                width = 5,
                height = 1,
                left=(10*i)+10,
                backgroundColor = (function()
                    if windowState.open and windowState.minimized then return clors.gray end
                    return colors.lightGray
                end)()
            },
            onClick = function(event)
                if windowState.maximized then windowDispatch({action = "minimize"}) else
                    windowDispatch({actcion = "maximize"})
                end
            end
           })  
        end)
    }) 
end

return Minimized
