
local CC = {
	colors = colors,
	paintutils = paintutils,
	setMonitor = function(_monitor)
		monitor = _monitor
	end,
	getMonitor = function()
		return monitor
	end
}
return CC