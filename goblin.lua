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

Goblin.waves = {
    {enemyHealth = 100, enemyNum = 7},
    {enemyHealth = 125, enemyNum = 10},
    {enemyHealth = 150, enemyNum = 15},
    {enemyHealth = 150, enemyNum = 25},
    {enemyHealth = 200, enemyNum = 25},
    {enemyHealth = 250, enemyNum = 40},
    {enemyHealth = 350, enemyNum = 50},
    {enemyHealth = 500, enemyNum = 100},
}

function Goblin:new(x, y, index)
    Goblin.super.new(self, x, y)
    self.hp = self.waves[index].enemyHealth
    self.damage = 40
    self.speed = 100
    self.maxHP = self.hp
    self.height = 50
    self.width = 50
    self.time = 0
    self.animation["walk"] = goblinWalkAnimation
    self.animation["attack"] = goblinAttackAnimation
end