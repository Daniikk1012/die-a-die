local Object = require 'object'

local Actor = Object:extend()

function Actor:init()
    self.children = {}
    self.keys = {}
end

function Actor:add(child)
    table.insert(self.children, child)
    child.parent = self
    child:load()

    return self
end

function Actor:remove()
    if self.parent then
        for i, child in ipairs(self.parent.children) do
            if child == self then
                table.remove(self.parent.children, i)

                break
            end
        end

        self.parent = nil
    end
end

function Actor:clear()
    while #self.children > 0 do
        self.children[1]:remove()
    end
end

function Actor:load() end

function Actor:keypressed(key)
    for i=#self.children,1,-1 do
        local child = self.children[i]

        if child:keypressed(key) then
            self.keys[key] = child

            return true
        end
    end

    return false
end

function Actor:keyreleased(key)
    if self.keys[key] then
        local result = self.keys[key]:keyreleased(key)
        self.keys[key] = nil

        return result
    end

    return false
end

function Actor:resize(w, h)
    for _, child in ipairs(self.children) do
        child:resize(w, h)
    end
end

function Actor:update(dt)
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Actor:draw()
    for _, child in ipairs(self.children) do
        child:draw()
    end
end

return Actor
