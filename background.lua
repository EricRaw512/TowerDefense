--> background

Background = Objects:extend()

local TREE_EXPAND = 3
local FLOOR_HEIGHT_TREE = -300

function Background:new(windowsWidth, windowsHeight)
    self.background = love.graphics.newImage("imageAssets/background/back2.png")
    self.tiles = love.graphics.newImage("imageAssets/background/Tile_02.png")
    self.dirt = love.graphics.newImage("imageAssets/background/Tile_12.png")
    self.tree2 = love.graphics.newImage("imageAssets/background/2.png")
    self.tree3 = love.graphics.newImage("imageAssets/background/3.png")
    self.rock = love.graphics.newImage("imageAssets/background/rock1.png")
    self.tilesWidth = self.tiles:getWidth()
    self.tilesHeight = self.tiles:getHeight()
    self.floorHeight = windowsHeight / 2 + 110
    self.treeHeight = (windowsHeight - 120) / self.tree2:getHeight()
    self.columns = math.ceil(windowsWidth / self.tilesWidth) + 10
    self.rows = math.ceil(windowsHeight / self.tilesHeight)
    self.windowsWidth = windowsWidth
    self.windowsHeight = windowsHeight
end

function Background:drawBack()
    love.graphics.draw(self.background, -400, 0, 0, (self.windowsWidth + 750) / self.background:getWidth(), (self.windowsHeight - 225) / self.background:getHeight())
end

function Background:draw()
    love.graphics.draw(self.tree2, -450, FLOOR_HEIGHT_TREE, 0, TREE_EXPAND , self.treeHeight)
    love.graphics.draw(self.tree3, -400, FLOOR_HEIGHT_TREE, 0, TREE_EXPAND , self.treeHeight)
    love.graphics.draw(self.tree2, -50, FLOOR_HEIGHT_TREE, 0, TREE_EXPAND , self.treeHeight)
    love.graphics.draw(self.tree2, self.windowsWidth - 250, FLOOR_HEIGHT_TREE, 0, TREE_EXPAND , self.treeHeight)
    love.graphics.draw(self.tree3, self.windowsWidth - 200, FLOOR_HEIGHT_TREE, 0, TREE_EXPAND , self.treeHeight)
    love.graphics.draw(self.tree2, self.windowsWidth - 50, FLOOR_HEIGHT_TREE, 0, -TREE_EXPAND , self.treeHeight)
    love.graphics.draw(self.rock, self.windowsWidth, self.floorHeight - self.rock:getHeight())
    love.graphics.draw(self.rock, 0, self.floorHeight - self.rock:getHeight(), 0, -1, 1)
    for column = -13, self.columns do
        local x = column * self.tilesWidth
        love.graphics.draw(self.tiles, x, self.floorHeight)
        for row = 1, self.rows do
            love.graphics.draw(self.dirt, x, self.floorHeight + (row * self.tilesHeight))
        end
    end   
end
