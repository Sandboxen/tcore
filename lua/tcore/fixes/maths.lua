function math.Clamp( _in, low, high )

if _in==nil or low==nil or high==nil then return _in end
	if ( _in < low ) then return low end
	if ( _in > high ) then return high end
	return _in
end
