Car = Object.extend(Object)

function Car:new(x, y)
    self.x = x
    self.y = y
    self.scale = 0.5
    self.image = love.graphics.newImage("img/blue_car.png")
    self.height = self.image:getHeight() * self.scale
    self.width = self.image:getWidth() * self.scale
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.height, self.width)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.direction = 0 --in radians
end

function Car:update(dt)

end

function Car:draw()
    love.graphics.draw(self.image, self.x, self.y, self.direction, self.scale)
end