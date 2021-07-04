Car = Object.extend(Object)
input = require("input")
world = require("world")

function Car:new(x, y)
    self.speed = 0
    self.max_speed = 15000
    self.start_acceleration = 200
    self.acceleration = self.start_acceleration
    self.max_acceleration = 800
    self.turn_speed = 3
    self.hits = 0
    self.time = 0

    self.backing_up = false
    self.max_backup_speed = -self.max_speed * 0.75
    self.backup_accelartion = -self.acceleration
    self.max_backup_accelaration = -self.max_acceleration * 0.75
    
    self.scale = 0.45

    self.image = love.graphics.newImage("img/blue_car.png")
    self.height = self.image:getHeight() * self.scale
    self.width = self.image:getWidth() * self.scale
    
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.height - (24 * self.scale), self.width - (12 * self.scale))
    -- local hitbox = {
    --     -self.height/2 + 4, -self.width/2 + 3, -- back right
    --     -self.height/2 + 4, self.width/2 - 3,  -- back left
    --     self.height/2 - 4, -self.width/2 + 6,  -- front right outside
    --     self.height/2 - 14, -self.width/2 + 1,  -- front right inside
    --     self.height/2, 0,  -- front point
    --     self.height/2 - 14, self.width/2 - 1,   -- front left inside
    --     self.height/2 - 4, self.width/2 - 6    -- front left outside
    -- }
    -- self.shape = love.physics.newPolygonShape(hitbox)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    
    self.body:setMass(1000)
    self.body:setLinearDamping(2)
    self.body:setAngularDamping(50)
    self.fixture:setFriction(0)
    self.fixture:setRestitution(0.25)
    self.fixture:setUserData({
        name = "car",
        collisionHandler = function(other)
            self.speed = self.speed / 10
            self.acceleration = self.acceleration / 10

            if(other:getBody():getType() == "static") then
                local x,y = self.body:getLinearVelocity()
                local newX = -x * 1.2
                local newY = -y * 1.2
                self.body:setLinearVelocity(newX, newY)
            else
                local angularVelocity = love.math.random(-10, 10)
                self.body:setAngularVelocity(angularVelocity)
            end
        end,
        increaseHits = function()
            self.hits = self.hits + 1
            print(self.hits)
        end
    })

    self.body:setAngle(-math.pi / 2)
end

function Car:update(dt)
    self.time = self.time + dt
    local x = self.body:getX()
    local y = self.body:getY()
    local current_angle = self.body:getAngle()
    local current_velocity = self.body:getLinearVelocity()

    if input.actions["go_forward"] then
        self.backing_up = false
        self.acceleration = self.acceleration + 20
        if self.acceleration > self.max_acceleration then
            self.acceleration = self.max_acceleration
        end

        self.speed = self.speed + self.acceleration

        if self.speed > self.max_speed then
            self.speed = self.max_speed
        end
        
    elseif input.actions["backup"] then
        self.backing_up = true
        self.backup_accelartion = self.backup_accelartion - 20
        if self.backup_accelartion > self.max_backup_accelaration then
            self.backup_accelartion = self.max_backup_accelaration
        end

        self.speed = self.speed + self.backup_accelartion

        if self.speed < self.max_backup_speed then
            self.speed = self.max_backup_speed
        end
    else
        if not self.backing_up then
            if self.speed > 0 then
                self.speed = self.speed - 250
            elseif self.speed < 0 then
                self.speed = 0
            end
        else
            if self.speed < 0 then
                self.speed = self.speed + 250
            elseif self.speed > 0 then
                self.speed = 0
            end
        end

        self.acceleration = self.start_acceleration
        self.backup_accelartion = -self.start_acceleration
    end 
    
    if input.actions["turn_left"] then --and math.abs(self.speed) > 0 then
        local direction = current_angle
        direction = direction - (self.turn_speed * dt)
        self.body:setAngle(direction)
    elseif input.actions["turn_right"] then --and math.abs(self.speed) > 0 then
        local direction = current_angle
        direction = direction + (self.turn_speed * dt)
        self.body:setAngle(direction)
    end
    
    local cos = math.cos(current_angle)
    local sin = math.sin(current_angle)
    self.body:setLinearVelocity((self.speed * cos * dt), (self.speed * sin * dt))
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
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.line(x, y, x + math.cos(current_angle) * 100, y + math.sin(current_angle) * 100)
        
        love.graphics.setColor(1,1,1,1)
    end
end

function Car:setCarSpeed(newSpeed)
    self.speed = newSpeed
end