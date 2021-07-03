function love.load()
    Object = require("classic")
    input = require("input")
    entities = require("entities")
    world = require("world")
    debug = true
end

function love.update(dt)
    for i=1,#entities do
        entities[i]:update(dt)
    end
    world:update(dt)
end

function love.draw()
    for i=1,#entities do
        entities[i]:draw()
    end
end

function love.keypressed(key)
    input.keypressed(key)
end

function love.keyreleased(key)
    input.keyreleased(key)
end