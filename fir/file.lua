local fs = require("filekit")
local readMoon
readMoon = function(file)
	local content
	do
		local _with_0 = fs.safeOpen(file, "r")
		if _with_0.error then
			return nil, "Could not open " .. tostring(file) .. ": " .. tostring(_with_0.error)
		end
		local to_lua
		do
			local _obj_0 = require("moonscript.base")
			to_lua = _obj_0.to_lua
		end
		local err
		content, err = to_lua(_with_0:read("*a"))
		if not content then
			return nil, "Could not read or parse " .. tostring(file) .. ": " .. tostring(err)
		end
		_with_0:close()
	end
	return content
end
local readLua
readLua = function(file)
	local content
	do
		local _with_0 = fs.safeOpen(file, "r")
		if _with_0.error then
			return nil, "Could not open " .. tostring(file) .. ": " .. tostring(_with_0.error)
		end
		content = _with_0:read("*a")
		if not content then
			return nil, "Could not read " .. tostring(file) .. ": " .. tostring(content)
		end
		_with_0:close()
	end
	return content
end
local loadEnv
loadEnv = function(content, env)
	local fn
	do
		local _exp_0 = _VERSION
		if "Lua 5.1" == _exp_0 then
			local err
			fn, err = loadstring(content)
			if not fn then
				return nil, "Could not load Firfile content (5.1): " .. tostring(err)
			end
			setfenv(fn, env)
		elseif "Lua 5.2" == _exp_0 or "Lua 5.3" == _exp_0 or "Lua 5.4" == _exp_0 then
			local err
			fn, err = load(content, "Fir", "t", env)
			if not fn then
				return nil, "Could not load Firfile content (5.2+): " .. tostring(err)
			end
		end
	end
	return fn
end
return {
	readMoon = readMoon,
	readLua = readLua,
	loadEnv = loadEnv
}
