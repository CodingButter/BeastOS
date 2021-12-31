os.loadAPI("/disk/beastOS/class.lua"); class = class.class;
UIElements = {}
UIElement = class({
    x = 1;
    y = 1;
    bgColor = colors.lime;
    clickedBG = colors.blue;
    textColor = colors.black;
    clickedTextColor = colors.green;
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
    render = function(self)
        local label = self.label;
        local textColor = self.textColor
        if self.isClicked then 
            label = self.clickedLabel 
            textColor = self.clickedTextColor
            bgColor = self.
        end;
        paintutils.drawFilledBox(self.x,self.y,self.x + #label + (self.paddingX * 2) - 1,self.y + self.paddingY ,color)
        term.setCursorPos(self.x+self.paddingX,self.y + self.paddingY/2)
        term.write(label)
    end;
    onClick = function(self) self.isClicked = true end;
})
Button.getButtons = function()
    return Buttons
end
