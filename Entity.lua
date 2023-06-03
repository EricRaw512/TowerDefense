--> SuperClass

Entity = Objects:extend()

function Entity:new(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.last = {}
    self.last.x =self.x
    self.last.y = self.y
    self.strength = 0
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
end

function Entity:wasVertical(e)
    return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontal(e)
    return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end

function Entity:checkCollision(e)
    return self.x + self.width > e.x
    and self.x < e.x + e.width
    and self.y + self.height > e.y
    and self.y + e.y + e.height
end

function Entity:resolveCollision(e)
    if self.strength > e.strength then
        e:resolveCollision(self)
        return
    end

    if self:checkCollision(e) then
        if self:wasVertical(e) then
            if self.x + self.width / 2 < e.x + e.width / 2 then
                self:collide(e, "right")
            else
                self:collide(e, "left")
            end
        elseif self:wasHorizontal(e) then 
            if self.y + self.height / 2 < e.y + e.height / 2 then
                self:collide(e, "bottom")
            else
                self:collide(e, "top")
            end
        end
        return true
    end
    return false
end

function Entity:collide(e, direction)
    if direction == "right" then
        self.x = e.x - self.width
    elseif direction == "left" then
        self.x = e.x + e.width
    elseif direction == "bottom" then
        self.y = e.y - self.height
        self.gravity = 0
    elseif direction == "top" then
        self.y = e.y + e.height
    end
end