require("Libs.PhysicsSensorLib")
require("Libs.Vector3")

function cut(number)
	return string.format("%-.2f", number)
end

function debugTableAxis(title, table)
	debug.log("$$|| " .. title .. " -> X: " .. cut(table[1]) .. ", Y: " .. cut(table[2]) .. ", Z: " .. cut(table[3]) .. ",")
end


PHS = PhisicsSensorLib:new()
VEC_BASE = Vector3:new(0, 0, 1)

function rad2turn(angle)
	return angle / (2 * math.pi)
end

function onTick()
	if input.getNumber(1) == 0 then
		debug.log("$$|| No Signal ||$$")
		return
	end
	PHS:update(1)

	local v = PHS:rotateVectorWorld2Local(VEC_BASE.vec)
	local vec_local = Vector3:new(v[1], v[2], v[3])
	local azimuth = vec_local:getAzimuth()
	local elevation = vec_local:getElevation()

	output.setNumber(1, 4 * rad2turn(azimuth))
	output.setNumber(2, 4 * rad2turn(elevation))

	debugTableAxis("Vector", v)
end