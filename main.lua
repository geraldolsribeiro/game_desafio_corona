debug = true

player = {
  img = nil
}

corona = {
  img = nil
}

function love.load(arg)
  corona.img = love.graphics.newImage('assets/corona.png')
  player.img = love.graphics.newImage('assets/player.png')
end

function love.update(dt)

end

function love.draw(dt)
  love.graphics.draw(corona.img, 300, 100)
  love.graphics.draw(player.img, 100, 100)
end
