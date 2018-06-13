--local math = require("math")
math.randomseed(os.time())
local shop = {
  {type = "pollen", damage = "fire", atk = 5, img = love.graphics.newImage("weapons/bullet-png-7.png"), price = 5},
  {type = "petal", def = 3, img = love.graphics.newImage("weapons/flower-icon--icon-search-engine-6.png"), price = 5},
  {type = "leaf", atk=3, img = love.graphics.newImage("weapons/flower-icon--icon-search-engine-17.png"), price = 5}
}
local damage = {
  "fire", "water", "earth", "wind"
  }
shop.pos = 1
function shop.randomize(lvl)
  for key, val in ipairs(shop) do
    shop[key]["price"] = math.random(math.floor(lvl*2), math.floor(lvl*3))
    if val.type == "pollen" then
      shop[key]["damage"] = damage[math.random(1, #damage)]
      shop[key]["atk"] = 5 + math.random(math.floor(lvl*0.8), math.floor(lvl*1.2))
    end
    if val.type == "petal" then
      shop[key]["def"] = 5 + math.random(math.floor(lvl), math.floor(lvl*1.5))
    end
    if val.type == "leaf" then
      shop[key]["atk"] = 5 + math.random(math.floor(lvl), math.floor(lvl*1.5))
    end 
  end
end

function shop.draw_inv(width, height, pos)
  for i, val in ipairs(shop) do
    love.graphics.draw(val.img, width/2+100*((i-1)%math.floor(width/200)), 100* (math.floor((i-1)/math.floor(width/200))))
  
    if i == shop.pos then
      love.graphics.rectangle("line", width/2+100*((i-1)%math.floor(width/200)), 100*(math.floor((i-1)/math.floor(width/200))), 100, 100)
    end
  end
end
return shop