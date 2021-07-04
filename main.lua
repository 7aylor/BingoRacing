function love.load()
    Object = require("classic")
    input = require("input")
    world = require("world")
    require("levelManager")
    require("entities")
    require("uiManager")

    debug = true
    currentGameState = "playing"
    previousGameState = "playing"
    currentLevel = 1
    levelJustChanged = false
    screen_width = love.graphics:getWidth()
    screen_height = love.graphics:getHeight()
    paused = false

    entities = Entities()
    ui = UIManager()
    levelManager = LevelManager()
end

function love.update(dt)
    if not paused then
        levelManager:update(entities)
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