os.loadAPI("/class.lua") class = class.class
os.loadAPI("/ElementRenderer.lua") render = ElementRenderer.render

React = (function()
    local hooks = {}
    local idx = 1
    local rootComponent = {}

    function rerender()
        render(rc)
    end;

    function useState(initVal)
        local state = initVal
        if hooks[idx] ~= nil then state = hooks[idx] end
        local _idx = idx
        local setState = function(newVal)
            hooks[_idx] = newVal
            rerender()
        end;
        idx = idx + 1
        return state,setState
    end
    
    function render(C)
        idx = 1
        C = C()
        _renderer(child)
        return C
    end

    createApp = function(rc)
        rootComponent = rc
    })

    return {useState = useState,render = render}
end)()



