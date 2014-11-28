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

-- Indeterminism Functions -----------------------------------------------------

-- Indeterminate
nsl.ind = 0/0
-- Not a Number
nsl.nan = -nsl.ind

function nsl.isFinite( number )
  return -math.huge < number and number < math.huge
end

function nsl.isInfinite( number )
  return math.huge == number and 1 or -math.huge == number and -1
end

function nsl.isNaN( object )
  return object ~= object
end

--[[----------------------------------------------------------------------------
    String
--]]----------------------------------------------------------------------------
ns.string = ns.string or {}
local nsl = ns.string

function nsl.chars( string )
  return function( t )
    t[1] = t[1] + 1
    local c = t[2]:sub( t[1], t[1] )
    if c and #c > 0 then return t[1], c end
  end, { 0, tostring( string ) }
end

function nsl.left( string, length )
  return tostring( string ):sub( 1, length )
end

function nsl.right( string, length )
  return tostring( string ):sub( -length )
end

function nsl.split( string, separator, plain )
  local string, separator, t =
    tostring( string ),
    tostring( separator or "" ),
    {}

  if separator == "" then
    for i = 1, #string do
      table.insert( t, string:sub( i, i ) )
    end

    return t
  end

  while true do
    local p1, p2 = string:find( separator, 1, plain )

    if not p1 or #string == 0 then
      if #string > 0 then table.insert( t, string ) end
      return t
    end

    table.insert( t, string:sub( 1, p1 - 1 ) )
    string = string:sub( p2 + 1 )
  end
end

-- Strip Functions -------------------------------------------------------------

function nsl.strip( string, character )
  return ( tostring( string ):gsub( "^[" .. tostring( character or "%s" )
    .. "]*(.-)[" .. tostring( character or "%s" ) .. "]*$", "%1" ) )
end

function nsl.stripLeft( string, character )
  return ( tostring( string ):gsub( "^[" .. tostring( character or "%s" )
  .. "]*", "" ) )
end

function nsl.stripRight( string, character )
  return ( tostring( string ):gsub( "[" .. tostring( character or "%s" )
  .. "]*$", "" ) )
end

--[[----------------------------------------------------------------------------
    Table
--]]----------------------------------------------------------------------------
ns.table = ns.table or {}
local nsl = ns.table

function nsl.contains( table, object )
  for _, v in pairs( table ) do if v == object then return true end end
  return false
end

function nsl.copy( table, recursive )
  local new = {}

  for k, v in pairs( table ) do
    new[ k ] = type( v ) == "table" and recursive and nsl.copy( v ) or v
  end
  setmetatable( new, getmetatable( table ) )

  return new
end

function nsl.count( table )
  local n = 0
  for _ in pairs( table ) do n = n + 1 end
  return n
end

function nsl.empty( table )
  for k in pairs( table ) do table[k] = nil end
  return table
end

function nsl.head( table )
  return next( table )
end

function nsl.merge( target, ... )
  for _, tab in pairs( { ... } ) do
    for _, v in pairs( tab ) do
      table.insert( target, v )
    end
  end

  return target
end

function nsl.print( tab, _depth, _recurse )
  _depth, _recurse = _depth or 0, _recurse or {}

  if _depth == 0 then
    print( tostring( tab ) .. " {" )
  end

  _depth = _depth + 1
  _recurse[ tab ] = true

  for k, v in pairs( tab ) do
    if type( v ) == "table" and not _recurse[ v ] then
      print(
        ("\t"):rep( _depth )
        .. tostring( k ) .. ": " .. tostring( v ) .. " {" )
      nsl.print( v, _depth, _recurse )
    else
      print( ("\t"):rep( _depth ) .. tostring( k ) .. ": " .. tostring( v ) )
    end
  end

  _depth = _depth - 1
  print( ("\t"):rep( _depth ) .. "}" )

end

function nsl.random( tab )
  local t = {}
  for _, v in pairs( tab ) do table.insert( t, v ) end
  return t[ math.random( #t ) ]
end

function nsl.tail( tab )
  local lk, lv
  for k, v in pairs( tab ) do lk, lv = k, v end
  return lk, lv
end

