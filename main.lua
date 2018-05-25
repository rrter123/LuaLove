local current_map = require("maps/map_1")
local math = require("math")
local texture_size_x = 100
local texture_size_y = 100
local offset_x = 0
local offset_y = 0
local person_image = love.graphics.newImage("flower.png")


--local width, height = love.window.getDesktopDimensions()
width, height = 800, 600
success = love.window.setMode(width, height)
love.keyboard.setKeyRepeat(true)

local function can_go_down()
  local check1, check2 = false, false
  local player_position_x = width/2-50+offset_x
  local player_position_y = height/2-50+offset_y
  if current_map[math.floor((player_position_y+100)/100)+1][math.floor(player_position_x/100)+1] %10 == 0 then
    check1 = true
  end
  if current_map[math.floor((player_position_y+100)/100)+1][math.floor((player_position_x+100)/100)+1] %10 == 0 then
    check2 = true
  end
  return check1 and check2
end

function love.update(dt)
  local character_speed = 5
   if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    offset_y =offset_y - character_speed
  end
  if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and can_go_down() then
    offset_y =offset_y + character_speed
  end
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    offset_x =offset_x - character_speed
  end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    offset_x =offset_x + character_speed
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then --Pressing Escape closes the window and then schedules the program to close
    love.window.close()
    love.event.quit()
  end
end

local function draw_map(tab)
  --textures drawing begin
  for y, row in ipairs(current_map) do
    for x, value in ipairs(row) do
      local key = "img"..value
      love.graphics.draw(current_map[key], ((x-1)*texture_size_x)-offset_x, ((y-1)*texture_size_y)-offset_y)
    end
  end 
  --textures drawn. Motion is simulated by changing the place in which texture drawing begins.
end
  


function love.draw()
  draw_map(current_map)
  --avatar drawing
  local window_width, window_height = love.window.getMode()
  love.graphics.draw(person_image, window_width/2-50, window_height/2-50)
  --avatar drawn
  
end
