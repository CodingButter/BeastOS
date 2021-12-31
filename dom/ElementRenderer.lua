rendered = {}
render = function(element,dontClear)
    if dontClear == nil then
        --term.clear()
    end;

    element:render()
    if type(element.children) == "table" then
        for _,child in ipairs(element.children) do
            if type(child) == "table" then
                    child.parent = element
                    render(child,true)
            end;
        end;
    end;
end;