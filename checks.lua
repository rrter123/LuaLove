math = require("math")
checks = {}

function checks.can_go_down(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed)
  local check1, check2 = false, false
  local player_position_x = width/2-player_size_x/2+offset_x
  local player_position_y = height/2-player_size_y/2+offset_y+character_speed
  if current_map[math.floor((player_position_y+player_size_y)/texture_size_y)+1]
  [math.floor((player_position_x+texture_size_x-player_size_x)/texture_size_x)+1] %10 == 0 then
    check1 = true
  end
  if current_map[math.floor((player_position_y+player_size_y)/texture_size_y)+1]
  [math.floor((player_position_x+player_size_x)/texture_size_x)+1] %10 == 0 then
    check2 = true
  end
  return check1 and check2
end

function checks.can_go_up(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed)
  local check1, check2 = false, false
  local player_position_x = width/2-player_size_x/2+offset_x
  local player_position_y = height/2-player_size_y/2+offset_y-character_speed
  if current_map[math.floor((player_position_y)/texture_size_y)+1]
  [math.floor((player_position_x+texture_size_x-player_size_x)/texture_size_x)+1] %10 == 0 then
    check1 = true
  end
  if current_map[math.floor((player_position_y)/texture_size_y)+1]
  [math.floor((player_position_x+player_size_x)/texture_size_x)+1] %10 == 0 then
    check2 = true
  end
  return check1 and check2
end

function checks.can_go_left(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed)
  local check1, check2 = false, false
  local player_position_x = width/2-player_size_x/2+offset_x-character_speed
  local player_position_y = height/2-player_size_y/2+offset_y
  
  if current_map[math.floor((player_position_y+texture_size_y-player_size_y)/texture_size_y)+1]
  [math.floor(player_position_x/texture_size_x)+1] %10 == 0 then
    check1 = true
  end
  
  if current_map[math.floor((player_position_y+player_size_y)/texture_size_y)+1]
  [math.floor((player_position_x)/texture_size_x)+1] %10 == 0 then
    check2 = true
  end
  return check1 and check2
end

function checks.can_go_right(offset_x, offset_y, current_map, player_size_x, player_size_y, texture_size_x, texture_size_y, character_speed)
  local check1, check2 = false, false
  local player_position_x = width/2-player_size_x/2+offset_x+ character_speed
  local player_position_y = height/2-player_size_y/2+offset_y
  
  if current_map[math.floor((player_position_y+texture_size_y-player_size_y)/texture_size_y)+1]
  [math.floor((player_position_x+player_size_x)/texture_size_x)+1] %10 == 0 then
    check1 = true
  end
  
  if current_map[math.floor((player_position_y+player_size_y)/texture_size_y)+1]
  [math.floor((player_position_x+player_size_x)/texture_size_x)+1] %10 == 0 then
    check2 = true
  end
  return check1 and check2
end
return checks