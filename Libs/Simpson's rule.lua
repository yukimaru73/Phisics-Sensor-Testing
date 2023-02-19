require("LifeBoatAPI.Utils.LBCopy")


---@section Simpson's rule 1 Simpson's rule
---@class SimpsonIntegration
---@field values table[]
---@field integralInterval number
---@field integratedNumber number
SimpsonIntegration = {

	---@section new
	---@param cls SimpsonIntegration
	---@param integralInterval number
	new =function (cls, integralInterval)
		local obj = {
			values = {},
			integralInterval = integralInterval,
			integratedNumber = 0
		}
		return LifeBoatAPI.lb_copy(cls, obj)
	end;
	---@endsection

	---@section isAvailable
	---@param self SimpsonIntegration
	---@return boolean
	isAvailable = function (self)
		return #self.values == 3
	end;
	---@endsection

	---@section update
	---@param self SimpsonIntegration
	---@param value number
	---@return number
	update = function (self, value)
		table.insert(self.values, value)
		if #self.values > 3 then
			table.remove(self.values, 1)
		end
		if #self.values == 3 then
			self.integratedNumber = self.integratedNumber + self.integralInterval * (self.values[1] + 4 * self.values[2] + self.values[3]) / 3
		end
		return self.integratedNumber
	end;
	---@endsection

	---@section reset
	---@param self SimpsonIntegration
	reset = function (self)
		self.values = {}
		self.integratedNumber = 0
	end;
	---@endsection

}
