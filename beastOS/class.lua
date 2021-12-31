class = function(newClass,parentClass)
    local tmp = {}
    newClass.__index = newClass
    tmp.__index = tmp
    setmetatable(tmp,newClass)
    tmp.new = function(...)
        local instance = {}
        if parentClass ~=nil then
            instance.super = parentClass.constructor   
        end
        setmetatable(instance,tmp)
        instance:constructor(...)
        return instance
    end
    return tmp
end