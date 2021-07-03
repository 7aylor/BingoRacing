Barrel = Object.extend(Object)
world = require("world")

function Barrel:new(x, y, color)
    if color == "red" then
        self.image = love.graphics.newImage("/img/barrel_red.png")
    else
        self.image = love.graphics.newImage("/img/barrel_blue.png")
    end

    self.inGoal = false
    self.scale = 0.75
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
        name = "barrel",
        collisionHandler = function()
            self:madeGoal()
        end
    })
end

function Barrel:draw()
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), 0, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))
    
    if debug then
        love.graphics.setColor(1,0,0,1)
        love.graphics.circle("line", self.body:getX(), self.body:getY(), self.radius)
        love.graphics.points(self.body:getX(), self.body:getY())
        love.graphics.setColor(1,1,1,1)
    end
end

function Barrel:update(dt)

end

function Barrel:madeGoal()
    x,y = self.body:getLinearVelocity()
    print("slowing barrel, x: " .. x .. ", y: " .. y)
    self.body:setLinearVelocity(x * 0.01, y * 0.01)
    self.inGoal = true
end