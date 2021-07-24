require("entities/background")
require("entities/car")
require("entities/ball")
require("entities/boundary")
require("entities/hole")

require("entities/obstacle")
require("managers/uiManager")

Entities = Object.extend(Object)

function Entities:new()
    local boundary_width = 10
    HOLE_SCALE = 1
    ui = UIManager()

    self.baseObjects = {
        Background(),
        Boundary(-boundary_width,0, boundary_width,screen_height), --left
        Boundary(screen_width,0, boundary_width,screen_height), --right
        Boundary(0,-boundary_width, screen_width,boundary_width), --top
        Boundary(0,screen_height, screen_width,boundary_width), --bottom
    }
    self.obstacles = {}
    --self:createConeBoundary()

    self.ball = nil
    self.hole = nil
    self.car = nil--Car(screen_width / 3, screen_height - 100)
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

        if currentLevel == 5 then
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

    --currentLevel = 1

    if currentLevel == 1 then
        self.hole = Hole(screen_width / 2 + 14, screen_height - 600, 0, HOLE_SCALE)
        self.ball = Ball(screen_width / 2, screen_height - 400, self.hole)
        self.car = Car(screen_width / 2, screen_height - 100, 0)
    elseif currentLevel == 2 then
        self.hole = Hole(screen_width - 200, screen_height / 2 - 8, math.pi / 2, HOLE_SCALE)
        self.ball = Ball(300, screen_height / 2, self.hole)
        self.car = Car(100, screen_height / 2, -math.pi / 2)
    elseif currentLevel == 3 then
        self.hole = Hole(screen_width - 50, 50, math.pi / 3.5, HOLE_SCALE)
        self.ball = Ball(360, screen_height - 220, self.hole)
        self.car = Car(50, screen_height - 50, -math.pi / 2.9)
    -- elseif currentLevel == 4 then

    --     --first column from bottom to top
    --     for i=1,50 do
    --         table.insert(self.obstacles, Obstacle(screen_width / 3, screen_height - ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale , cone_scale, 0, imageManager.cone))
    --     end

    --     --second column from top to bottom
    --     for i=1,50 do
    --         table.insert(self.obstacles, Obstacle(2 * screen_width / 3, ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale , cone_scale, 0, imageManager.cone))
    --     end

    --     --top corners
    --     table.insert(self.obstacles, Obstacle(15, 10, 0.5, math.pi/3, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(screen_width - 15, 10, 0.5, -math.pi/3, imageManager.cornerBumper))
    --     --bottoms corners
    --     table.insert(self.obstacles, Obstacle(15, screen_height - 10, 0.5, -math.pi/3, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(screen_width - 15, screen_height - 10, 0.5, math.pi/3, imageManager.cornerBumper))
    --     --left third wall
    --     table.insert(self.obstacles, Obstacle(screen_width /3 - 15, screen_height - 5, 0.5, math.pi/3, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(screen_width /3 + 15, screen_height - 5, 0.5, -math.pi/3, imageManager.cornerBumper))
    --     --right third wall
    --     table.insert(self.obstacles, Obstacle(2 * screen_width /3 - 15, 10, 0.5, -math.pi/3, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(2 * screen_width /3 + 15, 10, 0.5, math.pi/3, imageManager.cornerBumper))

    --     self.hole = Hole(screen_width - 200, 150, 0, HOLE_SCALE)
    --     self.ball = Ball(250, 300, self.hole)
    --     self.car = Car(100, screen_height - 100, 0)

    --     --first column from bottom to top
    --     -- for i=1,17 do
    --     --     table.insert(self.obstacles, Obstacle(2 * (screen_width / 3) + ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, 80, cone_scale, 0, imageManager.cone))
    --     -- end

    --     -- for i=1,17 do
    --     --     table.insert(self.obstacles, Obstacle(2 * (screen_width / 3) + ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, 80, cone_scale, 0, imageManager.cone))
    --     -- end

    -- elseif currentLevel == 5 then
    --     --first row from left to right
    --     for i=1,80 do
    --         table.insert(self.obstacles, Obstacle(((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, screen_height / 3, cone_scale, 0, imageManager.cone))
    --     end

    --     --second row from right to left
    --     for i=1,80 do
    --         table.insert(self.obstacles, Obstacle(screen_width - ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, 2 * screen_height / 3, cone_scale, 0, imageManager.cone))
    --     end

    --     --top corners
    --     table.insert(self.obstacles, Obstacle(15, 10, 0.5, math.pi/3, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(screen_width - 15, 10, 0.5, -math.pi/3, imageManager.cornerBumper))
    --     --bottoms corners
    --     table.insert(self.obstacles, Obstacle(15, screen_height - 10, 0.5, -math.pi/3, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(screen_width - 15, screen_height - 10, 0.5, math.pi/3, imageManager.cornerBumper))
    --     --left third wall
    --     table.insert(self.obstacles, Obstacle(10, screen_height /3 - 10, 0.5, -math.pi/4, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(10, screen_height /3 + 10, 0.5, math.pi/4, imageManager.cornerBumper))
    --     -- --right third wall
    --     table.insert(self.obstacles, Obstacle(screen_width - 10, 2 * screen_height /3 - 10, 0.5, math.pi/4, imageManager.cornerBumper))
    --     table.insert(self.obstacles, Obstacle(screen_width - 10, 2 * screen_height /3 + 10, 0.5, -math.pi/4, imageManager.cornerBumper))

    --     self.hole = Hole(screen_width - 150, screen_height - 125, math.pi / 2, HOLE_SCALE)
    --     self.ball = Ball(800, 150, self.hole)
    --     self.car = Car(100, 100, -math.pi / 2)
    elseif currentLevel > 5 then
        currentLevel = 1
        self:loadLevel()
    end
end