os.loadAPI("/disk/beastOS/class.lua"); class = class.class;
Buttons = {}
Button = class({
    x = 1;
    y = 1;
    backgroundColor = colors.lime;
    textColor = colors.black;
    label = "Button";
    clickLabel = "Clicked";
    paddingX = 1;
    paddingY = 2;
    isClicked = false;
    constructor = function(self,x,y,paddingX,paddingY,label,clickLabel)
        if x ~= nil then self.x = x end
        if y ~= nil then self.y = y end
        if label ~= nil then self.label = label end
        if clickText ~= nil then self.clickLabel = clickLabel end
        Buttons[#Buttons+1] = self;
    end;
    place = function(self)
        local label = self.label;
        if self.isClicked then label = self.clickedLabel end;
        paintutils.drawFilledBox(self.x,self.y,self.x + #label + (self.paddingX * 2) - 1,self.y + self.paddingY ,self.backgroundColor)
        term.setCursorPos(self.x+self.paddingX,self.y + self.paddingY/2)
        term.write(label)
    end;
    onClick = function(self) end;
})
Button.getButtons = function()
    return Buttons
end
