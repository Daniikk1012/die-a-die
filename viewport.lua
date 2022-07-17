local Camera = require 'camera'
local Vector = require 'vector'

local Viewport = Camera:extend()

function Viewport:init(w, h)
    Camera.init(self)
    self.size = Vector:new(w, h)
end

function Viewport:resize(w, h)
    if w / h > self.size.x / self.size.y then
        self.bounds.size:set(w * self.size.y / h, self.size.y)
    else
        self.bounds.size:set(self.size.x, h * self.size.x / w)
    end

    Camera.resize(self, w, h)
end

return Viewport
