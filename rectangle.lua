local Object = require 'object'
local Vector = require 'vector'

local Rectangle = Object:extend()

function Rectangle:init(x, y, w, h)
    self.position = Vector:new()
    self.size = Vector:new()
    self:set(x or 0, y or 0, w or 0, h or 0)
end

function Rectangle:unpack()
    local x, y = self.position:unpack()
    local w, h = self.size:unpack()
    return x, y, w, h
end

function Rectangle:set(x, y, w, h)
    if type(x) == 'table' then
        if x:is(Rectangle) then
            self.position:set(x.position)
            self.size:set(x.size)
        else
            self.position:set(x)
            self.size:set(y)
        end
    else
        self.position:set(x, y)
        self.size:set(w, h)
    end
end

function Rectangle:overlap(other)
    return self:left() < other:right()
        and self:right() > other:left()
        and self:top() < other:bottom()
        and self:bottom() > other:top()
end

function Rectangle:center(vector)
    return (vector or Vector:new()):set(self.size):scl(1 / 2):add(self.position)
end

function Rectangle:setcenter(x, y)
    if type(x) == 'table' then
        x, y = x:unpack()
    else
        local center = self:center(Vector.a)
        x, y = x or center.x, y or center.y
    end

    self.position:set(x, y):sub(Vector.a:set(self.size):scl(1 / 2))

    return self
end

function Rectangle:left()
    return self.position.x
end

function Rectangle:top()
    return self.position.y
end

function Rectangle:right()
    return self.position.x + self.size.x
end

function Rectangle:bottom()
    return self.position.y + self.size.y
end

function Rectangle:setleft(x)
    self.position.x = x
    return self
end

function Rectangle:setright(x)
    self.position.x = x - self.size.x
    return self
end

function Rectangle:settop(y)
    self.position.y = y
    return self
end

function Rectangle:setbottom(y)
    self.position.y = y - self.size.y
    return self
end

return Rectangle
