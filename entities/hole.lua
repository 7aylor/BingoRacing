Hole = Object.extend(Object)
world = require("world")

function Hole:new(x,y, rotation, scale)
    self.rotation = rotation
    self.scale = scale
    self.image = love.graphics.newImage("img/barrel_red.png")
    self.width = math.floor(self.image:getWidth() * scale)
    self.height = math.floor(self.image:getHeight() * scale)
    self.x = x
    self.y = y

    self.body = love.physics.newBody(world, x, y, "static")
    self.shape = love.physics.newCircleShape(self.width / 2)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setFilterData(tonumber('00010', 2), tonumber('10000', 2), 0)
end

function Hole:update(dt)
    
end

function Hole:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))

    if debug then
        love.graphics.setColor(1,0,0,1)
        love.graphics.points(self.x, self.y)
        love.graphics.circle("line", self.body:getX(), self.body:getY(), self.width / 2)
    end
    love.graphics.setColor(1,1,1,1)
end

function Hole:destroy()
    self.body:destroy()
    self.shape:release()
end