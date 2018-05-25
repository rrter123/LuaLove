local map = 
{
  { 101, 101, 101, 101, 101, 101, 101, 101 },
  { 101, 100, 100, 100, 100, 100, 100, 101 },
  { 101, 100, 100, 100, 100, 100, 100, 101 },
  { 101, 100, 100, 100, 100, 100, 100, 101 },
  { 101, 100, 100, 100, 100, 100, 100, 101 },
  { 101, 100, 100, 100, 100, 100, 100, 101 },
  { 101, 100, 100, 100, 100, 100, 100, 101 },
  { 101, 100, 100, 100, 100, 100, 100, 101 },
  { 101, 101, 101, 101, 101, 101, 101, 101 }
}

-- The main file reads the array, adds "img" to the number and draws the image from below
-- The last digit is 0 if the tile is walk-through and 1 if it's a wall, or an obstacle, for an example 100 is walk-through
-- The middle digit is the number of texture, we can have 10 different textures with the same properties
-- The first digit informs about the map number, After the first nine it will become a two digit number
-- !Notice there shouldn't be a map 0, as Lua would interpret the number and the texture names would have to be changed accordingly 
-- (001 would have to be just 1.jpg)

map["img100"] = love.graphics.newImage("maps/100.jpg")
map["img101"] = love.graphics.newImage("maps/101.jpg")

return map