Crystal = Entity:extend()

function Crystal:new(x, y, width, height, hp)
    Crystal.super.new(self, x, y, width, height, hp)
    self.strength = 200
    self.defeat = false
    self.hp = 1000
    self.frames = {}
    self.animation = 1
    self.image = love.graphics.newImage("imageAssets/crystal/crystalAnimation.png")
    self.frame_width = 65
    self.frame_height = 100
    self.imageWidth = self.image:getWidth()
    self.imageHeight = self.image:getHeight() 
    for i=0,7 do
        table.insert(self.frames, love.graphics.newQuad(i * self.frame_width, 15, self.frame_width, self.frame_height, self.imageWidth + (i * 1.5), self.imageHeight))
    end
end

function Crystal:draw()
    local hpPercentange = self.hp / 1000
    love.graphics.rectangle("fill", self.x, self.y - 20, hpPercentange * self.width, 10)
    love.graphics.draw(
        self.image,
        self.frames[math.floor(self.animation)], 
        self.x, 
        self.y, 
        0,
        0.8, 
        1
    )
end

function Crystal:update(dt)
    self.animation = self.animation + 5 * dt
    if (self.animation >= 7) then 
        self.animation = 1
    end
    if self.hp <= 0 and not self.defeat then
        self.hp = 0
        self.defeat = true
    end
end
