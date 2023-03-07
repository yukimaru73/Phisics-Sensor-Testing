require("Libs.PhysicsSensorLib")
require("Libs.Vector3")

--Definition --
--[[
	0: none
	1: tiltFront
	2: tiltBack
	3: tiltRight
	4: tiltLeft
	5: tiltUp
	6: tiltDown
	7: compass
	8: speed_x_local
	9: speed_y_local
	10: speed_z_local
	11: speed_vertical
	12: speed_horizontal
	13: speed_absolute
	14: angular_speed_x_local
	15: angular_speed_y_local
	16: angular_speed_z_local
	17: GPS_x
	18: Altitude
	19: GPS_y
]]
VARS_NAME = {
	"tiltFront",
	"tiltBack",
	"tiltRight",
	"tiltLeft",
	"tiltUp",
	"tiltDown",
	"compass",
	"speed_x_local",
	"speed_y_local",
	"speed_z_local",
	"speed_vertical",
	"speed_horizontal",
	"speed_absolute",
	"angular_speed_x_local",
	"angular_speed_y_local",
	"angular_speed_z_local",
	"GPS_x",
	"Altitude",
	"GPS_y"
}

---@type number[]
OUTPUT_VARS = {}

-- Properties Definition --
TIMELAG = property.getNumber("Time Lag")

OUTPUT_CH_DEF = {}
for i = 1, 32 do
	OUTPUT_CH_DEF[i] = property.getNumber("Ch." .. i)
end

-- Global Variables --
PHS = PhisicsSensorLib:new()

BASE_VEC_FRONT = Vector3:new(0, 0, 1)
VEC_BASE_BACK = Vector3:new(0, 0, -1)
BASE_VEC_RIGHT = Vector3:new(1, 0, 0)
VEC_BASE_LEFT = Vector3:new( -1, 0, 0)
BASE_VEC_UP = Vector3:new(0, 1, 0)
VEC_BASE_DOWN = Vector3:new(0, -1, 0)

RAD_TO_TURN = 1 / (2 * math.pi)

GPS_Y_PREV = 0
GPS_HORIZONTAL_PREV = 0

function onTick()
	-- INPUT BLOCK --
	PHS:update(1)

	-- PROCESS BLOCK --

	local frontLocal2World = Vector3:newFromArray(PHS:rotateVectorLocal2World(BASE_VEC_FRONT.vec, TIMELAG))
	local rightLocal2World = Vector3:newFromArray(PHS:rotateVectorLocal2World(BASE_VEC_RIGHT.vec, TIMELAG))
	local upLocal2World = Vector3:newFromArray(PHS:rotateVectorLocal2World(BASE_VEC_UP.vec, TIMELAG))

	local angularSpeedWorld2Local = PHS:rotateVectorWorld2Local(PHS.angularSpeed, TIMELAG)

	OUTPUT_VARS[1] = frontLocal2World:getElevation() * RAD_TO_TURN
	OUTPUT_VARS[2] = -OUTPUT_VARS[1]
	OUTPUT_VARS[3] = rightLocal2World:getElevation() * RAD_TO_TURN
	OUTPUT_VARS[4] = -OUTPUT_VARS[3]
	OUTPUT_VARS[5] = upLocal2World:getElevation() * RAD_TO_TURN
	OUTPUT_VARS[6] = -OUTPUT_VARS[5]
	OUTPUT_VARS[7] = -frontLocal2World:getAzimuth() * RAD_TO_TURN

	OUTPUT_VARS[8] = PHS.velocity[3]
	OUTPUT_VARS[9] = PHS.velocity[2]
	OUTPUT_VARS[10] = PHS.velocity[1]

	OUTPUT_VARS[11] = (PHS.GPS[2] - GPS_Y_PREV) * 60
	OUTPUT_VARS[12] = (math.sqrt(PHS.GPS[1] * PHS.GPS[1] + PHS.GPS[3] * PHS.GPS[3]) - GPS_HORIZONTAL_PREV) * 60
	OUTPUT_VARS[13] = PHS.absVelocity

	OUTPUT_VARS[14] = -angularSpeedWorld2Local[1] * RAD_TO_TURN * 60
	OUTPUT_VARS[15] = angularSpeedWorld2Local[2] * RAD_TO_TURN * 60
	OUTPUT_VARS[16] = angularSpeedWorld2Local[3] * RAD_TO_TURN * 60

	OUTPUT_VARS[17] = PHS.GPS[1]
	OUTPUT_VARS[18] = PHS.GPS[2]
	OUTPUT_VARS[19] = PHS.GPS[3]


	-- OUTPUT BLOCK --

	for i = 1, 32 do
		if OUTPUT_CH_DEF[i] ~= 0 then
			local key = OUTPUT_CH_DEF[i]
			local out = OUTPUT_VARS[key]
			output.setNumber(i, out or 0)
			debug.log("$$|| Ch." .. i .. ": " .. VARS_NAME[key] .. " = " .. (out or "nil"))
		end
	end

	-- PREPARE FOR NEXT TICK --
	GPS_Y_PREV = PHS.GPS[2]
	GPS_HORIZONTAL_PREV = math.sqrt(PHS.GPS[1] * PHS.GPS[1] + PHS.GPS[3] * PHS.GPS[3])
end
