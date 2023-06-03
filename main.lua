if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    Objects = require "classic"
    require "entity"
    require "player"
    require "enemy"
    require "crystal"
    require "tower"

    windowsWidth = love.graphics.getWidth()
    windowsHeight = love.graphics.getHeight()
    player = Player(windowsWidth / 2 - 50, windowsHeight / 2, 50, 100)
    enemy = {}
    crystal = Crystal(windowsWidth / 2, windowsHeight / 2, 50, 100)
    tower = Tower(windowsWidth / 2 + 70, windowsHeight / 2 - 20)

    spawnTimer = 0
end

function love.update(dt)
    spawnTimer = spawnTimer - dt
    if spawnTimer < 0 and not crystal.defeat then
        spawnTimer = 5
        table.insert(enemy, Enemy(100, windowsHeight / 2 + 50, 50, 50))
    end
    player:update(dt)
    tower:update(dt)
    for i = #enemy, 1, -1 do
        enemy[i]:update(dt)
        enemy[i]:resolveCollision(player)
        if enemy[i]:resolveCollision(crystal) and not crystal.defeat then
            enemy[i]:attack(crystal, dt)
            crystal:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(0, windowsHeight / 2 + player.height, windowsWidth, windowsHeight / 2 + player.height)
    love.graphics.setColor(0, 1, 0)
    crystal:draw()
    love.graphics.setColor(0, 1, 1)
    player:draw()
    love.graphics.setColor(0, 1, 1)
    tower:draw()
    for i, v in ipairs(enemy) do
        love.graphics.setColor(1, 0, 0)
        v:draw()
        if tower:target(v) then
            love.graphics.setColor(1, 1, 0)
            love.graphics.line(v.x + v.width, v.y + v.width / 2, tower.x + tower.width / 2, tower.y + tower.height / 2)
        end
    end
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