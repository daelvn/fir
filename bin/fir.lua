local argparse = require("argparse")
local fs = require("path.fs")
local fspath = require("path")
local fsinfo = require("path.info")
local style = require("ansikit.style").style
local args
do
	local _with_0 = argparse()
	_with_0:name("fir")
	_with_0:description("Language-agnostic documentation generator")
	_with_0:epilog("fir v" .. tostring(require('fir.version')) .. " - https://github.com/daelvn/fir")
	_with_0:help_description_margin(30)
	local c
	do
		local _with_1 = _with_0:option("-c --config")
		_with_1:description("Configuration file for this project")
		c = _with_1
	end
	local cl
	do
		local _with_1 = _with_0:option("--config-language")
		_with_1:description("Uses an explicit language for the config file")
		cl = _with_1
	end
	_with_0:group("Configuration", c, cl)
	local g
	do
		local _with_1 = _with_0:command("generate gen g")
		_with_1:description("Generates documentation for a project")
		g = _with_1
	end
	local d
	do
		local _with_1 = _with_0:command("dump d")
		_with_1:description("Dumps AST to stdout using tableview (does not generate docs)")
		d = _with_1
	end
	_with_0:group("Documentation", g)
	local sl
	do
		local _with_1 = _with_0:flag("-s --silent")
		_with_1:description("Does not print to stderr")
		sl = _with_1
	end
	_with_0:group("Flags", sl)
	args = _with_0:parse()
end
local FILE
do
	if args.c then
		FILE = args.c
	elseif args.config then
		FILE = args.config
	elseif fs.exists("Fir.lua") then
		FILE = "Fir.lua"
	elseif fs.exists("Fir.moon") then
		FILE = "Fir.moon"
	else
		FILE = error("No Firfile found.")
	end
end
local LANGUAGE
do
	if FILE:match("moon$") then
		LANGUAGE = "moon"
	elseif FILE:match("lua$") then
		LANGUAGE = "lua"
	elseif args.config_language then
		LANGUAGE = args.config_language
	else
		LANGUAGE = error("Cannot resolve format for Firfile.")
	end
end
if not arg.silent then
	io.stderr:write("Using " .. tostring(FILE) .. " (" .. tostring(LANGUAGE) .. ")\n")
end
local readMoon, readLua, loadEnv
do
	local _obj_0 = require("fir.file")
	readMoon, readLua, loadEnv = _obj_0.readMoon, _obj_0.readLua, _obj_0.loadEnv
end
local content, contentErr
if "moon" == LANGUAGE then
	content, contentErr = readMoon(FILE)
elseif "lua" == LANGUAGE then
	content, contentErr = readLua(FILE)
else
	content, contentErr = error("Cannot resolve format '" .. tostring(LANGUAGE) .. "' for Firfile.")
end
if not content then
	error(contentErr, 1)
end
local firEnv = { }
local fir, firErr = loadEnv(content, firEnv)
if firErr then
	error("Could not load Firfile: " .. tostring(firErr))
end
local list = fir()
local rconfig = list and (list.config and list.config or { }) or { }
local project = firEnv
for k, v in pairs(rconfig) do
	project[k] = v
end
local printArrow
printArrow = function(txt)
	if not args.silent then
		return io.stderr:write(style("%{blue}==>%{white} " .. tostring(txt) .. "\n"))
	end
end
local printError
printError = function(txt)
	if not args.silent then
		return io.stderr:write(style("%{red}" .. tostring(txt) .. "\n"))
	end
end
local printPlus
printPlus = function(txt)
	if not args.silent then
		return io.stderr:write(style("%{green}+ " .. tostring(txt) .. "\n"))
	end
end
local printMini
printMini = function(txt)
	if not args.silent then
		return io.stderr:write(style("%{yellow}-> " .. tostring(txt) .. "\n"))
	end
end
local readFile
readFile = function(f)
	local content
	do
		local _with_0 = io.open(f, "r")
		content = _with_0:read("*a")
		_with_0:close()
	end
	return content
end
local writeFile
writeFile = function(f, t)
	local _with_0 = io.open(f, "w")
	_with_0:write(t)
	_with_0:close()
	return _with_0
end
local mkdirFor
mkdirFor = function(path)
	path = path:match("(.+)/.-")
	local sep, pStr = (package.config:sub(1, 1)), ""
	for dir in path:gmatch("[^" .. sep .. "]+") do
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
if args.generate or args.dump then
	printArrow("Generating docs" .. tostring((project.name ~= nil) and (' for ' .. project.name) or ''))
	if not (project.input ~= nil) then
		printError("No input specified.")
		printError("Please set an 'input' field (table) in " .. tostring(FILE))
		os.exit(1)
	end
	local ignore
	if project.ignore then
		ignore = flatten((function()
			local _accum_0 = { }
			local _len_0 = 1
			local _list_0 = project.ignore
			for _index_0 = 1, #_list_0 do
				local ig = _list_0[_index_0]
				_accum_0[_len_0] = fromGlob(globCompat(ig))
				_len_0 = _len_0 + 1
			end
			return _accum_0
		end)())
	end
	local cwd = fspath.cwd()
	local files = { }
	local emitted = { }
	local _list_0 = project.input
	for _index_0 = 1, #_list_0 do
		local inp = _list_0[_index_0]
		local nodes = fromGlob(globCompat((inp.verbatim and inp[1] or inp)))
		for _index_1 = 1, #nodes do
			local node = nodes[_index_1]
			if fs.isfile(node) then
				local doIgnore = false
				if project.ignore then
					for _index_2 = 1, #ignore do
						local ig = ignore[_index_2]
						if node:match(ig) then
							doIgnore = true
						end
					end
				end
				if not doIgnore then
					local fname = (fspath.abs(node)):match(tostring(cwd) .. tostring(fsinfo.sep) .. "(.+)")
					if inp.verbatim then
						emitted[fname] = readFile(fname)
					else
						files[#files + 1] = fname
					end
					printPlus(fname)
				end
			end
		end
	end
	if not (project.language ~= nil) then
		printError("No language specified.")
		printError("Please set a 'language' field (table) in " .. tostring(FILE))
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
		extracted[file] = extract((readFile(file)), project.language, project.backend or { })
	end
	local parse
	do
		local _obj_0 = require("fir.generic.parser")
		parse = _obj_0.parse
	end
	local parsed = { }
	for _index_0 = 1, #files do
		local file = files[_index_0]
		parsed[file] = parse(extracted[file], project.language)
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
	if not (project.format ~= nil) then
		printError("No format specified.")
		printError("Please set a 'format' field (string) in " .. tostring(FILE))
		os.exit(1)
	end
	local symbols = { }
	if project.format == 'markdown' then
		local listAllSymbols
		do
			local _obj_0 = require("fir.generic.emit.markdown")
			listAllSymbols = _obj_0.listAllSymbols
		end
		for file, parsed in pairs(parsed) do
			local this_symbols = listAllSymbols(parsed, {
				url_prefix = project.url_prefix
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
		local _obj_0 = require("fir.generic.emit." .. tostring(project.format))
		emit = _obj_0.emit
	end
	for _index_0 = 1, #files do
		local file = files[_index_0]
		emitted[file] = emit(parsed[file], (function()
			local _tab_0 = { }
			local _obj_0 = (project.emit or { })
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
		end)())
	end
	if not (project.output ~= nil) then
		printError("No output folder specified.")
		printError("Please set an 'output' field (string) in " .. tostring(FILE))
		os.exit(1)
	end
	if not fs.isdir(project.output) then
		fs.mkdir(project.output)
	end
	for oldfile, content in pairs(emitted) do
		local file = oldfile
		if project.transform then
			file = fspath(project.output, project.transform(oldfile))
		end
		mkdirFor(file)
		writeFile(file, content)
	end
end
