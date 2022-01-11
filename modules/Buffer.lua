---------------------------------------------------------------------
local tFrameBufferMetatable = { __index = getfenv() }
---------------------------------------------------------------------
function getTextColor(self)
    return 2 ^ tonumber(self.sTextColor, 16)
end
getTextColour = getTextColor
---------------------------------------------------------------------
function getBackgroundColor(self)
    return 2 ^ tonumber(self.sBackColor, 16)
end
getBackgroundColour = getBackgroundColor
---------------------------------------------------------------------
function getSize (self)
    return self.nWidth, self.nHeight, self
end
---------------------------------------------------------------------
function getCursorPos (self)
    return self.nCursorX, self.nCursorY, self
end
---------------------------------------------------------------------
function setCursorPos (self, x, y)
    self.nCursorX = math.floor (x) or self.nCursorX
    self.nCursorY = math.floor (y) or self.nCursorY

    return self
end
---------------------------------------------------------------------
function isColor (self)
    return self.tTerm.isColor(), self
end
---------------------------------------------------------------------
function setTextColor (self, nTextColor)
    self.sTextColor = string.format ("%x", math.log (nTextColor) / math.log (2)) or self.sTextColor
    return self
end
---------------------------------------------------------------------
function setBackgroundColor (self, nBackColor)
    self.sBackColor = string.format ("%x", math.log (nBackColor) / math.log (2)) or self.sBackColor
    return self
end
---------------------------------------------------------------------
function setCursorBlink (self, bCursorBlink)
    self.bCursorBlink = bCursorBlink
    return self
end
---------------------------------------------------------------------
isColour            = isColor
setTextColour       = setTextColor
setBackgroundColour = setBackgroundColor
---------------------------------------------------------------------
function clearLine (self, nLineNumber)
    nLineNumber = nLineNumber or self.nCursorY

    if nLineNumber >= 1 and nLineNumber <= self.nHeight then
        self.tText[nLineNumber]       = (" "):rep (self.nWidth)
        self.tTextColors[nLineNumber] = self.sTextColor:rep (self.nWidth)
        self.tBackColors[nLineNumber] = self.sBackColor:rep (self.nWidth)
    end
end
---------------------------------------------------------------------
function clear (self)
    for nLineNumber = 1, self.nHeight do
        self:clearLine (nLineNumber)
    end
    
    if not self.tRedirectthen then
        self.tRedirect = {}

        for sFunctionName, _ in pairs (self.tTerm) do
            self.tRedirect[sFunctionName] = function (...)
                return self[sFunctionName] (self, ...)
            end
        end
    end

    return self
end
---------------------------------------------------------------------
function scroll (self, nTimesToScroll)
    for nTimesScrolled = 1, math.abs (nTimesToScroll) do
        if nTimesToScroll > 0 then
            for nLineNumber = 1, self.nHeight do
                self.tText[nLineNumber]       = self.tText[nLineNumber + 1] or string.rep (" ", self.nWidth)
                self.tTextColors[nLineNumber] = self.tTextColors[nLineNumber + 1] or string.rep (self.sTextColor, self.nWidth)
                self.tBackColors[nLineNumber] = self.tBackColors[nLineNumber + 1] or string.rep (self.sBackColor, self.nWidth)
            end
        else
            for nLineNumber = self.nHeight, 1, -1 do
                self.tText[nLineNumber]       = self.tText[nLineNumber - 1] or string.rep (" ", self.nWidth)
                self.tTextColors[nLineNumber] = self.tTextColors[nLineNumber - 1] or string.rep (self.sTextColor, self.nWidth)
                self.tBackColors[nLineNumber] = self.tBackColors[nLineNumber - 1] or string.rep (self.sBackColor, self.nWidth)
            end
        end
    end
end
---------------------------------------------------------------------
function write (self, sText)
    return self:blit(sText, string.rep(self.sTextColor, sText:len()), string.rep(self.sBackColor, sText:len()))
end
---------------------------------------------------------------------
function blit(self, sText, sTextColors, sBackColors)
    local nCursorX, nCursorY = self.nCursorX, self.nCursorY
    
    if nCursorY >= 1 and nCursorY <= self.nHeight then
        sText = tostring(sText):gsub("\t", " "):gsub("%c", "?")
        
        local nStartX, nStopX = nCursorX, nCursorX + sText:len()
        
        if nCursorX + sText:len() < 1 or nCursorX > self.nWidth then
            self.nCursorX = self.nCursorX + sText:len()
            return self
        end
        
        if nCursorX + sText:len() > self.nWidth + 1 then
            sText = sText:sub(1, self.nWidth - nCursorX + 1)
            sTextColors = sTextColors:sub(1, self.nWidth - nCursorX + 1)
            sBackColors = sBackColors:sub(1, self.nWidth - nCursorX + 1)
            
            nStopX = self.nWidth
        end
        if nCursorX < 1 then
            sText = sText:sub(2 + math.abs(nCursorX))
            sTextColors = sTextColors:sub(2 + math.abs(nCursorX))
            sBackColors = sBackColors:sub(2 + math.abs(nCursorX))
            
            nStartX = 1
        end
        
        local sTextLine = self.tText[nCursorY]
        local sTextColorLine = self.tTextColors[nCursorY]
        local sBackColorLine = self.tBackColors[nCursorY]
        
        sTextLine = sTextLine:sub(1, nStartX - 1) .. sText .. sTextLine:sub(nStopX + 1)
        sTextColorLine = sTextColorLine:sub(1, nStartX - 1) .. sTextColors .. sTextColorLine:sub(nStopX + 1)
        sBackColorLine = sBackColorLine:sub(1, nStartX - 1) .. sBackColors .. sBackColorLine:sub(nStopX + 1)
        
        self.tText[nCursorY] = sTextLine
        self.tTextColors[nCursorY] = sTextColorLine
        self.tBackColors[nCursorY] = sBackColorLine
    end
    
    self.nCursorX = self.nCursorX + sText:len()
end
---------------------------------------------------------------------
function render(self)
    local redirect     = term.redirect
    local tCurrentTerm = redirect(self.tTerm)

    local blit         = term.blit
    local setCursorPos = term.setCursorPos

    local tText       = self.tText
    local tTextColors = self.tTextColors
    local tBackColors = self.tBackColors

    local x = self.x
    local y = self.y

    for nLine = 1, self.nHeight do
        setCursorPos(x, nLine + y - 1)
        blit(tText[nLine], tTextColors[nLine], tBackColors[nLine])
    end

    local tonumber = tonumber

    term.setTextColor(2 ^ tonumber(self.sTextColor, 16))
    term.setBackgroundColor(2 ^ tonumber(self.sBackColor, 16))
    term.setCursorBlink(self.bCursorBlink)

    setCursorPos(self.nCursorX + x - 1, self.nCursorY + y - 1)
    redirect(tCurrentTerm)

    return self, false
end
---------------------------------------------------------------------
function new (nWidth, nHeight, x, y, tCurrentTerm)
    return setmetatable (
        {
            nWidth  = nWidth,
            nHeight = nHeight,

            tRedirect = false,

            x = x,
            y = y,

            tTerm = tCurrentTerm or term.current(),

            nCursorX = 1,
            nCursorY = 1,

            sTextColor = "0",
            sBackColor = "f",

            tText       = {},
            tTextColors = {},
            tBackColors = {},

            bCursorBlink = false
        }
    , tFrameBufferMetatable):clear()
end
---------------------------------------------------------------------
function redirect (self)
    return self.tRedirect
end