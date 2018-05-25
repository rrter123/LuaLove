local temp_map = require("maps/map_1")
local math = require("math")
local texture_size_x = 100
local texture_size_y = 100
local person_x = 200
local person_y = 200
local person_image = love.graphics.newImage("flower.png")


local width, height = love.window.getDesktopDimensions()
print (width, height)
success = love.window.setMode(800, 600)
love.keyboard.setKeyRepeat(true)


function love.update(dt)
  local character_speed = 5
   if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    person_y =person_y - character_speed
  end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    person_y =person_y + character_speed
  end
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    person_x =person_x - character_speed
  end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    person_x =person_x + character_speed
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
  for y, row in ipairs(temp_map) do
    for x, value in ipairs(row) do
      local key = "img"..value
      love.graphics.draw(temp_map[key], ((x-1)*texture_size_x)-person_x, ((y-1)*texture_size_y)-person_y)
    end
  end 
  --textures drawn. Motion is simulated by changing the place in which texture drawing begins.
end
  


function love.draw()
  draw_map(temp_map)
  --avatar drawing
  local window_width, window_height = love.window.getMode()
  love.graphics.draw(person_image, window_height/2, window_width/2)
  --avatar drawn
  
end
