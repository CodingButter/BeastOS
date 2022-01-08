-- require("/disk/modules/CC")
-- require("/disk/modules/Element")
-- require("/disk/src/context/UserContext")

BeastOs = function(props)
    setUserName = React.setContext(UserContext)
    return Element.button(
    {
        id="beastos",
        style = {
            paddingRight = 1,
            left = WIDTH - 8,
            height = 1,
            width = 8,
            color = cc.colors.lightBlue
        }, 
        onClick = function(self,event)
            setUserName("garry")
        end,
        content = "beast"
    })
end