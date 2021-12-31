os.loadAPI("/class.lua"); class = class.class
os.loadAPI("/dom/Element.lua"); Element = Element.Element

local DivElement = class({
    constructor = function(self,data)
        self.super:constructor(data)
    end;
},Element)

Div = function(data)
    data.type = "Div"
    return Element.new(data)
end