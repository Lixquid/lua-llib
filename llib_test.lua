--[[----------------------------------------------------------------------------
	LLib Testing suite

	For v0.3.0
--]]----------------------------------------------------------------------------

local test = require "gambiarra"



--[[----------------------------------------------------------------------------
	Module Loading
--]]----------------------------------------------------------------------------

test( "Module Loading::Local Use", function()
	local llib = require "llib"

	ok( llib, "LLib can be loaded locally" )
	ok( llib.util, "LLib contains libraries locally" )
end )

test( "Module Loading::Environment Importing", function()
	local env = {}
	local llib = require "llib"
	llib( env )

	ok( env.util, "LLib can be imported into a local environment" )
end )

test( "Module Loading::Global Importing", function()
	require "llib"()

	ok( util, "LLib can be imported into the global scope" )
end )



--[[----------------------------------------------------------------------------
	Util
--]]----------------------------------------------------------------------------

require "llib"()

test( "Util::Import", function()
	local from, to = {1,2,3}, {}
	util.import( from, to )
	ok( eq( from, to ), "Import copies over values correctly" )

	local from, to = {1,2,3}, {5,6,7}
	util.import( from, to )
	ok( eq( from, to ), "Import copies replaces values correctly" )

	local from, to = { a = {1,2,3}, b = {4,5,6} }, { a = {5,6,7}, b = {1,2,3} }
	util.import( from, to )
	ok( eq( from, to ), "Import recursively replaces values correctly" )

	local from, to, target = { a = {5,6,7}, b = {8,9} },
	  { a = {1,2,3,4}, b = {1,2,3} },
	  { a = {5,6,7,4}, b = {8,9,3} }
	util.import( from, to )
	ok( eq( to, target ), "Import will not touch keys that don't exist in the"
	  .. " parent table" )

	local from, to, target = { a = {5}, b={a=8, b=9} },
	  { a = 1, b = {a=2, b=3} },
	  { a = 1, b = {a=8, b=9} }
	util.import( from, to, { a = true } )
	ok( eq( to, target ), "Import will copy recursive keys on the exclusion"
	  .. " list" )
end )
