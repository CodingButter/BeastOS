local utils = require "modules/Utils"
local Element = require "modules/Element"
local React = require "modules/React"

local Greed = function(props)
    local windowState = props.windowState
    local windowDispatch = props.windowDispatch
    local WIDTH, HEIGHT = utils.window.getSize()
    local centerX = WIDTH / 2
    local centerY = HEIGHT / 3
    local radius = 4
    local elWidth = 15
    local elHeight = 5
    local increment = 15
    local angle, setAngle = React.useState(1)
    local function degsToRad(deg)
        return deg / (180 / math.pi)
    end
    local sinY = math.sin(degsToRad(angle)) * radius
    local cosX = math.cos(degsToRad(angle)) * radius
    if windowState.open then
        setAngle(function(_angle)
            local newAngle = angle + increment
            if newAngle > 360 then
                newAngle = newAngle - 360
            end
            return newAngle
        end)
    end
    return React.createElement("div", {
        style = {
            top = centerY - elHeight / 2 + sinY,
            left = props.width / 2 - elWidth / 2 + cosX,
            width = elWidth,
            height = elHeight,
            backgroundColor = colors.red,
            color = colors.black
        },
        children = {Element.div({
            style = {
                top = 2,
                left = elWidth / 2 - #"GREED" / 2 - 1,
                textColor = colors.black
            }
        }, "GREED")}
    })
end

return Greed
