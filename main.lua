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
local gridSize = 50
local deleteTower = false

function love.load()
    Objects = require "classic"
    require "entity"
    require "player"
    require "enemy"
    require "crystal"
    require "tower"
    require "wall"
    require "goblin"
    require "platform"
    require "background"

    love.window.setMode(800, 600, {resizable=true, vsync=false})

    enemy = {}
    crystal = Crystal(windowsWidth / 2 - 10, windowsHeight / 2 + 10, 50, 100)
    player = Player(windowsWidth / 2, windowsHeight / 2 + 60, 50, 50)
    towers = {
        archerTower = {},
        walls = {}
    }
    platform = {}
    background = Background(windowsWidth, windowsHeight)
    deleteTowerGrid = love.graphics.newImage("imageAssets/player/delete_tower.png")

    placingTowerGrid = love.graphics.newImage("imageAssets/player/place_tower.png")

    offsetX = -player.x + love.graphics.getWidth() / 2
    offsetY = -player.y + love.graphics.getHeight() / 2
end

function love.update(dt)
    player:update(dt)

    if wavesDelay > 0 then
        wavesDelay = wavesDelay - dt
    elseif wavesDelay <= 0 then
        if spawn then
            enemyNum = Goblin:CreateWave(wave)
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
            else
                enemy[i]:stopAttacking()
            end
            for j = #towers.walls, 1, -1 do
                if enemy[i]:resolveCollision(towers.walls[j]) then
                    enemy[i]:attack(towers.walls[j], dt)
                end
                if towers.walls[j].hp <= 0 then
                    table.remove(towers.walls, j)
                end
            end
            for j = #platform, 1, -1 do
                if enemy[i]:resolveCollision(platform[j]) then
                    enemy[i]:attack(platform[j], dt)
                end
                if platform[j].hp <= 0 then
                    removeOnPlatform(j)
                    table.remove(platform, j)
                end
            end
        end
    end
    crystal:update(dt)

    offsetX = -player.x + love.graphics.getWidth() / 2
    offsetY = -player.y + love.graphics.getHeight() / 2
    for i =#towers.archerTower, 1, -1 do
        towers.archerTower[i]:update(dt, enemy)
        for j = #enemy, 1, -1 do
            towers.archerTower[i]:target(enemy[j])
            if enemy[j]:resolveCollision(towers.archerTower[i]) then
                enemy[j]:attack(towers.archerTower[i], dt)
            end
        end
        if towers.archerTower[i].hp < 0 then
            table.remove(towers.archerTower, i)
        end
    end

    if not crystal.defeat and #enemy == 0 and wavesDelay <= 0 and enemyNum <= 0 and not spawn then
        wavesDelay = 60
        wave = wave + 1
        spawn = true
    end
end

function love.draw()
    if love.graphics.getWidth() ~= 1920 and love.graphics.getHeight() ~= 1080 then
        love.graphics.translate(offsetX, offsetY)
    end

    background:drawBack()

    crystal:draw()
    for i, v in ipairs(enemy) do
        v:draw()
        v:drawHealthBar()
    end
    for i, wall in ipairs(towers.walls) do
        wall:draw()
        wall:drawHealthBar()
    end
    for i, tower in ipairs(towers.archerTower) do
        tower:drawTower()
        tower:drawHealthBar()
    end
    for i, plat in ipairs(platform) do
        plat:resolveCollision(player)
        plat:draw()
        plat:drawHealthBar()
    end

    player:draw()
    background:draw()
    
    if placingTower then
        local destinationX, destinationY = placeInFrontOfCharacter(player)
        --love.graphics.rectangle("line", destinationX, destinationY, 50, 50)
        love.graphics.draw(
            placingTowerGrid,
            destinationX,
            destinationY,
            0,
            50 / placingTowerGrid:getWidth(),
            50 / placingTowerGrid:getHeight()
        )
    end
    if deleteTower then
        local destinationX, destinationY = placeInFrontOfCharacter(player)
        love.graphics.draw(
            deleteTowerGrid,
            destinationX,
            destinationY,
            0,
            50 / placingTowerGrid:getWidth(),
            50 / placingTowerGrid:getHeight()
        )
    end
    love.graphics.origin()
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
        deleteTower = false
        towerType = 1
    elseif key == '2' and startingPoint >= 100 then
        placingTower = true
        deleteTower = false
        towerType = 2
    elseif key == '3' and startingPoint >= 500 then
        placingTower = true
        deleteTower = false
        towerType = 3
    elseif key == 'p' then
        deleteTower = true
        placingTower = false
    elseif key == 'down' then
        goDownplatform()
    elseif key == "space" then
        if placingTower and not playerOnEnemy() and not placeTowerFlag and player.gravity == 0 then
            placeTowerFlag = true
            local towerX, towerY = Tower:placeInFrontOfCharacter(player)
            if towerX > 100 and towerX < 1800 and not isOccupied(towerX, towerY, towerType) then
                placingTower = placeTower(towerX, towerY, towerType)
            end
        elseif deleteTower and player.gravity == 0 then
            local towerX, towerY = Tower:placeInFrontOfCharacter(player)
            if refundTower(towerX, towerY) then
                deleteTower = false
            end
        end

    elseif key == "f1" then
        wavesDelay = 0
    end
    placeTowerFlag = false
end

-- spawn the enemy at left or right 
function spawnEnemy(x)
    enemyNum = enemyNum - 1
    table.insert(enemy, Goblin(x, windowsHeight / 2 + 60, wave))
    return love.math.random(2, 6)
end

--placing tower at platform or not
function placeTower(towerX, towerY, towerType)
    if towerType ~= 3 then
        if towerY < 600 then
            for i, v in ipairs(platform) do
                if v.y == towerY + gridSize and v.x == towerX then
                    startingPoint = startingPoint - 100
                    towerInsert(towerType, towerX, towerY)
                end
            end
        else
            startingPoint = startingPoint - 100
            towerInsert(towerType, towerX, towerY)
        end
    else
        startingPoint = startingPoint - 500
        table.insert(platform, Platform(towerX, towerY, 0))
    end
    return false
end

--remove tower if there are on a platform
function removeOnPlatform(index)
    local towersToRemove = {}  -- Store the indices of towers to be removed

    -- Find the towers to be removed and store their indices
    for i, tower in ipairs(towers.archerTower) do
        if tower.x == platform[index].x and tower.y == platform[index].y - 50 then
            table.insert(towersToRemove, i)
        end
    end

    -- Remove the towers using the stored indices
    for i = #towersToRemove, 1, -1 do
        if i ~= 0 then
            table.remove(towers.archerTower, towersToRemove[i])
        end
    end

    towersToRemove = {}  -- Clear the table for the next use

    -- Repeat the same process for the walls table
    for i, wall in ipairs(towers.walls) do
        if wall.x == platform[index].x and wall.y == platform[index].y - 50 then
            table.insert(towersToRemove, i)
        end
    end

    for i = #towersToRemove, 1, -1 do
        table.remove(towers.walls, towersToRemove[i])
    end
end

--check if the grid is occupied
function isOccupied(gridX, gridY, towerType)
    if towerType ~= 3 then
        for i, t in ipairs(towers.archerTower) do
            if t.x == gridX and t.y == gridY then
                return true
            end
        end
        for i, t in ipairs(towers.walls) do
            if t.x == gridX and t.y == gridY then
                return true
            end
        end
    end

    if towerType == 3 then
        for i, w in ipairs(platform) do
            if w.x == gridX and w.y == gridY then
                return true
            end
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

-- place in front of player per grid
function placeInFrontOfCharacter(player)
    local offsetX = math.cos(player.facingAngle) * gridSize
    local offsetY = math.sin(player.facingAngle) * gridSize
    local gridX = math.floor((player.x + player.width / 2+ offsetX) / gridSize) * gridSize
    local gridY = math.floor((player.y + player.height / 2+ offsetY) / gridSize) * gridSize
    gridX = math.max(0, math.min(gridX, 1920 - player.width))
    gridY = math.max(0, math.min(gridY, 1080 - player.height))
    return gridX, gridY
end

-- go down the platform with down button
function goDownplatform()
    for i ,v in ipairs(platform) do
        if player.x + player.width >= v.x
        and player.x <= v.x + v.width
        and player.y + gridSize == v.y then
            player.y = player.y + 1
        end
    end
end

-- check if player is on enemy
function playerOnEnemy()
    for i, e in ipairs(enemy) do
        if player.y + player.height <= e.y and
            player.x + player.width >= e.x and
            player.x <= e.x + e.width then
            return true
        end
    end
    return false
end

-- insert tower into corresponding table
function towerInsert(towerType, towerX, towerY)
    if towerType == 1 then
        table.insert(towers.archerTower, Tower(towerX, towerY))
    elseif towerType == 2 then
        table.insert(towers.walls, Wall(towerX, towerY))
    end
end

--refund the tower based on the hp
function refundTower(gridX, gridY)
    for i, t in ipairs(towers.archerTower) do
        if t.x == gridX and t.y == gridY then
            startingPoint = startingPoint + math.floor(t.value / 2 * (t.hp / t.maxHp)) -- Refund half of the tower's health value
            table.remove(towers.archerTower, i)
            return true
        end
    end
    for i, t in ipairs(towers.walls) do
        if t.x == gridX and t.y == gridY then
            startingPoint = startingPoint + math.floor(t.value / 2 * (t.hp / t.maxHp))
            table.remove(towers.walls, i)
            return true
        end
    end
    for i, t in ipairs(platform) do
        if t.x == gridX and t.y == gridY then
            startingPoint = startingPoint + math.floor(t.value / 2 * (t.hp / t.maxHp))
            table.remove(platform, i)
            return true
        end
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