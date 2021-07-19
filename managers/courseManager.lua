CourseManager = Object.extend(Object)

function CourseManager:new(data)
    self.levelData = data
end

function CourseManager:update(entities)
    if levelJustChanged then
        levelJustChanged = false
        entities:loadLevel()
        currentGameState = "playing"
    end
end