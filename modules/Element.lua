local class = require "modules/Class"
local Style = require "modules/Style"
local utils = require "modules/Utils"
local paintutils = require "modules/Shape"
local term = utils.window
local Elements = {}
local focusedElement = nil
local Element = class((function()
    local ElementBase = {
        id = nil,
        children = {},
        content = false
    }
    function ElementBase:constructor(tag, props, content)
        for k, v in pairs(props) do
            self[k] = v
        end
        self.id = props.id or self.id
        self.style = Style:new(props.style or {})
        self.tag = tag
        self.content = content or self.content
        self:getBounds()
        Elements[#Elements + 1] = self
    end

    function ElementBase:appendChild(_element)
        _element.parent = self
        _element:getBounds()
        if _element.style.backgroundColor == "transparent" then
            _element.style.backgroundColor = self.style.backgroundColor
        end
        self.children[#self.children + 1] = _element
    end

    function ElementBase:prependChild(_element)
        table.insert(self.children, 1, _element)
    end

    function ElementBase:loseFocus()

    end

    function ElementBase:setFocus(event)
        focusedElement = self:getUID()
    end

    function ElementBase:monitor_touch(event)
        self:mouse_click(event)
    end

    function ElementBase:mouse_click(event)
        local left, top, width, height = self:getBounds()
        local x = event[3]
        local y = event[4]
        if x >= left and x < left + width and y >= top and y < top + height then
            self:setFocus(event)
            if self.onClick then
                self:onClick(event)
            end
            return true
        end
        self:loseFocus()
        return false
    end

    function ElementBase:getBounds()
        local offsetLeft = 0
        local offsetTop = 0
        if self.parent then
            offsetLeft = self.parent.offsetLeft
            offsetTop = self.parent.offsetTop
        end
        local style = self.style
        offsetLeft = offsetLeft + style.left + style.marginLeft
        offsetTop = offsetTop + style.top + style.marginTop
        local width = style.width + style.paddingLeft + style.paddingRight
        local height = style.height + style.paddingTop + style.paddingBottom
        self.offsetLeft = offsetLeft
        self.offsetTop = offsetTop
        return offsetLeft, offsetTop, width, height
    end

    function ElementBase:render()
        if self.id == "taskbar" then
            utils.debugger.print(#self.children .. " in taskbar")
            utils.debugger.stop()
            utils.debugger.printTable(self.children)
            utils.debugger.print(self.id)
        end
        local style = self.style
        local color = style.color
        local backgroundColor = style.backgroundColor
        local left, top, width, height = self:getBounds()
        if style.display ~= "none" then
            if style.backgroundColor ~= "transparent" then
                paintutils.drawFilledBox(left, top, width, height, self.style.backgroundColor)
            else
                if self.parent then
                    self.style.backgroundColor = self.parent.style.backgroundColor
                end
            end
            if self.content then
                term.setBackgroundColor(self.style.backgroundColor)
                term.setTextColor(color)
                term.setCursorPos(left + style.paddingLeft + 1, top + style.paddingTop)
                term.write(self.content)
                term.setCursorPos(10, 10)
            end
            table.sort(self.children, function(a, b)
                return a.style.zIndex > b.style.zIndex
            end)
            for k, v in ipairs(self.children) do
                v:render()
                term.setBackgroundColor(colors.black)
                term.setTextColor(colors.white)
            end
        end
    end

    function ElementBase:event(event)
        local childClicked = false
        for i = #self.children, 1, -1 do
            local v = self.children[i]
            if v:event(event) then
                if childClicked == false then
                    childClicked = true
                end
            end
        end
        if childClicked then
            return true
        end
        if self[event[1]] then
            return self[event[1]](self, event)
        end
        return false
    end

    function ElementBase:getUID()
        if self.id == nil then
            self.id = math.random(1, 1000)
        end
        return self.id
    end

    return ElementBase

end)())

local root = false
local div = class({
    constructor = function(self, props, content)
        self.super:constructor("div", props, content)
    end
}, Element)

local button = class({
    style = Style:new({
        backgroundColor = colors.gray,
        focusedBackgroundColor = colors.lightGray
    }),
    constructor = function(self, props, content)
        self.super.constructor(self, "button", props, content)
    end,
    render = function(self)

        if focusedElement == self:getUID() and self.style.focusedBackgroundColor then
            local oldBgColor = self.style.backgroundColor
            self.style.backgroundColor = self.style.focusedBackgroundColor
            self.super.render(self)
            self.style.backgroundColor = oldBgColor
        else
            self.super.render(self)
        end
    end
}, Element)

local ul = class({
    style = Style:new({
        backgroundColor = colors.gray,
        focusedBackgroundColor = colors.lightGray
    }),
    constructor = function(self, props, content)
        self.super.constructor(self, "u", props, content)
    end
}, Element)

local input = class({
    constructor = function(self, props, content)
        self.super.constructor(self, "input", props, content)
    end,
    change = function(self, value)
        self.content = self.content .. value
        self:onChange()
    end,
    setFocus = function(self)
        self.super:setFocus()
        self.style.width = #self.content
        self.content = "";
    end,
    onChange = function(self)

    end,
    char = function(self, event)
        if focusedElement == self then
            self:change(event[2])
        end
    end
}, Element)

Element.createElement = function(tag, props, content)
    return Element[tag](props, content)
end

Element.attachRoot = function(child)
    root = child
    Elements = {root}
end

Element.triggerEvent = function(event)
    root:event(event)
end

Element.div = function(props, content)
    return div:new(props, content)
end
Element.button = function(props, content)
    return button:new(props, content)
end
Element.input = function(props, content)
    return input:new(props, content)
end
Element.ul = function(props, content)
    return ul:new(props, content)
end
Element.Elements = Elements

return Element

