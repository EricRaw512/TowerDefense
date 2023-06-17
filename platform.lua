Platform = Entity:extend()

function Platform:new(x, y, index)
    Platform.super.new(self, x, y, index)
    self.hp = 250
    self.index = index
    self.towerType = 0
    self.x = x
    self.y = y
    self.width = 50
    self.height = 20
    self.strength = 160
    self.maxHP = self.hp
end

function Platform:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end