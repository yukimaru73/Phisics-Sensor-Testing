require("Libs.PhysicsSensorLib")
require("Libs.Vector3")
require("Libs.PID")

function cut(number)
	return string.format("%-.2f", number)
end

function debugTableAxis(title, table)
	debug.log("$$|| " .. title .. " -> X: " .. cut(table[1]) .. ", Y: " .. cut(table[2]) .. ", Z: " .. cut(table[3]) .. ",")
end


PHS = PhisicsSensorLib:new()
PivotPID = PID:new(7, 0.007, 0.2, 0.05)
VEC_BASE = Vector3:new(1, 1, 0)

PIVOT_H = 0

function rad2turn(angle)
	return angle / (2 * math.pi)
end

function onTick()
	if input.getNumber(1) == 0 then
		debug.log("$$|| No Signal ||$$")
		return
	end
	VEC_BASE = Vector3:new(input.getNumber(15), input.getNumber(16), input.getNumber(17))
	PHS:update(1)

	local v = PHS:rotateVectorWorld2Local(VEC_BASE.vec)
	local vec_local = Vector3:new(v[1], v[2], v[3])
	local azimuth = vec_local:getAzimuth()
	local elevation = vec_local:getElevation()

	output.setNumber(1, 4 * rad2turn(azimuth))
	output.setNumber(2, 4 * rad2turn(elevation))
	PIVOT_H = rad2turn(azimuth)

	output.setNumber(3, PivotPID:update((PIVOT_H - input.getNumber(18) + 1.5) % 1 - 0.5, 0))

	debugTableAxis("Vector", v)
end