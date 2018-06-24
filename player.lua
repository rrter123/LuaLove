local love = require ("love")
local sh = require("shop")
math.randomseed(os.time())
math.random(2)

local player = {
  {type = "leaf", atk = 2, img = love.graphics.newImage("weapons/leaf-icon-20.png"), price = 2},
  {type = "pollen", damage = "fire", atk = 5, img = love.graphics.newImage("weapons/bullet-png-7.png"), price = 2},
  {type = "petal", def = 3, img = love.graphics.newImage("weapons/flower-icon--icon-search-engine-6.png"), price = 2}
  }
width, height = love.window.getDesktopDimensions()
player.shop = sh
player.person_image = love.graphics.newImage("flower.png")
player.player_x = 2 -- < texture_size_x
player.player_y = 2 -- < texture_size_y
--player.top = 11 -- !!!!!!Amount of stuff
player.stats = {
atk = 1,
def = 1,
hp = 10,
maxhp = 10,
level = 1,
money = 10,
xp = 0,
maxxp = 10
}
player.leaf_eq = 1
player.pollen_eq = 2
player.petal_eq=3
player.dead = 0

player.pos = 1


player.invspace = math.floor(width/200)
local fontheight = 25
local font = love.graphics.newFont("font/trench100free.ttf", fontheight)
love.graphics.setFont(font)

local enemy = {}

local function draw_background_inv()
  love.graphics.setColor( 0.9, 0.9, 0.9, 1 )
  love.graphics.rectangle( "fill", 0, 0, width/2, height )
  love.graphics.setColor( 0.5, 0.5, 0.5, 1 )
  love.graphics.rectangle( "fill", width/2, 0, width/2, height/2 )
  love.graphics.setColor( 0.6, 0.6, 0.6, 1 )
  love.graphics.rectangle( "fill", width/2, height/2, width/2, height/2 )
  love.graphics.setColor( 1, 1, 1, 1 )
end

local function draw_background_battle()
  love.graphics.setColor( 0.9, 0.9, 0.9, 1 )
  love.graphics.rectangle( "fill", 0, 0, width/2, height )
  love.graphics.setColor( 0.6, 0.6, 0.6, 1 )
  love.graphics.rectangle( "fill", width/2, 0, width/2, height )
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

local function draw_player_and_enemy_info()
  local lineheight = 0
  love.graphics.draw(player.person_image, (width/4)-50, 10)
  love.graphics.draw(enemy.enemy_image, (3*width/4)-50, 10)
  love.graphics.setColor( 0, 0, 0, 1 )
  for key, value in pairs(player.stats) do 
    if key ~= 'money' and key ~= 'xp' and key ~= 'maxxp' and key ~= 'maxhp' then
      if key == 'def' then
        love.graphics.print(key..": "..value.." (+"..player[player.petal_eq].def..")", (width/4)-50, height/2+10+lineheight)
      else
      love.graphics.print(key..": "..value, (width/4)-50, height/2+10+lineheight)
    end
      lineheight = lineheight + fontheight 
    end
  end
  lineheight = 0
  for key, value in pairs(enemy.stats) do
    if key ~= 'money' and key ~= 'init_hp' then
      love.graphics.print(key..": "..value, (3*width/4)-50, height/2+10+lineheight)
      lineheight = lineheight + fontheight 
    end
  end
  love.graphics.setColor( 1, 1, 1, 1 )
end

local function draw_item_info(off1, off2)
  if off1 == nil then off1, off2= 0,0 end
  local lineheight = 0
  for key, value in pairs(player[player.pos]) do
    if key~="img" then
      love.graphics.print(key..": "..value, off1+width/2+10, off2+10+lineheight)
      lineheight = lineheight + fontheight 
    end
  end
end
local function draw_inventory()
  love.graphics.setColor( 0.9, 1, 0.9, 0.4 )
  love.graphics.rectangle( "fill", 100*((player.leaf_eq-1)%player.invspace), 100*(math.floor((player.leaf_eq-1)/player.invspace)), 100, 100)
  love.graphics.rectangle( "fill", 100*((player.pollen_eq-1)%player.invspace), 100*(math.floor((player.pollen_eq-1)/player.invspace)), 100, 100)
  love.graphics.rectangle( "fill", 100*((player.petal_eq-1)%player.invspace), 100*(math.floor((player.petal_eq-1)/player.invspace)), 100, 100)
  love.graphics.setColor( 1, 1, 1, 1 )
  for i, val in ipairs(player) do
    love.graphics.draw(val.img, 100*((i-1)%player.invspace), 100* (math.floor((i-1)/player.invspace)))
    if i == player.pos then
      love.graphics.rectangle("line", 100*((i-1)%player.invspace), 100*(math.floor((i-1)/player.invspace)), 100, 100)
    end
  end
end

local function draw_battle()
  love.graphics.setColor( 1, 1, 1, 1 )
  love.graphics.rectangle( "fill", width/4, height - height/5, width/2, height/10)
  love.graphics.setColor( 0, 0, 0 )
  love.graphics.print("[1] LEAF ATTACK".." (+ "..player[player.leaf_eq].atk..") ".."[2] POLLEN ATTACK (+ ".. player[player.pollen_eq].atk..")", width/4 + width/12, height-height/6)
  love.graphics.setColor( 1, 1, 1, 1 )
end

function player.inv_draw()
  draw_background_inv()
  draw_inventory()
  draw_player_info()
  draw_item_info()
end
function player.shop_draw()
  draw_background_inv()
  draw_inventory()
  player.shop.draw_inv(width, height)
  draw_item_info(0, height/2)
  local lineheight = 0
  for key, value in pairs(player.shop[player.shop.pos]) do
    if key~="img" then
      love.graphics.print(key..": "..value, width*3/4+10, height/2+10+lineheight)
      lineheight = lineheight + fontheight 
    end
  end
  love.graphics.setColor( 0, 0, 0, 1 )
  love.graphics.print(player.stats.money, 0, height-fontheight)
  love.graphics.setColor( 1, 1, 1, 1 )
end
function player.found_chest()
  local money = math.random(20)
  player.stats.money = player.stats.money + money*10
end
function player.gen_enemy(number)
  local damage = { "fire", "water", "earth", "wind" }
  if number == 12 then --weak enemy
    enemy.enemy_image = love.graphics.newImage("entities/enemies/goat1.png")
    enemy.stats = {
      level = math.random(player.stats.level),
      hp = math.random(player.stats.maxhp),
      money = math.random(player.stats.level)*100,
      atk = math.random(player.stats.atk),
      def = math.random(player.stats.def)}
  else --stronger enemy
    enemy.enemy_image = love.graphics.newImage("entities/enemies/goat2.png")
    enemy.stats = {
      level = math.random(player.stats.level*2),
      hp = math.random(player.stats.maxhp*2),
      money = math.random(player.stats.level*2)*100,
      atk = math.random(player.stats.atk*2),
      def = math.random(player.stats.def*2)}
  end  
  enemy.dead = 0
  enemy.stats.init_hp = enemy.stats.hp
  enemy.weakness = damage[math.random(4)]  
end
function player.battle_draw()
  draw_background_battle()
  draw_player_and_enemy_info()
  draw_battle()
end

local function battle_loss()
  love.graphics.setColor( 1, 1, 1, 1 )
  love.graphics.print( "YOU LOSE", width/2-10, height/2-10)
  love.graphics.print("Press Escape to Continue", width/2, height- height/10)
end

local function battle_win()
  love.graphics.setColor( 1, 1, 1, 1 )
  love.graphics.print( "YOU WIN", width/2-10, height/2-10)
  love.graphics.print("Press Escape to Continue", width/2, height- height/10)
end

function player.check_hp()
  if player.stats.hp <= 0 then
    love.draw = battle_loss
    player.dead = 1
    player.stats.xp = 0
    player.stats.money = 0
  end
end
function player.new_life()
  player.stats.hp = player.stats.level*10
  player.stats.dead = 0
end
function player.level_up()
  player.stats.xp = player.stats.xp + enemy.stats.init_hp
  if player.stats.xp > player.stats.maxxp then
    player.stats.level = player.stats.level + 1
    player.stats.atk = player.stats.atk + 1
    player.stats.def = player.stats.def + 1
    player.stats.xp = 0
    player.stats.maxxp = math.floor(player.stats.maxxp*1.5)
    player.stats.maxhp = player.stats.level*10
    player.stats.hp = player.stats.maxhp
    player.stats.money = player.stats.money + enemy.stats.money
  else
    player.stats.hp = player.stats.maxhp
  end
end
function player.battle_moves(status)
  local attack = player.stats.atk
  local defense = player[player.petal_eq].def + player.stats.def
  if status == 1 then --leaf attack
    attack = player[player.leaf_eq].atk + player.stats.atk
  elseif status == 2 then --pollen attack
    local pollen_type = player[player.pollen_eq].damage
    if pollen_type == enemy.weakness then
      attack = player[player.pollen_eq].atk + player.stats.atk
    end
  end
  local diff = attack - enemy.stats.def
  if diff > 0 then
    enemy.stats.hp = enemy.stats.hp - diff
  else
    player.stats.hp = player.stats.hp + diff
  end
  if enemy.stats.hp > 0 then --counterattack
    diff = enemy.stats.atk - defense
    if diff > 0 then
      player.stats.hp = player.stats.hp - enemy.stats.atk
    else
      enemy.stats.hp = enemy.stats.hp + diff
    end
  end
  if enemy.stats.hp <= 0 then
    love.draw = battle_win
    enemy.dead = 1
    player.level_up()
  end
  player.check_hp()  

end

function player.check_status()
  if player.dead == 1 then
    return -1
  elseif enemy.dead == 1 then
    return 1
  end
  return 0
end



--function player.shop()
 -- player.shop.randomize(player.stats.level)
--end
function player.equip()
  local t = player[player.pos]["type"]
  if t == "leaf" then
    player.leaf_eq = player.pos
  end
  if t == "pollen" then
    player.pollen_eq = player.pos
  end
  if t == "petal" then
    player.petal_eq = player.pos
  end
end
function player.sell_buy(mode)
  if mode == 2 then
    if (player.pos~=player.leaf_eq) and (player.pos~=player.petal_eq) and (player.pos~=player.pollen_eq) then
      if player.pollen_eq>player.pos then player.pollen_eq = player.pollen_eq-1 end
      if player.leaf_eq>player.pos then player.leaf_eq = player.leaf_eq-1 end
      if player.petal_eq>player.pos then player.petal_eq = player.petal_eq-1 end
      player.stats.money = player.stats.money + player[player.pos]["price"]
      table.remove(player, player.pos)
      player.pos=1
    end
  else
    if player.stats.money >= player.shop[player.shop.pos].price then
      player.stats.money = player.stats.money-player.shop[player.shop.pos].price
      table.insert(player,player.shop[player.shop.pos])
    end
  end
end
return player