
Tower = Entity:extend()

function Tower:new(x, y)
    Tower.super.new(self, x, y)
    self.width = 50
    self.height = 50
    self.hp = 250
    self.bullets = {}
    self.timer = 0
    self.strength = 200
end

function Tower:update(dt, enemy)
    self.timer = self.timer - dt
    local bulletSpeed = 250
    for i = #self.bullets, 1, -1 do
        self.bullets[1].x = (self.bullets[1].x + math.cos(self.bullets[1].angle) * bulletSpeed * dt)
        self.bullets[i].y = (self.bullets[i].y + math.sin(self.bullets[i].angle) * bulletSpeed * dt)
        local hit = false
        for j = #enemy, 1, -1 do
            if self:bulletCollision(self.bullets[i], enemy[j]) then
                enemy[j].hp = enemy[j].hp - 25
                table.remove(self.bullets, i)
                hit = true
                break
            end
        end
        if not hit and (self.bullets[i].x < 0 or self.bullets[i].x > 1920 or self.bullets[i].y < 0 or self.bullets[i].y > 1080) then
            table.remove(self.bullets, i)
        end
    end
end

function Tower:target(e)
    local distanceX = e.x - self.x
    local distanceY = e.y - self.y
    local distance = math.sqrt(distanceX^2 + distanceY^2)
    if distance <= 200 and self.timer <= 0 then
        self.timer = 2
        local angle = math.atan2(distanceY, distanceX)
        table.insert(self.bullets, {
            x = self.x + self.width / 2+ math.cos(angle),
            y = self.y + self.height / 2 + math.sin(angle),
            angle = angle
        })
    end
end

function Tower:drawTower()
    love.graphics.setColor(0, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Tower:drawBullet()
    for i, bullet in ipairs(self.bullets) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
    end
end

function Tower:bulletCollision(bullet, e)
    return bullet.x + 10 > e.x
    and bullet.x < e.x + e.width
    and bullet.y + 10 > e.y
    and bullet.y < e.y + e.height
end

function Tower:placeInFrontOfCharacter(player)
    local gridSize = 50
    local offsetX = math.cos(player.facingAngle) * gridSize
    local offsetY = math.sin(player.facingAngle) * gridSize
    local gridX = math.floor((player.x + player.width / 2 + offsetX) / gridSize) * gridSize
    local gridY = math.floor((player.y + player.height / 2 + offsetY) / gridSize) * gridSize
    return gridX, gridY
end