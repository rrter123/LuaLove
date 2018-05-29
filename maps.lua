
local width = 15
local length = 16
local map_nr = 3

maps = {}

--copied from lua-users.org/wiki/TableUtils
--needed to convert table to string

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

--generate new map

function maps.gen_map(width, length, map_nr) --width, length and number of map we want to generate
  local map = {}
  for i=1, width do
    map[#map+1] = {}
    for j=1, length do
      if i == 1 or i == width or j == 1 or j == length  then
        map[i][j] = map_nr*100 + 1
      else
        map[i][j] = map_nr*100
      end
    end
  end
  local door_x = math.random(width) 
  local door_y = math.random(length)
  map[door_x][door_y] = map_nr*100 + 2 --generates door in random place on map
 
 --create new .lua file with new map
 
local new_map = io.open("maps/map_"..map_nr..".lua", "w") 
new_map:write("map =\n"..table.tostring(map).."\n\n")
new_map:write('map["img'..map_nr..'00"] = love.graphics.newImage("maps/dungeon_textures/200.jpg")\nmap["img'..map_nr..'01"] = love.graphics.newImage("maps/dungeon_textures/201.jpg")\nmap["img'..map_nr..'02"] = love.graphics.newImage("maps/dungeon_textures/202.jpg")\n\nmap["path202"] = "maps/map_'..map_nr..'"\nmap["x102"] = 2\nmap["y102"] = 2\n')
new_map:write("return map")
new_map:flush()
new_map:close()

end

return maps