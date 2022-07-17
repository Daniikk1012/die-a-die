local Enemy = require 'enemy'
local Goal = require 'goal'
local Player = require 'player'
local Start = require 'start'
local TiledImage = require 'tiledimage'
local Vector = require 'vector'
local Viewport = require 'viewport'

WORLD_SIZE = 4096

local TILE_SIZE = 128

local GameViewport = Viewport:extend()

function GameViewport:init()
    Viewport.init(self, 1920, 1080)

    self.assets = {}

    self.assets.dice = {}

    for i=1,6 do
        table.insert(
            self.assets.dice,
            love.graphics.newImage('assets/' .. i .. '.png')
        )
        self.assets.dice[i]:setFilter('nearest', 'nearest')
    end

    self.assets.tile = love.graphics.newImage('assets/tile.png')
    self.assets.tile:setFilter('nearest', 'nearest')

    self.assets.start = love.graphics.newImage('assets/start.png')
    self.assets.start:setFilter('nearest', 'nearest')

    self.assets.shoot = love.audio.newSource('assets/shoot.wav', 'static')
    self.assets.hit = love.audio.newSource('assets/hit.wav', 'static')
    self.assets.pickup = love.audio.newSource('assets/pickup.wav', 'static')
    self.assets.bring = love.audio.newSource('assets/bring.wav', 'static')
    self.assets.death = love.audio.newSource('assets/death.wav', 'static')
    self.assets.victory = love.audio.newSource('assets/victory.wav', 'static')

    self.assets.font =
        love.graphics.newFont('assets/pressstart2p-regular.ttf', 64)
end

function GameViewport:load()
    self:newgame()
end

function GameViewport:newgame()
    self.playing = true
    self.parent.ui:newgame()

    self:clear()

    local tiledimage =
        TiledImage:new(self.assets.tile, Vector:new(TILE_SIZE, TILE_SIZE))
    tiledimage.bounds:set(0, 0, WORLD_SIZE, WORLD_SIZE)
    self:add(tiledimage)

    self.start = Start:new()
    self:add(self.start)

    self.player = Player:new()
    self:add(self.player)

    self.goal = Goal:new()
    self.goal:replace()
    self:add(self.goal)

    self.enemies = {}

    for i=1,20 do
        table.insert(self.enemies, Enemy:new(i))
    end
end

function GameViewport:victory()
    self.playing = false
    self.parent.ui:victory()
end

function GameViewport:gameover()
    self.playing = false
    self.parent.ui:gameover()
end

function GameViewport:keypressed(key)
    if key == 'r' then
        self:newgame()
        return true
    end

    return Viewport.keypressed(self, key)
end

function GameViewport:update(dt)
    if self.playing then
        for _, enemy in ipairs(self.enemies) do
            if not enemy.parent then
                self:add(enemy)
            end
        end

        Viewport.update(self, dt)
    end
end

return GameViewport
