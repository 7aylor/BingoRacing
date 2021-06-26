function love.load()
    Object = require("classic")
    world = love.physics.newWorld(0,0)
    require("car")
    player = Car(100, 100)
end

function love.update(dt)
    player:update(dt)
    world:update(dt)
end

function love.draw()
    player:draw()
end