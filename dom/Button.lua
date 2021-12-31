os.loadAPI("/class.lua"); class = class.class
os.loadAPI("/dom/Element.lua"); Element = Element.Element

local ButtonElement = class({
    constructor = function(self,data)
        self.super:constructor(data)
    end;
},Element)

Button = function(data)
    data.type = "button"
    return Element.new(data)
end