local Actor = require 'actor'
local Bullet = require 'bullet'
local Rectangle = require 'rectangle'
local Vector = require 'vector'

local SIZE = 128
local RECOIL = 96
local BULLET_SPEED = 1536

local Player = Actor:extend()

function Player:init()
    Actor.init(self)
    self.bounds = Rectangle:new()
    self.bounds.size:set(SIZE, SIZE)
    self.bounds:setcenter(WORLD_SIZE / 2, WORLD_SIZE / 2)
    self.velocity = Vector:new()
    self.direction = Vector:new(1, 0)
    self.keys = {left = false, right = false, up = false, down = false}
    self.picked = false
    self.action = love.math.random(6)
end

function Player:damage()
    self.parent.assets.death:play()
    self.parent:gameover()
    self:remove()
end

function Player:updateVelocity()
    self.velocity.x = 0

    if self.keys.left then
        self.velocity.x = self.velocity.x - 1
    end

    if self.keys.right then
        self.velocity.x = self.velocity.x + 1
    end

    self.velocity.y = 0

    if self.keys.up then
        self.velocity.y = self.velocity.y - 1
    end

    if self.keys.down then
        self.velocity.y = self.velocity.y + 1
    end

    if self.velocity:len2() > 0 then
        self.direction:set(self.velocity)
    end

    self.velocity:normalize():scl(768)
end

function Player:keypressed(key)
    if key == 'left' then
        self.keys.left = true
    elseif key == 'right' then
        self.keys.right = true
    elseif key == 'up' then
        self.keys.up = true
    elseif key == 'down' then
        self.keys.down = true
    elseif key == 'z' then
        self.parent.assets.shoot:play()

        if self.action == 1 then
            self.parent:add(Bullet:new(
                self.bounds:center(),
                Vector:new(self.direction):normalize():scl(BULLET_SPEED),
                self.action
            ))
        elseif self.action == 2 then
            self.parent:add(Bullet:new(
                self.bounds:center(),
                Vector:new(self.direction):neg():normalize():scl(BULLET_SPEED),
                self.action
            ))
        elseif self.action == 3 then
            self.parent:add(Bullet:new(
                self.bounds:center(),
                Vector:new(self.direction):normalize():scl(BULLET_SPEED),
                self.action
            ))
            self.bounds.position
                :add(Vector.a:set(self.direction):neg():normalize():scl(RECOIL))
        elseif self.action == 4 then
            self.parent:add(Bullet:new(
                self.bounds:center(),
                Vector:new(self.direction):neg():normalize():scl(BULLET_SPEED),
                self.action
            ))
            self.bounds.position
                :add(Vector.a:set(self.direction):normalize():scl(RECOIL))
        elseif self.action == 5 then
            self.parent:add(Bullet:new(
                self.bounds:center(),
                Vector:new(self.direction):normalize():scl(BULLET_SPEED / 3),
                self.action
            ))
        elseif self.action == 6 then
            self.parent:add(Bullet:new(
                self.bounds:center(),
                Vector:new(self.direction):normalize():scl(BULLET_SPEED / 6),
                self.action
            ))
        end

        self.action = love.math.random(6)
    end

    self:updateVelocity()

    return true
end

function Player:keyreleased(key)
    if key == 'left' then
        self.keys.left = false
    elseif key == 'right' then
        self.keys.right = false
    elseif key == 'up' then
        self.keys.up = false
    elseif key == 'down' then
        self.keys.down = false
    end

    self:updateVelocity()

    return true
end

function Player:update(dt)
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

    self.parent.bounds:setcenter(self.bounds:center(Vector.a))

    if self.parent.bounds:left() < 0 then
        self.parent.bounds:setleft(0)
    elseif self.parent.bounds:right() > WORLD_SIZE then
        self.parent.bounds:setright(WORLD_SIZE)
    end

    if self.parent.bounds:top() < 0 then
        self.parent.bounds:settop(0)
    elseif self.parent.bounds:bottom() > WORLD_SIZE then
        self.parent.bounds:setbottom(WORLD_SIZE)
    end

    if not self.picked and self.bounds:overlap(self.parent.goal.bounds) then
        self.parent.assets.pickup:play()
        self.picked = true
        self.parent.goal:remove()
    end

    if self.picked and self.bounds:overlap(self.parent.start.bounds) then
        self.picked = false
        self.parent.start:put()
        self.parent.goal:replace()
        self.parent:add(self.parent.goal)
    end
end

function Player:draw()
    love.graphics.setColor(1, 1, self.picked and 0 or 1)
    love.graphics.rectangle('fill', self.bounds:unpack())
    love.graphics.draw(
        self.parent.assets.dice[self.action],
        self.bounds:left(),
        self.bounds:top(),
        nil,
        Vector.a
            :set(self.bounds.size)
            :div(self.parent.assets.dice[self.action]:getDimensions())
            :unpack()
    )
end

return Player
