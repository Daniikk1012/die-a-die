local Object = require 'object'

local Queue = Object:extend()

function Queue:init()
    self.left, self.right = 1, 0
end

function Queue:pushl(x)
    self.left = self.left - 1
    self[self.left] = x

    return self
end

function Queue:pushr(x)
    self.right = self.right + 1
    self[self.right] = x

    return self
end

function Queue:popl()
    if self.left <= self.right then
        local x = self[self.left]
        self[self.left] = nil
        self.left = self.left + 1

        return x
    end
end

function Queue:popr()
    if self.left <= self.right then
        local x = self[self.right]
        self[self.right] = nil
        self.right = self.right - 1

        return x
    end
end

function Queue:peekl()
    return self[self.left]
end

function Queue:peekr()
    return self[self.right]
end

function Queue:len()
    return self.right - self.left + 1
end

return Queue
