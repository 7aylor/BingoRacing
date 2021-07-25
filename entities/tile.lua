Tile = Object.extend(Object)

function Tile:new(x, y, scale, rotation, img)
    self.x = x
    self.y = y
    self.scale = scale
    self.rotation = rotation
    self.image = img
    self.width = math.floor(self.image:getWidth() * scale)
    self.height = math.floor(self.image:getHeight() * scale)
end

function Tile:update(dt)

end

function Tile:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.width / (self.scale * 2), self.height / (self.scale * 2))
end