local cc = require "modules/CC"
local Element = require "modules/Element"
local React = require "modules/React"
debugger = peripheral.wrap("left")
debugger.stop()
local App = require "src/App"
local WIDTH,HEIGHT = term.getSize()
local root = Element.createElement("div",{
    style = {
    width = WIDTH,
    height = HEIGHT,
    backgroundColor = colors.black
    }
})

React.renderDom(App,root) 