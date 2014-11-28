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
