--> SuperClass

Enemy = Entity:extend()

function Enemy:new(x, y, width, height, hp, damage)
    Enemy.super.new(self, x, y, width, height, hp, damage)
    self.speed = 100
    self.strength = 150
    self.time = 0
    self.damage = damage
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)

    self.x = self.x +self.speed * dt
    if self.x + self.width > 800 then
        self.speed = -self.speed
    elseif self.x < 0 then
        self.speed = -self.speed
    end
end

function Enemy:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Enemy:attack(e, dt)
    if self.time < 0 then
        self.time = 3
        e.hp = e.hp - self.damage
    else
        self.time = self.time - dt
    end
end