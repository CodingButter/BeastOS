utils = {}
   -- Save copied tables in `copies`, indexed by original table.
local tbl = {}
    tbl.copy = function(orig, copies)
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
                  copy[tbl.copy(orig_key, copies)] = tbl.copy(orig_value, copies)
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
     local avoid_loops = {}
     local function recurse(t1, t2)
        -- compare value types
        if type(t1) ~= type(t2) then return false end
        -- Base case: compare simple values
        if type(t1) ~= "table" then return t1 == t2 end
        -- Now, on to tables.
        -- First, let's avoid looping forever.
        if avoid_loops[t1] then return avoid_loops[t1] == t2 end
        avoid_loops[t1] = t2
        -- Copy keys from t2
        local t2keys = {}
        local t2tablekeys = {}
        for k, _ in pairs(t2) do
           if type(k) == "table" then table.insert(t2tablekeys, k) end
           t2keys[k] = true
        end
        -- Let's iterate keys from t1
        for k1, v1 in pairs(t1) do
           local v2 = t2[k1]
           if type(k1) == "table" then
              -- if key is a table, we need to find an equivalent one.
              local ok = false
              for i, tk in ipairs(t2tablekeys) do
                 if table_eq(k1, tk) and recurse(v1, t2[tk]) then
                    table.remove(t2tablekeys, i)
                    t2keys[tk] = nil
                    ok = true
                    break
                 end
              end
              if not ok then return false end
           else
              -- t1 has a key which t2 doesn't have, fail.
              if v2 == nil then return false end
              t2keys[k1] = nil
              if not recurse(v1, v2) then return false end
           end
        end
        -- if t2 has a key which t1 doesn't have, fail.
        if next(t2keys) then return false end
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
   utils.table = tbl