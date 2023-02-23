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
VEC_PREV = Vector3:new(0, 0, 0)

PIVOT_H = 0

function rad2turn(angle)
	return angle / (2 * math.pi)
end

function onTick()
	if input.getNumber(1) == 0 then
		debug.log("$$|| No Signal ||$$")
		return
	end
	PHS:update(1)
	local targetPosition = Vector3:new(input.getNumber(15), input.getNumber(16), input.getNumber(17))
	local selfPosition = Vector3:new(PHS.GPS[1], PHS.GPS[2], PHS.GPS[3])
	
	local viewVecGrobal = targetPosition:sub(selfPosition):normalize()
	local viewVecLocal = Vector3:newFromArray(PHS:rotateVectorWorld2Local(viewVecGrobal.vec, 3))

	local azimuth = viewVecLocal:getAzimuth()
	local elevation = viewVecLocal:getElevation()

	output.setNumber(1, 4 * rad2turn(azimuth))
	output.setNumber(2, 4 * rad2turn(elevation))
	PIVOT_H = rad2turn(azimuth)

	output.setNumber(3, PivotPID:update((PIVOT_H - input.getNumber(18) + 1.5) % 1 - 0.5, 0))


	debugTableAxis("Vector", viewVecLocal.vec)
	
end