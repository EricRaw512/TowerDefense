Platform = Entity:extend()

function Platform:new(x, y)
    Platform.super.new(self, x, y)
    self.hp = 250
    self.x = x
    self.y = y
    self.width = 50
    self.height = 20
    self.strength = 160
end

function Platform:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end