Ball = Object.extend(Object)
world = require("world")

function Ball:new(x, y)
    self.image = love.graphics.newImage("/img/ball.png")

    self.inGoal = false
    self.scale = 0.5
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale
    self.radius = self.width / 2
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.body:setMass(3)
    self.fixture:setFriction(0)
    self.fixture:setRestitution(0.5)
    self.body:setLinearDamping(0.15)
    
    self.fixture:setUserData({
        name = "ball",
        collisionHandler = function()
            self:madeGoal()
        end
    })
end

function Ball:draw()
    if self.inGoal then
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

end

function Ball:madeGoal()
    local x,y = self.body:getLinearVelocity()
    self.body:setLinearVelocity(x * 0.05, y * 0.05)
    self.inGoal = true
end