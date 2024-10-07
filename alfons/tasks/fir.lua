local _anon_func_0 = function(self)
	local _obj_0 = self.config
	if _obj_0 ~= nil then
		return _obj_0.name
	end
	return nil
end
local _anon_func_1 = function(fromGlob, globCompat, self)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = self.config.ignore
	for _index_0 = 1, #_list_0 do
		local ig = _list_0[_index_0]
		_accum_0[_len_0] = fromGlob(globCompat(ig))
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_2 = function(pairs, self, symbols)
	local _tab_0 = { }
	local _obj_0 = (self.config.emit or { })
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(_obj_0) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.symbols = symbols
	return _tab_0
end
return {
	tasks = {
		fir = function(self)
			local FIR_VERSION = require('fir.version')
			prints("%{bold blue}Fir " .. tostring(FIR_VERSION) .. " (in Alfons mode)")
			self.reader = self.reader or readfile
			self.writer = self.writer or writefile
			local printArrow
			printArrow = function(txt)
				if not (self.s or self.silent) then
					return prints("%{blue}==>%{white} " .. tostring(txt))
				end
			end
			local printError
			printError = function(txt)
				if not (self.s or self.silent) then
					return prints("%{red}" .. tostring(txt))
				end
			end
			local printPlus
			printPlus = function(txt)
				if not (self.s or self.silent) then
					return prints("%{green}+ " .. tostring(txt))
				end
			end
			local printMini
			printMini = function(txt)
				if not (self.s or self.silent) then
					return prints("%{yellow}-> " .. tostring(txt))
				end
			end
			local mkdirFor
			mkdirFor = function(_path)
				_path = _path:match("(.+)/.-")
				local sep, pStr = fsinfo.sep, ""
				for dir in _path:gmatch("[^" .. sep .. "]+") do
					pStr = pStr .. dir .. sep
					fs.mkdir(pStr)
				end
			end
			local fromGlob
			fromGlob = function(pattern)
				local _accum_0 = { }
				local _len_0 = 1
				for node in fs.glob(pattern) do
					_accum_0[_len_0] = node
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end
			local reduce
			reduce = function(array, callback, initial)
				local accumulator = initial and initial or array[1]
				local start = initial and 1 or 2
				for i = start, #array do
					accumulator = callback(accumulator, array[i])
				end
				return accumulator
			end
			local flatten
			flatten = function(arr)
				return reduce(arr, (function(acc, val)
					local _tab_0 = { }
					local _idx_0 = #_tab_0 + 1
					for _index_0 = 1, #acc do
						local _value_0 = acc[_index_0]
						_tab_0[_idx_0] = _value_0
						_idx_0 = _idx_0 + 1
					end
					local _idx_1 = #_tab_0 + 1
					for _index_0 = 1, #val do
						local _value_0 = val[_index_0]
						_tab_0[_idx_1] = _value_0
						_idx_1 = _idx_1 + 1
					end
					return _tab_0
				end), { })
			end
			local globCompat
			globCompat = function(pattern)
				return pattern:gsub("%*%*([^" .. tostring(fsinfo.sep) .. "])", "**" .. tostring(fsinfo.sep) .. "*%1")
			end
			if self.generate or self.dump then
				printArrow("Generating docs" .. tostring(_anon_func_0(self) and (' for ' .. self.config.name) or ''))
				if not (self.config.input ~= nil) then
					printError("No input specified.")
					printError("Please set an 'input' field (table) in " .. tostring(FILE))
					os.exit(1)
				end
				local ignore
				if self.config.ignore then
					ignore = flatten(_anon_func_1(fromGlob, globCompat, self))
				end
				local cwd = path.cwd()
				local files = { }
				local emitted = { }
				local _list_0 = self.config.input
				for _index_0 = 1, #_list_0 do
					local inp = _list_0[_index_0]
					local nodes = fromGlob(globCompat((inp.verbatim and inp[1] or inp)))
					for _index_1 = 1, #nodes do
						local node = nodes[_index_1]
						if fs.isfile(node) then
							local doIgnore = false
							if self.config.ignore then
								for _index_2 = 1, #ignore do
									local ig = ignore[_index_2]
									if node:match(ig) then
										doIgnore = true
									end
								end
							end
							if not doIgnore then
								local fname = (path.abs(node)):match(tostring(cwd) .. tostring(fsinfo.sep) .. "(.+)")
								if inp.verbatim then
									emitted[fname] = self.reader(fname)
								else
									files[#files + 1] = fname
								end
								printPlus(fname)
							end
						end
					end
				end
				if not (self.config.language ~= nil) then
					printError("No language specified.")
					printError("Please set a 'language' field (table) in your Taskfile")
					os.exit(1)
				end
				local extract
				do
					local _obj_0 = require("fir.generic.backend")
					extract = _obj_0.extract
				end
				local extracted = { }
				for _index_0 = 1, #files do
					local file = files[_index_0]
					extracted[file] = extract((self.reader(file)), self.config.language, self.config.backend or { })
				end
				local parse
				do
					local _obj_0 = require("fir.generic.parser")
					parse = _obj_0.parse
				end
				local parsed = { }
				for _index_0 = 1, #files do
					local file = files[_index_0]
					parsed[file] = parse(extracted[file], self.config.language)
				end
				if args.dump then
					local generate
					do
						local _obj_0 = require("tableview")
						generate = _obj_0.generate
					end
					for _index_0 = 1, #files do
						local file = files[_index_0]
						print(generate(parsed[file]))
					end
					os.exit()
				end
				if not (self.config.format ~= nil) then
					printError("No format specified.")
					printError("Please set a 'format' field (string) in " .. tostring(FILE))
					os.exit(1)
				end
				local symbols = { }
				if self.config.format == 'markdown' then
					local listAllSymbols
					do
						local _obj_0 = require("fir.generic.emit.markdown")
						listAllSymbols = _obj_0.listAllSymbols
					end
					for file, parsed in pairs(parsed) do
						local this_symbols = listAllSymbols(parsed, {
							url_prefix = self.config.url_prefix
						})
						local _tab_0 = { }
						local _idx_0 = 1
						for _key_0, _value_0 in pairs(symbols) do
							if _idx_0 == _key_0 then
								_tab_0[#_tab_0 + 1] = _value_0
								_idx_0 = _idx_0 + 1
							else
								_tab_0[_key_0] = _value_0
							end
						end
						local _idx_1 = 1
						for _key_0, _value_0 in pairs(this_symbols) do
							if _idx_1 == _key_0 then
								_tab_0[#_tab_0 + 1] = _value_0
								_idx_1 = _idx_1 + 1
							else
								_tab_0[_key_0] = _value_0
							end
						end
						symbols = _tab_0
					end
				end
				local emit
				do
					local _obj_0 = require("fir.generic.emit." .. tostring(self.config.format))
					emit = _obj_0.emit
				end
				for _index_0 = 1, #files do
					local file = files[_index_0]
					emitted[file] = emit(parsed[file], _anon_func_2(pairs, self, symbols))
				end
				if not (self.config.output ~= nil) then
					printError("No output folder specified.")
					printError("Please set an 'output' field (string) in " .. tostring(FILE))
					os.exit(1)
				end
				if not fs.isdir(self.config.output) then
					fs.mkdir(self.config.output)
				end
				for oldfile, content in pairs(emitted) do
					local file = oldfile
					if self.config.transform then
						file = path(self.config.output, self.config.transform(oldfile))
					end
					mkdirFor(file)
					self.writer(file, content)
				end
			end
		end
	}
}
