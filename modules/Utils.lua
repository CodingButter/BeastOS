local pretty = require "cc.pretty"
local Utils = {}
Utils.switch = function(val,actions)
   local action = actions[val] or actions.default or function() end
   return action()
end
Utils.colors = {}
Utils.colors.getCharOf = function( colour )
   if type(colour) == "number" then
       local value = math.floor( math.log(colour) / math.log(2) ) + 1
       if value >= 1 and value <= 16 then
           local ret string.sub( "0123456789abcdef", value, value )
           return ret
       end
   end
   return " "
end  
Utils.table = {}
Utils.table.copy = function(orig, copies,lvl)
   lvl = lvl or 0
   copies = copies or {}
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      if copies[orig] then
         copy = copies[orig]
      else
         copy = {}
         copies[orig] = copy
         for orig_key, orig_value in next, orig, nil do
               if lvl<2 then
               copy[Utils.table.copy(orig_key, copies,lvl+1)] = Utils.table.copy(orig_value, copies,lvl+1)
               else
                  copy[orig_key] = orig_value
               end
         end
         setmetatable(copy, Utils.table.copy(getmetatable(orig), copies))
      end
   else 
      copy = orig
   end
   return copy
end
Utils.table.map = function(_tbl, f)
   local t = {}
   local i = 1
   if type(_tbl)=="table" then
      for k,v in pairs(_tbl) do
            t[i] = f(v,i,k)
            i = i + 1
      end
   end
   return t
end

Utils.table.filter = function(_tbl,f)
   
   local t = {}
   local i = 1
   for k,v in pairs(_tbl) do
         if f(v,i,k) then t[i] = v; end
         i = i + 1
   end
   return t
end

Utils.table.is = function(table1, table2)
   local function recurse(t1, t2)
      if type(t1) ~= type(t2) then return false end
      for key,val in pairs(t1) do
            if t2[key] == nil then return false end
            if type(t1[key]) == "table" then recurse(t1[key],t2[key]) end
            if type(t1[key]) ~= type(t2[key]) then return false end
            if t1 ~= t2 then return false end         
      end
      return true
   end
   return recurse(table1, table2)
end

local function deepen(str, r)
   return (" "):rep(r) .. str
end

local function basicSerial(value, depth)
depth = depth or 0
if type(value) == "table" then
   local s = deepen("{\n", depth)
   for k, v in pairs(value) do
      s = s ..  deepen("[" .. basicSerial(k, 0) .. "] = " .. basicSerial(v, depth + 2), depth + 2) .. "\n"
   end
   return s .. deepen("}", depth)
elseif type(value) == "string" then
   return '"' .. value .. '"'
elseif type(value) == "function" then
   return "function"
end
   return tostring(value)
end

Utils.table.serialize = basicSerial

Utils.table.save = function(data, filename)
   local h = io.open(filename, 'w')
   h:write(basicSerial(data))
   h:close()
 end

Utils.debugger = peripheral.find "debugger" or term
Utils.debugger.debugPrint = function(obj)
   Utils.debugger.print(Utils.table.serialize(obj))
end
local WIDTH,HEIGHT = term.getSize()
Utils.window = window.create(term.current(),1,1,WIDTH,HEIGHT,true)
return Utils
