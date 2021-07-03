require("entities/background")
require("entities/car")
require("entities/barrel")
require("entities/boundary")
require("entities/goal")
local screen_width = love.graphics:getWidth()
local screen_height = love.graphics:getHeight()
local boundary_width = 10
local GOAL_SCALE = 0.5

entities = {
    Background(),
    Boundary(-boundary_width,0, boundary_width,screen_height), --left
    Boundary(screen_width,0, boundary_width,screen_height), --right
    Boundary(0,-boundary_width, screen_width,boundary_width), --top
    Boundary(0,screen_height -boundary_width, screen_width,boundary_width), --bottom

    Goal(2 * screen_width / 3, screen_height - 600, 0, GOAL_SCALE),
    Goal(screen_width / 3, screen_height - 600, 0, GOAL_SCALE),
    Car(screen_width / 2, screen_height - 50),
    Barrel(2 * screen_width / 3, screen_height - 400, "red"),
    Barrel(screen_width / 3, screen_height - 400, "red"),
    -- Barrel(screen_width / 3 + 20, 200),
    -- Barrel(screen_width / 2 + 10, 200),
    -- Barrel(2 * screen_width / 3, 200),
    -- Barrel(screen_width / 2 + 40, 140),
    -- Barrel(screen_width / 3 + 50, 140),
}

return entities