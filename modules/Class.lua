local utils = require "modules/Utils"

local class =  function(newClass,parentClass)
    newClass.__index = newClass
    local hasConstructor = newClass.constructor ~= nil
    if parentClass ~=nil then 
        setmetatable(newClass,parentClass)
        newClass.super = parentClass
    end
    newClass.new = function(...)
        local instance = {}
        setmetatable(instance,utils.table.copy(newClass))
        if hasConstructor == true then
            instance:constructor(...)
        end;
        return instance
    end
    return newClass
end

return class