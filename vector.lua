local Object = require 'object'

local Vector = Object:extend()

local function normalize(x, y)
    if type(x) == 'table' then
        return x:unpack()
    end

    return x, y
end

function Vector:init(x, y)
    self:set(x or 0, y or 0)
end

function Vector:unpack()
    return self.x, self.y
end

function Vector:set(x, y)
    x, y = normalize(x, y)
    self.x, self.y = x or self.x, y or self.y

    return self
end

function Vector:add(x, y)
    x, y = normalize(x, y)

    return self:set(self.x + (x or 0), self.y + (y or 0))
end

function Vector:sub(x, y)
    x, y = normalize(x, y)

    return self:set(self.x - (x or 0), self.y - (y or 0))
end

function Vector:mul(x, y)
    x, y = normalize(x, y)

    return self:set(self.x * (x or 1), self.y * (y or 1))
end

function Vector:div(x, y)
    x, y = normalize(x, y)

    return self:set(self.x / (x or 1), self.y / (y or 1))
end

function Vector:mod(x, y)
    x, y = normalize(x, y)

    return self:set(x and self.x % x or self.x, y and self.y % y or self.y)
end

function Vector:scl(x)
    return self:set(self.x * x, self.y * x)
end

function Vector:neg(x, y)
    if not x and not y then
        x, y = true, true
    end

    return self:set(x and -self.x or self.x, y and -self.y or self.y)
end

function Vector:len2()
    return self.x * self.x + self.y * self.y
end

function Vector:len()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:normalize()
    local len = self:len()

    if len > 0 then
        self:scl(1 / self:len())
    end

    return self
end

Vector.a = Vector:new()
Vector.b = Vector:new()

return Vector
