os.loadAPI("/Library.lua")
React = Library.React
RenderDom = React.renderDom
Element = Library.Element
CC = Element.ccraft
e = React.createElement

WIDTH, HEIGHT = CC.term.getSize()
root = Element.createElement("div",{
    width = WIDTH,
    height = HEIGHT,
    background = CC.colors.blue
})

App = function()
    return {
        tag = "div",
        props = {
            children = "hello"
        },
        key = 1
    }
end

RenderDom(App,root)