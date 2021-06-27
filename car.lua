Car = Object.extend(Object)
input = require("input")

function Car:new(x, y)
    self.speed = 0
    self.max_speed = 25000
    self.acceleration = 100
    self.max_acceleration = 800

    self.backing_up = false
    self.max_backup_speed = -self.max_speed * 0.75
    self.backup_accelartion = -self.acceleration
    self.max_backup_accelaration = -self.max_acceleration * 0.75
    
    self.scale = 0.5
    self.turn_speed = 3
    self.image = love.graphics.newImage("img/blue_car.png")
    self.height = self.image:getHeight() * self.scale
    self.width = self.image:getWidth() * self.scale
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.body:setMass(1000)
    self.shape = love.physics.newRectangleShape(self.height, self.width)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setFriction(1)
end

function Car:update(dt)
    local x = self.body:getX()
    local y = self.body:getY()
    local current_angle = self.body:getAngle()
    local current_velocity = self.body:getLinearVelocity()
    -- print("cos: " .. cos .. ", sin: " .. sin)
    print(self.speed)

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

        self.acceleration = 50
        self.backup_accelartion = -50
    end 
    
    if input.actions["turn_left"] and math.abs(self.speed) > 3000 then
        local direction = current_angle
        direction = direction - (self.turn_speed * dt)
        self.body:setAngle(direction)
    elseif input.actions["turn_right"] and math.abs(self.speed) > 3000 then
        local direction = current_angle
        direction = direction + (self.turn_speed * dt)
        self.body:setAngle(direction)
    end
    
    local cos = math.cos(current_angle)
    local sin = math.sin(current_angle)
    self.body:setLinearVelocity((self.speed * cos * dt), (self.speed * sin * dt))
    self.body:setLinearDamping(2)
end

function Car:draw()
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle() + math.pi / 2, self.scale, self.scale, self.width, self.height)

    local current_angle = self.body:getAngle()
    local x = self.body:getX()
    local y = self.body:getY()

    -- love.graphics.setColor(1,0,0,1)
    -- love.graphics.points(x, y)
    -- love.graphics.line(x, y, x + math.cos(current_angle) * 100, y + math.sin(current_angle) * 100)
    -- love.graphics.setColor(1,1,1,1)
end