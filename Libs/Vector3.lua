--require("LifeBoatAPI.Utils.LBCopy")
require("Libs.LBCopy")

---@section Vector3 1 Vector3  {x,y,z}
---@class Vector3
---@field vec table
Vector3 = {

	---@param cls Vector3
	---@overload fun(cls:Vector3):Vector3 creates a new zero-initialized Vector3
	---@return Vector3
	new = function(cls, x, y, z)
		return LifeBoatAPI.lb_copy(cls, { vec = { x, y, z } or { 0, 0, 0 } })
	end;

	---@section newFromPolar
	---@param cls Vector3
	---@param l number distance
	---@param a number azimuth
	---@param e number elevation
	---@return Vector3
	newFromPolar = function(cls, l, a, e)
		return Vector3:new(l * math.cos(e) * math.cos(a), l * math.sin(e), l * math.cos(e) * math.sin(a))
	end;
	---@endsection

	---@section newFromArray
	---@param cls Vector3
	---@param arr table
	---@return Vector3
	newFromArray = function(cls, arr)
		return Vector3:new(arr[1], arr[2], arr[3])
	end;
	---@endsection

	---@section getNorm
	---@param self Vector3
	---@return number
	getNorm = function(self)
		return math.sqrt(self.vec[1] * self.vec[1] + self.vec[2] * self.vec[2] + self.vec[3] * self.vec[3])
	end;
	---@endsection

	---@section normalize
	---@param self Vector3
	---@return Vector3
	normalize = function(self)
		local norm = self:getNorm()
		return self:new(self.vec[1] / norm, self.vec[2] / norm, self.vec[3] / norm)
	end;
	---@endsection

	---@section add
	---@param v1 Vector3
	---@param v2 Vector3
	---@return Vector3
	add = function(v1, v2)
		return Vector3:new(v1.vec[1] + v2.vec[1], v1.vec[2] + v2.vec[2], v1.vec[3] + v2.vec[3])
	end;
	---@endsection

	---@section sub
	---@param v1 Vector3
	---@param v2 Vector3
	---@return Vector3 
	sub = function(v1, v2)
		return Vector3:new(v1.vec[1] - v2.vec[1], v1.vec[2] - v2.vec[2], v1.vec[3] - v2.vec[3])
	end;
	---@endsection

	---@section mul
	---@param v1 Vector3
	---@param n number
	---@return Vector3
	mul = function(v1, n)
		return Vector3:new(v1.vec[1] * n, v1.vec[2] * n, v1.vec[3] * n)
	end;
	---@endsection

	---@section getDistanceBetween2Vectors
	---@param v1 Vector3
	---@param v2 Vector3
	---@return number
	getDistanceBetween2Vectors = function(v1, v2)
		return v1:sub(v2):getNorm()
	end;
	---@endsection

	---@section getAzimuth
	---@param self Vector3
	---@return number azimuth(rad)
	getAzimuth = function(self)
		return math.atan(self.vec[1], self.vec[3])
	end;
	---@endsection

	---@section getElevation
	---@param self Vector3
	---@return number elevation(rad)
	getElevation = function(self)
		return math.atan(self.vec[2], math.sqrt(self.vec[1] * self.vec[1] + self.vec[3] * self.vec[3]))
	end;
	---@endsection
	
}
---@endsection
