require("entities/background")
require("entities/car")
require("entities/barrel")
require("entities/boundary")
local screen_width = love.graphics:getWidth()
local screen_height = love.graphics:getHeight()
local boundary_width = 10

entities = {
    Background(),
    Boundary(-boundary_width,0, boundary_width,screen_height), --left
    Boundary(screen_width,0, boundary_width,screen_height), --right
    Boundary(0,-boundary_width, screen_width,boundary_width), --top
    Boundary(0,screen_height -boundary_width, screen_width,boundary_width), --bottom

    Car(screen_width / 2, screen_height - 50),
    Barrel(screen_width / 2, screen_height - 400, "red"),
    Barrel(screen_width / 3 + 20, 200),
    Barrel(screen_width / 2 + 10, 200),
    Barrel(2 * screen_width / 3, 200),
    Barrel(screen_width / 2 + 40, 140),
    Barrel(screen_width / 3 + 50, 140)
}

return entities