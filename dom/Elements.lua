os.loadAPI("/class.lua") class = class.class
os.loadAPI("/dom/Element.lua") 
startEventLoop = Element.startEventLoop
Element = Element.Element

local DivElement = class({
    constructor = function(self,data)
        self.super:constructor(data)
    end;
},Element)

Div = function(data)
    data.type = "Div"
    return Element.new(data)
end

local ButtonElement = class({
    constructor = function(self,data)
        self.super:constructor(data)
    end;
},Element)

Button = function(data)
    data.type = "button"
    return Element.new(data)
end