
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
    local bulletSpeed = 250
    for i = #self.bullets, 1, -1 do
        self.bullets[i].x = (self.bullets[i].x + math.cos(self.bullets[i].angle) * bulletSpeed * dt)
        self.bullets[i].y = (self.bullets[i].y + math.sin(self.bullets[i].angle) * bulletSpeed * dt)
        if self.bullets[i].x < 0 or self.bullets[i].x > 800 or self.bullets[i].y < 0 or self.bullets[i].y > 600 then
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