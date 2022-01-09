-- require("/disk/modules/CC")
-- require("/disk/modules/React")
-- require("/disk/modules/Element")
-- require("/disk/src/context/UserContext")
local e = React.Element

StartMenu = function(props)
    local buttons = {
        Element.button({
            top = 20,
            left = 1,
            width = 12,
            height = 1
        },"Settings")
    }
    
    return Element.div({
        id = "startmenu",
        style = {
            width = 12,
            height = 5,
            left = 3,
            top = -5,
            backgroundColor = cc.colors.lightGray
        },
        onClick = function(self,event)
        end,
        children = {
            Element.button({
                top = 20,
                left = 1,
                width = 12,
                height = 1
            },"Settings")
        }
    })
    
    return  startMenu
end
