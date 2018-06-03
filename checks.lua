math = require("math")
checks = {}

function checks.can_go_down(posx, posy, currentmap)
  return currentmap[posy+1][posx]%10==0
end
function checks.can_go_up(posx, posy, currentmap)
  return currentmap[posy-1][posx]%10==0
end
function checks.can_go_left(posx, posy, currentmap)
  return currentmap[posy][posx-1]%10==0
end
function checks.can_go_right(posx, posy, currentmap)
  return currentmap[posy][posx+1]%10==0
end
function checks.around(posx, posy, currentmap)
  if currentmap[posy+1][posx]%10>1 then return currentmap[posy+1][posx] end
  if currentmap[posy-1][posx]%10>1 then return currentmap[posy-1][posx] end
  if currentmap[posy][posx+1]%10>1 then return currentmap[posy][posx+1] end
  if currentmap[posy][posx-1]%10>1 then return currentmap[posy][posx-1] end
  return 0 
end
return checks