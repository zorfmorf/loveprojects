-- a set of helper functions

-- rotates p1 around p2 by angle and returns the new coordinates
function helper_rotatePointAroundPoint(p1x, p1y, p2x, p2y, angle)
	p3x = math.cos(angle) * (p1x - p2x) - math.sin(angle) * (p1y - p2y) + p2x
	p3y = math.sin(angle) * (p1x - p2x) + math.cos(angle) * (p1y - p2y) + p2y
	return p3x, p3y
end

-- rounding as expected
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end