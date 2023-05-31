
Tower = Entity:extend()

function Tower:new(x, y)
    Tower.super.new(self, x, y)
    self.width = 50
    self.height = 70
    self.hp = 250
end

function Tower:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end