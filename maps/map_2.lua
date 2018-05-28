local map = 
{
  { 201, 202, 202, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201 },
  { 201, 200, 200, 200, 200, 200, 201, 201, 200, 200, 200, 200, 200, 200, 201, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 201, 200, 200, 200, 200, 200, 200, 200, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 201, 200, 200, 200, 200, 201, 200, 200, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 201, 200, 200, 200, 200, 200, 200, 200, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 201, 200, 200, 200, 200, 200, 200, 200, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 201, 200, 200, 200, 200, 200, 200, 200, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 201, 201, 200, 200, 200, 200, 200, 200, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 201, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 201, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 201, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 201, 201 },
  { 201, 200, 200, 200, 201, 200, 200, 200, 200, 200, 200, 200, 200, 200, 201, 201 },
  { 201, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 201, 201 },
  { 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201 }
}
-- The main file reads the array, adds "img" to the number and draws the image from below
-- The last digit is 0 if the tile is walk-through and 1 if it's a wall, or an obstacle, for an example 200 is walk-through
-- The middle digit is the number of texture, we can have 10 different textures with the same properties
-- The first digit informs about the map number, After the first nine it will become a two digit number
-- !Notice there shouldn't be a map 0, as Lua would interpret the number and the texture names would have to be changed accordingly 
-- (001 would have to be just 1.jpg)

map["img200"] = love.graphics.newImage("maps/map_2/200.jpg")
map["img201"] = love.graphics.newImage("maps/map_2/201.jpg")
map["img202"] = love.graphics.newImage("maps/map_2/202.jpg")

map["path202"] = "maps/map_1"
map["x102"] = 2
map["y102"] = 2

return map