Wall = Entity:extend()

function Wall:new(x, y)
    Wall.super.new(self, x, y)
    self.hp = 300
    self.strength = 200
    self.width = 50
    self.height = 50
end

function Wall:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end