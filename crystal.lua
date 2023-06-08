Crystal = Entity:extend()

function Crystal:new(x, y, width, height, hp)
    Crystal.super.new(self, x, y, width, height, hp)
    self.strength = 200
    self.defeat = false
    self.hp = 1000
end

function Crystal:draw()
    local hpPercentange = self.hp / 1000
    love.graphics.rectangle("fill", self.x, self.y - 20, hpPercentange * self.width, 10)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    if self.defeat then
        love.graphics.print("YOU LOSE", windowsHeight / 2, windowsWidth / 2)
    end
end

function Crystal:update(dt)
    if self.hp <= 0 and not self.defeat then
        self.hp = 0
        self.defeat = true
    end
end
