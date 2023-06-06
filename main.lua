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
    towers = {}

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
    for i =#towers, 1, -1 do
        towers[i]:update(dt, enemy)
        for j = #enemy, 1, -1 do
            towers[i]:target(enemy[j])
            if enemy[j]:resolveCollision(towers[i]) then
                enemy[j]:attack(towers[i], dt)
            end
        end
        if towers[i].hp < 0 then
            table.remove(towers, i)
        end
    end
    for i = #enemy, 1, -1 do
        enemy[i]:update(dt)
        enemy[i]:resolveCollision(player)
        if enemy[i].hp < 0 then
            table.remove(enemy, i)
            startingPoint = startingPoint + 50
        elseif enemy[i]:resolveCollision(crystal) and not crystal.defeat then
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
    for i = #towers, 1 , -1 do
        towers[i]:draw()
    end
    for i, v in ipairs(enemy) do
        love.graphics.setColor(1, 0, 0)
        v:draw()
    end
    love.graphics.setColor(0, 0.5, 1)
    player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Points : " ..startingPoint, 10, 10)
end

function love.keypressed(key)
    if key == "up" then
        player:jump()
    elseif key == "space" and not placeTowerFlag and player.gravity == 0 then
        if startingPoint >= 100 then
            placeTowerFlag = true
            local towerX, towerY = Tower:placeInFrontOfCharacter(player)
            if towerX ~= windowsWidth / 2 and towerX > 100 and not isOccupied(towerX, towerY) then
                startingPoint = startingPoint - 100
                table.insert(towers, Tower(towerX, towerY))
            end
        end
    end
    placeTowerFlag = false
end

function isOccupied(gridX, gridY)
    local gridSize = 50
    for i, t in ipairs(towers) do
        if t.x == gridX and t.y == gridY then
            return true
        end
    end

    for i, e in ipairs(enemy) do
        local enemyGridX = math.floor((e.x + e.width / 2) / gridSize) * gridSize
        local enemyGridY = math.floor((e.y + e.height / 2) / gridSize) * gridSize
        if enemyGridX == gridX and enemyGridY == gridY then
            return true
        end
    end

    return false
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