local current_map = require("maps/map_1")
local math = require("math")
local check = require("checks")
local maps = require("maps")
local socket = require("socket")

function sleep(sec)
    socket.select(nil, nil, sec)
end


width, height = love.window.getDesktopDimensions()
--width, height = 800, 600
success = love.window.setMode(width, height)
love.keyboard.setKeyRepeat(true)

local texture_size_x = 100
local texture_size_y = 100

local person_image = love.graphics.newImage("flower.png")
local player_x = 2 -- < texture_size_x
local player_y = 2 -- < texture_size_y
local offset_x = -width/2+player_x*100-texture_size_x/2
local offset_y = -height/2+player_y*100-texture_size_y/2

function set_offset()
  offset_x = -width/2+player_x*100-texture_size_x/2
  offset_y = -height/2+player_y*100-texture_size_y/2
end

function load_map(number)
  path = current_map["path"..number]
  player_x = current_map["x"..number]
  player_y = current_map["y"..number]
  current_map = require(path)
  set_offset()
end

function love.update(dt)
  local sleep_time = 0.15
   if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) 
   and check.can_go_up(player_x, player_y, current_map)
   then
    offset_y =offset_y - 100
    player_y = player_y - 1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) 
  and check.can_go_down(player_x, player_y, current_map) 
  then
    offset_y =offset_y + 100
    player_y =player_y +1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) 
  and check.can_go_left(player_x, player_y, current_map) 
  then
    offset_x =offset_x - 100
    player_x =player_x -1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) 
  and check.can_go_right(player_x, player_y, current_map) 
  then
    offset_x =offset_x + 100
    player_x =player_x +1
    love.draw()
    --sleep(sleep_time)
  end
  sleep(sleep_time)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then --Pressing Escape closes the window and then schedules the program to close
    love.window.close()
    love.event.quit()
  end
  if key == "e" then
    local test = checks.around(player_x, player_y, current_map)
    if test ~= 0 then
      if test%10 == 2 then
        load_map(test)
      end
    end
end
  --[[
  if (key == "right" or key == "d") and check.can_go_right(player_x, player_y, current_map)
  then
    offset_x =offset_x + 100
    player_x = player_x+1
  end
  if (key == "left" or key == "a") and check.can_go_left(player_x, player_y, current_map)
  then
    offset_x =offset_x - 100
    player_x = player_x-1
  end
  if (key == "down" or key == "s") and check.can_go_down(player_x, player_y, current_map)
  then
    offset_y =offset_y + 100
    player_y = player_y+1
  end
  if (key == "up" or key == "w") and check.can_go_up(player_x, player_y, current_map)
  then
    offset_y =offset_y - 100
    player_y = player_y-1
  end
  ]]--
  --Pressing E should open door if they are nearby and load a new map with starting positions
end

local function draw_map(tab)
  --textures drawing begin
  for y, row in ipairs(current_map) do
    for x, value in ipairs(row) do
      local key = "img"..value
      --print (x,y,value)
      love.graphics.draw(current_map[key], ((x-1)*texture_size_x)-offset_x, ((y-1)*texture_size_y)-offset_y)
    end
  end 
  --textures drawn. Motion is simulated by changing the place in which texture drawing begins.
end
  


function love.draw()
  maps.gen_map(15,16,3)
  --current_map = require("maps/map_3")
  draw_map(current_map)
  --avatar drawing
  local window_width, window_height = love.window.getMode()
  love.graphics.draw(person_image, window_width/2-texture_size_x/2, window_height/2-texture_size_y/2)
  --avatar drawn
  
end
