Barrel = Object.extend(Object)
world = require("world")

function Barrel:new(x, y, color)
    if color == "red" then
        self.image = love.graphics.newImage("/img/barrel_red.png")
    else
        self.image = love.graphics.newImage("/img/barrel_blue.png")
    end
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.radius = self.image:getWidth() / 2
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.body:setMass(50)
    -- self.fixture:setFriction(0.5)
    self.fixture:setRestitution(0.5)
    self.fixture:setUserData({
        name = "barrel"
    })
    self.body:setLinearDamping(0.25)
end

function Barrel:draw()
    love.graphics.draw(self.image, self.body:getX() - self.width / 2, self.body:getY() - self.height / 2)
end

function Barrel:update(dt)

end