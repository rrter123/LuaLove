local current_map = require("maps/map_1")
local current_entities=require("maps/entities_1")
--local math = require("math")
local check = require("checks")
local maps = require("maps")
local socket = require("socket")
local player = require("player")
--local functions = require("functions")

function sleep(sec)
    socket.select(nil, nil, sec)
end
width, height = love.window.getDesktopDimensions()
success = love.window.setMode(width, height)
love.keyboard.setKeyRepeat(false)

local texture_size_x = 100
local texture_size_y = 100

local offset_x = -width/2+player.player_x*100-texture_size_x/2
local offset_y = -height/2+player.player_y*100-texture_size_y/2

function set_offset()
  offset_x = -width/2+player.player_x*100-texture_size_x/2
  offset_y = -height/2+player.player_y*100-texture_size_y/2
end

--checks if map already exists
function exists(path, number)
   local ok, err, code = os.rename(path..'.lua', path..'.lua')
   if not ok then
      if code == 13 then
        print("file exists")
         -- Permission denied, but it exists
      elseif code == 2 then --map doesn't exists, we have to generate it
          maps.gen_map(30,30,(math.floor((number/100)%10)+1),current_map["x"..number],current_map["y"..number])
      end
    end
end


function load_map(number)
  local path = current_map["path"..number]
  local path_e = current_entities["path"..number]
  exists(path,number)
  player.player_x = current_map["x"..number]
  player.player_y = current_map["y"..number]
  current_map = require(path)
  if number/100 > 100 and number%100 ~= 12 then
      maps.update_entities(current_map, math.floor((number/100)%10)+1, player.player_x, player.player_y)
  end
  current_entities = require(path_e)
  set_offset()
end


local mode = 0
-- 0 default mode
-- 1 inventory  mode
-- 2 shop mode
-- 3 sell mode
-- 4 battle mode

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then --Pressing Escape closes the window and then schedules the program to close
    if mode == 1 or mode == 2 or mode == 3 then 
      love.draw = functions.draw
      mode = 0
    elseif mode == 4 then
      local bat_end = player.check_status()
      if bat_end == -1 then
        current_map = require("maps/map_1")
        current_entities = require("maps/entities_1")
        player.player_x = 2
        player.player_y = 2
        set_offset()
        love.draw = functions.draw
        mode = 0
        player.new_life()
      elseif bat_end == 1 then
        love.draw = functions.draw
        mode = 0
      end
    else
      love.window.close()
      love.event.quit()
    end
  end
  if key == "e" then
    if mode == 1 then
      player.equip()
    
    elseif mode == 2 or mode == 3 then
      player.sell_buy(mode)
    else
      local test = checks.around(player.player_x, player.player_y, current_map)
      if test ~= 0 then
        if test%10 == 2 then
          load_map(test)
        end
      else      
        local y, x = 0
        test, y, x = checks.around(player.player_x, player.player_y, current_entities)
        if test == 32 then
          player.found_chest()
          current_entities[y][x] = 0
        elseif test == 22 or test == 12 then
          mode = 4
          player.gen_enemy(test)
          love.draw = player.battle_draw
          current_entities[y][x] = 0
        end 
      end
      if test%10 == 3 then
          --SHOP
          mode = 2
          player["shop"].randomize(player.stats.level)
          love.draw = player.shop_draw
      end

    end
  end
  if key == "i" then
    if mode == 0 then
      love.draw = player.inv_draw
      mode = 1
    elseif mode == 1 then
      love.draw = functions.draw
      mode = 0
    end
  end
  if key == "z" then
    if mode == 3 then
      mode = 2
    else
      mode = 3
    end
  end
  if (key == 'a' or key == 'left') and (mode == 1 or mode == 2 or mode == 3) then
    if mode == 1 or mode == 2 then
      player.pos = player.pos - 1
      if player.pos <= 0 then
        player.pos = #player
      end
    else 
      player.shop.pos = player.shop.pos - 1
      if player.shop.pos <= 0 then
        player.shop.pos = #player.shop
      end
    end
  end
  if (key == 'd' or key == 'right') and (mode == 1 or mode == 2 or mode == 3)then
    if mode == 1 or mode == 2 then
      player.pos = player.pos + 1
      if player.pos >= #player+1 then
        player.pos = 1
      end
    else
      player.shop.pos = player.shop.pos + 1
      if player.shop.pos >= #player.shop+1 then
        player.shop.pos = 1
      end
    end
  end
  if key == '1' and mode == 4 then
    player.battle_moves(1)
  end
  if key == '2' and mode == 4 then
    player.battle_moves(2)
  end
end


functions = {}

local function draw_map()
  --textures drawing begin
  for y, row in ipairs(current_map) do
    for x, value in ipairs(row) do
      local key = "img"..value
      --print (x,y,value)
      love.graphics.draw(current_map[key], ((x-1)*texture_size_x)-offset_x, ((y-1)*texture_size_y)-offset_y)
    end
  end 
  for y, row in ipairs(current_entities) do
    for x, value in ipairs(row) do
      if value ~= 0 then
        local key = "img"..value
        --print (x,y,value)
        love.graphics.draw(current_entities[key], ((x-1)*texture_size_x)-offset_x, ((y-1)*texture_size_y)-offset_y)
      end
    end
  end 
  --textures drawn. Motion is simulated by changing the place in which texture drawing begins.
end

function functions.draw()
  draw_map()
  --avatar drawing
  local window_width, window_height = love.window.getMode()
  love.graphics.draw(player.person_image, window_width/2-texture_size_x/2, window_height/2-texture_size_y/2)
  --avatar drawn
end



function functions.update(dt)
  local sleep_time = 0.2
   if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) 
   and check.can_go_up(player.player_x, player.player_y, current_map)
   and check.can_go_up(player.player_x, player.player_y, current_entities)
   and mode == 0
   then
    offset_y =offset_y - 100
    player.player_y = player.player_y - 1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) 
  and check.can_go_down(player.player_x, player.player_y, current_map)
  and check.can_go_down(player.player_x, player.player_y, current_entities)
  and mode == 0
  then
    offset_y =offset_y + 100
    player.player_y =player.player_y +1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) 
  and check.can_go_left(player.player_x, player.player_y, current_map)
  and check.can_go_left(player.player_x, player.player_y, current_entities)
  and mode == 0
  then
    offset_x =offset_x - 100
    player.player_x =player.player_x -1
    love.draw()
    --sleep(sleep_time)
  end
  if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) 
  and check.can_go_right(player.player_x, player.player_y, current_map) 
  and check.can_go_right(player.player_x, player.player_y, current_entities)
  and mode == 0
  then
    offset_x =offset_x + 100
    player.player_x =player.player_x +1
    love.draw()
    --sleep(sleep_time)
  end
  sleep(sleep_time)
end

love.update = functions.update
love.draw = functions.draw
