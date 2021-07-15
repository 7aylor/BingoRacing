function love.load()
    Object = require("libs/classic")
    input = require("managers/inputManager")
    world = require("world")
    imageManager = require("managers/imageManager")
    require("managers/levelManager")
    require("entities/entities")
    require("managers/uiManager")

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

    song = love.audio.newSource("sfx/Neon Laser Horizon.mp3", "stream")
    song:setLooping(true)

    if not debug then
        song:play()
    end
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

function math.dist(x1,y1, x2,y2) 
    return ((x2-x1)^2+(y2-y1)^2)^0.5 
end