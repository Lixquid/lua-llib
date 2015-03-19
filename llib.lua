--[[----------------------------------------------------------------------------
	LLib - v0.3.0

	A lightweight library of Lua functions
	Made with <3 by Lixquid
--]]----------------------------------------------------------------------------

local llib = {}
llib.version = "0.3.0"



--[[----------------------------------------------------------------------------
	Util
--]]----------------------------------------------------------------------------
llib.util = {}

--- Imports all members of one table into another, recursively.
-- An optional key-based table of keys to exclude from importing at the top-most
-- level can bed passed.
-- @tparam {...} from Table to import keys from.
-- @param env Environment to import into.
-- @tparam ?{boolean,...} exclude Optional. Key-based table of keys to exclude
--   from import. Only applies to the top-most level. Defaults to {}.
function llib.util.import( from, env, exclude )
	local exclude = exclude or {}

	for key, value in pairs( from ) do
		if not exclude[ key ] then
			if type( env[ key ] ) == "table" and type( value ) == "table" then
				llib.util.import( value, env[ key ] )
			else
				env[ key ] = value
			end
		end
	end
end



--[[----------------------------------------------------------------------------
	Export
--]]----------------------------------------------------------------------------

setmetatable( llib, {

--- Imports LLib into an environment.
-- @tparam ?env Environment to import into. If omitted, _G is used by default.
__call = function( self, env )
	llib.util.import( self, env or _G, { version = true } )
end

} )

return llib
