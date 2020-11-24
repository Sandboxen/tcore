function math.Clamp( _in, low, high )
local _in = tonumber(_in)
local low = tonumber(low)
local high = tonumber(high)
if _in==nil or low==nil or high==nil then return _in end
	if ( _in < low ) then return low end
	if ( _in > high ) then return high end
	return _in
end
