const  code = `
-- require("/disk/modules/cc")
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
`
const rexp = /require\(([^)]+)\)/g;
let matches = code.match(rexp)

console.log(matches)
