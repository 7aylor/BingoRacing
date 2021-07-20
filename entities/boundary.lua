Boundary = Object.extend(Object)
world = require("world")

function Boundary:new(x, y, width, height)
    self.width = width
    self.height = height
    self.body = love.physics.newBody(world, x + width/2, y + height/2, "static")
    self.shape = love.physics.newRectangleShape(width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setFilterData(tonumber('00001', 2), tonumber('10100', 2), 0)
end

function Boundary:update()

end

function Boundary:draw()
    if debug then
        love.graphics.rectangle("line", self.body:getX() - self.width/2, self.body:getY() - self.height/2, self.width, self.height)
    end
end