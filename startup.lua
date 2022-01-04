--[[
	Creating a DOM for Lua 
	Author: Jamie Nichols
	Email: Jamie337nichols@gmail.com
]]



--[[UTILITY FUNCTIONS]]

utils = (function()

  -- Save copied tables in `copies`, indexed by original table.
  function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
  end

	local t = {
        map = function(tbl, f)
            local t = {}
            for k,v in pairs(tbl) do
                t[k] = f(v,k)
            end
            return t
	    end,
      filter = function(tbl,f)
          local t = {}
          for k,v in pairs(tbl) do
              if f(v,k) then t[k] = v; end
          end
          return t
      end,
      -- Save copied tables in `copies`, indexed by original table.
      copy = deepcopy
  }
    return {table = t}
end)()


--[[API FACTORY]]

ccraft = (function()
	return {
		term = term, 
		colors = colors,
        paintutils = paintutils
	}
end)()
--[[CLASS FACTORY]]

class = (function()
 		return function(newClass,parentClass)
      newClass.__index = newClass
      local hasConstructor = newClass.constructor ~= nil
      if parentClass ~=nil then 
          setmetatable(newClass,parentClass)
          newClass.super = utils.table.copy(parentClass)
      end
      newClass.new = function(...)
          local instance = {}
          setmetatable(instance,utils.table.copy(newClass))
          if hasConstructor == true then
              instance:constructor(...)
          end;
          return instance
      end
      return newClass
  	end
  end)()

--[[STYLE CLASS FACTORY]]

Style = class({
    display = "block",
    top = 0,
    left = 0,
    bottom = 0,
    right = 0,
    width = 0,
    height = 0,
    minWidth = 0,
    minHeight = 0,
    maxWidth = 'auto',
    maxHeight = 'auto',
    paddingLeft = 1,
    paddingTop = 1,
    paddingRight = 1,
    paddingBottom = 1,
    marginLeft = 0,
    marginTop = 0,
    marginRight = 0,
    marginBottom = 0,
    backgroundColor = "transparent",
    color = ccraft.colors.black,
    position = "relative",
    margin = function(self,val)
      self.marginTop = val
      self.marginLeft = val
      self.marginRight = val
      self.marginBottom = val
    end,
    padding = function(self,val)
      self.paddingTop = val
      self.paddingLeft = val
      self.paddingRight = val
      self.paddingBottom = val
    end,
    constructor = function(self,styles)
    	for k,v in pairs(styles) do
    		self[k] = v
    	end
    end
  })

--[[ELEMENT BASE CLASSFACTORY]]

	Element = (function()
	
	-- Private Variables
	local Elements = {}
    
  local EventLoop = function(event)
    for k,v in pairs(Elements) do
      if v[event[1]] then
        v[event[1]](v,event)
      end
    end
  end
  
  
  
  local Element = class({
  focused = false,
  children = {},
  offsetTop = 1,
  offsetLeft = 1,
  constructor = function(self,tag,props,content)
      for k,v in pairs(props) do
        self[k] = v
      end
      self.style = props.style or Style.new({})
      self.tag = tag
      self.content = content
      Elements[#Elements+1] = self
  end,
  appendChild = function(self,_element)
      _element.parent = self
      if _element.style.backgroundColor == "transparent" then
        _element.style.backgroundColor = self.style.backgroundColor     
      end
      _element.offsetTop = self.style.top + self.style.paddingTop + self.style.marginTop + self.offsetTop
      _element.offsetLeft = self.style.left + self.style.paddingLeft + self.style.marginLeft + self.offsetLeft
      table.insert(self.children, _element)
  end,
  prependChild = function(self,_element)
    table.insert(self.children,1,_element)
  end,
  setFocus  = function(self,event)
    self.focused = true
  end,
  mouse_click = function(self,event)
    self.focused = false
    local top,left,right,bottom = self:getBounds()
    local x = event[3]
    local y = event[4]
    if x > left - 1 and x < right + 1 and y > top - 1 and y < bottom + 1 and self.rendered then             
            self.focused = true
            if self.onClick then
                self:setFocus(event)
                self:onClick(event)
            end
        end
  end,
  -- Return the Bounding Box that will be rendered for the element
  getBounds = function(self)
    local offsetLeft = self.offsetLeft
    local offsetTop = self.offsetTop 
    local style = self.style
    local width = style.width
    local height = style.height
    local minWidth = style.minWidth
    local minHeight = style.minHeight
    local maxWidth = style.maxWidth
    local maxHeight = style.maxHeight
    if minWidth == 'auto' then minWidth = 0 end
    if minHeight == 'auto' then minHeight = 0 end
    if maxWidth == 'auto' then maxWidth = style.width end
    if maxHeight == 'auto' then maxHeight = style.height end
    minWidth = minWidth + style.paddingLeft + style.paddingRight + 1
    maxWidth = maxWidth + style.paddingLeft + style.paddingRight + 1
    minHeight = minHeight + style.paddingTop + style.paddingBottom
    maxHeight = maxHeight + style.paddingTop + style.paddingBottom 

 
    -- update the sides to include position, and margins
    offsetLeft = offsetLeft + style.left + style.marginLeft
    offsetTop = offsetTop + style.top + style.marginTop
    local offsetRight = offsetLeft + style.paddingRight + 1
    local offsetBottom = offsetTop + style.paddingBottom
    
    if self.content then
      offsetRight = math.max(offsetRight + width,offsetRight + style.paddingLeft + style.paddingRight + #tostring(self.content) - 2)
      offsetBottom = math.max(offsetBottom + height, offsetBottom + style.paddingTop + style.paddingBottom - 1)
    end
    for k,v in pairs(utils.table.filter(self.children,function(t)return t.style.display ~= "none";end)) do
      pleft,pTop,pRight,pBottom = v:getBounds(offsetLeft + style.paddingLeft,offsetTop + style.paddingTop)
      offsetRight = math.max(offsetRight, pRight + style.paddingRight)
      offsetBottom = math.max(offsetBottom, pBottom + style.paddingBottom)
    end 
    --offsetRight = offsetLeft + math.max(minWidth,math.min(offsetRight- offsetLeft,maxWidth))
    --offsetBottom = offsetTop + math.max(minHeight,math.min(offsetBottom - offsetTop,maxHeight))
    return offsetLeft ,offsetTop, offsetRight, offsetBottom
  end,
  render = function(self)
    self.rendered = true
    for k,v in ipairs(self.children) do
      v.rendered = false
    end
    -- Set Local Variable to override if neccessary
    local style = self.style
    local color = style.color
    local backgroundColor = style.backgroundColor
    local left,top,right,bottom = self:getBounds()

    if style.display ~= "none" then
        if style.backgroundColor ~= "transparent" then
          ccraft.paintutils.drawFilledBox(left,top,right,bottom,backgroundColor)
        end
        if self.content then
          ccraft.term.setBackgroundColor(backgroundColor)
          ccraft.term.setTextColor(color)      
          ccraft.term.setCursorPos(left + style.paddingLeft,top + style.paddingTop)
          ccraft.term.write(self.content)
          ccraft.term.setCursorPos(10,10)
          for k,v in ipairs(self.children) do
            v:render(left + style.paddingLeft,top + style.paddingTop )
          end
      end;
    end
  end
  })

  Element.div = class({
    constructor = function(self,props,content)
      self.super.constructor(self,"div",props,content)
    end
  },Element)
  
  Element.button = class({
    constructor = function(self,props,content)
      self.super.constructor(self,"button",props,content)
    end
  },Element)

  Element.input = class({
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
  Element.createElement = function(tag,props,content)
    return Element[tag].new(props,content)
  end

  Element.startEventLoop = function()
    while true do
      if Elements[1] then
        ccraft.term.clear()
        Elements[1]:render()
        event = {os.pullEvent()}
        EventLoop(event)
      end
    end
  end
  Element.attachRoot = function(child,props)
    local width,height = ccraft.term.getSize()
    local props = props or {}
    local rootStyle = props.style or Style.new({
      width = width,
      height = height,
      backgroundColor = ccraft.colors.black
    })
    local root = Element.new("div",{
      style = rootStyle
    })
    root:appendChild(child)
    Element.startEventLoop()
  end
  return Element
end)()


--[[Create a root element]]
ccraft.term.clear()
clicks = 1;
root = Element.createElement("div",{
    style = Style.new({
        backgroundColor = ccraft.colors.blue,
        color = ccraft.colors.black,
        left = 4,
        top = 4,
        maxWidth = 12
    }),
},"Something")
input = Element.createElement("input",{
  style = Style.new({
    minWidth = 5,
    backgroundColor = ccraft.colors.lime,
    color = ccraft.colors.black,
  }),
  onClick = function(self,event)
  end
},"Hello there")

root:appendChild(input)


Element.attachRoot(root,{})






