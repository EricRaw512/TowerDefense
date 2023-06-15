Goblin = Enemy:extend()

Goblin.waves = {
    {enemyHealth = 100, enemyNum = 7},
    {enemyHealth = 125, enemyNum = 10},
    {enemyHealth = 150, enemyNum = 15},
    {enemyHealth = 150, enemyNum = 25},
}

function Goblin:new(x, y, index)
    Goblin.super.new(self, x, y)
    print(index)
    self.hp = self.waves[index].enemyHealth;
    self.damage = 20;
    self.speed = 100;
    self.maxHP = self.hp
    self.height = 50;
    self.width = 50;
    self.time = 0;
end