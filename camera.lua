local Actor = require 'actor'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local Camera = Actor:extend()

function Camera:init()
    Actor.init(self)
    self.bounds = Rectangle:new()
    self.scale = Vector:new()
    self.rotation = 0
end

function Camera:resize(w, h)
    self.scale:set(w, h):div(self.bounds.size)

    Actor.resize(self, w, h)
end

function Camera:draw()
    love.graphics.push()

    love.graphics.scale(self.scale:unpack())
    love.graphics.rotate(self.rotation)
    love.graphics.translate(Vector.a:set(self.bounds.position):neg():unpack())

    Actor.draw(self)

    love.graphics.pop()
end

return Camera
