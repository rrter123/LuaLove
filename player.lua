local love = require ("love")
local math = require("math")


local player = {
  {type = "leaf", atk = 2, img = love.graphics.newImage("weapons/leaf-icon-20.png")},
  {type = "pollen", damage = "fire", atk = 5, img = love.graphics.newImage("weapons/bullet-png-7.png")},
  {type = "petal", def = 3, img = love.graphics.newImage("weapons/flower-icon--icon-search-engine-6.png")}
  }
width, height = love.window.getDesktopDimensions()

player.person_image = love.graphics.newImage("flower.png")
player.player_x = 2 -- < texture_size_x
player.player_y = 2 -- < texture_size_y
player.top = 3 -- !!!!!!Amount of stuff
player.stats = {
atk = 1,
def = 1,
hp = 10,
level = 1,
money = 50,
xp = 0,
maxxp = 10
}
player.leaf_eq = 1
player.pollen_eq = 2
player.petal_eq=3

player.pos = 1
player.invspace = math.floor(width/200)
local fontheight = 50
local font = love.graphics.newFont("font/trench100free.ttf", 50)
love.graphics.setFont(font)

local function draw_background()
  love.graphics.setColor( 0.9, 0.9, 0.9, 1 )
  love.graphics.rectangle( "fill", 0, 0, width/2, height )
  love.graphics.setColor( 0.6, 0.6, 0.6, 1 )
  love.graphics.rectangle( "fill", width/2, 0, width/2, height/2 )
  love.graphics.setColor( 0.8, 0.8, 0.8, 1 )
  love.graphics.rectangle( "fill", width/2, height/2, width/2, height/2 )
  love.graphics.setColor( 1, 1, 1, 1 )
end

local function draw_player_info()
  local lineheight = 0
  love.graphics.setColor( 0, 0, 0, 1 )
  for key, value in pairs(player.stats) do
    love.graphics.print(key..": "..value, width/2+10, height/2+10+lineheight)
    lineheight = lineheight + fontheight 
  end
  love.graphics.setColor( 1, 1, 1, 1 )
end
local function draw_item_info()
  local lineheight = 0
  for key, value in pairs(player[player.pos]) do
    if key~="img" then
      love.graphics.print(key..": "..value, width/2+10, 10+lineheight)
      lineheight = lineheight + fontheight 
    end
  end
end

function player.inv_draw()
  draw_background()
  for i, val in ipairs(player) do
    love.graphics.draw(val.img, 100*(i-1%player.invspace), 100* (math.floor(i/player.invspace)))
  end
  draw_player_info()
  draw_item_info()
end

return player