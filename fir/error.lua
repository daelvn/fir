local _module_0 = { }
local style
do
	local _obj_0 = require('ansikit.style')
	style = _obj_0.style
end
local buildContext
buildContext = function(self)
	local lines
	do
		local _tab_0 = {
			(self.tag and self.tag_type and "in " .. tostring(self.tag_type) .. ": %{magenta}" .. tostring(self.tag) .. "%{reset}" or false),
			(self.section and "in section: %{magenta}" .. tostring(self.section) .. "%{reset}" or false),
			(self.tree and "in tree: %{magenta}" .. tostring(self.tree) .. "%{reset}" or false)
		}
		local _obj_0 = (self.extra or { })
		local _idx_0 = 1
		for _key_0, _value_0 in pairs(_obj_0) do
			if _idx_0 == _key_0 then
				_tab_0[#_tab_0 + 1] = _value_0
				_idx_0 = _idx_0 + 1
			else
				_tab_0[_key_0] = _value_0
			end
		end
		lines = _tab_0
	end
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #lines do
		local a = lines[_index_0]
		if a then
			_accum_0[_len_0] = a
			_len_0 = _len_0 + 1
		end
	end
	return _accum_0
end
_module_0["buildContext"] = buildContext
local errorOut
errorOut = function(msg, context)
	print(style("%{red}!!! " .. tostring(context.source) .. ": " .. tostring(msg)))
	do
		local _
		local _accum_0 = { }
		local _len_0 = 1
		local _list_0 = buildContext(context)
		for _index_0 = 1, #_list_0 do
			local ctx_line = _list_0[_index_0]
			_accum_0[_len_0] = print(style("%{red}      " .. tostring(ctx_line)))
			_len_0 = _len_0 + 1
		end
		_ = _accum_0
	end
	return os.exit(1)
end
_module_0["errorOut"] = errorOut
return _module_0
