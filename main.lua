local temp_map = require("maps/map_1")

local texture_size_x = 100
local texture_size_y = 100

local width, height = love.window.getDesktopDimensions()
print (width, height)
success = love.window.setMode(width, height)

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
end
