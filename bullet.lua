local Actor = require 'actor'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local SIZE = 64
local MAX_DISTANCE = 1024

local Bullet = Actor:extend()

function Bullet:init(position, velocity, number)
    Actor.init(self)
    self.position = position
    self.bounds = Rectangle:new()
    self.bounds.size:set(SIZE, SIZE)
    self.bounds:setcenter(position)
    self.velocity = velocity

    self.number = number
end

function Bullet:update(dt)
    self.bounds.position:add(Vector.a:set(self.velocity):scl(dt))

    if self.bounds:center(Vector.a):sub(self.position):len2()
        > MAX_DISTANCE * MAX_DISTANCE
    then
        self:remove()
        return
    end

    for _, enemy in ipairs(self.parent.enemies) do
        if self.bounds:overlap(enemy.bounds) then
            enemy:damage(self.number)
            self:remove()
            return
        end
    end
end

function Bullet:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', self.bounds:unpack())
    love.graphics.draw(
        self.parent.assets.dice[self.number],
        self.bounds:left(),
        self.bounds:top(),
        nil,
        Vector.a
            :set(self.bounds.size)
            :div(self.parent.assets.dice[self.number]:getDimensions())
            :unpack()
    )
end

return Bullet
