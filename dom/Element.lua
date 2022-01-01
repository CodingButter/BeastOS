os.loadAPI("/class.lua") class = class.class 

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


clearFocus = function()
    for _,v in ipairs(elements) do
        v.focused = false
    end;
end;
elements = {}
Element = class({
    type = "div";
    id = "";
    className = "";
    focused = false;
    defaultStyles = {
        x = 1;
        y = 1;
        width = 1;
        height = 1;
        bgColor = "transparent";
        textColor = "white";
        position = "relative";
        paddingX = 1;
        paddingY = 1;
        marginX = 0;
        marginY = 0;
        padding = function(self,p)
             self.paddingX = p
             self.paddingY = p
        end;
        margin = function(self,m)
             self.marginX = m
             self.marginY = m
        end;
        display = "block";
        textAlign = "center";
    };
    constructor = function(self,data)
        self.type = data.type
        self.id = data.id
        self.className = data.id
        self.style = {}
        self.children = data.children
      
        for k,v in pairs(self.defaultStyles) do
            self.style[k] = v;
            if data.style and data.style[k] then
                self.style[k] = data.style[k]
            end;
        end;
        if type(data.children) == "table" then
            for k,v in pairs(data.children) do
                self.children[k] = v
            end;
        end;
        if data.onClick then
            self.onClick = data.onClick
        end
        elements[#elements + 1] = self
    end;
    onClick = function(self)
        self.focused = true
    end;
    getComputedWidth = function(self)
        local width = self.style.width;
        width = math.max(width,#self.children)
        if type(self.children) == "table" then
            for _,v in pairs(self.children) do
                width = math.max(width,v:getComputedWidth())
            end;
        end
       
        return width + self.style.paddingX * 2 + 1
    end;
    getComputedHeight = function(self)
        return math.max(self.style.height,1 + self.style.paddingY * 2)
       
    end;
    getComputedX = function(self)
        local x = self.style.x
        if self.parent then
            x = self.style.x + self.parent.style.x
        end
        return x
    end;
    getComputedY = function(self)
        local y = self.style.y
        if self.parent then
            y = self.style.y + self.parent.style.y
        end
        return y
    end;
    getChildren = function(self)
        return self.children
    end;
    getPrevious = function(self)
        local previousChildIndex = self.childIndex - 1
        if previousChildIndex == 0 then
            return nil;
        end;
        return self.parent.children[previousChildIndex]
    end;
    getBounds = function(self)
        local computedX = self:getComputedX()
        local computedY = self:getComputedY()
        local computedWidth = self:getComputedWidth()
        local computedHeight = self:getComputedHeight()
        local x1 = computedX + self.style.marginX
        local y1 = computedY + self.style.marginY
        local x2 = x1 + computedWidth ;
        local y2 = y1 + computedHeight - 1;
        return x1,y1,x2,y2;
    end;
    render = function(self) 
        local x1,y1,x2,y2 = self:getBounds()
        if self.style.display ~= "none" then
            
            local bgColor = self.style.bgColor
           
            if bgColor == "transparent" then
                if self.parent and self.parent.style.bgColor ~= "transparent" then
                    bgColor = self.parent.style.bgColor
                end
                if self.isclicked then
                    bgColor = colors.lime
                else
                    bgColor = colors.black
                end
            end
            if self.parent and self.parent.style.display ~= "none" then
                if bgColor ~= "transparent" then 
                    term.setBackgroundColor(bgColor)
                    paintutils.drawFilledBox(x1,y1,x2,y2,bgColor)
                end;
                x1 = x1 + self.style.paddingX;
                y1 = y1 + self.style.paddingY;
                if type(self.children) == "string" or type(self.children) == "number" then
                    term.setTextColor(colors.white)
                    term.setCursorPos(x1 + self.style.paddingX, y1 )
                    term.write(self.children)
                    term.setCursorPos(1,1)
                end;
            end;
        end
        term.setCursorPos(1,1)
        
    end;
    onClick = function(self,clickFunction,event)end;
    checkClick = function(self,event)
        x = event[3]
        y = event[4]
        local x1,y1,x2,y2 = self:getBounds()
        if x > x1 - 1 and x < x2 + 1 and y > y1 -1 and y < y2 + 1 then
            for _,btn in pairs(elements) do
                if btn ~= self then
                    btn.isClicked = false;
                end;
            end;
            self.focused = true
            self.isClicked = true
            return true
        end;
        return false
    end;
})

startEventLoop = function()
    local timer = {
        index = false;
        timer = false;
    }
    while true do
        local event = {os.pullEvent()}
        if event[1] == "mouse_click" or event[1] == "monitor_click" then
            if event[3] < 3 and event[4] < 3 then 
                term.setBackgroundColor(colors.black)
                term.clear()
                error("Good Bye") 
            end;
            for k,els in pairs(elements) do
                local didClick = els:checkClick(event)
                if didClick then
                
                    els:onClick(event)
                    timer.index = k
                    timer.timer = os.startTimer(1)
                end;
            end;
        elseif event[1] == "timer" and event[2] == timer.timer then
            elements[timer.index].isClicked = false
            timer = {}
        end;
    end
end

local DivElement = class({
    constructor = function(self,data)
        self.super:constructor(data)
    end;
},Element)

Div = function(data)
    data.type = "Div"
    return DivElement.new(data)
end

local ButtonElement = class({
    constructor = function(self,data)
        self.super:constructor(data)
    end;
},Element)

Button = function(data)
    data.type = "button"
    return ButtonElement.new(data)
end