local cc = require "modules/CC"
local Element = require "modules/Element"
local React = require "modules/React"
local App = require "src/App"
local WIDTH,HEIGHT = cc.term.getSize()

local root = Element.createElement("div",{
    style = {
    width = WIDTH,
    height = HEIGHT,
    backgroundColor = cc.colors.blue
    }
})

React.renderDom(App,root) 