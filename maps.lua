
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

local function not_visited(x,y, visited)
  for i=1, #visited do
    if visited[i] == 10*(x-1)+y then
      return false
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
    for j=1, length do
      if i == 1 or i == width or j == 1 or j == length  then
        visited[#visited + 1] = 10*(i-1)+j
        map[i][j] = map_nr*1000 + 1
     else
        map[i][j] = map_nr*1000
      end
      entities[i][j] = 0
    end
  end
  local x = 2
  local y = 2 
  while #visited < #map*#map[1]/2  do
    x = 1 + math.random(width-2)
    y = 1 + math.random(length-2)
    print (#visited, x, y)
    local rand = math.random(4) -- 1 -> go right, 2 -> go left, 3-> go up, 4 -> go down  
    if rand == 1 then
      if x ~= width and not_visited(x+1, y, visited) then
        --[[
        if y ~= 1 then
            if not_visited(x, y-1, visited) then
              visited[#visited + 1] = 10*(x-1) + y-1
            end
        end
        if y ~= length then
            if not_visited(x, y+1, visited) then
              visited[#visited + 1] = 10*(x-1) + y+1
            end
        end--]]
        x = x + 1
        map[x][y] = map_nr*1000+1
        visited[#visited+1] = 10*(x-1)+y
      end
    end
    if rand == 2 then
      if x ~= 1 and not_visited(x-1, y, visited) then
      --[[  if y ~= 1 then
            if not_visited(x, y-1, visited) then
              visited[#visited + 1] = 10*(x-1) + y-1
            end
        end
        if y ~= length then
            if not_visited(x, y+1, visited) then
              visited[#visited + 1] = 10*(x-1) + y+1
            end
        end--]]
        x = x - 1
        map[x][y] = map_nr*1000+1
        visited[#visited+1] = 10*(x-1)+y
      end
    end
    if rand == 3 then
      if y ~= 1 and not_visited(x,y-1, visited) then
       --[[ if x ~= width then
          if not_visited(x+1, y, visited) then
            visited[#visited + 1] = 10*x + y
          end
        end
        if x ~= 1 then
          if not_visited(x-1, y, visited) then
            visited[#visited + 1] = 10*(x-2) + y
          end
        end--]]
        y = y - 1
        map[x][y] = map_nr*1000+1
        visited[#visited+1]= 10*(x-1) + y
      end
    end
    if rand == 4 then
      if y ~= length and not_visited(x,y+1, visited) then
        --[[if x ~= width then
          if not_visited(x+1, y, visited) then
            visited[#visited + 1] = 10*x + y
          end
        end
        if x ~= 1 then
          if not_visited(x-1, y, visited) then
            visited[#visited + 1] = 10*(x-2) + y
          end
        end--]]
        y = y + 1
        map[x][y] = map_nr*1000+1
        visited[#visited+1]= 10*(x-1) + y
      end
    end      
  end

  --]]

  local door_x = math.random(width) 
  local door_y = math.random(length)
  map[door_x][door_y] = map_nr*1000 + 2 --generates door in random place on map
 
 --create new .lua file with new map
 
local new_map = io.open("maps/map_10"..map_nr..".lua", "w") 
new_map:write("map =\n"..tostr(map).."\n\n")
new_map:write('map["img'..map_nr..'000"] = love.graphics.newImage("maps/dungeon_textures/floors/200.jpg")\n')
new_map:write('map["img'..map_nr..'001"] = love.graphics.newImage("maps/dungeon_textures/walls/201.jpg")\n')
new_map:write('map["img'..map_nr..'002"] = love.graphics.newImage("maps/dungeon_textures/doors/202.jpg")\n')
new_map:write('map["path'..(100*map_nr)..'"] = "maps/map_10'..(map_nr+1)..'"\n')
new_map:write('map["x'..(100*map_nr)..'2"] = 2\n')
new_map:write('map["y'..(100*map_nr)..'2"] = 2\n')
new_map:write("return map")
new_map:flush()
new_map:close()
local new_entities = io.open("maps/entities_"..map_nr..".lua","w")
new_entities:write("entities =\n"..tostr(entities).."\n\n")
--new_entities:write('entities['img'..
new_entities:write("return entities")
new_entities:flush()
new_entities:close()
end

return maps