local image = love.graphics.newImage("imageAssets/wall/wood_crate.png")
Wall = Entity:extend()

function Wall:new(x, y)
    Wall.super.new(self, x, y)
    self.hp = 500
    self.strength = 200
    self.width = 50
    self.height = 50
    self.maxHP = self.hp
    self.image = image
    self.imageWidth = image:getWidth()
    self.imageHeight = image:getHeight()
end

function Wall:draw()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        0,
        self.width / self.imageWidth,
        self.height / self.imageHeight
    )
end