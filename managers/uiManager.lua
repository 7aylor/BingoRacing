UIManager = Object.extend(Object)

function UIManager:new()
    self.fontSize = 20
    self.font = love.graphics.newFont("fonts/Ldfcomicsans-jj7l.ttf", self.fontSize)
    love.graphics.setFont(self.font)
end

function UIManager:draw(car)
    love.graphics.setColor(1,1,1,1)
    local carX = car.body:getX()
    local carY = car.body:getY()
    local offsetX = screen_width / 2
    local offsetY = screen_height / 2
    
    if currentGameState == "mainMenu" then
        
    elseif currentGameState == "playing" then
        local time = math.floor(car.time)
        love.graphics.print("HITS:" .. car.hits, carX - offsetX + 24, carY - offsetY + 24)
        love.graphics.printf(time, carX + offsetX - 150,  carY - offsetY + 24, 150 - 24, "right")
        love.graphics.setColor(0,0,0,1)
        local turboRectWidth = 100
        local turboRectHeight = 20
        love.graphics.rectangle("line", carX - turboRectWidth / 2, carY - offsetY + 24, turboRectWidth, turboRectHeight)
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle("fill", carX - turboRectWidth / 2, carY - offsetY + 24, turboRectWidth, turboRectHeight)
        love.graphics.setColor(0,1,0,1)
        love.graphics.rectangle("fill", carX - turboRectWidth / 2, carY - offsetY + 24, math.clamp(0, car.turbo_power * turboRectWidth, turboRectWidth), turboRectHeight)

    elseif currentGameState == "paused" then
        love.graphics.printf("PAUSED", carX - offsetX, carY - self.fontSize / 2 - offsetY / 3, screen_width, "center")
    elseif currentGameState == "endOfLevel" then
        local time = string.format("%.2f", car.time)

        local message = "You beat the round!"
        local roundHits = "HITS: " .. car.hits
        local roundTime = "TIME: " .. time .. "s"
        
        love.graphics.setColor(0.1,0,0.75, 0.8)
        local rect_width = 400
        local rect_height = 300
        love.graphics.rectangle("fill", carX - rect_width / 2, carY - rect_height / 2, rect_width, rect_height)
        love.graphics.setColor(1,1,1,1)
        
        local print_top = carY - rect_height / 4
        love.graphics.printf(message, carX - offsetX, print_top - self.fontSize / 2, screen_width, "center")
        love.graphics.printf(roundHits, carX - offsetX, print_top + self.fontSize, screen_width, "center")
        love.graphics.printf(roundTime, carX - offsetX, print_top + (2 * self.fontSize), screen_width, "center")
        love.graphics.printf("Press enter to continue to the next level", carX - offsetX, print_top + (3 * self.fontSize) + self.fontSize / 2, screen_width, "center")
    elseif currentGameState == "win" then

        love.graphics.setColor(0.1,0,0.75, 0.8)
        love.graphics.rectangle("fill",carX - offsetX, carY - offsetY, screen_width, screen_height)
        love.graphics.setColor(1,1,1,1)
        local print_top = 100
        local message = "Congratulations, you won!"
        love.graphics.printf(message, carX - offsetX, carY - print_top - self.fontSize / 2, screen_width, "center")

        for i,v in ipairs(entities.results) do
            local resultMessage = v["level"] .. " - HITS - " .. v["hits"] .. " - TIME - " .. v["time"]
            love.graphics.printf(resultMessage, carX - offsetX, carY - print_top + (self.fontSize * i), screen_width, "center")
        end

        love.graphics.printf("Press Enter to replay or Esc to exit", carX - offsetX, carY - print_top + (self.fontSize * (#entities.results + 1)), screen_width, "center")
    end

    if debug then
        love.graphics.setColor(0,1,0,1)
        love.graphics.print(love.timer.getFPS(), carX + offsetX - 40, carY + offsetY - 40)

        love.graphics.print("speed:" .. car.speed, carX - offsetX + 20, carY + offsetY - 80)
        love.graphics.print("acc:" .. car.acceleration, carX - offsetX + 20, carY + offsetY - 60)
        love.graphics.print("b_acc:" .. car.backup_accelartion, carX - offsetX + 20, carY + offsetY - 40)
        
    end

    love.graphics.setColor(1,1,1,1)
end