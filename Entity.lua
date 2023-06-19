--> SuperClass

Entity = Objects:extend()

function Entity:new(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.last = { x = self.x, y = self.y}
    self.strength = 0
    self.healthTimer = 0
    self.maxHP = 0
end

function Entity:update(dt)
    if self.healthTimer > 0 then
        self.healthTimer = self.healthTimer - dt
    end
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
    return self.x + self.width >= e.x
    and self.x <= e.x + e.width
    and self.y + self.height >= e.y
    and self.y <= e.y + e.height
end

function Entity:resolveCollision(e)
    if self.strength > e.strength then
        e:resolveCollision(self)
        return
    end

    if self:checkCollision(e) then
        if self:wasVertical(e) then
            if self.x + self.width / 2 < e.x + e.width / 2 then
                local a = self:checkResolve(e, "right")
                local b = e:checkResolve(self, "left")
                if a and b then
                    self:collide(e, "right")
                end
            else
                local a = self:checkResolve(e, "left")
                local b = e:checkResolve(self, "right")
                if a and b then
                    self:collide(e, "left")
                end
            end
        elseif self:wasHorizontal(e) then 
            if self.y + self.height / 2 < e.y + e.height / 2 then
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "bottom")
                end
            else
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "top")
                end
            end
        end
        return true
    end
    return false
end

function Entity:checkResolve(e, direction)
    return true
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

function Entity:drawHealthBar()
    if self.healthTimer > 0 then
        local hpPercentange = self.hp / self.maxHP
        love.graphics.rectangle("fill", self.x, self.y - 20, hpPercentange * self.width, 10)
    end
end