local Actor = require 'actor'
local Rectangle = require 'rectangle'

local Text = Actor:extend()

function Text:init(text, font)
    Actor.init(self)
    self.text = love.graphics.newText(font, text)
    self.bounds = Rectangle:new()
    self.bounds.size:set(self.text:getDimensions())
end

function Text:set(text)
    self.text:set(text)
    self.bounds.size:set(self.text:getDimensions())
end

function Text:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.text, self.bounds:left(), self.bounds:top())
end

return Text
