
Tower = Entity:extend()

function Tower:new(x, y)
    Tower.super.new(self, x, y)
    self.width = 50
    self.height = 50
    self.hp = 250
    self.bullets = {}
    self.timer = 0
end

function Tower:update(dt, enemy)
    self.timer = self.timer - dt
    local bulletSpeed = 250
    for i = #self.bullets, 1, -1 do
        self.bullets[i].x = (self.bullets[i].x + math.cos(self.bullets[i].angle) * bulletSpeed * dt)
        self.bullets[i].y = (self.bullets[i].y + math.sin(self.bullets[i].angle) * bulletSpeed * dt)
        local hit = false
        for j = #enemy, 1, -1 do
            if Tower:bulletCollision(self.bullets[i], enemy[j]) then
                enemy[j].hp = enemy[j].hp - 25
                table.remove(self.bullets, i)
                hit = true
                break
            end
        end
        if not hit and (self.bullets[i].x < 0 or self.bullets[i].x > love.graphics.getWidth() or self.bullets[i].y < 0 or self.bullets[i].y > love.graphics.getHeight()) then
            table.remove(self.bullets, i)
        end
    end
end

function Tower:target(e)
    local distanceX = e.x - self.x
    local distanceY = e.y - self.y
    local distance = math.sqrt(distanceX^2 + distanceY^2)
    if distance <= 150 and self.timer <= 0 then
        self.timer = 2
        local angle = math.atan2(distanceY, distanceX)
        table.insert(self.bullets, {
            x = self.x + self.width / 2+ math.cos(angle),
            y = self.y + self.height / 2 + math.sin(angle),
            angle = angle
        })
    end
end

function Tower:draw()
    love.graphics.setColor(0, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    for i, bullet in ipairs(self.bullets) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
    end
end

function Tower:bulletCollision(bullet, e)
    return bullet.x + 10 > e.x
    and bullet.x < e.x + e.width
    and bullet.y + 10 > e.y
    and bullet.y + e.y + e.height
end