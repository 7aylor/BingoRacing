LevelManager = Object.extend(Object)

function LevelManager:new()

end

function LevelManager:update(entities)
    if levelJustChanged then
        levelJustChanged = false
        entities:loadLevel()
        currentGameState = "playing"
    end
end