--[[----------------------------------------------------------------------------
--  LLib - v0.3.0
--
--      A lightweight library of Lua functions
--
--          Made with <3 by Lixquid
--]]----------------------------------------------------------------------------
local stringRep = string.rep
local type = type
local unpack = unpack or table.unpack
local mathLog = math.log
local tonumber = tonumber
local stringGsub = string.gsub
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

--- Returns if a value is NaN (Not a Number).
-- @number value The value to be checked
-- @treturn bool if the number is NaN
function llib.math.isNaN(value)
    return value ~= value
end

-- String ----------------------------------------------------------------------
llib.string = {}

--- Returns a string representation of a number with separators.
-- @number value The number to convert to a string
-- @string[opt=","] separator The separator to use
-- @number[opt=3] spacing The number of digits to separate by
-- @treturn string string representation of value with separators
function llib.string.comma(value, separator, spacing)
    spacing = "^(-?%d+)(" .. stringRep("%d", tonumber(spacing or 3)) .. ")"
    separator = "%1" .. tostring(separator or ",") .. "%2"
    local hit
    while true do
        value, hit = stringGsub(value, spacing, separator)
        if hit == 0 then return value end
    end
end

--- Returns the English ordinal suffix for a number.
-- @number value The number to return a suffix for
-- @treturn string The ordinal suffix of value
function llib.string.ordinal(value)
    value = tonumber(value)

    if 10 <= value % 100 and value % 100 <= 19 then
        return "th"
    elseif value % 10 == 1 then
        return "st"
    elseif value % 10 == 2 then
        return "nd"
    elseif value % 10 == 3 then
        return "rd"
    end

    return "th"
end

--- Returns the SI metric representation of a number.
-- @number value The value to return a representation for
-- @number[opt=1000] base The numeric base to delimit units for
-- @treturn number The reduced metric number for value
-- @treturn string The metric unit suffix for the value
-- @treturn string The name of the metric unit suffix for the value
local llibStringMetricSITable = {
    [-8] = { "y", "yocto" },
    [-7] = { "z", "zepto" },
    [-6] = { "a", "atto" },
    [-5] = { "f", "femto" },
    [-4] = { "p", "pico" },
    [-3] = { "n", "nano" },
    [-2] = { "u", "micro" },
    [-1] = { "m", "milli" },
    [0] = { "", "" },
    { "k", "kilo" },
    { "M", "mega" },
    { "G", "giga" },
    { "T", "tera" },
    { "P", "peta" },
    { "E", "exa" },
    { "Z", "zetta" },
    { "Y", "yotta" },
}
function llib.string.metricSI(value, base)
    base = tonumber(base or 1000)
    local div = llibMathClamp(mathFloor(mathLog(value) / mathLog(base)), -8, 8)
    return value / base ^ div, unpack(llibStringMetricSITable[div])
end


--------------------------------------------------------------------------------

return llib
