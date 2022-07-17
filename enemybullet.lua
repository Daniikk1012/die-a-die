local Actor = require 'actor'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local SIZE = 64
local MAX_DISTANCE = 1024

local EnemyBullet = Actor:extend()

function EnemyBullet:init(position, velocity, index)
    Actor.init(self)
    self.position = position
    self.bounds = Rectangle:new()
    self.bounds.size:set(SIZE, SIZE)
    self.bounds:setcenter(position)
    self.velocity = velocity

    if self.velocity:len2() == 0 then
        self.velocity.x = 1
    end

    self.velocity:normalize():scl(1024)

    self.number = love.math.random(6)

    self.index = index
end

function EnemyBullet:update(dt)
    self.bounds.position:add(Vector.a:set(self.velocity):scl(dt))

    if self.bounds:center(Vector.a):sub(self.position):len2()
        > MAX_DISTANCE * MAX_DISTANCE * self.number * self.number / 36
    then
        self:remove()
        return
    end

    for i, enemy in ipairs(self.parent.enemies) do
        if i ~= self.index and self.bounds:overlap(enemy.bounds) then
            enemy:damage(self.number)
            self:remove()
            return
        end
    end

    if self.bounds:overlap(self.parent.player.bounds) then
        self.parent.player:damage()
        self:remove()
    end
end

function EnemyBullet:draw()
    love.graphics.setColor(1, 0, 0)
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

return EnemyBullet
