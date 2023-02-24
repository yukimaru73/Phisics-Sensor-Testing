require("Libs.PhysicsSensorLib")
require("Libs.Vector3")

--Definition --
VARS_DEF = {
	"none", --0
	"tiltFront", --1
	"tiltBack", --2
	"tiltRight", --3
	"tiltLeft", --4
	"tiltUp", --5
	"tiltDown", --6
	"compass" --7
}

OUTPUT_VARS = {
	tiltFront = 0,
	tiltBack= 0,
	tiltRight = 0,
	tiltLeft = 0,
	tiltUp = 0,
	tiltDown = 0,
	compass = 0
}

-- Properties Definition --
-- Number --
TIMELAG = property.getNumber("Time Lag")


OUTPUT_CH_DEF = {}
for i = 1, 32 do
	OUTPUT_CH_DEF[i] = property.getNumber("Output Channel " .. i)
end
-- Boolean --


OUTPUT_VARS = {}

PHS = PhisicsSensorLib:new()

VASE_VEC_FRONT = Vector3:new(0, 0, 1)
VASE_VEC_RIGHT = Vector3:new(1, 0, 0)
VASE_VEC_UP = Vector3:new(0, 1, 0)

RAD_TO_TURN = 1 / (2 * math.pi)

ALT_PREV = 0

function onTick()

	-- INPUT BLOCK --
	PHS:update(1)

	-- PROCESS BLOCK --
	local front = Vector3:newFromArray(PHS:rotateVectorLocal2World(VASE_VEC_FRONT.vec, TIMELAG))
	local right = Vector3:newFromArray(PHS:rotateVectorLocal2World(VASE_VEC_RIGHT.vec, TIMELAG))
	local up = Vector3:newFromArray(PHS:rotateVectorLocal2World(VASE_VEC_UP.vec, TIMELAG))

	OUTPUT_VARS.tiltFront = front:getElevation() * RAD_TO_TURN
	OUTPUT_VARS.tiltBack = -OUTPUT_VARS.tiltFront
	OUTPUT_VARS.tiltRight = right:getElevation() * RAD_TO_TURN
	OUTPUT_VARS.tiltLeft = -OUTPUT_VARS.tiltRight
	OUTPUT_VARS.tiltUp = up:getElevation() * RAD_TO_TURN
	OUTPUT_VARS.tiltDown = -OUTPUT_VARS.tiltUp
	OUTPUT_VARS.compass = -front:getAzimuth() * RAD_TO_TURN



	-- OUTPUT BLOCK --

	for i = 1, 32 do
		if OUTPUT_CH_DEF[i] ~= 0 then
			output.setNumber(i, OUTPUT_VARS[VARS_DEF[OUTPUT_CH_DEF[i]]])
		end
	end

end

