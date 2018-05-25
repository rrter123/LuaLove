local temp_map = require("maps/map_1")

local texture_size_x = 100
local texture_size_y = 100
local person_x = 200
local person_y = 200
local person_image = love.graphics.newImage("flower.png")


local width, height = love.window.getDesktopDimensions()
print (width, height)
success = love.window.setMode(width, height)
love.keyboard.setKeyRepeat(true)


function love.update(dt)
   if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    person_y =person_y - 5
  end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    person_y =person_y + 5
  end
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    person_x =person_x - 5
  end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    person_x =person_x + 5
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then --Pressing Escape closes the window and then schedules the program to close
    love.window.close()
    love.event.quit()
  end
end

function love.draw()
  --texture drawing begin
  for y, row in ipairs(temp_map) do
    for x, value in ipairs(row) do
      local key = "img"..value
      love.graphics.draw(temp_map[key], (x-1)*texture_size_x, (y-1)*texture_size_y)
    end
  end
  --texture drawing end
  --avatar drawing
  love.graphics.draw(person_image, person_x, person_y)
  
end
