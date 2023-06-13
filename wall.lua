Wall = Entity:extend()

function Wall:new(x, y)
    Wall.super.new(self, x, y)
    self.hp = 500
    self.strength = 200
    self.width = 50
    self.height = 50
    self.maxHP = self.hp
end

function Wall:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end