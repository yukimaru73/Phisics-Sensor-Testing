require("Libs.PhysicsSensorLib")
require("Libs.Vector3")

pi = math.pi

print(math.atan(0, 1)*180/pi)

PHS = PhisicsSensorLib:new()
VEC_BASE = Vector3:new(0, 0, 1)
--pitch
PHS.euler[1] = pi/2
--yaw
PHS.euler[2] = 0
--roll
PHS.euler[3] = 0

v = PHS:rotateVectorWorld2Local(VEC_BASE.vec)
print  "a"