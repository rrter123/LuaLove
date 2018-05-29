
local width = 15
local length = 16
local map_nr = 3

maps = {}

--function formating table to string

function tostr(map)
  str= {}
  for i=1, #map do
      str[#str+1] = '{'..table.concat(map[i], ',')..'}'
  end
  return '{'..table.concat(str, ',\n')..'}'
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
new_map:write("map =\n"..tostr(map).."\n\n")
new_map:write('map["img'..map_nr..'00"] = love.graphics.newImage("maps/dungeon_textures/200.jpg")\nmap["img'..map_nr..'01"] = love.graphics.newImage("maps/dungeon_textures/201.jpg")\nmap["img'..map_nr..'02"] = love.graphics.newImage("maps/dungeon_textures/202.jpg")\n\nmap["path202"] = "maps/map_'..map_nr..'"\nmap["x102"] = 2\nmap["y102"] = 2\n')
new_map:write("return map")
new_map:flush()
new_map:close()

end

return maps