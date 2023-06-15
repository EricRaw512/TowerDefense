if arg[2] == "debug" then
    require("lldebugger").start()
end

local windowsWidth = 1920
local windowsHeight = 1080
local wave = 1
local leftSpawnTimer = 0
local rightSpawnTimer = 5
local timeLimit = 0
local placingTower = false
local towerType = 0
local placeTowerFlag = false
local startingPoint = 500
local wavesDelay = 60
local enemyNum = 0
local spawn = true
function love.load()
    Objects = require "classic"
    require "entity"
    require "player"
    require "enemy"
    require "crystal"
    require "tower"
    require "wall"
    require "goblin"

    love.window.setMode(800, 600, {resizable=true, vsync=false})

    enemy = {}
    crystal = Crystal(windowsWidth / 2 - 10, windowsHeight / 2 + 10, 50, 100)
    player = Player(windowsWidth / 2, windowsHeight / 2 + 10, 50, 100)
    towers = {}
    walls = {}

    offsetX = -player.x + 400
    offsetY = -player.y + 300
end

function love.update(dt)
    player:update(dt)

    if wavesDelay > 0 then
        wavesDelay = wavesDelay - dt
    elseif wavesDelay <= 0 then
        if spawn then
            enemyNum = Goblin.waves[wave].enemyNum * 2
            spawn = false
        end
        leftSpawnTimer = leftSpawnTimer - dt
        rightSpawnTimer = rightSpawnTimer - dt
        if enemyNum > 0 then
            if  leftSpawnTimer <= timeLimit then
                leftSpawnTimer = spawnEnemy(100)
            end
    
            if rightSpawnTimer <= timeLimit then
                rightSpawnTimer = spawnEnemy(1810)
            end
        end
    end

    for i = #enemy, 1, -1 do
        enemy[i]:update(dt)
        enemy[i]:resolveCollision(player)
        if enemy[i].hp <= 0 then
            enemyNum = enemyNum - 1
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

    if not crystal.defeat and #enemy == 0 and wavesDelay <= 0 and enemyNum <= 0 and not spawn then
        wavesDelay = 60
        wave = wave + 1
        if wave > 4 then
            wave = 4
        end
        spawn = true
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
    if wavesDelay > 0 then
        love.graphics.print("Wave "..wave.." Start In", love.graphics.getWidth() / 2 - 50, 10)
        love.graphics.print(string.format("%.0f", wavesDelay), love.graphics.getWidth() / 2 - 15, 30)
        love.graphics.print("Press F1 to start the round", love.graphics.getWidth() / 2 - 80, 50)
    end
    if crystal.defeat then
        love.graphics.print("YOU LOSE", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end
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
            placeTower(towerX, towerY, towerType)
        end
    elseif key == "f1" then
        wavesDelay = 0
    end
    placeTowerFlag = false
end

function spawnEnemy(x)
    enemyNum = enemyNum - 1
    table.insert(enemy, Goblin(x, windowsHeight / 2 + 60, wave))
    return love.math.random(2, 6)
end

function placeTower(towerX, towerY, towerType)
    if towerType == 1 then
        table.insert(towers, Tower(towerX, towerY))
    elseif towerType == 2 then
        table.insert(walls, Wall(towerX, towerY))                 
    end
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