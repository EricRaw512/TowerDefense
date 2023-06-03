
Tower = Entity:extend()

function Tower:new(x, y)
    Tower.super.new(self, x, y)
    self.width = 50
    self.height = 50
    self.hp = 250
end

function Tower:target(e)
    local distanceX = e.x + e.width - (self.x + self.x / self.width)
    local distanceY = e.y + e.height - (self.y + self.y / self.height)
    local distance = math.sqrt(distanceX^2, distanceY^2)
    if distance <= 150 then
        return true
    end
    local angle = math.atan2(distanceX, distanceY)
    

end

function Tower:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end