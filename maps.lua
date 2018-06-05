
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
  local tab = {}
  if x+2 < width and not visited[10*(y-1)+x+2] then
      tab[#tab+1] = 1
  end
  if x-2 > 1 and not visited[10*(y-1)+x-2] then
      tab[#tab+1] = 2
  end
  if y-2 > 1 and not visited[10*(y-3)+x] then
      tab[#tab+1] = 3
  end
  if y+2 < length and not visited[10*(y+1)+x] then
      tab[#tab+1] = 4
  end
  return tab
end

local function neighbours(x,y, map)
  if x ~= 1 then
    if map[y][x-1] % 10 == 0 then
      return false
    end
  end
  if x ~= #map[1] then
    if map[y][x+1] % 10 == 0 then
      return false
    end
  end
  if y ~= 1 then
    if map[y-1][x] % 10 == 0 then
      return false
    end
  end
  if y ~= #map then
    if map[y+1][x] % 10 == 0 then
      return false
    end
  end
  return true  
end

function maps.gen_map(width, length, map_nr, doorx,doory) --width, length and number of map we want to generate
  math.randomseed(os.time())
  math.random(2)
  print (os.time())
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
  if doory-2 > 1 then
      map[doory-2][doorx] = 10000+map_nr*100+12
      map[doory-1][doorx] = 10000+map_nr*100
      visited[10*(doory-3)+doorx] = true
      visited[10*(doory-2)+doorx] = true
  else
      map[doory+2][doorx] = 10000+map_nr*100+12
      map[doory+1][doorx] = 10000+map_nr*100
      visited[10*(doory+1)+doorx] = true
      visited[10*doory+doorx] = true
  end
  local x,y = doorx, doory
  map[y][x] = 10000+map_nr*100  
  visited[10*(y-1) + x] = true
  queue = {}
  queue[#queue +1] = {x,y}

  while #queue > 0  do 
    local tab = visit(x,y,width,length, visited)
    print ("dlugosc tab "..#tab)
    print (x, y)
    print ("dlugosc kolejki "..#queue)
    if #tab ~= 0 then
      local rand = math.random(#tab)
      local vis = tab[rand]
      print ("wartosc vis"..vis)
      if vis == 1 then
        x = x + 2
        map[y][x] = 10000+map_nr*100
        map[y][x-1] = 10000+map_nr*100
        visited[10*(y-1)+x-1] = true
        if y-1 > 1 then
          visited[10*(y-2)+x-1] = true
        end
        if y+1 < length then
          visited[10*y+x-1] = true
        end
      end
      if vis == 2 then
        x = x - 2
        map[y][x] = 10000+map_nr*100
        map[y][x+1] = 10000+map_nr*100
        visited[10*(y-1)+x+1] = true
        if y-1 > 1 then
          visited[10*(y-2)+x+1] = true
        end
        if y+1 < length then
          visited[10*y+x+1] = true
        end
      end
      if vis == 3 then
        y = y - 2
        map[y][x] = 10000+map_nr*100
        map[y+1][x] = 10000+map_nr*100
        visited[10*y+x] = true
        if x-1 > 1 then
          visited[10*y+x-1] = true
        end
        if x+1 < width then
          visited[10*y+x+1] = true
        end
      end
      if vis == 4 then
        y = y + 2
        map[y][x] = 10000+map_nr*100
        map[y-1][x] = 10000+map_nr*100
        visited[10*(y-2)+x] = true
        if x-1 > 1 then
          visited[10*(y-2)+x-1] = true
        end
        if x+1 < width then
          visited[10*(y-2)+x+1] = true
        end
      end
      queue[#queue+1] = {x,y}
      visited[10*(y-1)+x] = true
    else
      while true do
        local a,b = queue[#queue][1], queue[#queue][2]
        queue[#queue] = nil
        if visit(a,b, width,length,visited) or #queue == 0 then
          x, y = a, b
          break
        end  
      end
    end
  end
  


  local door_x = math.random(width) 
  local door_y = math.random(length)

  while neighbours(door_x, door_y, map) do
    door_x = math.random(width) 
    door_y = math.random(length)
  end
  map[door_y][door_x] = 10000+map_nr*100+2 --generates door in random place on map
 
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