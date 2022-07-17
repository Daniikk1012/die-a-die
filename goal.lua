local Actor = require 'actor'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local SIZE = 128

local Goal = Actor:extend()

function Goal:init()
    Actor.init(self)
    self.bounds = Rectangle:new()
    self.bounds.size:set(SIZE, SIZE)
end

function Goal:replace()
    self.number = love.math.random(6)
    self.bounds.position:set(
        Vector.a:set(WORLD_SIZE, WORLD_SIZE)
            :sub(self.bounds.size)
            :mul(love.math.random(), love.math.random())
    )
end

function Goal:draw()
    love.graphics.setColor(1, 1, 0)
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

return Goal
