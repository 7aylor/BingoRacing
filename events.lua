--more info: https://love2d.org/wiki/love.event

--can use by calling love.event.push("goToNextHole")
love.handlers.goToNextHole = function()
    currentHole = currentHole + 1
    paused = false
    currentGameState = "playing"
    entities:loadLevel()
end

--can use by calling love.event.push("restartHole")
love.handlers.restartHole = function()
    paused = false
    currentGameState = "playing"
    entities:loadLevel()
end