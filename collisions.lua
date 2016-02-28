local coll = {}

function coll.collides(a, b)
	-- Test if a and b collide

	local ax,ay,aw,ah = a.x, a.y, a.width, a.height
	local bx,by,bw,bh = b.x, b.y, b.width, b.height

	return ax < bx+bw and bx < ax+aw and ay < by+bh and by < ay+ah
end

return coll
