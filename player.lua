local love = require ("love")
local math = require("math")


local player = {
  {type = "leaf", atk = 2, img = love.graphics.newImage("weapons/leaf-icon-20.png")},
  {type = "pollen", damage = "fire", atk = 5, img = love.graphics.newImage("weapons/bullet-png-7.png")},
  {type = "petal", def = 3, img = love.graphics.newImage("weapons/flower-icon--icon-search-engine-6.png")},
  {type = "leaf", atk=3, img = love.graphics.newImage("weapons/flower-icon--icon-search-engine-17.png")}
  }
width, height = love.window.getDesktopDimensions()

player.person_image = love.graphics.newImage("flower.png")
player.player_x = 2 -- < texture_size_x
player.player_y = 2 -- < texture_size_y
player.top = 4 -- !!!!!!Amount of stuff
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
  love.graphics.setColor( 0.9, 1, 0.9, 0.4 )
  love.graphics.rectangle( "fill", 100*(player.leaf_eq-1%player.invspace), 100*(math.floor(player.leaf_eq/player.invspace)), 100, 100)
  love.graphics.rectangle( "fill", 100*(player.pollen_eq-1%player.invspace), 100*(math.floor(player.pollen_eq/player.invspace)), 100, 100)
  love.graphics.rectangle( "fill", 100*(player.petal_eq-1%player.invspace), 100*(math.floor(player.petal_eq/player.invspace)), 100, 100)
  
  love.graphics.setColor( 1, 1, 1, 1 )
  for i, val in ipairs(player) do
    love.graphics.draw(val.img, 100*(i-1%player.invspace), 100* (math.floor(i/player.invspace)))
    if i == player.pos then
      love.graphics.rectangle("line", 100*(i-1%player.invspace), 100*(math.floor(i/player.invspace)), 100, 100)
    end
  end
  draw_player_info()
  draw_item_info()
end

function player.found_chest()
  math.randomseed(os.time())
  math.random(2)
  local money = math.random(20)
  print (money)
  player.stats.money = player.stats.money + money*10
end
function player.battle(number)
  --[[
  draw_background()
  love.graphics.setColor( 0.9, 1, 0.9, 0.4 )
  local enemy = {}
  if number == 12 then
    enemy.enemy_image = love.graphics.newImage("entities/enemies/pisilohe10.png")
    enemy.stats = {
      atk = player.stats.atk,
      def = player.stats.def,
      hp = math.floor(player.stats.hp*1.25),
      level = player.stats.level}
  else
    enemy.enemy_image = love.graphics.newImage("entities/enemies/pisilohe12.png")
    enemy.stats = {
      atk = math.floor(player.stats.atk*1.25),
      def = math.floor(player.stats.def*1.25),
      hp = math.floor(player.stats.hp*1.75),
      level = player.stats.level+1}
  end
  --]]  
    
  
  
  return false 
  
end


return player