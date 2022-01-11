
local class = require "modules/Class"
local Style = require "modules/Style"
local utils = require "modules/Utils"

local Elements = {}
local focusedElement = nil
local focusSet = false
local root = {}
local Element = class({
  id = #Elements,
  renderDepth = 1,
  children = {},
  content = false,
  constructor = function(self,tag,props,content)  
    for k,v in pairs(props) do
      self[k] = v
    end
    self.id = props.id or self.id
    self.style = Style.new(props.style or {})
    self.tag = tag
    self.content = content or self.content
    Elements[#Elements+1] = self
  end,
  getElementsByClassName = function(className)
    return table.filter(Elements,function(v)
      return v.Class == className
    end)
  end,
  appendChild = function(self,_element)
    _element.parent = self
    _element.renderDepth = self.renderDepth+1
    if _element.style.backgroundColor == "transparent" then
      _element.style.backgroundColor = self.style.backgroundColor     
    end
    self.children[#self.children+1] =  _element
  end,
  prependChild = function(self,_element)
    table.insert(self.children,1,_element)
  end,
  setFocus  = function(self,event)
    focusedElement = self:getUID()
  end,
  monitor_touch = function(self,event)
      self:mouse_click(event)
  end,
  mouse_click = function(self,event)
    local left,top,right,bottom = self:getBounds()
    local x = event[3]
    local y = event[4]
    if x > left - 1 and x < right + 1 and y > top - 1 and y < bottom + 1 then  
        self:setFocus(event)
        if self.onClick then 
          self:onClick(event)
        end
        return true
    end
    return false
  end,
  getBounds = function(self)
    
    local offsetLeft = 0
    local offsetTop = 1
    if self.parent then
      offsetLeft = self.parent.offsetLeft + self.parent.style.marginLeft + self.parent.style.paddingLeft
      offsetTop = self.parent.offsetTop + self.parent.style.marginTop + self.parent.style.paddingTop
    end
    local style = self.style
    offsetLeft = offsetLeft + style.left + style.marginLeft 
    offsetTop = offsetTop + style.top + style.marginTop
    offsetRight = offsetLeft + style.width + style.paddingLeft + style.paddingRight
    offsetBottom = offsetTop +  style.height + style.paddingTop + style.paddingBottom -1
    
    self.offsetLeft = offsetLeft
    self.offsetTop = offsetTop
    return offsetLeft ,offsetTop, offsetRight, offsetBottom
  end,
  render = function(self)
    
    -- Set Local Variable to override if neccessary
    local style = self.style
    local color = style.color
    local backgroundColor = style.backgroundColor
    local left,top,right,bottom = self:getBounds()
    
    if style.display ~= "none" then
      if style.backgroundColor ~= "transparent" then
        paintutils.drawFilledBox(left,top,right,bottom,self.style.backgroundColor)
      else
        if self.parent then
          self.style.backgroundColor = self.parent.style.backgroundColor
        end
      end
      if self.content then
        term.setBackgroundColor(self.style.backgroundColor)
        term.setTextColor(color)     
        term.setCursorPos(left + style.paddingLeft+1,top + style.paddingTop)
        term.write(self.content)
        term.setCursorPos(10,10)
      end;
      for k,v in ipairs(self.children) do
        v:render()
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)      
      end
    end
  end,
  event = function(self,event)
    for _,v in pairs(self.children) do
      if v:event(event) then return true end    
    end
    if self[event[1]] then
      return self[event[1]](self,event) 
    end
    return false
  end,
  getUID = function(self)
    -- term.setBackgroundColor(colors.black)
    -- term.setTextColor(colors.white)
    -- local function recursiveParent(el,prevId)
    --   if el.parent then
    --     if el.parent.id then
    --       local newId = tostring(el.parent.id) .. tostring(prevId)
    --       return recursiveParent(el.parent,newId) 
    --     end
    --   end
    --   return prevId
    -- end
    -- return recursiveParent(self,self.id)
    return self.id
  end
})

local root = false

local div = class({
  constructor = function(self,props,content)
    self.super.constructor(self,"div",props,content)
  end
},Element)

local button = class({
  constructor = function(self,props,content)
    self.super.constructor(self,"button",props,content)
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
},Element)

local input = class({
  constructor = function(self,props,content)
    self.super.constructor(self,"input",props,content)
  end,
  change = function(self,value)
    self.content = self.content .. value
    self:onChange(value)
  end,
  setFocus = function(self)
    self.super:setFocus()
    self.style.width = #self.content
    self.content = "";
  end,
  onChange = function(self)

  end,
  char = function(self,event)
    if focusedElement == self then
      self:change(event[2])
    end
  end
},Element)

Element.createElement = function(tag,props,content)
  return Element[tag](props,content)
end
  
Element.attachRoot = function(child)
  root = child
  Elements = {root}
end
  
Element.triggerEvent = function(event)
  root:event(event)
end

Element.div = div.new
Element.button = button.new
Element.input = input.new
Element.Elements = Elements

return Element

