--[[----------------------------------------------------------------------------
    LLib - v0.1.0

    A lightweight library of Lua functions
    Made with <3 by Lixquid
--]]----------------------------------------------------------------------------

llib = {}
llib.version = "0.1.0"
llib.invasive = true

local ns = llib.invasive and _G or llib

--[[----------------------------------------------------------------------------
    Assert
--]]----------------------------------------------------------------------------

function ns.assertNumber( object )
  return tonumber( object )
end

function ns.assertString( object )
  return object ~= nil and tostring( object ) or nil
end

function ns.assertTable( object )
  return type( object ) == "table" and object or nil
end

--[[----------------------------------------------------------------------------
    General
--]]----------------------------------------------------------------------------

function ns.toBool( object )
  if not object then
    return false
  elseif type( object ) == "number" then
    return object ~= 0
  elseif type( object ) == "string" then
    return object ~= "" and object ~= "0" and object:lower() ~= "false"
  elseif type( object ) == "table" then
    return next( object ) and true or false
  end

  return true
end

--[[----------------------------------------------------------------------------
    Math
--]]----------------------------------------------------------------------------
ns.math = ns.math or {}
local nsl = ns.math

function nsl.clamp( number, minimum, maximum )
  return math.max( math.min( number, maximum ), minimum )
end

function nsl.comma( number, delimiter, spacing )
  local number, delimiter, spacing, hit =
    tostring( number ),
    tostring( delimiter or "," ),
    tonumber( spacing or 3 )

  while true do
    number, hit = number:gsub(
      "^(-?%d+)(" .. ("%d"):rep( spacing ) .. ")",
      "%1" .. delimiter .. "%2" )
    if hit == 0 then return number end
  end
end

function nsl.lerp( number, target, amount )
  return number + ( target - number ) * math.min( math.max( amount, 0 ), 1 )
end

function nsl.logB( number, base )
  return math.log( number ) / math.log( base )
end

local metric_table = { { "k", "kilo" }, { "M", "mega" }, { "G", "giga" },
	{ "T", "tera" }, { "P", "peta" }, { "E", "exa" }, { "Z", "zetta" },
	{ "Y", "yotta" }, [0] = { "", "" }, [-1] = { "m", "milli" },
	[-2] = { "u", "micro" }, [-3] = { "n", "nano" }, [-4] = { "p", "pico" },
	[-5] = { "f", "femto" }, [-6] = { "a", "atto" }, [-7] = { "z", "zepto" },
	[-8] = { "y", "yocto" } }
function nsl.metric( number, base )
  local base = base or 1000

  local div = math.max( math.min( math.floor(
    math.log( number ) / math.log( base ) ), 8 ), -8 )
  return number / base ^ div, unpack( metric_table[ div ] )
end

function nsl.ordinal( number )
  local last = tostring( math.floor( tonumber( number ) + 0.5 ) ):sub( -1 )

  if tonumber( number ) > 10 and
    tostring( math.floor( number + 0.5 ) ):sub( -2, -2 ) == "1" then

      return "th"
  elseif last == "1" then
    return "st"
  elseif last == "2" then
    return "nd"
  elseif last == "3" then
    return "rd"
  end
  return "th"
end

function nsl.randomSign()
  return math.random() > 0.5 and 1 or -1
end

function nsl.round( number, dp )
  return dp
    and math.floor( number * 10 ^ dp + 0.5 ) / 10 ^ dp
    or math.floor( number + 0.5 )
end

-- Binary Functions ------------------------------------------------------------

function nsl.binaryToInteger( string )
  return tonumber( string, 2 )
end

local binary_table = {
  [0] = "000", "001", "010", "011", "100", "101", "110", "111" }

function nsl.integerToBinary( number )
  return ( ("%o"):format( number ):gsub( "(.)", function( char )
    return binary_table[ tonumber( char ) ]
  end ):gsub( "^0*", "" ) )
end

