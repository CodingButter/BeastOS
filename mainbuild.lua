
    -- [[ ./modules/CC ]]

    cc =  (function()
	return {
		term = term, 
		colors = colors,
		paintutils = paintutils
	}
end)()

    -- [[ ./modules/Utils ]]

    
utils = (function()
   local Utils = {}
      -- Save copied tables in `copies`, indexed by original table.
   local tbl = {}
      tbl.copy = function(orig, copies,lvl)
        lvl = lvl or 0
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
                   if lvl<2 then
                     copy[tbl.copy(orig_key, copies,lvl+1)] = tbl.copy(orig_value, copies,lvl+1)
                   else
                       copy[orig_key] = orig_value
                   end
               end
               setmetatable(copy, tbl.copy(getmetatable(orig), copies))
            end
         else -- number, string, boolean, etc
            copy = orig
         end
         return copy
      end
      tbl.map = function(tbl, f)
         local t = {}
         for k,v in pairs(tbl) do
               t[k] = f(v,k)
         end
         return t
      end
   
      tbl.filter = function(tbl,f)
         local t = {}
         for k,v in pairs(tbl) do
               if f(v,k) then t[k] = v; end
         end
         return t
      end
   
   --Compare tables
   
   tbl.is = function(table1, table2)
      local function recurse(t1, t2)
         if type(t1) ~= type(t2) then return false end
         for key,val in pairs(t1) do
               if t2[key] == nil then return false end
               if type(t1[key]) == "table" then recurse(t1[key],t2[key]) end
               if type(t1[key]) ~= type(t2[key]) then return false end
               if t1 ~= t2 then return false end         
         end
         return true
      end
      return recurse(table1, table2)
   end
   
   local function exportstring( s )
         return string.format("%q", s)
      end

      --// The Save Function
   tbl.save = function(  tbl,filename )
      local charS,charE = "   ","\n"
      local file,err = io.open( filename, "wb" )
      if err then return err end

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      file:write( "return {"..charE )

      for idx,t in ipairs( tables ) do
         file:write( "-- Table: {"..idx.."}"..charE )
         file:write( "{"..charE )
         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
               file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
               file:write(  charS..tostring( v )..","..charE )
            end
         end

         for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
               if stype == "table" then
                  if not lookup[i] then
                     table.insert( tables,i )
                     lookup[i] = #tables
                  end
                  str = charS.."[{"..lookup[i].."}]="
               elseif stype == "string" then
                  str = charS.."["..exportstring( i ).."]="
               elseif stype == "number" then
                  str = charS.."["..tostring( i ).."]="
               end
            
               if str ~= "" then
                  stype = type( v )
                  -- handle value
                  if stype == "table" then
                     if not lookup[v] then
                        table.insert( tables,v )
                        lookup[v] = #tables
                     end
                     file:write( str.."{"..lookup[v].."},"..charE )
                  elseif stype == "string" then
                     file:write( str..exportstring( v )..","..charE )
                  elseif stype == "number" then
                     file:write( str..tostring( v )..","..charE )
                  end
               end
            end
         end
         file:write( "},"..charE )
      end
      file:write( "}" )
      file:close()
   end
   Utils.table = tbl
   return Utils
end)()


    -- [[ ./modules/Class ]]

    -- require("/disk/modules/Utils")

class = (function()
    return function(newClass,parentClass)
        newClass.__index = newClass
        local hasConstructor = newClass.constructor ~= nil
        if parentClass ~=nil then 
            setmetatable(newClass,parentClass)
            newClass.super = parentClass
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


    -- [[ ./modules/Style ]]

    -- require("/disk/modules/Class")
-- require("/disk/modules/CC")

Style = (function()
  return class({
    zIndex = 1,
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
    color = cc.colors.black,
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
end)()

    -- [[ ./modules/Element ]]

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


    -- [[ ./modules/React ]]

    -- require("/disk/modules/Element")
-- require("/disk/modules/Utils")

React = (function()
  local React = {}
  local rootComponent = function()end
  local rootElement = {}
  local hookStorage = {}
  local refStorage = {}
  local hookIndex = 1
  local virtualDom = {}
  local renderElement = function(c)
    local child = nil
    el = Element[c.tag](c.props,"")
    el.children = {}
    if type(c.props.children) ~= "table" then
      el.content = c.props.children
    else
      for _,v in ipairs(c.props.children) do
        if v.props then
          child = renderElement(v)
        else
          child = v
        end
        el:appendChild(child)
      end      
    end
    return el
  end

  local render = function(c)
    hookIndex = 1
    Element.Elements = {rootElement}
    comp = renderElement(c())
    return comp
  end

  local rerender = function()
    cc.term.setBackgroundColor(cc.colors.black)
    local el = render(rootComponent)
    if utils.table.is(el,virtualDom) == false then
      rootElement.children = {}
        rootElement:appendChild(el)
        rootElement:render()
        virtualDom = el
    end
  end

  React.useState = function(startState)
    local state = hookStorage[hookIndex] or startState
    local frozenIndex = hookIndex
    local setState = function(newVal)
      if type(newVal) == "function" then
        newVal = newVal(hookStorage[frozenIndex])
      end
      hookStorage[frozenIndex] = newVal
      return newVal
    end
    hookIndex = hookIndex + 1
    return state,setState
  end

  React.useRef = function(val)
    local state = useState({current = val})
    return state
  end

  React.createContext = function(val)
    local frozenIndex = hookIndex
    local state,setState = React.useState(val)
    return {
      index = frozenIndex,
      Provider = function(self,props)
        self.updater = props.updater
        setState(props.value)
        return props.children
      end
    }
  end

  React.useContext = function(context) 
    local value = hookStorage[context.index]
    return value
  end

  React.setContext = function(context)
    return context.updater
  end

  React.useEffect = function(cb,depArray)
    local oldDeps = hookStorage[hookIndex]
    local hasChanged = false
    
    if oldDeps then
      hasChanged = utils.table.is(depArray,oldDeps) == false
    end
    if hasChanged then cb() end
    hookStorage[hookIndex] = depArray
  end

  local clock = os.clock
  function sleep(n)  -- seconds
    local t0 = clock()
    while clock() - t0 <= n do
    end
  end

  local startWorkLoop = function()
      local speed = .5
    for i=1,0,-speed do
      os.startTimer(1)
      sleep(speed)
    end
    while true do
      event = {os.pullEvent()}
      Element.triggerEvent(event)
      rerender()
      if event[1] == "timer" then
        timer = os.startTimer(1)
      end
    end
    end
    
  React.renderDom = function(component,re,norender) 
    rootElement = re
    rootComponent = component
    local element = render(rootComponent)
    rootElement:appendChild(element)
    rootElement:render()
    if norender then return end
    startWorkLoop()
    Element.attachRoot(rootElement)
  end

  React.Element = class({
    constructor = function(self,tag,props,key,ref)
      self.tag = tag
      self.props = props
      self.key = key
      self.ref = ref
    end
  })
  return React
end)()

    -- [[ ./src/context/UserContext ]]

    -- require("/disk/modules/React")

UserContext = React.createContext(nil)

    -- [[ ./src/components/TaskBar/StartButton ]]

    -- require("/disk/modules/CC")
-- require("/disk/modules/React")
-- require("/disk/modules/Element")
-- require("/disk/src/context/UserContext")

StartButton = function(props)
    local name = React.useContext(UserContext)
    local setUser = React.setContext(UserContext)
    return  Element.createElement("button",{
        id = "startBtn",
        style = {
            width = 7,
            height = 1,
            left = 1,
            backgroundColor = cc.colors.lightGray,
            focusedBackgroundColor = cc.colors.lime
        },
        onClick = function(self,event)
            props.toggleMenu()
        end,
    },name)
end


    -- [[ ./src/components/TaskBar/BeastOs ]]

    -- require("/disk/modules/CC")
-- require("/disk/modules/Element")
-- require("/disk/src/context/UserContext")

BeastOs = function(props)
    setUserName = React.setContext(UserContext)
    return Element.button(
    {
        id="beastos",
        style = {
            paddingRight = 1,
            left = WIDTH - 8,
            height = 1,
            width = 8,
            color = cc.colors.lightBlue
        }, 
        onClick = function(self,event)
            setUserName("garry")
        end,
        content = "beast"
    })
end

    -- [[ ./src/components/TaskBar/StartMenu ]]

    -- require("/disk/modules/CC")
-- require("/disk/modules/React")
-- require("/disk/modules/Element")
-- require("/disk/src/context/UserContext")

StartMenu = function(props)

    local buttons = {
        Element.button({
            top = 0,
            width = 12,
            height = 1
        },"Settings")
    }

    return  Element.div({
        id = "startmenu",
        style = {
            width = 12,
            height = 5,
            left = 0,
            top = -5,
            backgroundColor = cc.colors.lightGray
        },
        onClick = function(self,event)
        end,
        children = buttons
    })
end


    -- [[ ./src/components/TaskBar/TaskBar ]]

    -- require("/disk/modules/React")
-- require("/disk/src/components/TaskBar/StartButton")
-- require("/disk/src/components/TaskBar/BeastOs")
-- require("/disk/src/components/TaskBar/StartMenu")

e = React.Element.new

TaskBar = function(props)
    local menu,updateMenu = React.useState(false)

    local function toggleMenu()
        updateMenu(function(val)
            return val == false
        end)
    end

    local element =  e("div",{
        id = "taskbar",
        style = {
            height = 1,
            width = WIDTH,
            top = HEIGHT - 1,
            backgroundColor = cc.colors.red,
            textColor = cc.colors.black
        },
        children = {}
    })

    table.insert(element.props.children,StartButton({
        toggleMenu = toggleMenu
    }))
    if menu then table.insert(element.props.children,StartMenu()) end
    table.insert(element.props.children,BeastOs())

    return element
end


    -- [[ ./src/App ]]

    -- require("/disk/modules/React")
-- require("/disk/src/components/TaskBar/TaskBar")
-- require("/disk/src/context/UserContext")

App = function()
    local user,setUser = React.useState("bob")
    return UserContext:Provider({
        value=user,
        updater=setUser,
        children = TaskBar({setUser=setUser})
    })
end

    -- [[ Main ]]

    -- require("/disk/modules/CC")
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