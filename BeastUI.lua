local utils = require "modules/Utils"
local Element = require "modules/Element"
local React = require "modules/React"
local App = require "src/App"
local WIDTH, HEIGHT = utils.window.getSize()
local root = Element.div({
    style = {
        width = WIDTH,
        height = HEIGHT,
        backgroundColor = colors.black
    }
})

React.renderDom(App, root)
