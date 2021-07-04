function love.load()
    Object = require("classic")
    input = require("input")
    world = require("world")
    require("entities")
    require("uiManager")

    debug = true
    currentGameState = "playing"
    previousGameState = "playing"
    screen_width = love.graphics:getWidth()
    screen_height = love.graphics:getHeight()
    paused = false

    entities = Entities()
    ui = UIManager()
end

function love.update(dt)
    if not paused then
        entities:update(dt)
        world:update(dt)
    end
end

function love.draw()
    entities:draw()
    ui:draw(entities)
end

function love.keypressed(key)
    input.keypressed(key)
end

function love.keyreleased(key)
    input.keyreleased(key)
end