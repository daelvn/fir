local _module_0 = { }
local rep, find, match = string.rep, string.find, string.match
local trim
trim = function(input)
	do
		local n = find(input, "%S")
		if n then
			return match(input, ".*%S", n)
		else
			return ""
		end
	end
end
local bkpairs
bkpairs = function(t)
	local a = { }
	for n in pairs(t) do
		table.insert(a, n)
	end
	table.sort(a)
	local i = 0
	local iter
	iter = function()
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end
local emitDescription
emitDescription = function(desc, options)
	if options == nil then
		options = { }
	end
	local md = { }
	if options.headerOffset == nil then
		options.headerOffset = 1
	end
	for _index_0 = 1, #desc do
		local line = desc[_index_0]
		local _exp_0 = line.type
		if "header" == _exp_0 then
			md[#md + 1] = ""
			md[#md + 1] = (rep("#", line.n + options.headerOffset)) .. " " .. line.content[1]
			md[#md + 1] = ""
		elseif "snippet" == _exp_0 then
			if options.tabs.use then
				if md[#md] == "<!-- tabs:end -->" then
					md[#md] = ""
				else
					md[#md + 1] = "<!-- tabs:start -->"
				end
				md[#md + 1] = ""
				md[#md + 1] = tostring(options.tabs.header) .. " " .. tostring(line.title)
				md[#md + 1] = ""
			end
			md[#md + 1] = "```" .. tostring(line.language)
			local _list_0 = line.content
			for _index_1 = 1, #_list_0 do
				local codeline = _list_0[_index_1]
				md[#md + 1] = codeline
			end
			md[#md + 1] = "```"
			if options.tabs.use then
				md[#md + 1] = ""
				md[#md + 1] = "<!-- tabs:end -->"
			end
		elseif "text" == _exp_0 then
			md[#md + 1] = line.content[1]
		end
	end
	return table.concat(md, "\n")
end
_module_0["emitDescription"] = emitDescription
local emitSection
emitSection = function(section, options)
	local md = { }
	if options.tabs == nil then
		options.tabs = {
			use = false
		}
	end
	if options.tabs.header == nil then
		options.tabs.header = "####"
	end
	if options.all == nil then
		options.all = false
	end
	if options.columns == nil then
		options.columns = { }
	end
	if options.types == nil then
		options.types = {
			type = "Types",
			["function"] = "Functions"
		}
	end
	if section.section.tags.internal and not options.all then
		return table.concat(md, "\n")
	end
	if section.section.name then
		md[#md + 1] = "## " .. tostring(section.section.name)
		md[#md + 1] = ""
	end
	if section.section.description then
		md[#md + 1] = emitDescription(section.section.description, {
			headerOffset = 2,
			tabs = options.tabs
		})
	end
	local byis = { }
	for k, v in pairs(section.contents) do
		local _update_0 = v.is
		byis[_update_0] = byis[_update_0] or { }
		byis[v.is][k] = v
	end
	md[#md + 1] = ""
	if options.columns[section.id] then
		md[#md + 1] = "| **" .. tostring(options.columns[section.id][1]) .. "** | " .. tostring(options.columns[section.id][2]) .. " |"
	elseif options.columns["*"] then
		md[#md + 1] = "| " .. tostring(options.columns['*'][1]) .. " | " .. tostring(options.columns['*'][2]) .. " |"
	else
		md[#md + 1] = "| Element | Summary |"
	end
	md[#md + 1] = "|---------|---------|"
	for ty, elems in pairs(byis) do
		md[#md + 1] = "| **" .. tostring(options.types[ty]) .. "** |  |"
		for elemk, elemv in bkpairs(elems) do
			md[#md + 1] = "| [" .. tostring(elemk) .. "](#" .. tostring(elemk) .. ") | " .. tostring(elemv.summary) .. " |"
		end
	end
	md[#md + 1] = ""
	for ty, elems in pairs(byis) do
		for elemk, elemv in bkpairs(elems) do
			local _continue_0 = false
			repeat
				if elemv.tags.internal and not options.all then
					_continue_0 = true
					break
				end
				md[#md + 1] = "### " .. tostring(elemk)
				md[#md + 1] = ""
				if ty == "function" then
					md[#md + 1] = "**Type:** `" .. tostring(trim(elemv.type)) .. "`  "
				end
				if #elemv.name > 1 then
					md[#md + 1] = "**Aliases:** `" .. tostring(table.concat((function()
						local _accum_0 = { }
						local _len_0 = 1
						local _list_0 = elemv.name
						for _index_0 = 2, #_list_0 do
							local n = _list_0[_index_0]
							_accum_0[_len_0] = n
							_len_0 = _len_0 + 1
						end
						return _accum_0
					end)(), ', ')) .. "`"
				end
				if (ty == "function") or (#elemv.name > 1) then
					md[#md + 1] = ""
				end
				md[#md + 1] = elemv.summary
				md[#md + 1] = ""
				md[#md + 1] = emitDescription(elemv.description, {
					headerOffset = 3,
					tabs = options.tabs
				})
				md[#md + 1] = ""
				_continue_0 = true
			until true
			if not _continue_0 then
				break
			end
		end
	end
	return table.concat(md, "\n")
end
_module_0["emitSection"] = emitSection
local emit
emit = function(ast, options)
	if options == nil then
		options = { }
	end
	local md = { }
	if options.tabs == nil then
		options.tabs = {
			use = false
		}
	end
	if options.tabs.header == nil then
		options.tabs.header = "####"
	end
	if options.all == nil then
		options.all = false
	end
	if options.columns == nil then
		options.columns = { }
	end
	if options.types == nil then
		options.types = {
			type = "Types",
			["function"] = "Functions"
		}
	end
	if ast.tags.internal and not options.all then
		return nil, "(internal)"
	end
	if ast.title then
		md[#md + 1] = "# " .. tostring(ast.title)
		md[#md + 1] = ""
	end
	if ast.description then
		md[#md + 1] = emitDescription(ast.description, {
			headerOffset = 1,
			tabs = options.tabs
		})
	end
	for i = 1, #ast do
		md[#md + 1] = emitSection(ast[i], options)
	end
	return table.concat(md, "\n")
end
_module_0["emit"] = emit
return _module_0
