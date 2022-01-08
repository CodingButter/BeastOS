
utils = (function()
   local Utils = {}
      -- Save copied tables in `copies`, indexed by original table.
   local tbl = {}
      tbl.copy = function(orig, copies,lvl)
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
                     copy[tbl.copy(orig_key, copies,lvl+1)] = tbl.copy(orig_value, copies,lvl+1)
                   else
                       copy[orig_key] = orig_value
                   end
               end
               setmetatable(copy, tbl.copy(getmetatable(orig), copies))
            end
         else -- number, string, boolean, etc
            copy = orig
         end
         return copy
      end
      tbl.map = function(tbl, f)
         local t = {}
         for k,v in pairs(tbl) do
               t[k] = f(v,k)
         end
         return t
      end
   
      tbl.filter = function(tbl,f)
         local t = {}
         for k,v in pairs(tbl) do
               if f(v,k) then t[k] = v; end
         end
         return t
      end
   
   --Compare tables
   
   tbl.is = function(table1, table2)
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

      --// The Save Function
   tbl.save = function(  tbl,filename )
      local charS,charE = "   ","\n"
      local file,err = io.open( filename, "wb" )
      if err then return err end

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      file:write( "return {"..charE )

      for idx,t in ipairs( tables ) do
         file:write( "-- Table: {"..idx.."}"..charE )
         file:write( "{"..charE )
         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
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
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
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
                  -- handle value
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
   Utils.table = tbl
   return Utils
end)()
