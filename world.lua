local begin_contact_callback = function(fixture_a, fixture_b, contact)
    local aUserData = fixture_a:getUserData()
    if aUserData ~= nil and aUserData.name == "car" then
        aUserData.collisionHandler()
    end
    -- print(fixture_a, fixture_b, contact, 'beginning contact')
  end
  
  local end_contact_callback = function(fixture_a, fixture_b, contact)
    --print(fixture_a, fixture_b, contact, 'ending contact')
    local aUserData = fixture_a:getUserData()
    local bUserData = fixture_b:getUserData()
    if aUserData ~= nil and bUserData ~= nil then
      if (aUserData.name == "barrel" and bUserData.name == "goal") then
        aUserData.collisionHandler()
      elseif (aUserData.name == "goal" and bUserData.name == "barrel") then
        bUserData.collisionHandler()
      end
    end
  end
  
  local pre_solve_callback = function(fixture_a, fixture_b, contact)
   -- print(fixture_a, fixture_b, contact, 'about to resolve a contact')
  end
  
  local post_solve_callback = function(fixture_a, fixture_b, contact)
   -- print(fixture_a, fixture_b, contact, 'just resolved a contact')
  end
  
  local world = love.physics.newWorld(0,0)
  
  world:setCallbacks(
    begin_contact_callback,
    end_contact_callback,
    pre_solve_callback,
    post_solve_callback
  )

  return world