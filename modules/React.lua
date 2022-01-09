local cc = require "modules/CC"
local class = require "modules/class"
local Element = require "modules/Element"
local utils = require "modules/Utils"

local React = {}
local rootComponent = function()end
local rootElement = {}
local hookStorage = {}
local refStorage = {}
local hookIndex = 1
local virtualDom = {}
local function renderElement(c)
  local child = nil
  local el = Element[c.tag](c.props,"")
  el.children = {}
  if type(c.props.children) ~= "table" then
    el.content = c.props.children
  else
    if c.props.children.style then
      el:appendChild(c.props.children)
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
  local function setState(newVal)
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

React.createElement = class({
  constructor = function(self,tag,props,key,ref)
    self.tag = tag
    self.props = props
    self.props.children = props.children or {}
    self.key = key
    self.ref = ref
  end
}).new

return React