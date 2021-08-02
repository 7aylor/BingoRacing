function love.load()
    Object = require("libs/classic")
    input = require("managers/inputManager")
    world = require("world")
    imageManager = require("managers/imageManager")
    common = require("common")
    require("managers/courseManager")
    require("entities/entities")
    require("utilities")
    require("events")
    -- local lume = require("libs/lume")

    -- local testLevel = {
    --     name = "course1",
    --     holes = {
    --         hole1 = {
    --             car = {
    --                 x = 100,
    --                 y = 200,
    --                 rotation = 0.3456
    --             },
    --             ball = {
    --                 x = 100,
    --                 y = 500
    --             },
    --             hole = {
    --                 x = 400,
    --                 y = 600
    --             }
    --         }
    --     }
    -- }

    -- local levelData = lume.serialize(testLevel)
    -- love.filesystem.write("course1.txt", levelData)

    -- local course1 = love.filesystem.read("course1.txt")
    -- local course1Data = lume.deserialize(course1)
    -- print(course1Data.holes.hole1.hole.x)


    debug = true
    currentGameState = "playing"
    previousGameState = "playing"
    screen_width = love.graphics:getWidth()
    screen_height = love.graphics:getHeight()
    paused = false

    entities = Entities()
    courseManager = CourseManager()

    song = love.audio.newSource("sfx/Neon Laser Horizon.mp3", "stream")
    song:setLooping(true)

    -- if not debug then
    --     song:play()
    -- end
end

function love.update(dt)
    if not paused then
        --courseManager:update(entities)
        entities:update(dt)
        world:update(dt)
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.1,0.5,0.7,1)
    entities:draw()
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

function math.clamp(low, n, high)
    return math.min(math.max(low, n), high)
end