require("entities/background")
require("entities/car")
require("entities/ball")
require("entities/boundary")
require("entities/goal")
require("entities/cone")

Entities = Object.extend(Object)

function Entities:new()
    local screen_width = love.graphics:getWidth()
    local screen_height = love.graphics:getHeight()
    local boundary_width = 10
    local GOAL_SCALE = 0.5

    self.baseObjects = {
        Background(),
        Boundary(-boundary_width,0, boundary_width,screen_height), --left
        Boundary(screen_width,0, boundary_width,screen_height), --right
        Boundary(0,-boundary_width, screen_width,boundary_width), --top
        Boundary(0,screen_height, screen_width,boundary_width), --bottom
    }
    self.goals = {
        Goal(2 * screen_width / 3, screen_height - 600, 0, GOAL_SCALE),
        Goal(screen_width / 3, screen_height - 600, 0, GOAL_SCALE)
    }
    self.balls = {
        Ball(2 * screen_width / 3, screen_height - 400, "red"),
        Ball(screen_width / 3, screen_height - 400, "red")
    }
    self.car = Car(screen_width / 3, screen_height - 100)
    self.obstacles = {}

    --create a box around the screen of cones
    local cone = Cone(-100, -100, 1) --not to be added to entities
    local cone_width = cone.width
    local cone_height = cone.height
    local num_cones_horizontal = math.ceil(screen_width / cone_width)
    local num_cones_veritcal = math.ceil(screen_height / cone_width) - 1

    --side columns
    for i=1,num_cones_veritcal do
        table.insert(self.obstacles, Cone(cone_width / 2, (cone_height * i) + cone_height / 2, 1))
        table.insert(self.obstacles, Cone(screen_width - cone_width / 2, (cone_height * i) + cone_height / 2, 1))
    end

    --top and bottom rows
    for i=0,num_cones_horizontal do
        table.insert(self.obstacles, Cone((cone_width * i) + cone_width / 2, cone_height / 2, 1))
        table.insert(self.obstacles, Cone((cone_width * i) + cone_width / 2, screen_height - cone_height / 2, 1))
    end
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
        print("win!")
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