local Actor = require 'actor'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local TiledImage = Actor:extend()

function TiledImage:init(image, imagesize)
    Actor.init(self)
    self.bounds = Rectangle:new()
    self.image = image
    self.imagesize = imagesize or Vector:new(image:getDimensions())
end

function TiledImage:draw()
    love.graphics.setColor(1, 1, 1)

    local xw, xc = 0, 0

    while xw < self.bounds.size.x do
        xw = xw + self.imagesize.x
        xc = xc + 1
    end

    local yw, yc = 0, 0

    while yw < self.bounds.size.y do
        yw = yw + self.imagesize.y
        yc = yc + 1
    end

    for i=1,xc do
        for j=1,yc do
            love.graphics.draw(
                self.image,
                self.bounds:left() + (i - 1) * self.imagesize.x,
                self.bounds:top() + (j - 1) * self.imagesize.y,
                nil,
                Vector.a
                    :set(self.imagesize)
                    :div(self.image:getDimensions())
                    :unpack()
            )
        end
    end
end

return TiledImage
