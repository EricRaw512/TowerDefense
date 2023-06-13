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
    require "wall"

    love.window.setMode(800, 600, {resizable=true, vsync=false})
    windowsWidth = 1920
    windowsHeight = 1080

    enemy = {}
    crystal = Crystal(windowsWidth / 2 - 10, windowsHeight / 2 + 10, 50, 100)
    player = Player(windowsWidth / 2, windowsHeight / 2 + 10, 50, 100)
    towers = {}
    walls = {}

    offsetX = -player.x + 400
    offsetY = -player.y + 300
    placingTower = false
    towerType = 0
    placeTowerFlag = false
    startingPoint = 500
    leftSpawnTimer = 5
    rightSpawnTimer = 10
    timeLimit = 0
end

function love.update(dt)
    player:update(dt)
    leftSpawnTimer = leftSpawnTimer - dt
    rightSpawnTimer = rightSpawnTimer - dt
    if leftSpawnTimer <= timeLimit and not crystal.defeat then
        leftSpawnTimer = 10
        local enemyLeftSpawn = 100
        table.insert(enemy, Enemy(enemyLeftSpawn, windowsHeight / 2 + 60, 50, 50))
    elseif rightSpawnTimer <= timeLimit and not crystal.defeat then
        rightSpawnTimer = 10
        local enemyrightSpawn = 1820
        table.insert(enemy, Enemy(enemyrightSpawn, windowsHeight / 2 + 60, 50, 50))
    end

    for i = #enemy, 1, -1 do
        enemy[i]:update(dt)
        enemy[i]:resolveCollision(player)
        if enemy[i].hp < 0 then
            table.remove(enemy, i)
            startingPoint = startingPoint + 50
        else 
            if enemy[i]:resolveCollision(crystal) and not crystal.defeat then
                enemy[i]:attack(crystal, dt)
                crystal:update(dt)
            end
            for j = #walls, 1, -1 do
                if enemy[i]:resolveCollision(walls[j]) then
                    enemy[i]:attack(walls[j], dt)
                end
                if walls[j].hp <= 0 then
                    table.remove(walls, j)
                end
            end
        end
    end

    offsetX = -player.x + 400
    offsetY = -player.y + 300

    for i =#towers, 1, -1 do
        towers[i]:update(dt, enemy, offsetX, offsetY)
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
end

function love.draw()
    if love.graphics.getWidth() ~= 1920 and love.graphics.getHeight() ~= 1080 then
        love.graphics.translate(offsetX, offsetY)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.line(0, windowsHeight / 2 + player.height + 10, windowsWidth, windowsHeight / 2 + player.height + 10)
    love.graphics.setColor(0, 1, 0)
    crystal:draw()
    for i, v in ipairs(enemy) do
        love.graphics.setColor(1, 0, 0)
        v:draw()
        v:drawHealthBar()
    end
    love.graphics.setColor(0.5, 1, 1)
    for i, wall in ipairs(walls) do
        wall:draw()
        wall:drawHealthBar()
    end
    for i, tower in ipairs(towers) do
        tower:drawTower()
        tower:drawBullet()
        tower:drawHealthBar()
    end
    love.graphics.setColor(0, 0.5, 1)
    player:draw()
    if placingTower then
        local destinationX, destinationY = placeInFrontOfCharacter(player)
        love.graphics.rectangle("line", destinationX, destinationY, 50, 50)
    end
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Points : " .. startingPoint, 10, 10)
end

function love.keypressed(key)
    if key == "up" then
        player:jump()
    elseif key == '1' and startingPoint >= 100 then
        placingTower = true
        towerType = 1
    elseif key == '2' and startingPoint >= 100 then
        placingTower = true
        towerType = 2
    elseif key == "space" and not placeTowerFlag and player.gravity == 0 and placingTower then
        local isPlayerOnEnemy = false
        for i, e in ipairs(enemy) do
            if player.y + player.height <= e.y and
                player.x + player.width >= e.x and
                player.x <= e.x + e.width then
                isPlayerOnEnemy = true
                break
            end
        end
        placeTowerFlag = true
        local towerX, towerY = Tower:placeInFrontOfCharacter(player)
        if not isPlayerOnEnemy and towerX > 100 and towerX < 1800 and not isOccupied(towerX, towerY) then
            startingPoint = startingPoint - 100
            placingTower = false
            if towerType == 1 then
                table.insert(towers, Tower(towerX, towerY))
            elseif towerType == 2 then
                table.insert(walls, Wall(towerX, towerY))                 
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

    for i, w in ipairs(walls) do
        if w.x == gridX and w.y == gridY then
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

    if gridX == 950 then
        return true
    end

    return false    
end

function placeInFrontOfCharacter(player)
    local gridSize = 50
    local offsetX = math.cos(player.facingAngle) * gridSize
    local offsetY = math.sin(player.facingAngle) * gridSize
    local gridX = math.floor((player.x + player.width / 2+ offsetX) / gridSize) * gridSize
    local gridY = math.floor((player.y + player.height / 2+ offsetY) / gridSize) * gridSize
    gridX = math.max(0, math.min(gridX, 1920 - player.width))
    gridY = math.max(0, math.min(gridY, 1080 - player.height))
    return gridX, gridY
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