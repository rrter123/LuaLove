
local width = 15
local length = 16
local map_nr = 3

maps = {}

--function formating table to string

local function tostr(map)
  str= {}
  for i=1, #map do
      str[#str+1] = '{'..table.concat(map[i], ',')..'}'
  end
  return '{'..table.concat(str, ',\n')..'}'
end

local function all_visited(visited)
  for i=1, #visited do
    for j=1, #visited[i] do
      if visited[i][j] == false then
        return false
      end
    end
  end
  return true
end


function maps.gen_map(width, length, map_nr) --width, length and number of map we want to generate
  local map = {}
  local entities = {}
  local visited = {}
  for i=1, width do
    map[#map+1] = {}
    entities[#entities+1] = {}
    visited = {}
    for j=1, length do
      if i == 1 or i == width or j == 1 or j == length  then
        visited[i][j] = true
      end
     -- else
     --   map[i][j] = map_nr*100
     -- end
      map[i][j] = map_nr*100 + 1
      visited[i][j] = false
      entities[i][j] = 0
    end
  end
  local x = 1 + math.random(width-2)
  local y = 1 + math.random(length-2)
  map[x][y] = map_nr*100
  visited[x][y] = true
  while all_visited(visited) do
    local rand = math.random(4) -- 1 -> go right, 2 -> go left, 3-> go up, 4 -> go down  
    if rand == 1 then
      if x ~= width and not visited[x+1][y] then
        if x ~= 1 then
          visited[x-1][y] = true
        end
        if y ~= 1 then
          visited[x][y-1] = true
        end
        if y ~= length then
          visited[x][y+1] = true
        end
        x = x + 1
        map[x][y] = map_nr*100
        visited[x][y] = true
      end
    end
      if rand == 2 then
      if x ~= 1 and not visited[x-1][y] then
        if x ~= width then
          visited[x+1][y] = true
        end
        if y ~= 1 then
          visited[x][y-1] = true
        end
        if y ~= length then
          visited[x][y+1] = true
        end
        x = x - 1
        map[x][y] = map_nr*100
        visited[x][y] = true
      end
    end
      if rand == 3 then
      if y ~= 1 and not visited[x][y-1] then
        if x ~= width then
          visited[x+1][y] = true
        end
        if x ~= 1 then
          visited[x-1][y] = true
        end
        if y ~= length then
          visited[x][y+1] = true
        end
        y = y - 1
        map[x][y] = map_nr*100
        visited[x][y] = true
      end
    end
    if rand == 4 then
      if y ~= length and not visited[x][y+1] then
        if x ~= width then
          visited[x+1][y] = true
        end
        if x ~= 1 then
          visited[x-1][y] = true
        end
        if y ~= 1 then
          visited[x][y-1] = true
        end
        y = y + 1
        map[x][y] = map_nr*100
        visited[x][y] = true
      end
    end      
      
  end

  

  --local door_x = math.random(width) 
  --local door_y = math.random(length)
  --map[door_x][door_y] = map_nr*100 + 2 --generates door in random place on map
 
 --create new .lua file with new map
 
local new_map = io.open("maps/map_10"..map_nr..".lua", "w") 
new_map:write("map =\n"..tostr(map).."\n\n")
new_map:write('map["img'..map_nr..'00"] = love.graphics.newImage("maps/dungeon_textures/floors/200.jpg")\n')
new_map:write('map["img'..map_nr..'01"] = love.graphics.newImage("maps/dungeon_textures/walls/201.jpg")\n')
new_map:write('map["img'..map_nr..'02"] = love.graphics.newImage("maps/dungeon_textures/doors/202.jpg")\n')
new_map:write('map["path202"] = "maps/map_'..map_nr..'"\nmap["x102"] = 2\nmap["y102"] = 2\n')
new_map:write("return map")
new_map:flush()
new_map:close()
local new_entities = io.open("maps/entities_"..map_nr..".lua","w")
new_entities:write("entities =\n"..tostr(entities).."\n\n")
--new_entities:write('entities['img'..
new_map:write("return entities")
new_map:flush()
new_map:close()
end

return maps