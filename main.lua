local temp_map = require("maps/map_1")

local texture_size_x = 100
local texture_size_y = 100


function love.draw()
  for x, row in ipairs(temp_map) do
    for y, value in ipairs(row) do
      local key = "img"..value
      love.graphics.draw(temp_map[key], (x-1)*texture_size_x, (y-1)*texture_size_y)
    end
  end
end