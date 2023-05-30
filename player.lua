--> file: player.lua

Player = Entity:extend()

function Player:new(x, y, width, height)
    Player.super.new(self, x, y, width, height)
    self.weight = 400
    self.gravity = 0
    self.strength = 10
    self.canJump =false
end

function Player:update(dt)
    Player.super.update(self, dt)

    if love.keyboard.isDown("left") then
        self.x = self.x - 200 * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 200 * dt
    end

    self.gravity = self.gravity + self.weight * dt
    self.y = self.y + self.gravity * dt
    if self.y > 300 then
        self.gravity = 0
        self.y = 300
        self.canJump = true
    end
    
    if self.x + self.width > 800 then
        self.x = 800 - self.width
    elseif self.x < 0 then
        self.x = 0
    end
end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Player:jump()
    if self.canJump then
        self.gravity = -300
        self.canJump = false
    end
end

function Player:collide(e, direction)
    Player.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end