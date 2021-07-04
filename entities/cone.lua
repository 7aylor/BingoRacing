Cone = Object.extend(Object)
world = require("world")

function Cone:new(x,y, scale)
    self.scale = scale
    self.image = love.graphics.newImage("img/cone.png")
    self.width = math.floor(self.image:getWidth() * scale)
    self.height = math.floor(self.image:getHeight() * scale)
    self.x = x
    self.y = y

    self.body = love.physics.newBody(world, x, y, "static")
    self.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData({
        name = "cone"
    })
end

function Cone:update(dt)

end

function Cone:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))
    
    if debug then
        love.graphics.setColor(1,0,0,1)
        love.graphics.points(self.x, self.y)
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.setColor(1,1,1,1)
    end
end

function Cone:destroy()
    self.body:destroy()
    self.shape:release()
end