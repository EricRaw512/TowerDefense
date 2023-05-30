if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    Objects = require "classic"
    require "entity"
    require "player"
    require "enemy"

    windowsWidth = love.graphics.getWidth()
    windowsHeight = love.graphics.getHeight()
    player = Player(100, 100, 50, 100)
    enemy = Enemy(100, windowsHeight / 2 + 50, 50, 50)

end

function love.update(dt)
    player:update(dt)
    enemy:update(dt)
    player:resolveCollision(enemy)
    --print(player.gravity)
end

function love.draw()
    love.graphics.setColor(0, 1, 1)
    player:draw()
    love.graphics.setColor(1, 0, 0)
    enemy:draw()
    love.graphics.line(player.x, player.y, enemy.x, enemy.y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(0, windowsHeight / 2 + player.height, windowsWidth, windowsHeight / 2 + player.height)
end

function love.keypressed(key)
    if key == "up" then
        player:jump()
    end
end

---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end