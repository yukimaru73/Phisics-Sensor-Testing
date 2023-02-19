require("Libs.PhysicsSensorLib")
require("Libs.Vector3")

PHS = PhisicsSensorLib:new()
VEC_BASE = Vector3:new(1, 0, 0)
PHS.euler[1] = 0
PHS.euler[2] = 0
PHS.euler[3] = math.pi / 4

PHS:rotateVectorWorld2Local(VEC_BASE.vec)
