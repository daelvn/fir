local _module_0 = { }
local rep, find, match
do
	local _obj_0 = string
	rep, find, match = _obj_0.rep, _obj_0.find, _obj_0.match
end
local Pcre = require("rex_pcre2")
local trim
trim = function(input)
	local n = find(input, "%S")
	if n then
		return match(input, ".*%S", n)
	else
		return ""
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
local replaceSymbols
replaceSymbols = function(str, symbols, no_backtick)
	if no_backtick == nil then
		no_backtick = false
	end
	return Pcre.gsub(str, "(`[^`]*?`)|@@@(.+?)@@@", function(in_b, sym)
		return in_b or (symbols[sym] and "[" .. tostring(no_backtick and "" or "`") .. tostring(sym) .. tostring(no_backtick and "" or "`") .. "](" .. tostring(symbols[sym]) .. ")" or tostring(no_backtick and "" or "`") .. tostring(sym) .. tostring(no_backtick and "" or "`"))
	end)
end
_module_0["replaceSymbols"] = replaceSymbols
local replaceNewlines
replaceNewlines = function(str)
	return str:gsub("\n", "<br/>")
end
local newlinesIntoParagraphs
newlinesIntoParagraphs = function(str)
	return str:gsub("\n", "\n\n")
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
			md[#md + 1] = (rep("#", line.n + options.headerOffset)) .. " " .. replaceSymbols(line.content[1], options.symbols)
			md[#md + 1] = ""
		elseif "snippet" == _exp_0 then
			if options.tabs.use == 'docsify' then
				if md[#md] == "<!-- tabs:end -->" then
					md[#md] = ""
				else
					md[#md + 1] = "<!-- tabs:start -->"
				end
				md[#md + 1] = ""
				md[#md + 1] = tostring(options.tabs.docsify_header) .. " " .. tostring(line.title)
				md[#md + 1] = ""
			elseif options.tabs.use == 'pymdownx' then
				md[#md + 1] = ""
				md[#md + 1] = "=== \"" .. tostring(line.title) .. "\""
				md[#md + 1] = ""
			end
			md[#md + 1] = tostring(options.tabs.use == 'pymdownx' and '    ' or '') .. "```" .. tostring(line.language)
			local _list_0 = line.content
			for _index_1 = 1, #_list_0 do
				local codeline = _list_0[_index_1]
				md[#md + 1] = (options.tabs.use == 'pymdownx' and '    ' or '') .. codeline
			end
			md[#md + 1] = tostring(options.tabs.use == 'pymdownx' and '    ' or '') .. "```"
			if options.tabs.use == 'docsify' then
				md[#md + 1] = ""
				md[#md + 1] = "<!-- tabs:end -->"
			elseif options.tabs.use == 'pymdownx' then
				md[#md + 1] = ""
			end
		elseif "text" == _exp_0 then
			md[#md + 1] = replaceSymbols(line.content[1], options.symbols)
		end
	end
	return table.concat(md, "\n")
end
_module_0["emitDescription"] = emitDescription
local _anon_func_0 = function(elemv)
	local _obj_0 = elemv.tags
	if _obj_0 ~= nil then
		return _obj_0.internal
	end
	return nil
end
local _anon_func_1 = function(elemv)
	local _obj_0 = elemv.tags
	if _obj_0 ~= nil then
		return _obj_0.internal
	end
	return nil
end
local _anon_func_2 = function(elemv)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = elemv.name
	for _index_0 = 2, #_list_0 do
		local n = _list_0[_index_0]
		_accum_0[_len_0] = n
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local emitSection
emitSection = function(section, options)
	local md = { }
	if options.tabs == nil then
		options.tabs = {
			use = false
		}
	end
	local _obj_0 = options.tabs
	if _obj_0.docsify_header == nil then
		_obj_0.docsify_header = "####"
	end
	if options.all == nil then
		options.all = false
	end
	if options.columns == nil then
		options.columns = { }
	end
	if options.symbols == nil then
		options.symbols = { }
	end
	if options.inline_type == nil then
		options.inline_type = false
	end
	if options.types == nil then
		options.types = {
			type = "Types",
			["function"] = "Functions",
			constant = "Constants",
			class = "Classes",
			test = "Tests",
			table = "Tables",
			field = "Fields",
			variable = "Variables"
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
			tabs = options.tabs,
			symbols = options.symbols
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
			if not (_anon_func_0(elemv) and not options.all) then
				md[#md + 1] = "| [" .. tostring(elemk) .. "](#" .. tostring(elemk) .. ") | " .. tostring(replaceNewlines(replaceSymbols(elemv.summary, options.symbols))) .. " |"
			end
		end
	end
	md[#md + 1] = ""
	for ty, elems in pairs(byis) do
		for elemk, elemv in bkpairs(elems) do
			if _anon_func_1(elemv) and not options.all then
				goto _continue_0
			end
			local has_type = (ty == 'function') or (ty == 'constant') or (ty == 'field') or (ty == 'variable')
			if options.inline_type then
				md[#md + 1] = "<div markdown class='fir-symbol fancy-scrollbar'>"
			end
			md[#md + 1] = "### " .. tostring(options.inline_type and "<strong>" .. tostring(elemk) .. "</strong>&nbsp;" or elemk)
			if has_type and options.inline_type then
				md[#md + 1] = "<span class='annotate'>:: " .. tostring(replaceSymbols((trim(elemv.type)), options.symbols, true)) .. "</span>"
			end
			if options.inline_type then
				md[#md + 1] = "</div>"
			end
			md[#md + 1] = ""
			if has_type and not options.inline_type then
				md[#md + 1] = "**Type:** `" .. tostring(trim(elemv.type)) .. "`{ .annotate }  "
			end
			if #elemv.name > 1 then
				md[#md + 1] = "**Aliases:** `" .. tostring(table.concat(_anon_func_2(elemv), ', ')) .. "`"
			end
			if (ty == "function") or (ty == "constant") or (ty == "field") or (ty == "variable") or (#elemv.name > 1) then
				md[#md + 1] = ""
			end
			md[#md + 1] = newlinesIntoParagraphs(replaceSymbols(elemv.summary, options.symbols))
			md[#md + 1] = ""
			md[#md + 1] = emitDescription(elemv.description, {
				headerOffset = 3,
				tabs = options.tabs,
				symbols = options.symbols
			})
			md[#md + 1] = ""
			::_continue_0::
		end
	end
	return table.concat(md, "\n")
end
_module_0["emitSection"] = emitSection
local listAllSymbols
listAllSymbols = function(ast, options)
	if options == nil then
		options = { }
	end
	local base = options.module or ast.title
	local prefix = (options.url_prefix or '/') .. base:gsub("%.", '/')
	local prefix_parts
	do
		local _accum_0 = { }
		local _len_0 = 1
		for part in base:gmatch("[^%.]+") do
			_accum_0[_len_0] = part
			_len_0 = _len_0 + 1
		end
		prefix_parts = _accum_0
	end
	local symbols = { }
	for i = 1, #ast do
		local section = ast[i]
		for symbol_key, symbol_value in pairs(section.contents) do
			local _list_0 = symbol_value.name
			for _index_0 = 1, #_list_0 do
				local symbol_name = _list_0[_index_0]
				symbols[symbol_name] = tostring(prefix) .. "#" .. tostring(symbol_key)
				symbols[tostring(prefix_parts[#prefix_parts]) .. "." .. tostring(symbol_name)] = tostring(prefix) .. "#" .. tostring(symbol_key)
			end
		end
	end
	return symbols
end
_module_0["listAllSymbols"] = listAllSymbols
local _anon_func_3 = function(ast)
	local _obj_0 = ast.tags
	if _obj_0 ~= nil then
		return _obj_0.internal
	end
	return nil
end
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
	local _obj_0 = options.tabs
	if _obj_0.docsify_header == nil then
		_obj_0.docsify_header = "####"
	end
	if options.all == nil then
		options.all = false
	end
	if options.columns == nil then
		options.columns = { }
	end
	if options.symbols == nil then
		options.symbols = { }
	end
	if options.symbols_in_code == nil then
		options.symbols_in_code = false
	end
	if options.types == nil then
		options.types = {
			type = "Types",
			["function"] = "Functions",
			constant = "Constants",
			class = "Classes",
			test = "Tests",
			table = "Tables",
			field = "Fields",
			variable = "Variables"
		}
	end
	if _anon_func_3(ast) and not options.all then
		return nil, "(internal)"
	end
	if ast.title then
		md[#md + 1] = "# " .. tostring(ast.title)
		md[#md + 1] = ""
	end
	if ast.description then
		md[#md + 1] = emitDescription(ast.description, {
			headerOffset = 1,
			tabs = options.tabs,
			symbols = options.symbols
		})
	end
	for i = 1, #ast do
		md[#md + 1] = emitSection(ast[i], options)
	end
	return table.concat(md, "\n")
end
_module_0["emit"] = emit
return _module_0
