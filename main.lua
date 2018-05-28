local current_map = require("maps/map_2")
local math = require("math")
local check = require("checks")

width, height = love.window.getDesktopDimensions()
--width, height = 800, 600
success = love.window.setMode(width, height)
love.keyboard.setKeyRepeat(true)

local texture_size_x = 100
local texture_size_y = 100
local offset_x = -width/2+200
local offset_y = -height/2+200
local person_image = love.graphics.newImage("flower.png")
local player_size_x = 98 -- < texture_size_x
local player_size_y = 98 -- < texture_size_y

function love.update(dt)
  local character_speed = 5
   if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) 
   and check.can_go_up(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed) 
   then
    offset_y =offset_y - character_speed
  end
  if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) 
  and check.can_go_down(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed) 
  then
    offset_y =offset_y + character_speed
  end
  if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) 
  and check.can_go_left(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed) 
  then
    offset_x =offset_x - character_speed
  end
    if (love.keyboard.isDown("right") or love.keyboard.isDown("d"))
    and check.can_go_right(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed) 
    then
    offset_x =offset_x + character_speed
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then --Pressing Escape closes the window and then schedules the program to close
    love.window.close()
    love.event.quit()
  end
  --Pressing E should open door if they are nearby and oad a new map with starting positions
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
  draw_map(current_map)
  --avatar drawing
  local window_width, window_height = love.window.getMode()
  love.graphics.draw(person_image, window_width/2-player_size_x/2, window_height/2-player_size_y/2)
  --avatar drawn
  
end
