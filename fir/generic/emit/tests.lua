local _module_0 = { }
local rep, find, match
do
	local _obj_0 = string
	rep, find, match = _obj_0.rep, _obj_0.find, _obj_0.match
end
local errorOut, buildContext
do
	local _obj_0 = require('fir.error')
	errorOut, buildContext = _obj_0.errorOut, _obj_0.buildContext
end
local trim
trim = function(input)
	local n = find(input, "%S")
	if n then
		return match(input, ".*%S", n)
	else
		return ""
	end
end
local fromMark
fromMark = function(mark, tag, context)
	if "T" == mark then
		return "is_true"
	elseif "t" == mark then
		return "truthy"
	elseif "F" == mark then
		return "is_false"
	elseif "f" == mark then
		return "falsy"
	elseif "E" == mark then
		return "has_no.errors"
	elseif "e" == mark then
		return "errors"
	elseif "n" == mark then
		return "near"
	elseif "u" == mark then
		return "unique"
	elseif ":" == mark then
		return "matches"
	elseif "=" == mark then
		return "equals"
	elseif "~" == mark then
		return "same"
	elseif "#" == mark then
		if not ("string" == type(tag)) then
			errorOut("No tag specified while trying to use a luassert type assertion", buildContext(context))
		end
		if not ("string" == type(tag)) then
			error("No tag specified while trying to use a luassert type assert")
		end
		return tag
	end
end
local KEYWORDS = {
	"and",
	"break",
	"do",
	"else",
	"elseif",
	"end",
	"false",
	"for",
	"function",
	"goto",
	"if",
	"in",
	"local",
	"nil",
	"not",
	"or",
	"repeat",
	"return",
	"then",
	"true",
	"until",
	"while"
}
local escapeName
escapeName = function(name)
	if name:match("^%d") then
		name = "_" .. name
	end
	for _index_0 = 1, #KEYWORDS do
		local keyword = KEYWORDS[_index_0]
		name = name:gsub(keyword, "_%0")
	end
	local escaped = name:gsub("[^a-zA-Z0-9_]", "_")
	return escaped
end
local emitString
emitString = function(content)
	return "'" .. tostring(content) .. "'"
end
local estring = emitString
local emitParentheses
emitParentheses = function(content)
	return "(" .. tostring(content) .. ")"
end
local eparen = emitParentheses
local emitLocalDeclaration
emitLocalDeclaration = function(name, lhs, options)
	local _exp_0 = options.language
	if 'moon' == _exp_0 then
		return tostring(name) .. " = " .. tostring(lhs)
	elseif 'lua' == _exp_0 then
		return "local " .. tostring(name) .. " = " .. tostring(lhs)
	else
		return "local " .. tostring(name) .. " = " .. tostring(lhs)
	end
end
local elocal = emitLocalDeclaration
local emitTableIndex
emitTableIndex = function(tbl, index)
	return tostring(tbl) .. "[" .. tostring(index) .. "]"
end
local eindex = emitTableIndex
local emitFunctionCall
emitFunctionCall = function(fn, args, options)
	if args == nil then
		args = { }
	end
	local _exp_0 = options.language
	if 'moon' == _exp_0 or 'yue' == _exp_0 then
		return tostring(fn) .. tostring((#args > 0) and (' ' .. table.concat(args, ', ')) or '!')
	elseif 'lua' == _exp_0 then
		return tostring(fn) .. "(" .. tostring(table.concat(args, ', ')) .. ")"
	else
		return tostring(fn) .. "(" .. tostring(table.concat(args, ', ')) .. ")"
	end
end
local efn = emitFunctionCall
local emitInlineFunctionDefinition
emitInlineFunctionDefinition = function(args, body, options)
	local _exp_0 = options.language
	if 'moon' == _exp_0 or 'yue' == _exp_0 then
		return "(" .. tostring(table.concat(args, ', ')) .. ") -> " .. tostring(body)
	elseif 'lua' == _exp_0 then
		return "function(" .. tostring(table.concat(args, ', ')) .. ") " .. tostring(body) .. " end"
	else
		return "function(" .. tostring(table.concat(args, ', ')) .. ") " .. tostring(body) .. " end"
	end
end
local eidef = emitInlineFunctionDefinition
local _anon_func_0 = function(pairs, tbl, tostring)
	local _accum_0 = { }
	local _len_0 = 1
	for rhs, lhs in pairs(tbl) do
		_accum_0[_len_0] = "[" .. tostring(rhs) .. "]: " .. tostring(lhs)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_1 = function(pairs, tbl, tostring)
	local _accum_0 = { }
	local _len_0 = 1
	for rhs, lhs in pairs(tbl) do
		_accum_0[_len_0] = "[" .. tostring(rhs) .. "] = " .. tostring(lhs)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_2 = function(pairs, tbl, tostring)
	local _accum_0 = { }
	local _len_0 = 1
	for rhs, lhs in pairs(tbl) do
		_accum_0[_len_0] = "[" .. tostring(rhs) .. "] = " .. tostring(lhs)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local emitTableLiteral
emitTableLiteral = function(tbl, options)
	local _exp_0 = options.language
	if 'moon' == _exp_0 or 'yue' == _exp_0 then
		return '{' .. (table.concat(_anon_func_0(pairs, tbl, tostring), ', ')) .. '}'
	elseif 'lua' == _exp_0 then
		return '{' .. (table.concat(_anon_func_1(pairs, tbl, tostring), ', ')) .. '}'
	else
		return '{' .. (table.concat(_anon_func_2(pairs, tbl, tostring), ', ')) .. '}'
	end
end
local etable = emitTableLiteral
local _anon_func_3 = function(block, condition, tostring)
	local _tab_0 = {
		"if " .. tostring(condition)
	}
	local _obj_0
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #block do
		local block_line = block[_index_0]
		_accum_0[_len_0] = "  " .. block_line
		_len_0 = _len_0 + 1
	end
	_obj_0 = _accum_0
	local _idx_0 = #_tab_0 + 1
	for _index_0 = 1, #_obj_0 do
		local _value_0 = _obj_0[_index_0]
		_tab_0[_idx_0] = _value_0
		_idx_0 = _idx_0 + 1
	end
	return _tab_0
end
local _anon_func_4 = function(block, condition, tostring)
	local _tab_0 = {
		"if " .. tostring(condition) .. " then"
	}
	local _obj_0
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #block do
		local block_line = block[_index_0]
		_accum_0[_len_0] = "  " .. block_line
		_len_0 = _len_0 + 1
	end
	_obj_0 = _accum_0
	local _idx_0 = #_tab_0 + 1
	for _index_0 = 1, #_obj_0 do
		local _value_0 = _obj_0[_index_0]
		_tab_0[_idx_0] = _value_0
		_idx_0 = _idx_0 + 1
	end
	_tab_0[#_tab_0 + 1] = 'end'
	return _tab_0
end
local _anon_func_5 = function(block, condition, tostring)
	local _tab_0 = {
		"if " .. tostring(condition) .. " then"
	}
	local _obj_0
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #block do
		local block_line = block[_index_0]
		_accum_0[_len_0] = "  " .. block_line
		_len_0 = _len_0 + 1
	end
	_obj_0 = _accum_0
	local _idx_0 = #_tab_0 + 1
	for _index_0 = 1, #_obj_0 do
		local _value_0 = _obj_0[_index_0]
		_tab_0[_idx_0] = _value_0
		_idx_0 = _idx_0 + 1
	end
	_tab_0[#_tab_0 + 1] = 'end'
	return _tab_0
end
local emitIfStatement
emitIfStatement = function(condition, block, options)
	if block == nil then
		block = { }
	end
	local _exp_0 = options.language
	if 'moon' == _exp_0 or 'yue' == _exp_0 then
		return table.concat(_anon_func_3(block, condition, tostring), '\n')
	elseif 'lua' == _exp_0 then
		return table.concat(_anon_func_4(block, condition, tostring), '\n')
	else
		return table.concat(_anon_func_5(block, condition, tostring), '\n')
	end
end
local eif = emitIfStatement
local emitPairsForStatement
emitPairsForStatement = function(k, v, iterator, body, options)
	local _exp_0 = options.language
	if 'moon' == _exp_0 or 'yue' == _exp_0 then
		return "for " .. tostring(k) .. ", " .. tostring(v) .. " in " .. tostring(iterator) .. " do " .. tostring(body)
	elseif 'lua' == _exp_0 then
		return "for " .. tostring(k) .. ", " .. tostring(v) .. " in " .. tostring(iterator) .. " do " .. tostring(body) .. " end"
	else
		return "for " .. tostring(k) .. ", " .. tostring(v) .. " in " .. tostring(iterator) .. " do " .. tostring(body) .. " end"
	end
end
local eforp = emitPairsForStatement
local _anon_func_6 = function(options)
	local _exp_0 = options.language
	if _exp_0 ~= nil then
		return _exp_0
	else
		return 'moon'
	end
end
local emitTestHeader
emitTestHeader = function(node, count, options, append, prepend, placement)
	if not options.testHeaders then
		return count + 1
	end
	append("--- @test " .. tostring(placement) .. "#" .. tostring(count))
	append("--- Test for element " .. tostring(placement) .. " #" .. tostring(count))
	append("-- - **Type:** `" .. tostring(node.type) .. "`" .. tostring((node.type:match('luassert')) and (' (' .. (fromMark(node.mark)) .. ')') or ''))
	if node.tag then
		append("-- - **Tag:** `" .. tostring(node.tag) .. "`")
	end
	append("--:" .. tostring(_anon_func_6(options)) .. " Test")
	append("-- " .. tostring(node.content[1]))
	return count + 1
end
local emitTestWrapper
emitTestWrapper = function(name, count, body, options)
	return table.concat({
		efn("xpcall", {
			eparen((eidef({ }, (table.concat({
				'',
				'  ' .. (eif('FIR_NEXT_PENDING', {
					'  ' .. efn('FIR_PINCR', { }, options),
					'  ' .. 'FIR_NEXT_PENDING = false',
					'  ' .. efn('FIR_PEND', {
						(estring(name)),
						(estring(tostring(count)))
					}, options),
					'  ' .. 'return'
				}, options)),
				'  ' .. body,
				'  ' .. efn("FIR_SUCCEED", {
					(estring(name)),
					(estring(tostring(count)))
				}, options),
				'  ' .. efn("FIR_SINCR", { }, options),
				''
			}, options.newline)), options))),
			eparen((eidef({
				'err'
			}, (table.concat({
				'',
				'  ' .. efn("FIR_FAIL", {
					(estring(name)),
					(estring(tostring(count))),
					'err'
				}, options),
				'  ' .. efn("FIR_FINCR", { }, options),
				''
			}, options.newline)), options)))
		}, options)
	}, options.newline)
end
local ewrap = emitTestWrapper
local emitInternal
emitInternal = function(description, options, append, prepend, placement)
	local ctrim = options.trim and trim or function(x)
		return x
	end
	local count = 1
	local assert_fn = "assert" .. tostring(options.luassert and '.truthy' or '')
	for _index_0 = 1, #description do
		local node = description[_index_0]
		local _exp_0 = node.type
		if "test-configuration" == _exp_0 then
			local _exp_1 = ctrim(node.content[1])
			if "pending" == _exp_1 then
				append("FIR_NEXT_PENDING = true")
			end
		elseif "test" == _exp_0 then
			count = emitTestHeader(node, count, options, append, prepend, placement)
			append(ewrap(tostring(placement) .. "#" .. tostring(count - 1), count - 1, (efn(assert_fn, {
				(ctrim(node.content[1]))
			}, options)), options))
			append("")
		elseif "tagged-test" == _exp_0 then
			count = emitTestHeader(node, count, options, append, prepend, placement)
			append(eif("tags['" .. tostring(ctrim(node.tag)) .. "']", {
				ewrap(tostring(placement) .. "#" .. tostring(count - 1), count - 1, (efn(assert_fn, {
					(ctrim(node.content[1]))
				}, options)), options)
			}, options))
			append("")
		elseif "verbatim-test" == _exp_0 then
			count = emitTestHeader(node, count, options, append, prepend, placement)
			append(ctrim(node.content[1]))
			append("")
		elseif "verbatim-setup" == _exp_0 then
			append(ctrim(node.content[1]))
		elseif "luassert-test" == _exp_0 then
			count = emitTestHeader(node, count, options, append, prepend, placement)
			append(ewrap(tostring(placement) .. "#" .. tostring(count - 1), count - 1, (efn("assert" .. tostring(node.negated and '.not' or '') .. "." .. tostring(fromMark(node.mark)), {
				ctrim(node.content[1])
			}, options)), options))
			append("")
		elseif "tagged-luassert-test" == _exp_0 then
			count = emitTestHeader(node, count, options, append, prepend, placement)
			if node.mark == "#" then
				append(ewrap(tostring(placement) .. "#" .. tostring(count - 1), count - 1, (efn("assert" .. tostring(node.negated and '.not' or '') .. "." .. tostring(fromMark(node.mark, node.tag)), {
					ctrim(node.content[1])
				}, options)), options))
			else
				append(eif((eindex('tags', ctrim(node.tag))), {
					(ewrap(tostring(placement) .. "#" .. tostring(count - 1), count - 1, (efn("assert" .. tostring(node.negated and '.not' or '') .. "." .. tostring(fromMark(node.mark, node.tag)), {
						ctrim(node.content[1])
					}, options)), options))
				}, options))
			end
			append("")
		end
	end
end
local _anon_func_7 = function(efn, estring, options, tostring)
	local _exp_0 = options.print
	if false == _exp_0 or 'plain' == _exp_0 or 'pretty' == _exp_0 then
		return ''
	elseif 'tap' == _exp_0 then
		return efn('print', {
			tostring(estring('ok ')) .. " .. count .. ' - ' .. current"
		}, options)
	elseif 'plain-verbose' == _exp_0 then
		return efn('print', {
			tostring(estring("Success → ")) .. " .. current"
		}, options)
	elseif 'pretty-verbose' == _exp_0 then
		return efn('print', {
			efn('S.style', {
				tostring(estring("%{green}Success%{reset} → ")) .. " .. current"
			}, options)
		}, options)
	end
end
local _anon_func_8 = function(efn, eparen, estring, options, tostring)
	local _exp_0 = options.print
	if false == _exp_0 then
		return ''
	elseif 'tap' == _exp_0 then
		return efn('print', {
			tostring(estring('not ok ')) .. " .. count .. ' - ' .. current .. ': ' .. " .. tostring(eparen((efn('string.gsub', {
				'err',
				(estring('[\\r\\n]+')),
				(estring(''))
			}, options))))
		}, options)
	elseif 'plain' == _exp_0 or 'plain-verbose' == _exp_0 then
		return efn('print', {
			tostring(estring("Failure → ")) .. " .. current .. " .. tostring(estring("\\n  ")) .. " .. err"
		}, options)
	elseif 'pretty' == _exp_0 or 'pretty-verbose' == _exp_0 then
		return efn('print', {
			efn('S.style', {
				tostring(estring("%{red}Failure%{reset} → ")) .. " .. current .. " .. tostring(estring("\\n  %{white}")) .. " .. err"
			}, options)
		}, options)
	end
end
local _anon_func_9 = function(efn, estring, options, tostring)
	local _exp_0 = options.print
	if false == _exp_0 then
		return ''
	elseif 'tap' == _exp_0 then
		return efn('print', {
			tostring(estring('not ok ')) .. " .. count .. ' - ' .. current .. ' # SKIP'"
		}, options)
	elseif 'plain' == _exp_0 or 'plain-verbose' == _exp_0 then
		return efn('print', {
			tostring(estring("Pending → ")) .. " .. current"
		}, options)
	elseif 'pretty' == _exp_0 or 'pretty-verbose' == _exp_0 then
		return efn('print', {
			efn('S.style', {
				tostring(estring("%{yellow}Pending%{reset} → ")) .. " .. current"
			}, options)
		}, options)
	end
end
local _anon_func_10 = function(efn, elocal, estring, options, table, tostring)
	local _exp_0 = options.print
	if false == _exp_0 or 'tap' == _exp_0 then
		return ''
	elseif 'plain' == _exp_0 or 'plain-verbose' == _exp_0 then
		return table.concat({
			'',
			'  ' .. (elocal('total_successes', ((efn('string.rep', {
				(estring('+')),
				'FIR_SUCCESSES'
			}, options))), options)),
			'  ' .. (elocal('total_pendings', ((efn('string.rep', {
				(estring('?')),
				'FIR_PENDINGS'
			}, options))), options)),
			'  ' .. (elocal('total_failures', ((efn('string.rep', {
				(estring('-')),
				'FIR_FAILURES'
			}, options))), options)),
			'  ' .. efn('print', { }, options),
			'  ' .. efn('print', {
				"total_successes .. total_pendings .. total_failures"
			}, options),
			'  ' .. efn('print', {
				tostring(estring('%{green}')) .. " .. FIR_SUCCESSES .. " .. tostring(estring('%{white} successes, %{yellow}')) .. " .. FIR_PENDINGS .. " .. tostring(estring('%{white} pending, %{red}')) .. " .. FIR_FAILURES .. " .. tostring(estring('%{white} errors.'))
			}, options),
			''
		}, '\n')
	elseif 'pretty' == _exp_0 or 'pretty-verbose' == _exp_0 then
		return table.concat({
			'',
			'  ' .. (elocal('total_successes', (efn('S.style', {
				tostring(estring("%{green}")) .. " .. " .. (efn('string.rep', {
					(estring('+')),
					'FIR_SUCCESSES'
				}, options))
			}, options)), options)),
			'  ' .. (elocal('total_pendings', (efn('S.style', {
				tostring(estring("%{yellow}")) .. " .. " .. (efn('string.rep', {
					(estring('?')),
					'FIR_PENDINGS'
				}, options))
			}, options)), options)),
			'  ' .. (elocal('total_failures', (efn('S.style', {
				tostring(estring("%{red}")) .. " .. " .. (efn('string.rep', {
					(estring('-')),
					'FIR_FAILURES'
				}, options))
			}, options)), options)),
			'  ' .. efn('print', { }, options),
			'  ' .. efn('print', {
				"total_successes .. total_pendings .. total_failures"
			}, options),
			'  ' .. efn('print', {
				efn('S.style', {
					tostring(estring('%{green}')) .. " .. FIR_SUCCESSES .. " .. tostring(estring('%{white} successes, %{yellow}')) .. " .. FIR_PENDINGS .. " .. tostring(estring('%{white} pending, %{red}')) .. " .. FIR_FAILURES .. " .. tostring(estring('%{white} errors.'))
				}, options)
			}, options),
			''
		}, '\n')
	end
end
local emit
emit = function(ast, options)
	if options == nil then
		options = { }
	end
	local module = options.module or ast.title or errorOut("Could not generate tests. Module name not found. Please set %{green}`options.module`%{red}.", {
		source = 'emit.tests'
	})
	local lua = {
		"---# Tests for " .. tostring(module) .. " #---",
		"-- This test suite was automatically generated from documentation comments,",
		"-- the tests are embedded in the code itself. Do not edit this file.",
		tostring(options.header or '')
	}
	local clength = 4
	local append
	append = function(x)
		if (not options.docs) and x:match("^%-%-") then
			return
		end
		lua[#lua + 1] = tostring(x)
	end
	local prepend
	prepend = function(x, offset)
		if offset == nil then
			offset = 0
		end
		if (not options.docs) and x:match("^%-%-") then
			return
		end
		table.insert(lua, clength + offset, tostring(x))
		clength = clength + 1
	end
	if options.trim == nil then
		options.trim = true
	end
	if options.newline == nil then
		options.newline = "\n"
	end
	if options.luassert == nil then
		options.luassert = true
	end
	if options.print == nil then
		options.print = 'pretty'
	end
	if options.testHeaders == nil then
		options.testHeaders = true
	end
	if options.docs == nil then
		options.docs = true
	end
	if options.language == nil then
		options.language = 'moon'
	end
	if options.auto_unpack == nil then
		options.auto_unpack = false
	end
	if options.luassert then
		prepend(elocal('assert', (efn('require', {
			estring('luassert')
		}, options)), options))
	end
	if (options.print == 'pretty') or (options.print == 'pretty-verbose') then
		prepend(elocal('S', (efn('require', {
			estring('ansikit.style')
		}, options)), options))
	end
	prepend(elocal('M', (efn('require', {
		estring(module)
	}, options)), options))
	if options.auto_unpack then
		prepend(efn('setmetatable', {
			'_ENV',
			(etable({
				[estring('__index')] = 'M'
			}, options))
		}, options))
	end
	if options.unpack then
		prepend("")
		prepend("--///--")
		prepend("-- unpack")
		local _list_0 = options.unpack
		for _index_0 = 1, #_list_0 do
			local name = _list_0[_index_0]
			prepend(elocal((escapeName(name)), (eindex('M', estring(name))), options))
		end
		prepend("--///--")
	end
	if options.snippet then
		prepend("")
		prepend(options.snippet)
	end
	prepend("")
	prepend("--///--")
	prepend("-- argument and tag initialization")
	prepend(elocal("args, tags", "{...}, {}", options))
	if options.all then
		prepend(efn('setmetatable', {
			'tags',
			(etable({
				[estring('__index')] = (eidef({ }, 'return true', options))
			}, options))
		}, options))
	end
	prepend(eforp('_', 'v', (efn('ipairs', {
		'args'
	}, options)), 'tags[v] = true', options))
	prepend("--///--")
	local pre_count = 0
	local _list_0 = ast.description
	for _index_0 = 1, #_list_0 do
		local node = _list_0[_index_0]
		local _exp_0 = node.type
		if "test" == _exp_0 or "tagged-test" == _exp_0 or "verbatim-test" == _exp_0 or "luassert-test" == _exp_0 or "tagged-luassert-test" == _exp_0 then
			pre_count = pre_count + 1
		end
	end
	for _index_0 = 1, #ast do
		local section = ast[_index_0]
		local _list_1 = section.section.description
		for _index_1 = 1, #_list_1 do
			local node = _list_1[_index_1]
			local _exp_0 = node.type
			if "test" == _exp_0 or "tagged-test" == _exp_0 or "verbatim-test" == _exp_0 or "luassert-test" == _exp_0 or "tagged-luassert-test" == _exp_0 then
				pre_count = pre_count + 1
			end
		end
		for name, element in pairs(section.contents) do
			local _list_2 = element.description
			for _index_1 = 1, #_list_2 do
				local node = _list_2[_index_1]
				local _exp_0 = node.type
				if "test" == _exp_0 or "tagged-test" == _exp_0 or "verbatim-test" == _exp_0 or "luassert-test" == _exp_0 or "tagged-luassert-test" == _exp_0 then
					pre_count = pre_count + 1
				end
			end
		end
	end
	if options.print == 'tap' then
		prepend(efn('print', {
			estring("TAP version 14")
		}, options))
		prepend(efn('print', {
			estring("1.." .. tostring(pre_count))
		}, options))
	end
	prepend("--///--")
	prepend("-- counters")
	prepend(elocal("FIR_SUCCESSES, FIR_FAILURES, FIR_PENDINGS", "0, 0, 0", options))
	prepend("-- incrementing functions")
	prepend(elocal("FIR_SINCR, FIR_FINCR, FIR_PINCR", (table.concat({
		"(" .. (eidef({ }, 'FIR_SUCCESSES = FIR_SUCCESSES + 1', options)) .. ")",
		"(" .. (eidef({ }, 'FIR_FAILURES = FIR_FAILURES + 1', options)) .. ")",
		"(" .. (eidef({ }, 'FIR_PENDINGS = FIR_PENDINGS + 1', options)) .. ")"
	}, ", ")), options))
	prepend("-- other functions")
	prepend(elocal("FIR_SUCCEED", (eidef({
		'current',
		'count'
	}, (_anon_func_7(efn, estring, options, tostring)), options)), options))
	prepend(elocal("FIR_FAIL", (eidef({
		'current',
		'count',
		'err'
	}, (_anon_func_8(efn, eparen, estring, options, tostring)), options)), options))
	prepend(elocal("FIR_PEND", (eidef({
		'current',
		'count'
	}, (_anon_func_9(efn, estring, options, tostring)), options)), options))
	prepend(elocal("FIR_RESULT", (eidef({
		'current'
	}, (_anon_func_10(efn, elocal, estring, options, table, tostring)), options)), options))
	prepend("-- marker for pending tests")
	prepend(elocal("FIR_NEXT_PENDING", "false", options))
	prepend("--///--")
	if ast.description then
		append("--# " .. tostring(options.subheader or 'General') .. " #--")
		append("-- Tests for the whole file are placed here.")
		append("")
		emitInternal(ast.description, options, append, prepend, ast.title)
	end
	for _index_0 = 1, #ast do
		local section = ast[_index_0]
		append("--# " .. tostring(section.section.name) .. " #--")
		append("-- Tests for " .. tostring(section.section.name) .. ".")
		append("")
		emitInternal(section.section.description, options, append, prepend, section.section.name)
		for name, element in pairs(section.contents) do
			append("--# `" .. tostring(name) .. "`")
			append("")
			emitInternal(element.description, options, append, prepend, name)
		end
	end
	append(efn('FIR_RESULT', { }, options))
	return table.concat(lua, "\n")
end
_module_0["emit"] = emit
return _module_0
