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

    self.turbo_speed = self.max_speed * 1.6 --power to add to speed
    self.turbo_max_power = 1
    self.turbo_power = self.turbo_max_power
    self.turbo_depleted = false
    self.turbo_cooldown = 5
    self.turbo_cooldown_time = 0

    self.backing_up = false
    self.max_backup_speed = -self.max_speed * 0.75
    self.backup_accelartion = -self.start_acceleration
    self.max_backup_accelaration = -self.max_acceleration * 0.75

    self.scale = 0.5

    self.image = love.graphics.newImage("img/blue_car.png")
    self.height = self.image:getHeight() * self.scale
    self.width = self.image:getWidth() * self.scale
    
    self.hits = 0
    self.time = 0
    
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(self.width / 2 + 2)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    --category: carBody, carPutter, Ball, Hole, Obstacles
    self.fixture:setFilterData(tonumber('10000', 2), tonumber('00011', 2), 0)
    
    self.body:setAngle((-math.pi / 2) - rotation)
    self.body:setMassData(x,y, 500,0)
    self.body:setLinearDamping(2)


    self.putterBody = love.physics.newBody(world, x, y, "dynamic")
    self.putterShape = love.physics.newRectangleShape(self.height - (24 * self.scale), self.width - (12 * self.scale))
    self.putterFixture = love.physics.newFixture(self.putterBody, self.putterShape)
    self.putterFixture:setFilterData(tonumber('01000', 2), tonumber('00100', 2), 0)
    self.putterBody:setMassData(x,y, 500,0)
    
    self.putterBody:setAngle((-math.pi / 2) - rotation)

    self.joint = love.physics.newWeldJoint(self.body, self.putterBody, x, y, false)

    self.fixture:setUserData({
        name = "carBody",
        collisionHandler = function(me, other)
            self:handleCollision(me, other)
        end
    })

    self.putterFixture:setUserData({
        name = "carPutter",
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
        --would be nice to also apply some kind of visual indicator like backup lights here as well
    elseif input.actions["go_forward"] then
        self.backing_up = false
        if input.actions["turbo"] and not self.turbo_depleted then
            self.speed = self.speed + self.turbo_speed
            self.turbo_power = self.turbo_power - dt

            if self.turbo_power <= 0 then
                self.turbo_depleted = true
            end
    
            if self.speed > self.turbo_speed then
                self.speed = self.turbo_speed
            end
        else
            self.acceleration = self.acceleration + self.acceleration_step * dt
            if self.acceleration > self.max_acceleration then
                self.acceleration = self.max_acceleration
            end

            self.speed = self.speed + self.acceleration * dt

            if self.speed > self.max_speed then
                self.speed = self.max_speed
            end
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
        self.putterBody:setAngle(direction)
    elseif input.actions["turn_right"] then
        local direction = current_angle
        direction = direction + (self.turn_speed * dt)
        self.body:setAngle(direction)
        self.putterBody:setAngle(direction)
    end

    if self.turbo_depleted then
        self.turbo_cooldown_time = self.turbo_cooldown_time + dt
        if self.turbo_cooldown_time > self.turbo_cooldown then
            self.turbo_power = self.turbo_power + dt
            if self.turbo_power > self.turbo_max_power then
                self.turbo_depleted = false
                self.turbo_cooldown_time = 0
                self.turbo_power = self.turbo_max_power
            end
        end
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
        love.graphics.polygon("line", self.putterBody:getWorldPoints(self.putterShape:getPoints()))
        love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
        love.graphics.line(x, y, x + math.cos(current_angle) * 100, y + math.sin(current_angle) * 100)
        
        love.graphics.setColor(1,1,1,1)
    end
end

function Car:handleCollision(me, other)
    self.speed = self.speed * 0.9
    self.acceleration = self.acceleration * 0.9
end

function Car:increaseHits()
    self.hits = self.hits + 1
end

function Car:destroy()
    self.joint:destroy()
    self.body:destroy()
    self.shape:release()
    self.putterBody:destroy()
    self.putterShape:release()
end