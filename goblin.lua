local goblinWalkAnimation = {}
local goblinAttackAnimation = {}
for i = 0, 6 do
    local walkingFile = "imageAssets/goblin/WALK_00" .. i .. ".png"
    local attackFile = "imageAssets/goblin/ATTAK_00" .. i .. ".png"
    local walkingImage = love.graphics.newImage(walkingFile)
    local attackImage = love.graphics.newImage(attackFile)
    table.insert(goblinWalkAnimation, walkingImage)
    table.insert(goblinAttackAnimation, attackImage)
end

Goblin = Enemy:extend()

function Goblin:new(x, y, wave)
    Goblin.super.new(self, x, y)
    self.hp = 80 + (80 * wave * 0.2)
    self.damage = 40 
    self.speed = 100
    self.maxHP = self.hp
    self.height = 50
    self.width = 50
    self.time = 0
    self.animation["walk"] = goblinWalkAnimation
    self.animation["attack"] = goblinAttackAnimation
end

function Goblin:CreateWave(wave)
    return math.floor(5 + (5 * wave * 0.5))
end