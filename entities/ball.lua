Ball = Object.extend(Object)
world = require("world")

function Ball:new(x, y, hole)
    self.image = love.graphics.newImage("/img/ball.png")
    self.hole = hole

    self.inHole = false
    self.scale = 0.4
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale
    self.radius = self.width / 2
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.body:setMass(3)
    self.fixture:setFriction(0.1)
    self.fixture:setRestitution(0.5)
    self.body:setLinearDamping(0.15)
    self.fixture:setFilterData(tonumber('00100', 2), tonumber('01101', 2), 0)
    
    self.fixture:setUserData({
        name = "ball"
    })
end

function Ball:draw()
    if self.inHole then
        love.graphics.setColor(0,1,0,1)
    end
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), 0, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))
    
    if debug then
        love.graphics.setColor(1,0,0,1)
        love.graphics.circle("line", self.body:getX(), self.body:getY(), self.radius)
        love.graphics.points(self.body:getX(), self.body:getY())
    end
    love.graphics.setColor(1,1,1,1)
end

function Ball:update(dt)
    local x = self.body:getX()
    local y = self.body:getY()
    local distToHole = math.dist(x, y, self.hole.x, self.hole.y)

    if distToHole - self.radius + 3 <= 0 then
        self.body:setLinearVelocity(0, 0)
        self.inHole = true
    elseif distToHole < (self.hole.width/2 + self.radius - 6) then
        local directionToHole = math.atan2(y - self.hole.y, x - self.hole.x)
        local cos = math.cos(directionToHole)
        local sin = math.sin(directionToHole)
        local vx, vy = self.body:getLinearVelocity()

        local speedReducerX = 0
        local speedReducerY = 0

        if math.abs(vx) > 200 then 
            speedReducerX = 0.1
        elseif math.abs(vx) > 100 then
            speedReducerX = 0.25
        elseif math.abs(vx) < 20 then
            speedReducerX = 1 
        else
            speedReducerX = 0.5
        end

        if math.abs(vy) > 200 then
            speedReducerY = 0.1
        elseif math.abs(vy) > 100 then
            speedReducerY = 0.25
        elseif math.abs(vy) < 20 then
            speedReducerY = 1 
        else
            speedReducerY = 0.5
        end

        local angleForce = 0
        if distToHole < (self.hole.width/2) then
            angleForce = 50
        else
            angleForce = 30
        end

        self.body:applyLinearImpulse(-vx * speedReducerX, -vy * speedReducerY)
        self.body:applyLinearImpulse(-cos * angleForce, -sin * angleForce)
    end
end

function Ball:destroy()
    self.body:destroy()
    self.shape:release()
end