-- Configuration
function love.conf(t)
  t.identity              = nil
  t.accelerometerjoystick = true
  t.version               = "11.1"
  t.gammacorret           = false

  t.title                 = "Desafio Corona 2020"
  t.window.icon           = "assets/image/icon.png"
  t.window.width          = 800
  t.window.height         = 480
  t.window.borderless     = false
  t.window.resizable      = false
  t.window.fullscreen     = false
  t.window.fullscreentype = "desktop"
  t.window.vsync          = true
  t.window.msaa           = 16 -- antialiase

  -- For Windows debugging
  t.console               = true
end
