local fs = require("filekit")
return {
	tasks = {
		fir_generate = function(self)
			local config = self.config
			local cwd = fs.currentDir()
			local files = { }
		end,
		fir = function(self)
			local generate = (uses("generate")) or (uses("gen")) or (uses("g"))
			local dump = (uses("dump")) or (uses("d"))
			local silent = self.silent or self.s
		end
	}
}
