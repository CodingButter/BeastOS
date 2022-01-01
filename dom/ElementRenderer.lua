rendered = {}
root = false
render = function(element,dontClear)
    if dontClear == nil then
        term.setCursorPos(1,1)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white);
        term.clear()
    end
    if root == false then
        root = element
    end
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
rerender = function()
    render(root)
end;