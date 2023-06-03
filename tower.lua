
Tower = Entity:extend()

function Tower:new(x, y)
    Tower.super.new(self, x, y)
    self.width = 50
    self.height = 50
    self.hp = 250
    self.bullets = {}
    self.timer = 2
end

function Tower:update(dt)
    self.timer = self.timer - dt
    print(self.timer)
    local bulletSpeed = 250
    for i, bullet in ipairs(self.bullets) do
        bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt)
        bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt)
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
            x = self.x + math.cos(angle),
            y = self.y + self.height / 2 + math.sin(angle),
            angle = angle
        })
    end
 
    

end

function Tower:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    for i, bullet in ipairs(self.bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
    end
end