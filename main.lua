debug = true

player = {
  speed = 150,
  img = nil,
  x = 100,
  y = 100
}

coronaImg = nil
coronas = {}
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

function love.load(arg)
  coronaImg = love.graphics.newImage('assets/corona.png')
  player.img = love.graphics.newImage('assets/player.png')
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if love.keyboard.isDown('left','a') then
    player.x = player.x - (player.speed*dt)
  elseif love.keyboard.isDown('right','d') then
    player.x = player.x + (player.speed*dt)
  elseif love.keyboard.isDown('up','w') then
    player.y = player.y - (player.speed*dt)
  elseif love.keyboard.isDown('down','s') then
    player.y = player.y + (player.speed*dt)
  end

  -- Time out enemy creation
  createEnemyTimer = createEnemyTimer - (1 * dt)
  if createEnemyTimer < 0 then
    createEnemyTimer = createEnemyTimerMax

    -- Create an enemy
    randomNumber = math.random(10, love.graphics.getHeight() - 10)
    newCorona = { y = randomNumber, x = love.graphics.getWidth() -10, img = coronaImg }
    table.insert( coronas, newCorona )
  end

  -- update the positions of enemies
  for i, corona in ipairs(coronas) do
    corona.x = corona.x - (200 * dt)

    if corona.x < -64 then -- remove enemies when they pass off the screen
      table.remove(coronas, i)
    end
  end
end

function love.draw(dt)
  love.graphics.draw(player.img, player.x, player.y)
  for i, corona in ipairs(coronas) do
    love.graphics.draw(corona.img, corona.x, corona.y)
  end
end
