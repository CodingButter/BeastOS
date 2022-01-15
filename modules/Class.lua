local utils = require "modules/Utils"

local class = function(newClass, parentClass)
    local hasConstructor = newClass.constructor ~= nil
    if parentClass ~= nil then
        setmetatable(newClass, {
            __index = parentClass
        })
        newClass.super = parentClass
    end
    function newClass:new(args)
        local instance = {}
        setmetatable(instance, {
            __index = self
        })
        if hasConstructor == true then
            instance:constructor(args)
        end
        return instance
    end
    return newClass
end

return class
