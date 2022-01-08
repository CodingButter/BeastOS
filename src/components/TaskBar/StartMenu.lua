-- require("/disk/modules/CC")
-- require("/disk/modules/React")
-- require("/disk/modules/Element")
-- require("/disk/src/context/UserContext")

StartMenu = function(props)

    local buttons = {
        Element.button({
            top = 0,
            width = 12,
            height = 1
        },"Settings")
    }

    return  Element.div({
        id = "startmenu",
        style = {
            width = 12,
            height = 5,
            left = 0,
            top = -5,
            backgroundColor = cc.colors.lightGray
        },
        onClick = function(self,event)
        end,
        children = buttons
    })
end
