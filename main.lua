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
    tower = {}

    placeTowerFlag = false
    startingPoint = 500
    spawnTimer = 0
    timeLimit = 0
end

function love.update(dt)
    spawnTimer = spawnTimer - dt
    if spawnTimer <= timeLimit and not crystal.defeat then
        timeLimit = timeLimit + dt * 5
        if timeLimit >= 4 then
            timeLimit = 4
        end
        spawnTimer = 5
        table.insert(enemy, Enemy(100, windowsHeight / 2 + 50, 50, 50))
    end
    player:update(dt)
    for i =#tower, 1, -1 do
        tower[i]:update(dt, enemy)
        for j = #enemy, 1, -1 do
            tower[i]:target(enemy[j])
        end
    end
    for i = #enemy, 1, -1 do
        enemy[i]:update(dt)
        enemy[i]:resolveCollision(player)
        if enemy[i].hp < 0 then
            table.remove(enemy, i)
            startingPoint = startingPoint + 50
        else if enemy[i]:resolveCollision(crystal) and not crystal.defeat then
                enemy[i]:attack(crystal, dt)
                crystal:update(dt)
            end
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
    for i = #tower, 1 , -1 do
        tower[i]:draw()
    end
    for i, v in ipairs(enemy) do
        love.graphics.setColor(1, 0, 0)
        v:draw()
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(startingPoint, 10, 10)
end

function love.keypressed(key)
    if key == "up" then
        player:jump()
    elseif key == ("space") and not placeTowerFlag then
        if startingPoint >= 100 then
            placeTowerFlag = true
            startingPoint = startingPoint - 100
            local gridX, gridY = player:placeTower(tower)
            table.insert(tower, Tower(gridX, gridY))
        end
    end
    placeTowerFlag = false
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