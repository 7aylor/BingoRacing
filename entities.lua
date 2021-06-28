require("entities/background")
require("entities/car")
require("entities/barrel")
local screen_width = love.graphics:getWidth()
local screen_height = love.graphics:getHeight()

entities = {
    Background(),
    Car(screen_width / 2, screen_height - 50),
    Barrel(screen_width / 2, screen_height - 400, "red"),
    Barrel(screen_width / 3 + 20, 200),
    Barrel(screen_width / 2 + 10, 200),
    Barrel(2 * screen_width / 3, 200),
    Barrel(screen_width / 2 + 40, 140),
    Barrel(screen_width / 3 + 50, 140),
}

return entities