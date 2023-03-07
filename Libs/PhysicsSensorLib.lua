--require("LifeBoatAPI.Utils.LBCopy")
require("Libs.LBCopy")
require("Libs.Quaternion")

---@section PhisicsSensorLib 1 PhisicsSensorLib
---@class PhysicsSensorLib
---@field GPS table[X, Y, Z]
---@field euler table[X, Y, Z]
---@field velocity table[X, Y, Z]
---@field angularSpeed table[X, Y, Z]
---@field absVelocity number
---@field absAngularSpeed number
PhisicsSensorLib = {
	---@param cls PhysicsSensorLib
	---@overload fun(cls:PhysicsSensorLib):PhysicsSensorLib creates a new zero-initialized PhisicsSensorLib
	---@return PhysicsSensorLib
	new = function(cls, GPS, euler, velocity, anglerSpeed, absVelocity, absAnglerSpeed)
		return LifeBoatAPI.lb_copy(cls, {
			GPS = GPS or { 0, 0, 0 },
			euler = euler or { 0, 0, 0 },
			velocity = velocity or { 0, 0, 0 },
			angularSpeed = anglerSpeed or { 0, 0, 0 },
			absVelocity = absVelocity or 0,
			absAngularSpeed = absAnglerSpeed or 0
		})
	end;

	---@section update
	---@param self PhysicsSensorLib
	---@param startChannel number
	---@return nil
	update = function(self, startChannel)
		for i = 1, 3 do
			self.GPS[i] = input.getNumber(startChannel + i - 1)
			self.euler[i] = input.getNumber(startChannel + i + 2)
			self.velocity[i] = input.getNumber(startChannel + i + 5)
			self.angularSpeed[i] = input.getNumber(startChannel + i + 8) * math.pi / 30
		end
		self.absVelocity = input.getNumber(startChannel + 12)
		self.absAnglerSpeed = input.getNumber(startChannel + 13)
	end;
	---@endsection

	---@section _getQuaternion
	---@param self PhysicsSensorLib
	---@param ticks number
	---@return Quaternion
	_getQuaternion = function(self, ticks)
		return Quaternion:newFromEuler(
			self.euler[1] + ticks * self.angularSpeed[1],
			self.euler[2] + ticks * self.angularSpeed[2],
			self.euler[3] + ticks * self.angularSpeed[3])
	end;
	---@endsection

	---@section rotateVectorLocal2World
	---@param self PhysicsSensorLib
	---@param ticks number
	---@param vector table[X, Y, Z]
	---@return table[X, Y, Z]
	rotateVectorLocal2World = function(self, vector, ticks)
		return self:_getQuaternion(ticks):rotateVector(vector)
	end;
	---@endsection

	---@section rotateVectorWorld2Local
	---@param self PhysicsSensorLib
	---@param vector table[X, Y, Z]
	---@param ticks number
	---@return table[X, Y, Z]
	rotateVectorWorld2Local = function(self, vector, ticks)
		return self:_getQuaternion(ticks):getConjugateQuaternion():rotateVector(vector)
	end;
	---@endsection



}
