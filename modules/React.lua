local class = require "modules.class"
local Element = require "modules.Element"
local utils = require "modules.Utils"
local WIDTH, HEIGHT = term.getSize()

local rootComponent = nil
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
    end
    hookIndex = hookIndex + 1
    return state, setState
end

local function useRef(val)
    local state = useState({
        current = val
    })
    return state
end

local function useReducer(_reducer, initVal)
    local state, setState = useState(initVal)
    local function dispatch(action)
        setState(_reducer(state, action))
    end
    return state, dispatch
end

local function createContext(val)
    local index = #contextStorage + 1
    contextStorage[index] = val
    return {
        index = index,
        Provider = function(self, props)
            contextStorage[index] = props.value
            return props.children
        end
    }
end

local function useContext(context)
    return contextStorage[context.index]
end

local function useEffect(cb, depArray)
    local oldDeps = hookStorage[hookIndex]
    local hasChanged = false

    if oldDeps then
        hasChanged = utils.table.is(depArray, oldDeps) == false
    end
    if hasChanged then
        cb()
    end
    hookStorage[hookIndex] = depArray
end

local function renderComponent(el)

    local children = el.children
    if children.type == "Element" then
        el:appendChild(children)
    elseif type(children) == "function" then
        el:appendChild(children())
    else

        for _, child in pairs(children) do
            if type(child) == "function" then
                child = renderComponent(child())
            end
            el:appendChild(child)
        end
    end
    return el
end

local function render()
    hookIndex = 1
    local el = rootComponent()
    rootElement.children = {}
    rootElement:appendChild(el)
    utils.window.setVisible(false)
    rootElement:render()
    utils.window.setVisible(true)
end

local function startWorkLoop()

    local speed = .5
    for i = 1, 0, -speed do
        render()
        os.startTimer(1)
        sleep(speed)
    end
    while true do
        local event = {os.pullEvent()}
        Element.triggerEvent(event)
        if event[1] == "timer" then
            render()
            os.startTimer(1)
        end
        if event[1] == "term_resize" then
            local WIDTH, HEIGHT = term.getSize()
            utils.window.reposition(0, 0, WIDTH, HEIGHT)
        end

    end
end

local function renderDom(component, re)
    rootElement = re
    rootComponent = component
    Element.attachRoot(rootElement)
    startWorkLoop()
end

local createElement = function(tag, props, key, ref)
    props.children = props.children or {}
    return {
        type = "ReactElement",
        tag = tag,
        props = props,
        key = key,
        ref = ref
    }
end
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
