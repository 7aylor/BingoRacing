--table that maps actions to keys
keymap = {
    go_forward = {"up", "w"},
    backup = {"down", "s"},
    turn_left = {"left", "a"},
    turn_right = {"right", "d"},
    powerup = {"space"},
    quit = {"escape"},
    pause = {"p"},
    restart = {"r"}
}
--table that holds currently pressed keys and related functions
input = {
    actions = {}
}

--function for handling key press events
input.keypressed = function(key)
    --add action to input if key from that action is pressed
    input.add_action(key)

    --input.print_inputs()

    if input.keymap_action_contains(key, "quit") then
        love.event.quit()
    end
    if input.keymap_action_contains(key, "pause") then
        --pause game
    end
    if input.keymap_action_contains(key, "restart") then
        print("restart")
        love.event.quit('restart')
    end
end

--function for handling key release events
input.keyreleased = function(key)
    input.remove_action(key)
end

--check if keymap contains currently pressed key
input.keymap_contains = function(key)
    for index, value in pairs(keymap) do
        for i=1,#value do
            if value[i] == key then
                return true
            end
        end
    end

    return false
end

--check if a particular action contains the currently pressed key
input.keymap_action_contains = function(key, actionkey)
    local action = keymap[actionkey]

    for i,v in pairs(action) do
        if v == key then
            return true
        end
    end

    return false
end

--returns the name of the keymap action based on the pressed key
input.get_action_from_key = function(pressedkey)
    for key, action in pairs(keymap) do
        for i,v in ipairs(action) do
            if v == pressedkey then
                return key
            end
        end
    end

    return nil
end

--adds the keymap action to input (indicating that that action has been pressed)
--if key has been pressed related to a defined action
input.add_action = function(key) 
    local action = input.get_action_from_key(key)

    if action then
        input.actions[action] = action
    end
end

--removes the keymap action from input if key has been pressed related to a defined action
input.remove_action = function(key)
    local action = input.get_action_from_key(key)

    if action then
        input.actions[action] = nil
    end
end

input.print_inputs = function()
    for key,value in pairs(input.actions) do
        print(value)
    end
end

return input