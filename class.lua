class = function(newClass,parentClass)
    newClass.__index = newClass
    local hasConstructor = newClass.constructor ~= nil
    if parentClass ~=nil then 
        setmetatable(newClass,parentClass)
        newClass.super = parentClass
    end
    newClass.new = function(...)
        local instance = {}
        setmetatable(instance,newClass)
        if hasConstructor == true then
            instance:constructor(...)
        end;
        return instance
    end
    return newClass
end