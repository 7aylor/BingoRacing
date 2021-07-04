  local begin_contact_callback = function(fixture_a, fixture_b, contact)
    local aUserData = fixture_a:getUserData()
    local bUserData = fixture_b:getUserData()

    if aUserData ~= nil and aUserData.name == "car" then
      aUserData.collisionHandler(fixture_b)
      if bUserData ~= nil and bUserData.name == "ball" then
        aUserData.increaseHits()
      end
    elseif bUserData ~= nil and bUserData.name == "car" then
      bUserData.collisionHandler(fixture_a)
      if aUserData ~= nil and aUserData.name == "ball" then
        bUserData.increaseHits()
      end
    end
  end
  
  local end_contact_callback = function(fixture_a, fixture_b, contact)
    local aUserData = fixture_a:getUserData()
    local bUserData = fixture_b:getUserData()
    
    if aUserData ~= nil and bUserData ~= nil then
      if (aUserData.name == "ball" and bUserData.name == "goal") or
      (aUserData.name == "goal" and bUserData.name == "ball") then
        aUserData.collisionHandler()
        bUserData.collisionHandler()
      end
    end

  end
  
  local pre_solve_callback = function(fixture_a, fixture_b, contact)
  end
  
  local post_solve_callback = function(fixture_a, fixture_b, contact)
  end
  
  local world = love.physics.newWorld(0,0)
  
  world:setCallbacks(
    begin_contact_callback,
    end_contact_callback,
    pre_solve_callback,
    post_solve_callback
  )

  return world