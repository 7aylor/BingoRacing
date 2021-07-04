UIManager = Object.extend(Object)

function UIManager:new()
    self.fontSize = 20
    self.font = love.graphics.newFont("fonts/Ldfcomicsans-jj7l.ttf", self.fontSize)
    love.graphics.setFont(self.font)
end

function UIManager:draw(entities)
    love.graphics.setColor(0,0,1,1)
    local car = entities.car
    
    if currentGameState == "mainMenu" then
        
    elseif currentGameState == "playing" then
        local time = math.floor(car.time)
        love.graphics.print("HITS:" .. car.hits, 12, 12)
        love.graphics.printf(time, screen_width - 150, 12, 135, "right")
    elseif currentGameState == "paused" then
        love.graphics.printf("PAUSED", 0, screen_height / 2 - self.fontSize / 2, screen_width, "center")
    elseif currentGameState == "endOfLevel" then
        local time = string.format("%.2f", car.time)

        local message = "You beat the round!"
        local roundHits = "HITS: " .. car.hits
        local roundTime = "TIME: " .. time

        love.graphics.printf(message, 0, screen_height / 2 - self.fontSize / 2, screen_width, "center")
        love.graphics.printf(roundHits, 0, screen_height / 2 + self.fontSize, screen_width, "center")
        love.graphics.printf(roundTime, 0, screen_height / 2 + (2 * self.fontSize), screen_width, "center")
        love.graphics.printf("Press enter to continue to the next level", 0, screen_height / 2 + (3 * self.fontSize) + self.fontSize / 2, screen_width, "center")
    elseif currentGameState == "win" then
        
    end

    love.graphics.setColor(1,1,1,1)
end