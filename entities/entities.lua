require("entities/background")
require("entities/car")
require("entities/ball")
require("entities/boundary")
require("entities/hole")

require("entities/obstacle")
require("managers/uiManager")
require("managers/courseManager")

Entities = Object.extend(Object)

function Entities:new()
    ui = UIManager()
    courseManager = CourseManager()

    self.baseObjects = {}
    self.obstacles = {}
    self.ball = nil
    self.hole = nil
    self.car = nil
    self.results = {} --used to keep track of scores
    self:loadLevel()
end

function Entities:update(dt)
    print(#love.handlers)

    for i,v in ipairs(self.baseObjects) do
        v:update(dt)
    end
    for i,v in ipairs(self.obstacles) do
        v:update(dt)
    end

    self.hole:update(dt)
    self.ball:update(dt)
    self.car:update(dt)

    if self.ball.inHole then
        local thisHoleTime = string.format("%.2f", self.car.time)

        local holeScores = {
            level = "Hole" .. currentHole,
            hits = self.car.hits,
            time = thisHoleTime
        }

        table.insert(self.results, holeScores)

        if currentHole == 3 then
            currentGameState = "endOfRound"
        else
            currentGameState = "endOfLevel"
        end
        paused = true
    end
end

function Entities:draw()
    love.graphics.translate(-self.car.body:getX() + screen_width / 2, -self.car.body:getY() + screen_height / 2)

    for i,v in ipairs(self.baseObjects) do
        v:draw()
    end
    for i,v in ipairs(self.obstacles) do
        v:draw()
    end
    self.hole:draw()
    self.ball:draw()
    self.car:draw()
    ui:draw(self.car)
end


function Entities:clearLevel()

    for i,v in ipairs(self.baseObjects) do
        if v:is(Obstacle) then
            v:destroy()
        end
    end

    --delete physics entities
    for i,v in ipairs(self.obstacles) do
        v:destroy()
    end
    
    -- self.hole:destroy()
    if self.ball ~= nil then self.ball:destroy() end
    if self.hole ~= nil then self.hole:destroy() end
    if self.car ~= nil then self.car:destroy() end

    self.obstacles = {}
    self.hole = nil
    self.ball = nil
    self.car = nil
end

function Entities:loadLevel()
    self:clearLevel()
    -- currentHole = 8
    
    if currentHole == 1 then
        self:getCurrentEntities()
    elseif currentHole == 2 then
        courseManager:goToNextHole()
        self:getCurrentEntities()

    elseif currentHole == 3 then
        currentHole = 1
        self:loadLevel()
    end
end

function Entities:getCurrentEntities()
    self.baseObjects = courseManager.current_map--courseManager.getCurrentMapObjects()
    self.obstacles = courseManager.current_obstacles--courseManager.getCurrentObstacles()
    self.car = courseManager.current_car--courseManager.getCurrentCar()
    self.hole = courseManager.current_hole--courseManager.getCurrentHole()
    self.ball = courseManager.current_ball--courseManager.getCurrentBall(self.hole)
end