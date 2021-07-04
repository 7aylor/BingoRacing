require("entities/background")
require("entities/car")
require("entities/ball")
require("entities/boundary")
require("entities/goal")
require("entities/cone")

Entities = Object.extend(Object)

function Entities:new()
    local boundary_width = 10
    GOAL_SCALE = 0.5
    cone_scale = 0.25
    cone = Cone(-100, -100, cone_scale) --not to be added to entities
    cone_width = cone.width
    cone_height = cone.height
    cone_scale_adjuster = (1 / cone_scale)

    self.baseObjects = {
        Background(),
        Boundary(-boundary_width,0, boundary_width,screen_height), --left
        Boundary(screen_width,0, boundary_width,screen_height), --right
        Boundary(0,-boundary_width, screen_width,boundary_width), --top
        Boundary(0,screen_height, screen_width,boundary_width), --bottom
    }
    self.obstacles = {}
    self:createConeBoundary()

    self.goals = {
        --Goal(2 * screen_width / 3, screen_height - 600, 0, GOAL_SCALE),
        --Goal(screen_width / 3, screen_height - 600, 0, GOAL_SCALE)
    }
    self.balls = {
        --Ball(2 * screen_width / 3, screen_height - 400, "red"),
        --Ball(screen_width / 3, screen_height - 400, "red")
    }
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
    for i,v in ipairs(self.goals) do
        v:update(dt)
    end
    for i,v in ipairs(self.balls) do
        v:update(dt)
    end
    self.car:update(dt)

    if self:checkAllGoalsScored() then
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
    for i,v in ipairs(self.baseObjects) do
        v:draw()
    end
    for i,v in ipairs(self.obstacles) do
        v:draw()
    end
    for i,v in ipairs(self.goals) do
        v:draw()
    end
    for i,v in ipairs(self.balls) do
        v:draw()
    end
    self.car:draw()
end

function Entities:checkAllGoalsScored()
    for i,v in pairs(self.goals) do
        if not v.closed then
            return false
        end
    end
    return true
end

function Entities:createConeBoundary()
    --create a box around the screen of cones
    local num_cones_horizontal = math.ceil(screen_width / (cone_width * cone_scale))
    local num_cones_veritcal = math.ceil(screen_height / (cone_width * cone_scale)) - 1

    --side columns
    for i=1,num_cones_veritcal do
        table.insert(self.baseObjects, Cone(cone_width / 2, ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale , cone_scale))
        table.insert(self.baseObjects, Cone(screen_width - cone_width / 2, ((cone_height * cone_scale_adjuster * i) + cone_height / 2) * cone_scale, cone_scale))
    end

    --top and bottom rows
    for i=0,num_cones_horizontal do
        table.insert(self.baseObjects, Cone(((cone_width * cone_scale_adjuster * i) + cone_width / 2) * cone_scale, cone_height / 2, cone_scale))
        table.insert(self.baseObjects, Cone(((cone_width * cone_scale_adjuster * i) + cone_width / 2) * cone_scale, screen_height - cone_height / 2, cone_scale))
    end
end

function Entities:clearLevel()

    --delete physics entities
    for i,v in ipairs(self.obstacles) do
        v:destroy()
    end
    for i,v in ipairs(self.goals) do
        v:destroy()
    end
    for i,v in ipairs(self.balls) do
        v:destroy()
    end

    self.car:destroy()

    self.obstacles = {}
    self.goals = {}
    self.balls = {}
    self.car = nil
end

function Entities:loadLevel()
    if currentLevel ~= 1 then
        self:clearLevel()
    end

    if currentLevel == 1 then
        self.goals = {
            Goal(screen_width / 2, screen_height - 600, 0, GOAL_SCALE)
        }
        self.balls = {
            Ball(screen_width / 2, screen_height - 400)
        }
        self.car = Car(screen_width / 2, screen_height - 100, 0)
    elseif currentLevel == 2 then
        self.goals = {
            Goal(screen_width - 200, screen_height / 2, math.pi / 2, GOAL_SCALE)
        }
        self.balls = {
            Ball(300, screen_height / 2)
        }
        self.car = Car(100, screen_height / 2, -math.pi / 2)
    elseif currentLevel == 3 then
        self.goals = {
            Goal(screen_width - 50, 50, math.pi / 3.5, GOAL_SCALE)
        }
        self.balls = {
            Ball(360, screen_height - 220)
        }
        self.car = Car(50, screen_height - 50, -math.pi / 2.9)
    elseif currentLevel == 4 then
        self.goals = {
            Goal(screen_width - 200, 150, 0, GOAL_SCALE)
        }
        self.balls = {
            Ball(250, 300)
        }
        self.car = Car(100, screen_height - 100, 0)

        --first column from bottom to top
        for i=1,50 do
            table.insert(self.obstacles, Cone(screen_width / 3, screen_height - ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale , cone_scale))
        end

        --second column from top to bottom
        for i=1,50 do
            table.insert(self.obstacles, Cone(2 * screen_width / 3, ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale , cone_scale))
        end

        --first column from bottom to top
        -- for i=1,17 do
        --     table.insert(self.obstacles, Cone(2 * (screen_width / 3) + ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, 80, cone_scale))
        -- end

        -- for i=1,17 do
        --     table.insert(self.obstacles, Cone(2 * (screen_width / 3) + ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, 80, cone_scale))
        -- end

    elseif currentLevel == 5 then
        self.goals = {
            Goal(screen_width - 150, screen_height - 125, math.pi / 2, GOAL_SCALE)
        }
        self.balls = {
            Ball(800, 150)
        }
        self.car = Car(100, 100, -math.pi / 2)

        --first row from left to right
        for i=1,80 do
            table.insert(self.obstacles, Cone(((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, screen_height / 3, cone_scale))
        end

        --second row from right to left
        for i=1,80 do
            table.insert(self.obstacles, Cone(screen_width - ((cone_height * cone_scale_adjuster * i) + (cone_height / 2)) * cone_scale, 2 * screen_height / 3, cone_scale))
        end
    elseif currentLevel > 5 then
        currentLevel = 1
        self:loadLevel()
    end
end