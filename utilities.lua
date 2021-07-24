function formatTime(seconds)
    local mins = 0
    if seconds >= 60 then
        mins = math.floor(seconds / 60)
        seconds = seconds % 60
    end
    
    --max out at an hours
    if mins > 60 then
        mins = 60
        seconds = 0
    end
    
    if mins < 10 then 
        mins = "0" .. mins
    end
    if seconds < 10 then
        seconds = "0" .. seconds
    end

    return mins .. ":" .. seconds
end