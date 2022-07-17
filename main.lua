local Actor = require 'actor'
local GameViewport = require 'gameviewport'
local UiViewport = require 'uiviewport'

local actor

function love.load()
    actor = Actor:new()

    actor.game = GameViewport:new()
    actor.ui = UiViewport:new()

    actor:add(actor.game)
    actor:add(actor.ui)

    love.resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function love.keypressed(key)
    actor:keypressed(key)
end

function love.keyreleased(key)
    actor:keyreleased(key)
end

function love.resize(w, h)
    actor:resize(w, h)
end

function love.update(dt)
    actor:update(dt)
end

function love.draw()
    actor:draw()
end
