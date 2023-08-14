--> file: player.lua
local walkingAnimation = {}
local jumpAnimation = {}
local standingAnimation = {} 
table.insert(standingAnimation, love.graphics.newImage("imageAssets/player/bunny1_stand.png"))
table.insert(jumpAnimation, love.graphics.newImage("imageAssets/player/bunny1_jump.png"))

for i = 1 , 2 do
    local walkFrame = love.graphics.newImage("imageAssets/player/bunny1_walk" ..i.. ".png")
    table.insert(walkingAnimation, walkFrame)
end

Player = Entity:extend()

function Player:new(x, y, width, height, hp)
    Player.super.new(self, x, y, width, height, hp)
    self.weight = 400
    self.gravity = 0
    self.strength = 100
    self.facingAngle = 0
    self.canJump =false
    local playerAnimations = {
        idle = standingAnimation,
        walk = walkingAnimation,
        jump = jumpAnimation
    }
    self.animation = playerAnimations
    self.frame = 1
    self.imageWidth = self.animation["idle"][1]:getWidth()
    self.imageHeight = self.animation["idle"][1]:getHeight()
end

function Player:update(dt)
    Player.super.update(self, dt)
    local movementSpeed = 200 * dt
    self.frame = self.frame + 10 * dt
    if love.keyboard.isDown("left") then
        self.x = self.x - movementSpeed
        self.facingAngle = math.pi
    elseif love.keyboard.isDown("right") then
        self.x = self.x + movementSpeed
        self.facingAngle = 0
    end


    self.gravity = self.gravity + self.weight * dt
    self.y = self.y + self.gravity * dt
    local windowsHeight = 1080 / 2 + 60
    if self.y > windowsHeight then
        self.gravity = 0
        self.y = windowsHeight
        self.canJump = true
    end
    
    self.x = math.max(0, math.min(self.x, 1920 - self.width))
end

function Player:draw()
    local currentAnimation = self.animation["idle"]
    local numFrames = 1

    if self.gravity < 0 then
        currentAnimation = self.animation["jump"]
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("right") then
        currentAnimation = self.animation["walk"]
        numFrames = 2
    end
    local currentFrame = math.floor(love.timer.getTime() * 10) % numFrames + 1
    
    love.graphics.draw(
        currentAnimation[currentFrame],
        self.x + (self.facingAngle == 0 and 0 or self.width), 
        self.y, 
        0, 
        self.width / self.imageWidth * (self.facingAngle == 0 and 1 or -1), 
        self.height / self.imageHeight
    )
end

function Player:jump()
    if self.canJump then
        self.gravity = -250
        self.canJump = false
    end
end

function Player:collide(e, direction)
    Player.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end

function Player:checkResolve(e, direction)
    if e:is(Platform) then
        if direction == "bottom" then
            return true
        else
            return false
        end
    end
    return true
end