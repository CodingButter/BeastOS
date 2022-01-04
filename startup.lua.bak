os.loadAPI("./Element.lua") 
Style = Element.Style
ccraft = Element.ccraft
Element = Element.Element


WIDTH,HEIGHT = ccraft.term.getSize()

root = Element.createElement("div",{
    id = "Full Page",
    style = Style.new({
        width = WIDTH,
        height = HEIGHT,
        backgroundColor = ccraft.colors.blue,
    })
})
taskbar = Element.createElement("div",{
    id = "taskbar",
    style = Style.new({
        height = 1,
        width = WIDTH,
        backgroundColor = ccraft.colors.red
    })
})

beastOs = Element.createElement("div",{
    style = Style.new({
        paddingRight = 1,
        left = WIDTH - 8,
        height = 1,
        width = 8,
        color = ccraft.colors.lightBlue
    }),
    content = "BeastOs"
})

dropdown = Element.createElement("div",{
    style = Style.new({
        width = 11,
        height = 2,
        left = 1,
        top = 1,
        display = 'none',
        backgroundColor = "transparent",
        color = ccraft.colors.white
    })
})

startBtn = Element.createElement("button",{
    style = Style.new({
        width = 7,
        height = 1,
        left = 1,
        backgroundColor = ccraft.colors.lightGray
    }),
    onClick = function(self,event)
        if dropdown.style.display=="block" then
            dropdown.style.display = "none"
        else
            dropdown.style.display = "block"
        end
    end,
    content = "[start]"
})

ccraft.term.setCursorPos(1,14)
for i=0,4,1 do
    local btn = Element.createElement("button",{
        style = Style.new({
            top = (i*2) -1,
            width = 9,
            height = 1,
            paddingLeft = 1,
            paddingRight = 1,
            paddingTop = 1,
            color = ccraft.colors.white,
            backgroundColor = ccraft.colors.brown,
            focusedBackgroundColor = ccraft.colors.purple
        }),
        class = "item",
        content = "Button " .. i+1,
    })
    if i==4 then btn.style.paddingBottom = 1 end
    dropdown.style.height = dropdown.style.height + 1
    dropdown:appendChild(btn)
end
taskbar:appendChild(startBtn)
taskbar:appendChild(beastOs)
root:appendChild(dropdown)
root:appendChild(taskbar)
Element.attachRoot(root)