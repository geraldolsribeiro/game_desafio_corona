debug = true

player = {
  speed = 150,
  img = nil,
  x = 100,
  y = 100
}

coronaImg = nil
coronas = {}
createCoronaTimerMax = 0.4
createCoronaTimer = createCoronaTimerMax

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

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

  -- Create an enemy
  createCoronaTimer = createCoronaTimer - (1 * dt)
  if createCoronaTimer < 0 then
    createCoronaTimer = createCoronaTimerMax
    randomNumber = math.random(10, love.graphics.getHeight() - 10)
    newCorona = { y = randomNumber, x = love.graphics.getWidth() -10, img = coronaImg }
    table.insert( coronas, newCorona )
  end

  -- update the positions of coronas
  for i, corona in ipairs(coronas) do
    corona.x = corona.x - (200 * dt)
    if corona.x < -64 then -- remove coronas when they pass off the screen
      table.remove(coronas, i)
    end
  end

  for i, corona in ipairs(coronas) do
    if checkCollision(corona.x, corona.y, corona.img:getWidth(), corona.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) then
      table.remove(coronas, i)
      -- table.remove(bullets, j)
      -- score = score + 1
    end
  end

end

function love.draw(dt)
  love.graphics.draw(player.img, player.x, player.y)
  for i, corona in ipairs(coronas) do
    love.graphics.draw(corona.img, corona.x, corona.y)
  end
end
