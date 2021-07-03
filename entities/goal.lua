Goal = Object.extend(Object)
world = require("world")

function Goal:new(x,y, rotation, scale)
    self.rotation = rotation
    self.scale = scale
    self.image = love.graphics.newImage("img/goal.png")
    self.width = math.floor(self.image:getWidth() * scale)
    self.height = math.floor(self.image:getHeight() * scale)
    self.x = x-- - self.width / 2
    self.y = y-- - self.height / 2

    local w = 5
    -- self.leftBody = love.physics.newBody(world, x - self.width/2 + w/2, y, "static")
    self.leftBody = love.physics.newBody(world, x, y, "static")
    self.leftShape = love.physics.newRectangleShape(-self.width/2, 0, w, self.height + 10)
    self.leftFixture = love.physics.newFixture(self.leftBody, self.leftShape)
    self.leftBody:setAngle(rotation + math.pi / 20)

    -- self.topBody = love.physics.newBody(world, x, y - self.width/2 - w/2, "static")
    self.topBlockerBody = love.physics.newBody(world, x, y - 5, "static")
    self.topBlockerShape = love.physics.newRectangleShape(0, -self.height/2, self.width, w)
    self.topBlockerFixture = love.physics.newFixture(self.topBlockerBody, self.topBlockerShape)
    self.topBlockerBody:setAngle(rotation)

    -- self.topBody = love.physics.newBody(world, x, y - self.width/2 - w/2, "static")
    self.topBody = love.physics.newBody(world, x, y, "static")
    self.topShape = love.physics.newRectangleShape(0, -self.height/2, self.width, w)
    self.topFixture = love.physics.newFixture(self.topBody, self.topShape)
    self.topBody:setAngle(rotation)

    -- self.rightBody = love.physics.newBody(world, x + self.width/2 - w/2, y, "static")
    self.rightBody = love.physics.newBody(world, x, y, "static")
    self.rightShape = love.physics.newRectangleShape(self.height/2, 0, w, self.height + 10)
    self.rightFixture = love.physics.newFixture(self.rightBody, self.rightShape)
    self.rightBody:setAngle(rotation - math.pi / 20)

    self.topFixture:setUserData({
        name = "goal"
    })
end

function Goal:update(dt)

end

function Goal:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))
    
    if debug then
        love.graphics.setColor(1,0,0,1)
        love.graphics.points(self.x, self.y)
        love.graphics.polygon("line", self.leftBody:getWorldPoints(self.leftShape:getPoints()))
        love.graphics.polygon("line", self.topBody:getWorldPoints(self.topShape:getPoints()))
        love.graphics.polygon("line", self.topBlockerBody:getWorldPoints(self.topBlockerShape:getPoints()))
        love.graphics.polygon("line", self.rightBody:getWorldPoints(self.rightShape:getPoints()))
        love.graphics.setColor(1,1,1,1)
    end
end