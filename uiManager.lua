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
        love.graphics.print("HITS:" .. car.hits, 24, 24)
        love.graphics.printf(time, screen_width - 150, 24, 150 - 24, "right")
    elseif currentGameState == "paused" then
        love.graphics.printf("PAUSED", 0, screen_height / 2 - self.fontSize / 2, screen_width, "center")
    elseif currentGameState == "endOfLevel" then
        local time = string.format("%.2f", car.time)

        local message = "You beat the round!"
        local roundHits = "HITS: " .. car.hits
        local roundTime = "TIME: " .. time .. "s"
        
        love.graphics.setColor(0.1,0,0.75, 0.8)
        local rect_width = 400
        local rect_height = 300
        love.graphics.rectangle("fill", screen_width / 2 - rect_width / 2, screen_height / 2 - rect_height / 2, rect_width, rect_height)
        love.graphics.setColor(1,1,1,1)
        
        local print_top = screen_height / 2 - rect_height / 4
        love.graphics.printf(message, 0, print_top - self.fontSize / 2, screen_width, "center")
        love.graphics.printf(roundHits, 0, print_top + self.fontSize, screen_width, "center")
        love.graphics.printf(roundTime, 0, print_top + (2 * self.fontSize), screen_width, "center")
        love.graphics.printf("Press enter to continue to the next level", 0, print_top + (3 * self.fontSize) + self.fontSize / 2, screen_width, "center")
    elseif currentGameState == "win" then

        love.graphics.setColor(0.1,0,0.75, 0.8)
        love.graphics.rectangle("fill",0, 0, screen_width, screen_height)
        love.graphics.setColor(1,1,1,1)
        local print_top = 100
        local message = "Congratulations, you won!"
        love.graphics.printf(message, 0, print_top - self.fontSize / 2, screen_width, "center")

        for i,v in ipairs(entities.results) do
            local resultMessage = v["level"] .. " - HITS - " .. v["hits"] .. " - TIME - " .. v["time"]
            love.graphics.printf(resultMessage, 0, print_top + (self.fontSize * i), screen_width, "center")
        end

        love.graphics.printf("Press Enter to replay or Esc to exit", 0, print_top + (self.fontSize * (#entities.results + 1)), screen_width, "center")
    end

    love.graphics.setColor(1,1,1,1)
end