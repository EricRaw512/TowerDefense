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
    self.animation = {}
    self.attacking = false
    self.currentAction = "walk"
    self.frame = 1
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    local frameSpeed = 10
    if not self.attacking then
        self.currentAction = "walk"
    elseif self.time >= 1 then
        self.frame = 2
    end
    print(self.time)
    local currentAnimation = self.animation[self.currentAction]
    self.frame = self.frame + frameSpeed * dt
    if (self.frame >= #currentAnimation) then self.frame = 1 end

    self.x = self.x + self.speed * dt
    if self.x + self.width > 1875 then
        self.speed = -self.speed
    elseif self.x <= 0 then
        self.speed = -self.speed
    end
end

function Enemy:draw()
    local direction = self.speed > 0 and 1 or -1
    local currentAnimation = self.animation[self.currentAction]
    local currentImage = currentAnimation[math.floor(self.frame)]
    local imageWidth = currentImage:getWidth()
    local imageHeight = currentImage:getHeight()
    love.graphics.draw(
        currentImage, 
        self.x  + (self.speed < 0 and self.width or 0), 
        self.y, 
        0, 
        self.width / imageWidth * direction, 
        self.height / imageHeight
    )
end

function Enemy:attack(e, dt)
    self.attacking = true
    self.currentAction = "attack"
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

function Enemy:stopAttacking()
    self.attacking = false
end