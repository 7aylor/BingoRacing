function love.load()
    Object = require("classic")
    input = require("input")
    world = love.physics.newWorld(0,0)
    require("car")
    car = Car(300, 300)
    sky_background = love.graphics.newImage("img/unity_sky.png")
end

function love.update(dt)
    car:update(dt)
    world:update(dt)
end

function love.draw()
    --love.graphics.draw(sky_background, 0, 0)
    car:draw()
end

function love.keypressed(key)
    input.keypressed(key)
end

function love.keyreleased(key)
    input.keyreleased(key)
end