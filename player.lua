local love = require ("love")

local player = {}

player.person_image = love.graphics.newImage("flower.png")
player.player_x = 2 -- < texture_size_x
player.player_y = 2 -- < texture_size_y
player.atk = 1
player.def = 1
player.hp = 10
player.level = 1
player.inv = 0

function player.inv_draw()
  love.graphics.rectangle( "fill", 0, 0, 1920/2, 1080/2 )
end

return player