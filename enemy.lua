--> SuperClass

Enemy = Entity:extend()

function Enemy:new(x, y, hp, damage)
    Enemy.super.new(self, x, y, hp, damage)
    self.speed = love.math.random(50, 200)
    self.strength = 150
    self.time = 0
    self.hp = love.math.random(50, 250)
    self.damage = damage
    self.width = 50
    self.height = 50
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)

    self.x = self.x + self.speed * dt
    if self.x + self.width > 1920 then
        self.speed = -self.speed
    elseif self.x <= 0 then
        self.speed = -self.speed
    end
end

function Enemy:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Enemy:attack(e, dt)
    self.time = self.time - dt
    if self.time <= 0 then
        self.time = 3
        e.hp = e.hp - self.damage
    end
end