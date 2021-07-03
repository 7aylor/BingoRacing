Background = Object.extend(Object)

function Background:new()
    self.sky = love.graphics.newImage("img/unity_sky.png")
    self.tiles = {
        love.graphics.newImage("img/tiles/land_grass04.png"),
        love.graphics.newImage("img/tiles/land_sand12.png")
    }
    self.map = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    }
end

function Background:update(dt)

end

function Background:draw()
    love.graphics.draw(self.sky, 0, 0, 0, love.graphics:getWidth() / self.sky:getWidth(), love.graphics:getHeight() / self.sky:getHeight())

    for index,row in ipairs(self.map) do
        for i=1,#row do
            local img = self.tiles[row[i]]
            love.graphics.draw(img, (i - 1) * img:getWidth() / 2, (index + 1) * img:getHeight() / 2, 0, 0.5, 0.5)
        end
    end
end