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
    print(distToHole)
    if distToHole < 5 then
        self.body:setLinearVelocity(0, 0)
        self.inHole = true
    elseif distToHole < 25 then
        -- self.body:setAngularVelocity(500)
        --instead of this, try making the ball move toward to the hole if it hits the edge, so it has a change to fall in

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
        else 
            speedReducerX = 0.5 
        end

        if math.abs(vy) > 200 then
            speedReducerY = 0.1
        elseif math.abs(vy) > 100 then
            speedReducerY = 0.25
        else
            speedReducerY = 0.5 
        end

        self.body:applyLinearImpulse(-vx * speedReducerX, -vy * speedReducerY)
        self.body:applyLinearImpulse(-cos * 50, -sin * 50)
    end
    print(self.body:getLinearVelocity())
end

function Ball:destroy()
    self.body:destroy()
    self.shape:release()
end