local Actor = require 'actor'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local SIZE = 256
local DIE_SIZE = 128

local Start = Actor:extend()

function Start:init()
    Actor.init(self)
    self.bounds = Rectangle:new()
    self.bounds.size:set(SIZE, SIZE)
    self.bounds:setcenter(WORLD_SIZE / 2, WORLD_SIZE / 2)
    self.diebounds = Rectangle:new()
    self.diebounds.size:set(DIE_SIZE, DIE_SIZE)
    self.diebounds:setcenter(WORLD_SIZE / 2, WORLD_SIZE / 2)
    self.required = 6
end

function Start:put()
    self.required = self.required - self.parent.goal.number

    if self.required <= 0 then
        self.parent.assets.victory:play()
        self.parent:victory()
        self:remove()
    else
        self.parent.assets.bring:play()
    end
end

function Start:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        self.parent.assets.start,
        self.bounds:left(),
        self.bounds:top(),
        nil,
        Vector.a
            :set(self.bounds.size)
            :div(self.parent.assets.start:getDimensions())
            :unpack()
    )
    love.graphics.draw(
        self.parent.assets.dice[self.required],
        self.diebounds:left(),
        self.diebounds:top(),
        nil,
        Vector.a
            :set(self.diebounds.size)
            :div(self.parent.assets.dice[self.required]:getDimensions())
            :unpack()
    )
end

return Start
