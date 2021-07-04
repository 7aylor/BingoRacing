function love.load()
    Object = require("classic")
    input = require("input")
    require("entities")
    entities = Entities()
    world = require("world")
    debug = false
end

function love.update(dt)
    entities:update(dt)
    world:update(dt)
end

function love.draw()
    entities:draw()
end

function love.keypressed(key)
    input.keypressed(key)
end

function love.keyreleased(key)
    input.keyreleased(key)
end