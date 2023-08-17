local image = love.graphics.newImage("imageAssets/platform/wood_platform.png")
Platform = Entity:extend()

function Platform:new(x, y, index)
    Platform.super.new(self, x, y, index)
    self.hp = 250
    self.index = index
    self.towerType = 0
    self.x = x
    self.y = y
    self.width = 50
    self.height = 20
    self.strength = 160
    self.maxHP = self.hp
    self.image = image
    self.imageWidth = image:getWidth()
    self.imageHeight = image:getHeight()
end

function Platform:draw()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.width / self.imageWidth,
        self.height / self.imageHeight
    )
end