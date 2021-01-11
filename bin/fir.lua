local argparse = require("argparse")
local fs = require("filekit")
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
		local _with_1 = _with_0:command("generate g")
		_with_1:description("Generates documentation for a project")
		g = _with_1
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
		fs.makeDir(pStr)
	end
end
if args.generate then
	printArrow("Generating docs" .. tostring((project.name ~= nil) and (' for ' .. project.name) or ''))
	if not (project.input ~= nil) then
		printError("No input specified.")
		printError("Please set an 'input' field (table) in " .. tostring(FILE))
		os.exit(1)
	end
	local ignore
	if project.ignore then
		do
			local _accum_0 = { }
			local _len_0 = 1
			local _list_0 = project.ignore
			for _index_0 = 1, #_list_0 do
				local ig = _list_0[_index_0]
				_accum_0[_len_0] = fs.fromGlob(ig)
				_len_0 = _len_0 + 1
			end
			ignore = _accum_0
		end
	end
	local cwd = fs.currentDir()
	local files = { }
	local _list_0 = project.input
	for _index_0 = 1, #_list_0 do
		local inp = _list_0[_index_0]
		for node in fs.iglob(inp) do
			if fs.isFile(node) then
				local doIgnore = false
				if project.ignore then
					for _index_1 = 1, #ignore do
						local ig = ignore[_index_1]
						if node:match(ig) then
							doIgnore = true
						end
					end
				end
				if not doIgnore then
					local fname = node:match(tostring(cwd) .. "/(.+)")
					files[#files + 1] = fname
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
	if not (project.format ~= nil) then
		printError("No format specified.")
		printError("Please set a 'format' field (string) in " .. tostring(FILE))
		os.exit(1)
	end
	local emit
	do
		local _obj_0 = require("fir.generic.emit." .. tostring(project.format))
		emit = _obj_0.emit
	end
	local emitted = { }
	for _index_0 = 1, #files do
		local file = files[_index_0]
		emitted[file] = emit(parsed[file], project.emit or { })
	end
	if not (project.output ~= nil) then
		printError("No output folder specified.")
		printError("Please set an 'output' field (string) in " .. tostring(FILE))
		os.exit(1)
	end
	if not fs.isDir(project.output) then
		fs.makeDir(project.output)
	end
	for _index_0 = 1, #files do
		local file = files[_index_0]
		local oldfile = file
		if project.transform then
			file = fs.combine(project.output, project.transform(file))
		end
		mkdirFor(file)
		writeFile(file, emitted[oldfile])
	end
end
