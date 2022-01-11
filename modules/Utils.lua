

local Utils = {}
Utils.switch = function(val,actions)
   local action = actions[val] or actions.default or function() end
   return action()
end
Utils.colors = {}
Utils.colors.getCharOf = function( colour )
   -- Incorrect values always convert to nil
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
   for k,v in pairs(_tbl) do
         t[k] = f(v,k)
   end
   return t
end

Utils.table.filter = function(_tbl,f)
   local t = {}
   for k,v in pairs(_tbl) do
         if f(v,k) then t[k] = v; end
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

local function exportstring( s )
      return string.format("%q", s)
   end

Utils.table.save = function(  _tbl,filename )
   local charS,charE = "   ","\n"
   local file,err = io.open( filename, "wb" )
   if err then return err end

   local tables,lookup = { _tbl },{ [_tbl] = 1 }
   file:write( "return {"..charE )

   for idx,t in ipairs( tables ) do
      file:write( "-- Table: {"..idx.."}"..charE )
      file:write( "{"..charE )
      local thandled = {}

      for i,v in ipairs( t ) do
         thandled[i] = true
         local stype = type( v )
         if stype == "table" then
            if not lookup[v] then
               table.insert( tables, v )
               lookup[v] = #tables
            end
            file:write( charS.."{"..lookup[v].."},"..charE )
         elseif stype == "string" then
            file:write(  charS..exportstring( v )..","..charE )
         elseif stype == "number" then
            file:write(  charS..tostring( v )..","..charE )
         end
      end

      for i,v in pairs( t ) do
         if (not thandled[i]) then
         
            local str = ""
            local stype = type( i )
            if stype == "table" then
               if not lookup[i] then
                  table.insert( tables,i )
                  lookup[i] = #tables
               end
               str = charS.."[{"..lookup[i].."}]="
            elseif stype == "string" then
               str = charS.."["..exportstring( i ).."]="
            elseif stype == "number" then
               str = charS.."["..tostring( i ).."]="
            end
         
            if str ~= "" then
               stype = type( v )
               if stype == "table" then
                  if not lookup[v] then
                     table.insert( tables,v )
                     lookup[v] = #tables
                  end
                  file:write( str.."{"..lookup[v].."},"..charE )
               elseif stype == "string" then
                  file:write( str..exportstring( v )..","..charE )
               elseif stype == "number" then
                  file:write( str..tostring( v )..","..charE )
               end
            end
         end
      end
      file:write( "},"..charE )
   end
   file:write( "}" )
   file:close()
end

return Utils
