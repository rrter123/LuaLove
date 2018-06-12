local current_map = require("maps/map_1")
local current_entities=require("maps/entities_1")
local math = require("math")
local check = require("checks")
local maps = require("maps")
local socket = require("socket")
local player = require("player")
--local functions = require("functions")

function sleep(sec)
    socket.select(nil, nil, sec)
end
width, height = love.window.getDesktopDimensions()
success = love.window.setMode(width, height)
love.keyboard.setKeyRepeat(false)

local texture_size_x = 100
local texture_size_y = 100

local offset_x = -width/2+player.player_x*100-texture_size_x/2
local offset_y = -height/2+player.player_y*100-texture_size_y/2

function set_offset()
  offset_x = -width/2+player.player_x*100-texture_size_x/2
  offset_y = -height/2+player.player_y*100-texture_size_y/2
end

function exists(path, number)
   local ok, err, code = os.rename(path..'.lua', path..'.lua')
   print (ok,err,code)
   if not ok then
      if code == 13 then
        print("file exists")
         -- Permission denied, but it exists
      end
      if code == 2 then
        if number == 212 then
          maps.gen_map(30,30,1,current_map["x"..number],current_map["y"..number] )
        else
          maps.gen_map(30,30,(math.floor((number/100)%10)+1),current_map["x"..number],current_map["y"..number])
        end
      end
    else
      if number/100 > 100 then
        current_map = require(path)
        maps.update_entities(current_map, math.floor((number/100)%10)+1)
      end
    end
end


function load_map(number)
  local path = current_map["path"..number]
  exists(path,number)
  local path_e = current_entities["path"..number]
  player.player_x = current_map["x"..number]
  player.player_y = current_map["y"..number]
  current_map = require(path)
  current_entities = require(path_e)
  set_offset()
end


local inv = 0
function love.keypressed(key, scancode, isrepeat)
  
  if key == "escape" then --Pressing Escape closes the window and then schedules the program to close
    love.window.close()
    love.event.quit()
  end
  if key == "e" then
    if inv == 1 then
      local t = player[player.pos]["type"]
      if t == "leaf" then
        player.leaf_eq = player.pos
      end
      if t == "pollen" then
        player.pollen_eq = player.pos
      end
      if t == "petal" then
        player.petal_eq = player.pos
      end
    else
      local test = checks.around(player.player_x, player.player_y, current_map)
      if test ~= 0 then
        if test%10 == 2 then
          load_map(test)
      end  end
    end
  end
  if key == "i" then
    if inv == 0 then
      love.draw = player.inv_draw
      inv = 1
    else
      love.draw = functions.draw
      inv = 0
    end
  end
  if (key == 'a' or key == 'left') and (inv==1) then
    player.pos = player.pos - 1
    if player.pos == 0 then
      player.pos = player.top
    end
  end
  if (key == 'd' or key == 'right') and (inv==1) then
    player.pos = player.pos + 1
    if player.pos == player.top+1 then
      player.pos = 1
    end
  end
  
end

functions = {}

local function draw_map()
  --textures drawing begin
  for y, row in ipairs(current_map) do
    for x, value in ipairs(row) do
      local key = "img"..value
      --print (x,y,value)
      love.graphics.draw(current_map[key], ((x-1)*texture_size_x)-offset_x, ((y-1)*texture_size_y)-offset_y)
    end
  end 
  for y, row in ipairs(current_entities) do
    for x, value in ipairs(row) do
      if value ~= 0 then
        local key = "img"..value
        --print (x,y,value)
        love.graphics.draw(current_entities[key], ((x-1)*texture_size_x)-offset_x, ((y-1)*texture_size_y)-offset_y)
      end
    end
  end 
  --textures drawn. Motion is simulated by changing the place in which texture drawing begins.
end

function functions.draw()
  draw_map()
  --avatar drawing
  local window_width, window_height = love.window.getMode()
  love.graphics.draw(player.person_image, window_width/2-texture_size_x/2, window_height/2-texture_size_y/2)
  --avatar drawn
end



function functions.update(dt)
  local sleep_time = 0.2
   if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) 
   and check.can_go_up(player.player_x, player.player_y, current_map)
   and check.can_go_up(player.player_x, player.player_y, current_entities)
   then
    offset_y =offset_y - 100
    player.player_y = player.player_y - 1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) 
  and check.can_go_down(player.player_x, player.player_y, current_map)
  and check.can_go_down(player.player_x, player.player_y, current_entities)
  then
    offset_y =offset_y + 100
    player.player_y =player.player_y +1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) 
  and check.can_go_left(player.player_x, player.player_y, current_map)
  and check.can_go_left(player.player_x, player.player_y, current_entities)
  then
    offset_x =offset_x - 100
    player.player_x =player.player_x -1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) 
  and check.can_go_right(player.player_x, player.player_y, current_map) 
  and check.can_go_right(player.player_x, player.player_y, current_entities)
  then
    offset_x =offset_x + 100
    player.player_x =player.player_x +1
    love.draw()
    --sleep(sleep_time)
  end
  sleep(sleep_time)
end

love.update = functions.update
love.draw = functions.draw
