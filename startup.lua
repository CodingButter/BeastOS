os.loadAPI("/Library.lua")
Element = Library.Element
cc = Library.ccraft
utils = Library.utils
Style = Library.Style
React = Library.React
RenderDom = React.renderDom
e = React.Element.new

WIDTH, HEIGHT = cc.term.getSize()
root = Element.createElement("div",{
    style = Style.new({
    width = WIDTH,
    height = HEIGHT,
    backgroundColor = cc.colors.blue
    })
})

--[[ Desktop Component ]]

BeastOs = function(props)
    return Element.button.new(
    {
        id="beastos",
        style = Style.new({
            paddingRight = 1,
            left = WIDTH - 8,
            height = 1,
            width = 8,
            color = cc.colors.lightBlue
        }), 
        onClick = function(self,event)
            props.setText("another")
        end,
        content = "beast"
    })
end

StartBtn = function(props)
    return Element.button.new({
        id = "startBtn",
        style = Style.new({
            width = 7,
            height = 2,
            left = 1,
            backgroundColor = cc.colors.lightGray
        }),
        onClick = function(self,event)
            props.setText("update")
        end,
        content = props.text
    })
end
TaskBar = function(props)

    local taskBarStyle = Style.new({
        height = 1,
        width = WIDTH,
        backgroundColor = cc.colors.red,
        textColor = cc.colors.black
    })
    return e("div",{
        id = "taskbar",
        style = taskBarStyle,
        children = {StartBtn({text = props.text,setText = props.setText}),BeastOs({text = props.text,setText = props.setText})}
    })
end
App = function()
    local text,setText = React.useState("[start]")
    local secondText,setSecondText = React.useState("[anotherone]")
    local renderCount = React.useRef(1)
    React.useEffect(function()
       renderCount.current = renderCount.current + 1
    end,{text})

    return TaskBar({
        secondText = secondText,
        setSecondText = setSecondText,
        text = text .. renderCount.current,
        setText = setText
    })
end

RenderDom(App,root)