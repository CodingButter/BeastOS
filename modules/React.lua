local class = require "modules/class"
local Element = require "modules/Element"
local utils = require "modules/Utils"
local WIDTH,HEIGHT = term.getSize()

local rootComponent = function()end
local rootElement = {}
local hookStorage = {}
local contextStorage = {}
local hookIndex = 1

local function useState(initState)
  local state = hookStorage[hookIndex] or initState
  hookStorage[hookIndex] = state
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

local function useRef(val)
  local state = useState({current = val})
  return state
end

local function useReducer(_reducer,initVal)
  local state,setState = useState(initVal)
  local function dispatch(action)
      setState(_reducer(state,action))
  end
  return state,dispatch
end

local function createContext(val)
  local index = #contextStorage + 1
  contextStorage[index] = val
  return {
    index = index,
    Provider = function(self,props)
      contextStorage[index] = props.value
      return props.children
    end
  }
end

local function useContext(context)
  return contextStorage[context.index]
end


local function useEffect(cb,depArray)
  local oldDeps = hookStorage[hookIndex]
  local hasChanged = false
  
  if oldDeps then
    hasChanged = utils.table.is(depArray,oldDeps) == false
  end
  if hasChanged then cb() end
  hookStorage[hookIndex] = depArray
end

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

local function render(c)
  hookIndex = 1
  return renderElement(c())
end

local function rerender()
  local WIDTH,HEIGHT = term.getSize()
  
  local el = render(rootComponent)
    rootElement.children = {}
    rootElement:appendChild(el)
    utils.window.setVisible(false)
    rootElement:render()
    utils.window.setVisible(true)
end

local function startWorkLoop()
  local speed = 1
  for i=1,0,-speed do
    rerender()
    os.startTimer(1)
    sleep(speed)
  end
  while true do
    event = {os.pullEvent()}
    rerender()
    Element.triggerEvent(event)
    if event[1] == "timer" then
      timer = os.startTimer(1)
    end
    if event[1] == "term_resize" then
      local WIDTH,HEIGHT = term.getSize()
      utils.window.reposition(0, 0 , WIDTH, HEIGHT)
    end
  end
end

local function renderDom(component,re,norender) 
  rootElement = re
  rootComponent = component
  local element = render(rootComponent)
  rootElement:appendChild(element)
  rootElement:render()
  if norender then return end
  Element.attachRoot(rootElement)
  startWorkLoop()
end

local createElement = class({
  constructor = function(self,tag,props,key,ref)
    self.tag = tag
    self.props = props
    self.props.children = props.children or {}
    self.key = key
    self.ref = ref
  end
}).new

return {
  useState = useState,
  useRef = useRef,
  useReducer = useReducer,
  createContext = createContext,
  useContext = useContext,
  useEffect = useEffect,
  renderDom = renderDom,
  createElement = createElement
}