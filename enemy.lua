--> SuperClass

Enemy = Entity:extend()

function Enemy:new(x, y)
    Enemy.super.new(self, x, y)
    self.speed = 0
    self.strength = 150
    self.time = 0
    self.attackDelay = 3
    self.hp = 0
    self.maxHP = self.hp
    self.width = 0
    self.height = 0
    self.walkFrame = 1
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    self.walkFrame = self.walkFrame + 10 * dt
    if (self.walkFrame >= 7) then self.walkFrame = 1 end

    self.x = self.x + self.speed * dt
    if self.x + self.width > 1875 then
        self.speed = -self.speed
    elseif self.x <= 0 then
        self.speed = -self.speed
    end
end

function Enemy:draw()
    local direction = self.speed > 0 and 1 or -1
    love.graphics.draw(
        self.walkAnimation[math.floor(self.walkFrame)], 
        self.x  + (self.speed < 0 and 50 or 0), 
        self.y, 
        0, 
        self.width / self.imageWidth * direction, 
        self.height / self.imageHeight
    )
end

function Enemy:attack(e, dt)
    self.time = self.time - dt
    if self.time <= 0 then
        if e:is(Crystal) then
            self.time = 3
            e.hp = e.hp - self.damage
            e.healthTimer = 0.5
        elseif self.y == e.y then
            if self.speed > 0 and self.x < e.x
            or self.speed < 0 and self.x > e.x then
                self.time = 3
                e.hp = e.hp - self.damage
                e.healthTimer = 0.5
            end
        end
    end
end