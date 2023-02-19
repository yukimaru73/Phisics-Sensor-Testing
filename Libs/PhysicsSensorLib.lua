require("LifeBoatAPI.Utils.LBCopy")
--require("Libs.LBCopy")
require("Libs.Quaternion")

---@section PhisicsSensorLib 1 PhisicsSensorLib
---@class PhysicsSensorLib
---@field GPS table[X, Y, Z]
---@field euler table[X, Y, Z]
---@field velocity table[X, Y, Z]
---@field anglerSpeed table[X, Y, Z]
---@field absVelocity number
---@field absAnglerSpeed number
PhisicsSensorLib = {
	---@param cls PhysicsSensorLib
	---@overload fun(cls:PhysicsSensorLib):PhysicsSensorLib creates a new zero-initialized PhisicsSensorLib
	---@return PhysicsSensorLib
	new = function(cls, GPS, euler, velocity, anglerSpeed, absVelocity, absAnglerSpeed)
		return LifeBoatAPI.lb_copy(cls, {
			GPS = GPS or { 0, 0, 0 },
			euler = euler or { 0, 0, 0 },
			velocity = velocity or { 0, 0, 0 },
			anglerSpeed = anglerSpeed or { 0, 0, 0 },
			absVelocity = absVelocity or 0,
			absAnglerSpeed = absAnglerSpeed or 0
		})
	end;

	---@section update
	---@param self PhysicsSensorLib
	---@param startChannel number
	---@return nil
	update = function(self, startChannel)
		for i = 0, 3 do
			self.GPS[i] = input.getNumber(startChannel + i - 1)
			self.euler[i] = input.getNumber(startChannel + i + 2)
			self.velocity[i] = input.getNumber(startChannel + i + 5)
		end
		self.anglerSpeed[1] = input.getNumber(startChannel + 10)
		self.anglerSpeed[2] = input.getNumber(startChannel + 11)
		self.anglerSpeed[3] = -input.getNumber(startChannel + 12)
		self.absVelocity = input.getNumber(startChannel + 13)
		self.absAnglerSpeed = input.getNumber(startChannel + 14)
	end;
	---@endsection

	---@section _getQuaternion
	---@param self PhysicsSensorLib
	---@return Quaternion
	_getQuaternion = function(self)
		return Quaternion:newFromEuler(self.euler[1], self.euler[2], self.euler[3])
	end;
	---@endsection

	---@section rotateVectorLocal2World
	---@param self PhysicsSensorLib
	---@param vector table[X, Y, Z]
	---@return table[X, Y, Z]
	rotateVectorLocal2World = function(self, vector)
		return self:_getQuaternion():rotateVector(vector)
	end;
	---@endsection

	---@section rotateVectorWorld2Local
	---@param self PhysicsSensorLib
	---@param vector table[X, Y, Z]
	---@return table[X, Y, Z]
	rotateVectorWorld2Local = function(self, vector)
		return self:_getQuaternion():getConjugateQuaternion():rotateVector(vector)
	end;
	---@endsection



}
