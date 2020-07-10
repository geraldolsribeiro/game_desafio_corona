debug = true

player = {
  speed = 150,
  img = nil,
  x = 100,
  y = 100
}

corona = {
  speed = -150,
  img = nil,
  x = 400,
  y = 200
}

function love.load(arg)
  corona.img = love.graphics.newImage('assets/corona.png')
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
end

function love.draw(dt)
  love.graphics.draw(corona.img, corona.x, corona.y)
  love.graphics.draw(player.img, player.x, player.y)
end
