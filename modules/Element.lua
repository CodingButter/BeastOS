-- require("/disk/modules/CC")
-- require("/disk/modules/Style")
-- require("/disk/modules/Utils")

Element = (function()
  local Elements = {}
  local focusedElement = false
  Element = class({
    renderDepth = 1,
    focused = false,
    children = {},
    content = false,
    constructor = function(self,tag,props,content)
        
      for k,v in pairs(props) do
        self[k] = v
      end
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
      table.insert(self.children, _element)
    end,
    prependChild = function(self,_element)
      table.insert(self.children,1,_element)
    end,
    setFocus  = function(self,event)
      self.focused = true
    end,
    monitor_touch = function(self,event)
        self:mouse_click(event)
    end,
    mouse_click = function(self,event)
      self.focused = false
      local left,top,right,bottom = self:getBounds()
      local x = event[3]
      local y = event[4]
      if x > left - 1 and x < right + 1 and y > top - 1 and y < bottom + 1 then   

        self:setFocus(event)
        if self.onClick and focusedElement == false then
          self:onClick(event)
          focusedElement = true
        end
        
      end
    end,
    getBounds = function(self)
      
      local offsetLeft = 1
      local offsetTop = 1
      if self.parent then
        offsetLeft = self.parent.offsetLeft + self.parent.style.marginLeft + self.parent.style.left + self.parent.style.paddingLeft - 1
        offsetTop = self.parent.offsetTop + self.parent.style.marginTop + self.parent.style.paddingTop
      end
      local style = self.style
      offsetLeft = offsetLeft + style.left + style.marginLeft 
      offsetTop = offsetTop + style.top + style.marginTop
      offsetRight = offsetLeft + style.width + style.paddingLeft + style.paddingRight
      offsetBottom = offsetTop +  style.height + style.paddingTop + style.paddingBottom - 1
      
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
          cc.paintutils.drawFilledBox(left,top,right,bottom,self.style.backgroundColor)
        else
          if self.parent then
            self.style.backgroundColor = self.parent.style.backgroundColor
          end
        end
        if self.content then
          cc.term.setBackgroundColor(self.style.backgroundColor)
          cc.term.setTextColor(color)     
          cc.term.setCursorPos(left + style.paddingLeft+1,top + style.paddingTop)
          cc.term.write(self.content)
          cc.term.setCursorPos(10,10)
        end;
        for k,v in ipairs(self.children) do
          v:render()
          cc.term.setBackgroundColor(cc.colors.black)
          cc.term.setTextColor(cc.colors.white)      
        end
      end
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
      if self.focused == true and self.style.focusedBackgroundColor then
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
      if self.focused then
        self:change(event[2])
      end
    end
  },Element)

  Element.div = div.new
  Element.button = button.new
  Element.input = input.new

  Element.createElement = function(tag,props,content)
    return Element[tag](props,content)
  end
    
  Element.attachRoot = function(child)
    local root = child
    startEventLoop()
  end
    
  Element.triggerEvent = function(event)
    focusedElement = false
    table.sort(Elements,function(a,b) return b.renderDepth > a.renderDepth end)
    
    for _,v in pairs(Elements) do
      if v[event[1]] then
        v[event[1]](v,event)
      end
    end
  end
  Element.Elements = Elements

  return Element
end)()
