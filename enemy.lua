local Actor = require 'actor'
local EnemyBullet = require 'enemybullet'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local SIZE = 128
local SAFE_DISTANCE = 512
local SHOOT_INTERVAL = 3
local SHOOT_DISTANCE = 1024

local Enemy = Actor:extend()

function Enemy:init(index)
    Actor.init(self)
    self.bounds = Rectangle:new()
    self.bounds.size:set(SIZE, SIZE)

    self.velocity = Vector:new()

    self.index = index

    self.health = 6
    self.time = 0
end

function Enemy:load()
    repeat
        self.bounds
            :setcenter(math.random() * WORLD_SIZE, math.random() * WORLD_SIZE)
    until
        self.bounds:center(Vector.a)
            :sub(self.parent.player.bounds:center(Vector.b))
            :len2()
        >= SAFE_DISTANCE * SAFE_DISTANCE

end

function Enemy:damage(amount)
    self.health = self.health - amount

    if self.health <= 0 then
        self.parent.assets.death:play()
        self.parent.enemies[self.index] = Enemy:new(self.index)
        self:remove()
    else
        self.parent.assets.hit:play()
    end
end

function Enemy:update(dt)
    self.velocity
        :set(self.parent.player.bounds:center(Vector.a))
        :sub(self.bounds:center(Vector.b))
        :normalize()

    if self.time < SHOOT_INTERVAL
        and self.parent.player.bounds:center(Vector.a)
            :sub(self.bounds:center(Vector.b))
            :len2()
        < SHOOT_DISTANCE * SHOOT_DISTANCE
    then
        self.time = self.time + dt
    end

    if self.time >= SHOOT_INTERVAL then
        self.parent.assets.shoot:play()
        self.parent:add(EnemyBullet:new(
            self.bounds:center(),
            Vector:new(self.velocity),
            self.index
        ))
        self.time = self.time % SHOOT_INTERVAL
    end

    self.velocity:scl(64)

    self.bounds.position:add(Vector.a:set(self.velocity):scl(dt))

    if self.bounds:left() < 0 then
        self.bounds:setleft(0)
    elseif self.bounds:right() > WORLD_SIZE then
        self.bounds:setright(WORLD_SIZE)
    end

    if self.bounds:top() < 0 then
        self.bounds:settop(0)
    elseif self.bounds:bottom() > WORLD_SIZE then
        self.bounds:setbottom(WORLD_SIZE)
    end

    if self.bounds:overlap(self.parent.player.bounds) then
        self.parent.player:damage()
    end
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', self.bounds:unpack())
    love.graphics.draw(
        self.parent.assets.dice[self.health],
        self.bounds:left(),
        self.bounds:top(),
        nil,
        Vector.a
            :set(self.bounds.size)
            :div(self.parent.assets.dice[self.health]:getDimensions())
            :unpack()
    )
end

return Enemy
