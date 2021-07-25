require("entities/car")
require("entities/ball")
require("entities/hole")
require("entities/obstacle")
require("entities/tile")

CourseManager = Object.extend(Object)

function CourseManager:new()
    self.tile_size = 64
    self.courses = 
    {
        testCourse = require("courses/testCourse")
    }

    self.current_course = self.courses.testCourse
    self.current_hole_data = self.current_course.holes[1]

    self.current_map = self:getCurrentMapObjects()
    self.current_obstacles =  self:getCurrentObstacles()
    self.current_car = self:getCurrentCar()
    self.current_hole = self:getCurrentHole()
    self.current_ball = self:getCurrentBall(self.current_hole)

    print("course: " .. self.current_course.name)
    print("hole: " .. self.current_hole_data.number)
end

function CourseManager:update(entities)
    if levelJustChanged then
        levelJustChanged = false
        entities:loadLevel()
        currentGameState = "playing"
    end
end

function CourseManager:getCurrentMapObjects()
    local map = {}
    local tiles = self.current_hole_data.map

    for i=1,#tiles do
        for j=1,#tiles[i] do
            local y = i * self.tile_size
            local x = j * self.tile_size

            if tiles[i][j] == 0 then
                --goto continue --might not work
            elseif tiles[i][j] == 1 then
                table.insert(map, Obstacle(x, y, 1, 0, imageManager.wall))
            elseif tiles[i][j] == 2 then
                table.insert(map, Tile(x, y, 1, 0, imageManager.grass))
            elseif tiles[i][j] == 3 then
                table.insert(map, Tile(x, y, 1, 0, imageManager.rough))
            end
        end
    end

    return map
end

function CourseManager:getCurrentObstacles()
    local newObs = {}
    local obstacles = self.current_hole_data.obstacles

    -- for i=1,#obstacles do
    --     for j=1,#obstacles[i] do
    --         local y = i * tile_size
    --         local x = j * tile_size

    --         table.insert(Obstacle(x, y, 1, 0, imageManager.wall))
    --     end
    -- end

    return newObs
end

function CourseManager:getCurrentCar()
    local car = self.current_hole_data.car
    return Car(car.x * self.tile_size, car.y * self.tile_size, car.r)
end

function CourseManager:getCurrentHole()
    local hole = self.current_hole_data.hole
    return Hole(hole.x * self.tile_size, hole.y * self.tile_size, hole.r, hole.s)
end

function CourseManager:getCurrentBall(hole)
    local ball = self.current_hole_data.ball
    return Ball(ball.x * self.tile_size, ball.y * self.tile_size, ball.s, hole)
end

function CourseManager:setCurrentEntities()
    self.current_map = self:getCurrentMapObjects()
    self.current_obstacles =  self:getCurrentObstacles()
    self.current_car = self:getCurrentCar()
    self.current_hole = self:getCurrentHole()
    self.current_ball = self:getCurrentBall(self.current_hole)
end

function CourseManager:goToNextHole()
    self:clearEntities()

    --ensure next hole isn't past the last hole on the course
    local nextHole = self.current_hole_data.number + 1 > #self.current_course.holes 
        and 1 or self.current_hole_data.number + 1

    self.current_hole_data = self.current_course.holes[nextHole]

    self:setCurrentEntities()
end

function CourseManager:clearEntities()

    for i,v in ipairs(self.current_map) do
        if v:is(Obstacle) then
            v:destroy()
        end
    end

    for i,v in ipairs(self.current_obstacles) do
        v:destroy()
    end
    
    -- self.hole:destroy()
    if self.current_ball ~= nil then self.current_ball:destroy() end
    if self.current_hole ~= nil then self.current_hole:destroy() end
    if self.current_car ~= nil then self.current_car:destroy() end

    self.current_map = {}
    self.current_obstacles =  {}
    self.current_car = nil
    self.current_hole = nil
    self.current_ball = nil
end

function CourseManager:setCourse(courseName)
    --set the current course
end

