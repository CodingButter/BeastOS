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
    paddingLeft = 0,
    paddingTop = 0,
    paddingRight = 0,
    paddingBottom = 0,
    marginLeft = 0,
    marginTop = 0,
    marginRight = 0,
    marginBottom = 0,
    backgroundColor = "transparent",
    focusedBackgroundColor = false,
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
  local focusedElement = false
  local EventLoop = function(event)
    focusedElement = false
    for i=#Elements,1,-1 do
      local v = Elements[i]
      if v[event[1]] then
        v[event[1]](v,event)
      end
    end
  end
  
  
  local Element = class({
  focused = false,
  children = {},
  content = false,
  constructor = function(self,tag,props,content)
      for k,v in pairs(props) do
        self[k] = v
      end
      self.style = props.style or Style.new({})
      self.tag = tag
      self.content = content or self.content
      Elements[#Elements+1] = self
  end,
  getElementsByClassName = function(className)
    return table.filter(Elements,function(v)
      return v.class == className
    end)
  end,
  appendChild = function(self,_element)
      _element.parent = self
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
  mouse_click = function(self,event)
    self.focused = false
    local left,top,right,bottom = self:getBounds()
    local x = event[3]
    local y = event[4]
    if x > left - 1 and x < right + 1 and y > top - 1 and y < bottom + 1 then   
      self.focused = true
      if self.onClick and focusedElement == false then
            self:setFocus(event)
            self:onClick(event)
        end
        focusedElement = true
      end
  end,
  -- Return the Bounding Box that will be rendered for the element
  getBounds = function(self)

    local offsetLeft = 1
    local offsetTop = 1
    if self.parent then
      offsetLeft = self.parent.offsetLeft + self.parent.style.marginLeft + self.parent.style.left + self.parent.style.paddingLeft - 1
      offsetTop = self.parent.offsetTop + self.parent.style.marginTop + self.parent.style.top + self.parent.style.paddingTop
    end
    local style = self.style
    -- update the sides to include position, and margins
    offsetLeft = offsetLeft + style.left + style.marginLeft 
    offsetTop = offsetTop + style.top + style.marginTop
    offsetRight = offsetLeft + style.width + style.paddingLeft + style.paddingRight
    offsetBottom = offsetTop +  style.height + style.paddingTop + style.paddingBottom - 1

    self.offsetLeft = offsetLeft
    self.offsetTop = offsetTop
    -- for k,v in pairs(utils.table.filter(self.children,function(t)return t.style.display ~= "none";end)) do
    --      pleft,pTop,pRight,pBottom = v:getBounds()
    --      offsetRight = math.max(offsetRight, pRight + style.paddingRight)
    --      offsetBottom = math.max(offsetBottom, pBottom + style.paddingBottom)
    -- end 
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
          ccraft.paintutils.drawFilledBox(left,top,right,bottom,self.style.backgroundColor)
        else
          if self.parent then
            self.style.backgroundColor = self.parent.style.backgroundColor
          end
        end
        if self.content then
          ccraft.term.setBackgroundColor(self.style.backgroundColor)
          ccraft.term.setTextColor(color)      
          ccraft.term.setCursorPos(left + style.paddingLeft+1,top + style.paddingTop)
          ccraft.term.write(self.content)
          ccraft.term.setCursorPos(10,10)
        end;
        for k,v in ipairs(self.children) do
          v:render()
        end
    end
  end
  })

  Element.root = false
  Element.div = class({
    constructor = function(self,props,content)
      self.super.constructor(self,"div",props,content)
    end
  },Element)
  
  Element.button = class({
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
      Element.root:render()
      event = {os.pullEvent()}
      EventLoop(event)
    end
  end
  Element.attachRoot = function(child)
    Element.root = child
    Element.startEventLoop()
  end
  return Element
end)()







