  local begin_contact_callback = function(fixture_a, fixture_b, contact)
    local aUserData = fixture_a:getUserData()
    local bUserData = fixture_b:getUserData()

    if aUserData ~= nil then
      if bUserData ~= nil then
        if aUserData.name == "carPutter" and bUserData.name == "ball" then
          aUserData.increaseHits()
        end
      end
      
      if aUserData.name == "ball" then
        aUserData.handleCollision()
      end
    end
    if bUserData ~= nil then
      if aUserData ~= nil then
        if bUserData.name == "carPutter" and aUserData.name == "ball" then
          bUserData.increaseHits()
        end
      end

      if bUserData.name == "ball" then
        bUserData.handleCollision()
      end
    end
  end
  
  local end_contact_callback = function(fixture_a, fixture_b, contact)
  end
  
  local pre_solve_callback = function(fixture_a, fixture_b, contact)
    
  end
  
  local post_solve_callback = function(fixture_a, fixture_b, contact)
    carCollision(fixture_a, fixture_b)
  end

  function carCollision(fixture_a, fixture_b)
    local aUserData = fixture_a:getUserData()
    local bUserData = fixture_b:getUserData()

    if aUserData ~= nil and aUserData.name == "carBody" then
      aUserData.collisionHandler(fixture_a, fixture_b)
    elseif bUserData ~= nil and bUserData.name == "carBody" then
      bUserData.collisionHandler(fixture_b, fixture_a)
    end
  end
  
  local world = love.physics.newWorld(0,0)
  
  world:setCallbacks(
    begin_contact_callback,
    end_contact_callback,
    pre_solve_callback,
    post_solve_callback
  )

  return world