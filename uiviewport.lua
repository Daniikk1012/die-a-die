local Text = require 'text'
local Viewport = require 'viewport'

local UiViewport = Viewport:extend()

function UiViewport:init()
    Viewport.init(self, 1920, 1080)
end

function UiViewport:load()
    self.text = Text:new('', self.parent.game.assets.font)
end

function UiViewport:newgame()
    if self.text then
        self.text:remove()
    end
end

function UiViewport:victory()
    self.text:set({{0, 0, 0}, 'You WON!\n Press R to play again'})
    self:add(self.text)
end

function UiViewport:gameover()
    self.text:set({{0, 0, 0}, 'You LOST!\n Press R to try again'})
    self:add(self.text)
end

function UiViewport:update(dt)
    self.text.bounds:setcenter(self.bounds:center())
    Viewport.update(self, dt)
end

return UiViewport
