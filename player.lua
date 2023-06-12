--> file: player.lua

Player = Entity:extend()

function Player:new(x, y, width, height, hp)
    Player.super.new(self, x, y, width, height, hp)
    self.weight = 400
    self.gravity = 0
    self.strength = 100
    self.facingAngle = 0
    self.canJump =false
end

function Player:update(dt)
    Player.super.update(self, dt)
    local movementSpeed = 200 * dt
    if love.keyboard.isDown("left") then
        self.x = self.x - movementSpeed
        self.facingAngle = math.pi
    elseif love.keyboard.isDown("right") then
        self.x = self.x + movementSpeed
        self.facingAngle = 0
    end


    self.gravity = self.gravity + self.weight * dt
    self.y = self.y + self.gravity * dt
    local windowsHeight = 600 / 2
    if self.y > windowsHeight then
        self.gravity = 0
        self.y = windowsHeight
        self.canJump = true
    end
    
    self.x = math.max(0, math.min(self.x, 800 - self.width))
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