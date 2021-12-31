os.loadAPI("/dom/ElementRenderer.lua"); 
os.loadAPI("/dom/Elements.lua")
Button = Elements.Button
Div = Elements.Div
startEventLoop = Element.startEventLoop
Element = Elements.Element

term.setTextColor(colors.white)
term.setCursorPos(1,5)
term.clear()
dom = Div({
    id = "Main Button";
    style = {
        textColor = colors.black;
        x = 1;
        y = 1;
        width = 5;
        height = 6;
    };
    children = {
        Button({
            id = "nested Button 1";
            style = {
                x = 5;
                y = 4;
                width = 8;
                height = 8;
                bgColor = colors.blue;
                textColor = colors.black;
            };
            children = "Im the best button";
        }),
        Button({
            id = "nested Button 2";
            style = {
                x = 18;
                y = 14;
                width = 8;
                height = 2;
                bgColor = colors.lime;
                textColor = colors.white;
            };
            children = "Hi I am a button";
        })
    };
})


ElementRenderer.render(dom)
startEventLoop()