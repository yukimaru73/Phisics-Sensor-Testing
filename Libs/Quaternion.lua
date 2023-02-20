--require("LifeBoatAPI.Utils.LBCopy")
require("Libs.LBCopy")

---@section Quaternion 1 Quaternion  {x,y,z; w}
---@class Quaternion
---@field x number
---@field y number
---@field z number
---@field w number
Quaternion = {

	---@param cls Quaternion
	---@overload fun(cls:Quaternion):Quaternion creates a new zero-initialized Quaternion
	---@return Quaternion
	_new = function(cls, x, y, z, w)
		return LifeBoatAPI.lb_copy(cls, { x = x or 0, y = y or 0, z = z or 0, w = w or 0 })
	end;

	---@section newFromEuler
	---@param cls Quaternion
	---@param Z number radian
	---@param X number radian
	---@param Y number radian
	---@return Quaternion
	newFromEuler = function(cls, X, Y, Z)
		local v = { 1, 0, 0 }
		local q = cls:newRotateQuaternion(X, v) --pitch(X)

		v = q:rotateVector({ 0, 1, 0 })
		q = cls:newRotateQuaternion(Y, v):product(q) --yaw(Y)

		v = q:rotateVector({ 0, 0, 1 })
		q = cls:newRotateQuaternion(Z, v):product(q) --roll(Z)

		return q
	end;
	---@endsection

	---@section getConjugateQuaternion
	---@param self Quaternion
	---@return Quaternion
	getConjugateQuaternion = function(self)
		return self:_new(-self.x, -self.y, -self.z, self.w)
	end;
	---@endsection

	---@section product calculate A⊗B
	---@param self Quaternion A
	---@param target Quaternion B
	---@return Quaternion
	product = function(self, target)
		return self:_new(
			self.x * target.w + self.w * target.x - self.z * target.y + self.y * target.z,
			self.y * target.w + self.z * target.x + self.w * target.y - self.x * target.z,
			self.z * target.w - self.y * target.x + self.x * target.y + self.w * target.z,
			self.w * target.w - self.x * target.x - self.y * target.y - self.z * target.z
		)
	end;
	---@endsection

	---@section normalize normalize the quaternion
	---@param self Quaternion
	---@return Quaternion
	normalize = function(self)
		local norm = math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2 + self.w ^ 2)
		return self:_new(self.x / norm, self.y / norm, self.z / norm, self.w / norm)
	end;
	---@endsection

	---@section newRotateQuaternion
	---@param cls Quaternion
	---@param angle number Turn(0 to 1, correspond to 0 to 2π)
	---@param vector table {x, y, z}
	---@return Quaternion
	newRotateQuaternion = function(cls, angle, vector)
		angle = angle / 2
		local sine, norm = math.sin(angle), math.sqrt(vector[1] ^ 2 + vector[2] ^ 2 + vector[3] ^ 2)
		for i = 1, 3 do
			vector[i] = vector[i] / norm
		end
		local r = cls:_new(vector[1], vector[2], vector[3], 0)
		r.x = sine * r.x
		r.y = sine * r.y
		r.z = sine * r.z
		r.w = math.cos(angle)
		return r
	end;
	---@endsection

	---@section rotateVector
	---@param self Quaternion Rotation Quaternion
	---@param vector table Vector3
	---@return table
	rotateVector = function(self, vector)
		local normalizedSelf = self:normalize()
		local q = normalizedSelf:product(self:_new(vector[1], vector[2], vector[3], 0):product(normalizedSelf:getConjugateQuaternion()))
		return { q.x, q.y, q.z }
	end;
	---@endsection

	---@section slerp
	---@param self Quaternion
	---@param target Quaternion
	---@param t number
	---@return Quaternion
	slerp = function(self, target, t)
		local cosHalfTheta = self.w * target.w + self.x * target.x + self.y * target.y + self.z * target.z
		if math.abs(cosHalfTheta) >= 1.0 then
			return self
		end
		local halfTheta = math.acos(cosHalfTheta)
		local sinHalfTheta = math.sqrt(1.0 - cosHalfTheta * cosHalfTheta)
		if math.abs(sinHalfTheta) < 0.001 then
			return self:_new(
				self.x * 0.5 + target.x * 0.5,
				self.y * 0.5 + target.y * 0.5,
				self.z * 0.5 + target.z * 0.5,
				self.w * 0.5 + target.w * 0.5
			)
		end
		local ratioA = math.sin((1 - t) * halfTheta) / sinHalfTheta
		local ratioB = math.sin(t * halfTheta) / sinHalfTheta
		return self:_new(
			self.x * ratioA + target.x * ratioB,
			self.y * ratioA + target.y * ratioB,
			self.z * ratioA + target.z * ratioB,
			self.w * ratioA + target.w * ratioB
		)
	end;
	---@endsection
}
---@endsection
