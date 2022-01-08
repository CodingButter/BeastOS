-- require("/disk/modules/CC")
-- require("/disk/src/App")

WIDTH,HEIGHT = cc.term.getSize()

root = Element.createElement("div",{
    style = {
    width = WIDTH,
    height = HEIGHT,
    backgroundColor = cc.colors.blue
    }
})

React.renderDom(App,root)