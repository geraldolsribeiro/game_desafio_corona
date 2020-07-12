--[[
--
--]]
local anim8 = require 'anim8'

debug = true

player = {
  speed = 150,
  img   = nil,
  x     = 100,
  y     = 100,
  mask  = 0
}


coronaImg = nil
playerImg_0 = nil
playerImg_1 = nil
playerImg_2 = nil
playerImg_3 = nil
playerSndFatigue = nil
playerSndDead = nil

coronas = {}
createCoronaTimerMax = 0.4
createCoronaTimer = createCoronaTimerMax
image = nil

function status()
  local st = "STATUS" .. "Máscaras: " .. 0
  -- love.graphics.setColor( 0, 0, 0 )
  love.graphics.print( st, 10, 10 )
end

function distance( x1, y1, x2, y2 )
  return math.sqrt( (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) )
end

function checkCollisionRadius( x1, y1, r1, x2, y2, r2 )
  return distance( x1, y1, x2, y2 ) <= (r1+r2)
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function love.load(arg)

  -- oculta o cursor do mouse
  love.mouse.setVisible( false )


  image = love.graphics.newImage('assets/corona_grid.png')
  local g = anim8.newGrid(64, 64, image:getWidth(), image:getHeight())
  animation = anim8.newAnimation(g('1-3',1), 0.1)

  cursorImg = love.graphics.newImage('assets/biohazard_32x32.png')
  coronaImg = love.graphics.newImage('assets/corona.png')
  playerImg_0 = love.graphics.newImage('assets/player_0.png')
  playerImg_1 = love.graphics.newImage('assets/player_1.png')
  playerImg_2 = love.graphics.newImage('assets/player_2.png')
  playerImg_3 = love.graphics.newImage('assets/player_3.png')
  playerSndFatigue = love.audio.newSource('assets/NFF-boy-fatigue.wav', 'static')
  playerSndDead = love.audio.newSource( 'assets/NFF-magic-drop.wav', 'static' )
  player.img = playerImg_0;
  player.mask = 0;
  coronas = {}
end

-- Atualização em tempo real
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

  animation:update(dt)

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
    -- if checkCollision(corona.x, corona.y, corona.img:getWidth(), corona.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) then
    if checkCollisionRadius(corona.x, corona.y, corona.img:getWidth()*0.4, player.x, player.y, player.img:getWidth()*0.4) then
      table.remove(coronas, i)
      player.mask = player.mask + 1

      playerSndFatigue:play()

      if player.mask == 1 then
        player.img = playerImg_1
      elseif player.mask == 2 then
        player.img = playerImg_2
      elseif player.mask == 3 then
        player.img = playerImg_3
      else
        playerSndDead:play()
        love.load()
      end
      -- table.remove(bullets, j)
      -- score = score + 1
    end
  end

end

function love.draw(dt)
  love.graphics.setBackgroundColor( 0.9, 0.9, 0.9 )

  -- cursor alternativo do mouse
  -- love.graphics.draw( cursorImg, love.mouse.getX(), love.mouse.getY() )

  -- draw( img, x, y, rot, wF, hF, origemX, origemH )
  love.graphics.draw(player.img, player.x, player.y)

  for i, corona in ipairs(coronas) do
    -- love.graphics.draw(corona.img, corona.x, corona.y)
    animation:draw(image, corona.x, corona.y)
  end

  status()
end

--[[
function love.focus( f )
  if f then
    print "Janela do jogo ativa"
  else
    print "Sem foco no jogo!"
  end
end

function love.quit()
  print( "Volte logo!" )
  if love.timer.sleep( 3 ) == 0 then
    -- aqui o programa é fechado
  end
end
--]]

