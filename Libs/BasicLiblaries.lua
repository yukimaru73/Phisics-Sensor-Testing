-- Author: TAK4129
-- GitHub: https://github.com/yukimaru73
-- Workshop: https://steamcommunity.com/profiles/76561198174258594/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Utils.LBCopy")

---@section Pulse 1 Pulse
---@class Pulse
---@field pastSignal boolean
Pulse = {

	---@section new
	---@param cls Pulse
	new = function(cls)
		return LifeBoatAPI.lb_copy(cls, {pastSignal = false})
	end;
	---@endsection

	---@section update
	---@param self Pulse
	---@param signal boolean
	---@return boolean
	update = function(self, signal)
		local result = signal and not self.pastSignal
		self.pastSignal = signal
		return result
	end;
	---@endsection
	
}
---@endsection