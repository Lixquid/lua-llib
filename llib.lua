--[[----------------------------------------------------------------------------
--  LLib - v0.3.0
--
--      A lightweight library of Lua functions
--
--          Made with <3 by Lixquid
--]]----------------------------------------------------------------------------
local type = type
local mathFloor = math.floor
local next = next
local mathMax = math.max
local mathMin = math.min
local stringLower = string.lower


local llib = {}
llib.version = "0.3.0"

-- Util ------------------------------------------------------------------------
llib.util = {}

--- Returns if a value could be considered "truthy".
-- An example of a "falsey" value is 0, or the empty string.
-- @param value The value to be examined
-- @treturn bool the "truthyness" of the value
function llib.util.truthy(value)
    if not value then
        return false
    elseif type(value) == "number" then
        return value ~= 0
    elseif type(value) == "string" then
        return value ~= "" and value ~= "0" and stringLower(value) ~= "false"
    elseif type(value) == "table" then
        return next(value) and true or false
    end

    return true
end

-- Math ------------------------------------------------------------------------
llib.math = {}

--- Returns a value, bound to a minimum and maximum.
-- @number value The value to be bound
-- @number minimum The minimum value that can be returned
-- @number maximum The maximum value that can be returned
-- @treturn number value bounded between minimum and maximum
function llib.math.clamp(value, minimum, maximum)
    return mathMin(mathMax(value, minimum), maximum)
end
local llibMathClamp = llib.math.clamp

--- Linearly interpolates a value towards another value.
-- @number value The value to be interpolated
-- @number target The value to interpolate towards
-- @number amount The amount to interpolate by. Clamped between 0 and 1.
-- @treturn number value linearly interpolated towards target by amount
function llib.math.lerp(value, target, amount)
    return value + (target - value) * llibMathClamp(amount, 0, 1)
end

--- Rounds a number towards positive Infinity.
-- @number value The number to be rounded
-- @number[opt] dp The number of decimal places to round to
-- @treturn number value rounded to dp decimal places
function llib.math.round(value, dp)
    return dp
        and mathFloor(value * 10 ^ dp + 0.5) / 10 ^ dp
        or mathFloor(value + 0.5)
end

--- Returns if a value is NaN (Not a Number)
-- @number value The value to be checked
-- @treturn bool if the number is NaN
function llib.math.isNaN(value)
    return value ~= value
end

--------------------------------------------------------------------------------

return llib
