--[[
https://incompetech.com/music/
Strength Of The Titans by Kevin MacLeod
Link: https://filmmusic.io/song/5744-strength-of-the-titans
License: http://creativecommons.org/licenses/by/4.0/

Circus Of Freaks by Kevin MacLeod
Link: https://incompetech.filmmusic.io/song/5740-circus-of-freaks
License: http://creativecommons.org/licenses/by/4.0/

Sound from Zapsplat.com


--]]
local anim8 = require 'anim8'

screenWidth  = love.graphics.getWidth();
screenHeight = love.graphics.getHeight();

debug = true

player = {
  speed   = 150,
  img     = nil,
  x       = 100,
  y       = 100,
  mask    = 3,
  alcohol = 0
}

-- Imagens
alcoholImg       = nil
coronaImg        = nil
playerImg_0      = nil
playerImg_1      = nil
playerImg_2      = nil
playerImg_3      = nil

-- Sons
playerSndFatigue = nil
playerSndDead    = nil
alcoholBubbleSnd = nil

-- Músicas
backgroundMusic  = nil

-- Listas de objetos
coronas  = nil
alcohols = nil

-- Tempos para criação
createCoronaTimerMax  = 0.4
createAlcoholTimerMax = 1
-- Temporizadores
createCoronaTimer    = createCoronaTimerMax
createAlcoholTimer   = createAlcoholTimerMax

image = nil

function status()
  local st = "STATUS" .. " Máscaras: " .. player.mask .. " Alcool: " .. player.alcohol
  -- love.graphics.setColor(0, 0, 0)
  love.graphics.print(st, 10, 10)
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))
end

function checkCollisionRadius(x1, y1, r1, x2, y2, r2)
  return distance(x1, y1, x2, y2) <= (r1+r2)
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function updatePlayerPosition(dt)
  if love.keyboard.isDown('left','a') then
    player.x = player.x - (player.speed*dt)
    if player.x < 10 then player.x = 10 end
  elseif love.keyboard.isDown('right','d') then
    player.x = player.x + (player.speed*dt)
    if player.x > screenWidth - 50 then player.x = screenWidth - 50 end
  elseif love.keyboard.isDown('up','w') then
    player.y = player.y - (player.speed*dt)
    if player.y < 30 then player.y = 30 end
  elseif love.keyboard.isDown('down','s') then
    player.y = player.y + (player.speed*dt)
    if player.y > screenHeight - 50 then player.y = screenHeight - 50 end
  end
end

function createCoronas(dt)
  createCoronaTimer = createCoronaTimer - (1 * dt)
  if createCoronaTimer < 0 then
    createCoronaTimer = createCoronaTimerMax
    randomNumber = math.random(30, love.graphics.getHeight() - 50)
    newCorona = { y = randomNumber, x = love.graphics.getWidth() - 10, img = coronaImg }
    table.insert(coronas, newCorona)
  end
end

function createAlcohol(dt)
  createAlcoholTimer = createAlcoholTimer - (1 * dt)
  if createAlcoholTimer < 0 then
    createAlcoholTimer = createAlcoholTimerMax
    randomNumber = math.random(30, love.graphics.getHeight() - 50)
    newAlcohol = { y = randomNumber, x = love.graphics.getWidth() - 10, img = alcoholImg }
    table.insert(alcohols, newAlcohol)
  end
end

function updateCoronasPosition(dt)
  for i, corona in ipairs(coronas) do
    corona.x = corona.x - (200 * dt)
    if corona.x < -64 then
      table.remove(coronas, i)
    end
  end
end

function updateAlcoholsPosition(dt)
  for i, alcohol in ipairs(alcohols) do
    alcohol.x = alcohol.x - (200 * dt)
    if alcohol.x < -64 then
      table.remove(alcohols, i)
    end
  end
end

function checkColisionAlcohol(dt)
  for i, alcohol in ipairs(alcohols) do
    if checkCollisionRadius(alcohol.x, alcohol.y, alcohol.img:getWidth()*0.4, player.x, player.y, player.img:getWidth()*0.4) then
      alcoholBubbleSnd:play();

      table.remove(alcohols, i)
      player.alcohol = player.alcohol + 1
    end
  end
end

function checkColisionCorona(dt)
  for i, corona in ipairs(coronas) do
    -- if checkCollision(corona.x, corona.y, corona.img:getWidth(), corona.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) then
    if checkCollisionRadius(corona.x, corona.y, corona.img:getWidth()*0.4, player.x, player.y, player.img:getWidth()*0.4) then
      playerSndFatigue:play()

      table.remove(coronas, i)
      player.mask = player.mask - 1

      if player.mask == 0 then
        player.img = playerImg_0
      elseif player.mask == 1 then
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

function love.load(arg)
  -- oculta o cursor do mouse
  love.mouse.setVisible(false)

  image = love.graphics.newImage('assets/image/corona_grid.png')
  local g = anim8.newGrid(64, 64, image:getWidth(), image:getHeight())
  coronaAnim = anim8.newAnimation(g('1-3',1), 0.1)

  alcoholImg  = love.graphics.newImage('assets/image/alcohol70_32x32.png')
  cursorImg   = love.graphics.newImage('assets/image/biohazard_32x32.png')
  coronaImg   = love.graphics.newImage('assets/image/corona.png')
  playerImg_0 = love.graphics.newImage('assets/image/player_0.png')
  playerImg_1 = love.graphics.newImage('assets/image/player_1.png')
  playerImg_2 = love.graphics.newImage('assets/image/player_2.png')
  playerImg_3 = love.graphics.newImage('assets/image/player_3.png')

  playerSndFatigue = love.audio.newSource('assets/sound/NFF-boy-fatigue.wav', 'static')
  playerSndDead    = love.audio.newSource('assets/sound/NFF-magic-drop.wav', 'static')
  alcoholBubbleSnd = love.audio.newSource('assets/sound/alcohol_bubbles.mp3', 'static')

  backgroundMusic = love.audio.newSource('assets/music/circus-of-freaks-by-kevin-macleod-from-filmmusic-io.mp3','stream')
  -- backgroundMusic = love.audio.newSource('assets/music/strength-of-the-titans-by-kevin-macleod-from-filmmusic-io.mp3','stream')

  backgroundMusic:setVolume(0.05) -- 90% of ordinary volume
  backgroundMusic:setLooping(true)
  -- backgroundMusic:setPitch(0.5) -- one octave lower
  backgroundMusic:play()

  player.img = playerImg_0;
  player.mask = 3;

  coronas  = {}
  alcohols = {}
end


function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  coronaAnim:update(dt)

  createCoronas(dt)
  createAlcohol(dt)

  updatePlayerPosition(dt)
  updateCoronasPosition(dt)
  updateAlcoholsPosition(dt)

  checkColisionCorona(dt)
  checkColisionAlcohol(dt)
end

function love.draw(dt)
  love.graphics.setBackgroundColor(0.9, 0.9, 0.9)

  -- cursor alternativo do mouse
  -- love.graphics.draw(cursorImg, love.mouse.getX(), love.mouse.getY())

  love.graphics.draw(player.img, player.x, player.y)

  for i, corona in ipairs(coronas) do
    coronaAnim:draw(image, corona.x, corona.y)
  end

  for i, alcohol in ipairs(alcohols) do
    love.graphics.draw(alcoholImg, alcohol.x, alcohol.y)
  end

  status()
end

--[[
function love.focus(f)
  if f then
    print "Janela do jogo ativa"
  else
    print "Sem foco no jogo!"
  end
end

function love.quit()
  print("Volte logo!")
  if love.timer.sleep(3) == 0 then
    -- aqui o programa é fechado
  end
end
--]]

