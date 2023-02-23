require("Libs.PhysicsSensorLib")
require("Libs.Vector3")


PHS = PhisicsSensorLib:new()

VASE_VEC_FRONT = Vector3:new(0, 0, 1)
VASE_VEC_BACK = Vector3:new(0, 0, -1)
VASE_VEC_RIGHT = Vector3:new(1, 0, 0)
VASE_VEC_LEFT = Vector3:new(-1, 0, 0)
VASE_VEC_UP = Vector3:new(0, 1, 0)

TILT_FRONT = 0
TILT_LEFT = 0
TILT_UP = 0
COMPASS = 0

RAD_TO_TURN = 1 / (2 * math.pi)

ALT_PREV = 0

function onTick()

	-- INPUT BLOCK --
	PHS:update(1)

	-- PROCESS BLOCK --
	local front = Vector3:newFromArray(PHS:rotateVectorLocal2World(VASE_VEC_FRONT.vec, 0))
	local left = Vector3:newFromArray(PHS:rotateVectorLocal2World(VASE_VEC_LEFT.vec, 0))
	local up = Vector3:newFromArray(PHS:rotateVectorLocal2World(VASE_VEC_UP.vec, 0))

	TILT_FRONT = front:getElevation() * RAD_TO_TURN
	TILT_LEFT = left:getElevation() * RAD_TO_TURN
	TILT_UP = up:getElevation() * RAD_TO_TURN

	COMPASS = -front:getAzimuth() * RAD_TO_TURN

	local altSpeed = 3.6 * (PHS.GPS[3] - ALT_PREV)

	-- OUTPUT BLOCK --
	output.setNumber(1, PHS.GPS[2])

	output.setNumber(2, PHS.velocity[3])
	output.setNumber(3, PHS.velocity[2])
	output.setNumber(4, PHS.velocity[1])

	output.setNumber(5, TILT_LEFT)
	output.setNumber(6, TILT_FRONT)
	output.setNumber(7, TILT_UP)
	output.setNumber(8, COMPASS)
	output.setNumber(9, altSpeed)

	ALT_PREV = PHS.GPS[3]
end

