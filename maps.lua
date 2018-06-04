
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

local function visit(x,y, width,length, visited)
  if x ~= 1 then
    if not visited[10*(x-2)+y] then
      return true
    end
  end
  if x ~= width then
    if not visited[10*x+y] then
      return true
    end
  end
  if y ~= 1 then
    if not visited[10*(x-1)+y-1] then
      return true
    end
  end
  if y ~= length then
    if not visited[10*(x-1)+y+1] then
      return true
    end
  end
  return false
end

local function neighbours(x,y, map)
  if x ~= 1 then
    if map[x-1][y] % 10 == 0 then
      return false
    end
  end
  if x ~= #map then
    if map[x+1][y] % 10 == 0 then
      return false
    end
  end
  if y ~= 1 then
    if map[x][y-1] % 10 == 0 then
      return false
    end
  end
  if y ~= #map[1] then
    if map[x][y+1] % 10 == 0 then
      return false
    end
  end
  return true  
end

function maps.gen_map(width, length, map_nr, doorx,doory) --width, length and number of map we want to generate
  print("mapa 10"..map_nr)
  local map = {}
  local entities = {}
  local visited = {}
  for i=1, width do
    map[#map+1] = {}
    entities[#entities+1] = {}
    for j=1, length do
      if i == 1 or i == width or j == 1 or j == length  then
        visited[#visited + 1] = true
     else
        visited[#visited + 1] = false
      end
      map[i][j] = 10000+map_nr*100+1
      entities[i][j] = 0
    end
  end

  --local path_x, path_y = 0,0
  if (doorx-1) ~= 1 then
      map[doorx-1][doory] = 10000+map_nr*100+12
      visited[10*(doorx-2)+doory] = true
     -- path_x, path_y = doorx-1, doory-1
  else
      map[doorx+1][doory] = 10000+map_nr*100+12
      visited[10*doorx+doory] = true
    --  path_x, path_y = doorx-1, doory+1
  end
  local x,y = doorx, doory
    
  visited[10*(x-1) + y] = true
  queue = {}
  queue[#queue +1] = {x,y}
  map[x][y] = 10000+map_nr*100

  while #queue > 0  do 
    if visit(x,y,width, length, visited) then
      while true do
        local rand = math.random(4) -- 1 -> go right, 2 -> go left, 3-> go up, 4 -> go down 
        if rand == 1 then
          if x < width and not visited[10*x+y] then
            x = x + 1
            map[x][y] = 10000+map_nr*100
            if y ~= 1 then
              visited[10*(x-2)+y-1] = true
            end
            if y ~= length then
              visited[10*(x-2)+y+1] = true
            end
            break
          end
        end
        if rand == 2 then
          if x > 1 and not visited[10*(x-2)+y] then
            x = x - 1
            map[x][y] = 10000+map_nr*100
            if y ~= 1 then
              visited[10*x+y-1] = true
            end
            if y ~= length then
              visited[10*x+y+1] = true
            end
            break
          end
        end
        if rand == 3 then
          if y > 1 and not visited[10*(x-1)+y-1] then
            y = y - 1
            map[x][y] = 10000+map_nr*100
            if x ~= 1 then
              visited[10*(x-2)+y+1] = true
            end
            if x ~= width then
              visited[10*x+y+1] = true
            end
            break
          end
        end
        if rand == 4 then
          if y < length and not visited[10*(x-1)+y+1] then
            y = y + 1
            map[x][y] = 10000+map_nr*100
            if x ~= 1 then
              visited[10*(x-2)+y-1] = true
            end
            if x ~= width then
              visited[10*x+y-1] = true
            end
            break
          end
        end
      end
      queue[#queue+1] = {x,y}
      visited[10*(x-1)+y] = true
      print ("x "..x.." y "..y)
    else
      while true do
        print (queue[#queue][1], queue[#queue][2])
        local a,b = queue[#queue][1], queue[#queue][2]
        queue[#queue] = nil
        if visit(a,b, width,length,visited) or #queue == 0 then
          x, y = a, b
          break
        end           
      end
    end
  end
  for i=1, width do
    for j=1, length do
      if i == 1 or i == width or j == 1 or j == length  then
        map[i][j] = 10000+map_nr*100+1
      end
    end
  end


  local door_x = math.random(width) 
  local door_y = math.random(length)

  while neighbours(door_x, door_y, map) do
    door_x = math.random(width) 
    door_y = math.random(length)
  end
  map[door_x][door_y] = 10000+map_nr*100+2 --generates door in random place on map
 
  local new_x, new_y = 1 + math.random(width-2), 1 + math.random(length-2)
 
 --create new .lua file with new map
 
local new_map = io.open("maps/map_10"..map_nr..".lua", "w") 
new_map:write("map =\n"..tostr(map).."\n\n")
new_map:write('map["img'..(10000+map_nr*100)..'"] = love.graphics.newImage("maps/dungeon_textures/floors/200.jpg")\n')
new_map:write('map["img'..(10000+map_nr*100+1)..'"] = love.graphics.newImage("maps/dungeon_textures/walls/201.jpg")\n')
new_map:write('map["img'..(10000+map_nr*100+2)..'"] = love.graphics.newImage("maps/dungeon_textures/doors/202.jpg")\n')
new_map:write('map["img'..(10000+map_nr*100+12)..'"] = love.graphics.newImage("maps/dungeon_textures/doors/castledoors.png")\n')
new_map:write('map["path'..(10000+map_nr*100+12)..'"] = "maps/map_1"\n')
new_map:write('map["path'..(10000+map_nr*100+2)..'"] = "maps/map_10'..(map_nr+1)..'"\n')
new_map:write('map["x'..(10000+map_nr*100+2)..'"] = '..new_x..' \n')
new_map:write('map["y'..(10000+map_nr*100+2)..'"] = '..new_y..'\n')
new_map:write('map["x'..(10000+map_nr*100+12)..'"] = 11 \n')
new_map:write('map["y'..(10000+map_nr*100+12)..'"] = 14 \n')
new_map:write("return map")
new_map:flush()
new_map:close()
local new_entities = io.open("maps/entities_"..(100+map_nr)..".lua","w")
new_entities:write("entities =\n"..tostr(entities).."\n\n")
--new_entities:write('entities['img'..
new_entities:write("return entities")
new_entities:flush()
new_entities:close()
end

return maps