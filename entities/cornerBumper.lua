require("entities/obstacle")
CornerBumper = Obstacle.extend(Obstacle)

function CornerBumper:new(x,y, scale, rotation)
    -- CornerBumper.super:new(x, y, scale, imageManager.rock)
    self.scale = scale
    self.image = imageManager.cornerBumer
    self.width = math.floor(self.image:getWidth() * scale)
    self.height = math.floor(self.image:getHeight() * scale)
    self.x = x
    self.y = y

    self.body = love.physics.newBody(world, x, y, "static")
    self.shape = love.physics.newPolygonShape(-self.width / 2, -self.height / 2, -self.width / 2, self.height / 2, self.width  / 2, self.height / 2)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData({
        name = "cornerBumper"
    })
end

function CornerBumper:update(dt)

end

function CornerBumper:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))
    
    if debug then
        love.graphics.setColor(1,0,0,1)
        love.graphics.points(self.x, self.y)
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.setColor(1,1,1,1)
    end
end

function CornerBumper:destroy()
    self.body:destroy()
    self.shape:release()
end