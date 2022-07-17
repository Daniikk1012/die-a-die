local Object = {}

function Object:extend()
    self.__index = self
    return setmetatable({}, self)
end

function Object:new(...)
    local object = self:extend()
    object:init(...)
    return object
end

function Object:init(_) end -- Underscore used to please LSP

function Object:is(class)
    local mt = getmetatable(self)

    while mt do
        if mt == class then
            return true
        end

        mt = getmetatable(mt)
    end

    return false
end

return Object
