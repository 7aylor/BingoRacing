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
    
end

function Hole:update(dt)
    
end

function Hole:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))

    if debug then
        love.graphics.setColor(1,0,0,1)
        love.graphics.points(self.x, self.y)
        love.graphics.setColor(0,0,1,1)
        love.graphics.circle("line", self.x, self.y, self.width / 2)
    end
    love.graphics.setColor(1,1,1,1)
end