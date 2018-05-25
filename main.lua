local tempmap = require("maps/map_1")



function love.draw()
  for x, row in ipairs(tempmap) do
    for y, value in ipairs(row) do
      local key = "img"..value
      love.graphics.draw(tempmap[key], (x-1)*100, (y-1)*100)
    end
  end
end