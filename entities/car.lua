Car = Object.extend(Object)
input = require("managers/inputManager")
world = require("world")

function Car:new(x, y, rotation)
    self.speed = 0
    self.max_speed = 250 -- not affected by dt, but everything else is
    self.start_acceleration = self.max_speed * 2
    self.acceleration_step = self.start_acceleration / 2
    self.acceleration = self.start_acceleration
    self.max_acceleration = self.start_acceleration * 0.9
    self.turn_speed = 2
    self.brake_speed = 1

    self.backing_up = false
    self.max_backup_speed = -self.max_speed * 0.75
    self.backup_accelartion = -self.start_acceleration
    self.max_backup_accelaration = -self.max_acceleration * 0.75

    -- print("max_speed: " .. self.max_speed)
    -- print("start_acceleration: " .. self.start_acceleration)
    -- print("acceleration_step: " .. self.acceleration_step)
    -- print("acceleration: " .. self.acceleration)
    -- print("max_acceleration: " .. self.max_acceleration)
    -- print("max_backup_speed: " .. self.max_backup_speed)
    -- print("backup_accelartion: " .. self.backup_accelartion)
    -- print("max_backup_accelaration: " .. self.max_backup_accelaration)
    -- print("-------------------------------")
    self.scale = 0.5

    self.image = love.graphics.newImage("img/blue_car.png")
    self.height = self.image:getHeight() * self.scale
    self.width = self.image:getWidth() * self.scale
    
    self.hits = 0
    self.time = 0
    
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(self.width / 2 - 3)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.body:setMassData(x,y, 500,0)
    self.body:setLinearDamping(2)
    -- self.fixture:setFriction(1)
    -- self.fixture:setRestitution(0.25)
    -- self.fixture:setDensity(500)

    self.body:setAngle((-math.pi / 2) - rotation)
    
    local hoodHitbox = {
        self.height/2 - 16, -self.width/2 + 4,-- back right
        self.height/2 - 16, self.width/2 - 4, -- back left
        self.height/2 - 4, -self.width/2 + 4, -- front right outside
        self.height/2 - 4, self.width/2 - 4   --front left outside
    }
    self.hood = love.physics.newBody(world, x, y, "dynamic")
    self.hoodShape = love.physics.newPolygonShape(hoodHitbox)
    self.hoodFixture = love.physics.newFixture(self.hood, self.hoodShape)
    
    self.hood:setMassData(x,y, 300,0)
    self.hood:setAngle((-math.pi / 2) - rotation)
    -- self.hood:setLinearDamping(2)
    -- self.hoodFixture:setFriction(1)
    self.hoodFixture:setRestitution(0.25)
    
    local trunkHitbox = {
        -self.height/2 + 16, -self.width/2 + 4,-- back right
        -self.height/2 + 16, self.width/2 - 4, -- back left
        -self.height/2 + 4, -self.width/2 + 4, -- front right outside
        -self.height/2 + 4, self.width/2 - 4   --front left outside
    }
    self.trunk = love.physics.newBody(world, x, y, "dynamic")
    self.trunkShape = love.physics.newPolygonShape(trunkHitbox)
    self.trunkFixture = love.physics.newFixture(self.trunk, self.trunkShape)
    
    self.trunk:setMassData(x,y, 300,0)
    self.trunk:setAngle((-math.pi / 2) - rotation)
    -- self.trunk:setLinearDamping(2)
    -- self.trunkFixture:setFriction(1)
    self.trunkFixture:setRestitution(0.25)

    self.hoodBodyJoint = love.physics.newWeldJoint(self.body, self.hood, x, y, true)
    self.trunkBodyJoint = love.physics.newWeldJoint(self.body, self.trunk, x, y, true)

    self.hoodFixture:setUserData({
        name = "car",
        collisionHandler = function(me, other)
            self:handleCollision(me, other)
        end,
        increaseHits = function()
            self:increaseHits()
        end
    })

    self.trunkFixture:setUserData({
        name = "car",
        collisionHandler = function(me, other)
            self:handleCollision(me, other)
        end,
        increaseHits = function()
            self:increaseHits()
        end
    })
end

function Car:update(dt)
    self.time = self.time + dt
    local x = self.body:getX()
    local y = self.body:getY()
    local current_angle = self.body:getAngle()
    local current_velocity = self.body:getLinearVelocity()

    if input.actions["brake"] then
        local break_speed = ((2 * self.acceleration / 3) + self.brake_speed)
        if self.backing_up then
            self.speed = self.speed + break_speed * dt
            if self.speed > 0 then
                self.speed = 0
            end
        else
            self.speed = self.speed - break_speed * dt
            if self.speed < 0 then
                self.speed = 0
            end
        end
        --would be nice to also apply some kind of visual indicator here as well
    elseif input.actions["go_forward"] then
        self.backing_up = false
        self.acceleration = self.acceleration + self.acceleration_step * dt
        if self.acceleration > self.max_acceleration then
            self.acceleration = self.max_acceleration
        end

        self.speed = self.speed + self.acceleration * dt

        if self.speed > self.max_speed then
            self.speed = self.max_speed
        end
        
    elseif input.actions["backup"] then
        self.backing_up = true
        self.backup_accelartion = self.backup_accelartion - self.acceleration_step * dt
        if self.backup_accelartion < self.max_backup_accelaration then
            self.backup_accelartion = self.max_backup_accelaration
        end

        self.speed = self.speed + self.backup_accelartion * dt

        if self.speed < self.max_backup_speed then
            self.speed = self.max_backup_speed
        end
    else
        --if not going forward or back, slow down in whichever direction we were last going
        if not self.backing_up then
            if self.speed > 0 then
                self.speed = self.speed - (self.max_speed / 3) * dt
            elseif self.speed < 0 then
                self.speed = 0
            end
        else
            if self.speed < 0 then
                self.speed = self.speed + (self.max_speed / 3) * dt
            elseif self.speed > 0 then
                self.speed = 0
            end
        end

        --reset accelerations
        self.acceleration = self.start_acceleration
        self.backup_accelartion = -self.start_acceleration
    end 
    
    if input.actions["turn_left"] then
        local direction = current_angle
        direction = direction - (self.turn_speed * dt)
        self.body:setAngle(direction)
        self.hood:setAngle(direction)
        self.trunk:setAngle(direction)
    elseif input.actions["turn_right"] then
        local direction = current_angle
        direction = direction + (self.turn_speed * dt)
        self.body:setAngle(direction)
        self.hood:setAngle(direction)
        self.trunk:setAngle(direction)
    end
    
    local cos = math.cos(current_angle)
    local sin = math.sin(current_angle)
    self.body:setLinearVelocity((self.speed * cos), (self.speed * sin))
    
end

function Car:draw()
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle() + math.pi / 2, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2)) --math.pi / 2 rotates the image 90 degrees

    if debug then
        local current_angle = self.body:getAngle()
        local x = self.body:getX()
        local y = self.body:getY()
        local topLeftX,topLeftY,bottomRightX,bottomRightY = self.fixture:getBoundingBox(1)
        
        love.graphics.setColor(1,0,0,1)
        love.graphics.points(x, y)
        love.graphics.polygon("line", self.hood:getWorldPoints(self.hoodShape:getPoints()))
        love.graphics.polygon("line", self.trunk:getWorldPoints(self.trunkShape:getPoints()))
        love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
        love.graphics.line(x, y, x + math.cos(current_angle) * 100, y + math.sin(current_angle) * 100)
        
        love.graphics.setColor(1,1,1,1)
    end
end

function Car:handleCollision(me, other)
    self.speed = self.speed / 10
    self.acceleration = self.acceleration / 10

    if(other:getBody():getType() == "static") then
        local x,y = self.body:getLinearVelocity()
        if x < 1 then x = 1 end
        if y < 1 then y = 1 end
        local newX = -x * 8
        local newY = -y * 8
        self.body:setLinearVelocity(newX, newY)
    end
end

function Car:increaseHits()
    self.hits = self.hits + 1
    print(self.hits)
end

function Car:destroy()
    self.hoodBodyJoint:destroy()
    self.trunkBodyJoint:destroy()
    self.body:destroy()
    self.shape:release()
    self.hood:destroy()
    self.hoodShape:release()
    self.trunk:destroy()
    self.trunkShape:release()
end