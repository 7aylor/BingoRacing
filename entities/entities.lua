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
    local boundary_width = 10
    -- HOLE_SCALE = 1
    ui = UIManager()
    courseManager = CourseManager()

    self.baseObjects = {
        -- Background(),
        -- Boundary(-boundary_width,0, boundary_width,screen_height), --left
        -- Boundary(screen_width,0, boundary_width,screen_height), --right
        -- Boundary(0,-boundary_width, screen_width,boundary_width), --top
        -- Boundary(0,screen_height, screen_width,boundary_width), --bottom
    }
    self.obstacles = {}
    self.ball = nil
    self.hole = nil
    self.car = nil
    self.results = {} --used to keep track of scores
    self:loadLevel()
end

function Entities:update(dt)
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
        local thisLevelTime = string.format("%.2f", self.car.time)

        local levelScores = {
            level = "level" .. currentLevel,
            hits = self.car.hits,
            time = thisLevelTime
        }

        table.insert(self.results, levelScores)

        if currentLevel == 3 then
            currentGameState = "win"
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
    -- currentLevel = 8
    
    if currentLevel == 1 then
        self:getCurrentEntities()
    elseif currentLevel == 2 then
        courseManager:goToNextHole()
        self:getCurrentEntities()

    elseif currentLevel == 3 then
        currentLevel = 1
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