local _module_0 = { }
local match, find, gsub, sub
do
	local _obj_0 = string
	match, find, gsub, sub = _obj_0.match, _obj_0.find, _obj_0.gsub, _obj_0.sub
end
local errorOut
do
	local _obj_0 = require('fir.error')
	errorOut = _obj_0.errorOut
end
local sanitize
sanitize = function(input)
	if "string" == type(input) then
		return input:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
	end
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
local parseDescription
parseDescription = function(desc)
	local incode = false
	local ndesc, code, tags = { }, { }, { }
	for _index_0 = 1, #desc do
		local line = desc[_index_0]
		if line == ":" then
			if incode then
				ndesc[#ndesc + 1] = code
			end
			incode = false
		elseif incode then
			local _obj_0 = code.content
			_obj_0[#_obj_0 + 1] = sub(line, 2)
		else
			local tag = match(line, "^%s-@(%w+)(.-)")
			if tag then
				local value
				tag, value = match(line, "^%s-@(%w+)(.-)")
				tags[tag] = (value == "") and true or value
			else
				local header = match(line, "^###%s+(.+)")
				if header then
					ndesc[#ndesc + 1] = {
						content = {
							trim(header)
						},
						type = "header",
						n = 3
					}
				else
					header = match(line, "^##%s+(.+)")
					if header then
						ndesc[#ndesc + 1] = {
							content = {
								trim(header)
							},
							type = "header",
							n = 2
						}
					else
						header = match(line, "^#%s+(.+)")
						if header then
							ndesc[#ndesc + 1] = {
								content = {
									trim(header)
								},
								type = "header",
								n = 1
							}
						else
							local headern = match(line, "^(%d)%s+(.+)")
							if headern then
								local n
								header, n = match(line, "^(%d)%s+(.+)")
								ndesc[#ndesc + 1] = {
									content = {
										trim(header)
									},
									type = "header",
									n = n
								}
							elseif match(line, "%s-%?(%^?)([TtFfenu:=~])%s-(.-)%s-:%s-(.+)") then
								local neg, mark
								neg, mark, tag, line = match(line, "%s-%?(%^?)([TtFfenu:=~])%s-(.-)%s-:%s-(.+)")
								ndesc[#ndesc + 1] = {
									content = {
										line
									},
									tag = tag,
									mark = mark,
									negated = (neg ~= ""),
									type = "tagged-luassert-test"
								}
							elseif match(line, "%s-%?(%^?)([TtFfenu:=~])%s-(.+)") then
								local neg, mark
								neg, mark, line = match(line, "%s-%?(%^?)([TtFfenu:=~])%s-(.+)")
								ndesc[#ndesc + 1] = {
									content = {
										line
									},
									mark = mark,
									negated = (neg ~= ""),
									type = "luassert-test"
								}
							else
								local taggedt = match(line, "^%s-%?%?%s-(.-)%s-:%s-(.+)")
								if taggedt then
									tag, line = match(line, "^%s-%?%?%s-(.-)%s-:%s-(.+)")
									ndesc[#ndesc + 1] = {
										content = {
											line
										},
										tag = tag,
										type = "tagged-test"
									}
								elseif match(line, "%s-%?%$%s-(.+)") then
									line = match(line, "%s-%?%$%s-(.+)")
									ndesc[#ndesc + 1] = {
										content = {
											line
										},
										type = "test-configuration"
									}
								elseif match(line, "%s-%?%?%s-(.+)") then
									line = match(line, "%s-%?%?%s-(.+)")
									ndesc[#ndesc + 1] = {
										content = {
											line
										},
										type = "test"
									}
								else
									local verbatimt = match(line, "%s-%?!%s+(.+)")
									if verbatimt then
										ndesc[#ndesc + 1] = {
											content = {
												verbatimt
											},
											type = "verbatim-test"
										}
									else
										local verbatims = match(line, "%s-!!%s+(.+)")
										if verbatims then
											ndesc[#ndesc + 1] = {
												content = {
													verbatims
												},
												type = "verbatim-setup"
											}
										else
											local snippet = match(line, "^:(%w+)%s+(.+)")
											if snippet then
												if incode then
													ndesc[#ndesc + 1] = code
												end
												local language, title = match(line, "^:(%w+)%s+(.+)")
												code = {
													language = language,
													title = title,
													content = { },
													type = "snippet"
												}
												incode = true
											else
												ndesc[#ndesc + 1] = {
													type = "text",
													content = {
														line:match(" ?(.+)")
													}
												}
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if incode then
		ndesc[#ndesc + 1] = code
	end
	return ndesc, tags
end
local determineSummaryBoundary
determineSummaryBoundary = function(content, lead)
	for i = 1, #content do
		local line = content[i]
		if line:match("^" .. tostring(lead) .. "%s+") then
			goto _continue_0
		else
			return i + 1
		end
		::_continue_0::
	end
	return #content
end
_module_0["determineSummaryBoundary"] = determineSummaryBoundary
local _anon_func_0 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 2, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_1 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 2, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_2 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@function'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_3 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_4 = function(comment, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = summary_boundary, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_5 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@type'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_6 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_7 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 3, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_8 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@class'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_9 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_10 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 3, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_11 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@constant'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_12 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_13 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 3, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_14 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@test'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_15 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_16 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 3, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_17 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@table'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_18 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_19 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 3, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_20 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@field'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_21 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_22 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 3, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_23 = function(context, main, pairs)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(context) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0.tag_type = '@variable'
	_tab_0.tag = main
	return _tab_0
end
local _anon_func_24 = function(comment, stripLead, summary_boundary)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	local _max_0 = summary_boundary
	for _index_0 = 2, _max_0 < 0 and #_list_0 + _max_0 or _max_0 do
		local comm = _list_0[_index_0]
		_accum_0[_len_0] = stripLead(comm)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_25 = function(comment)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = comment.content
	for _index_0 = 3, #_list_0 do
		local l = _list_0[_index_0]
		_accum_0[_len_0] = l
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local parse
parse = function(comments, language)
	local ast = { }
	local lead = sanitize(sub(language.single, -1))
	local tracking = {
		editing = false,
		section = {
			id = 0,
			name = ""
		}
	}
	local context = {
		source = 'parser'
	}
	local stripLead
	stripLead = function(str)
		return match((str or ""), "^" .. tostring(lead) .. "+%s+(.+)")
	end
	for _index_0 = 1, #comments do
		local comment = comments[_index_0]
		local heading = comment.content[1]
		local summary_boundary = determineSummaryBoundary(comment.content, lead)
		local title = match(heading, "^" .. tostring(lead) .. "#(.+)#" .. tostring(lead) .. ".+")
		if title then
			tracking.editing = "title"
			ast.title = trim(title)
			ast.description, ast.tags = parseDescription(_anon_func_0(comment))
			local _tab_0 = { }
			local _idx_0 = 1
			for _key_0, _value_0 in pairs(context) do
				if _idx_0 == _key_0 then
					_tab_0[#_tab_0 + 1] = _value_0
					_idx_0 = _idx_0 + 1
				else
					_tab_0[_key_0] = _value_0
				end
			end
			_tab_0.tree = ast.title
			context = _tab_0
		else
			local section = match(heading, "^#(.+)#.+")
			if section then
				tracking.editing = "section"
				tracking.section = {
					id = tracking.section.id + 1,
					name = trim(section)
				}
				tracking.section.description, tracking.section.tags = parseDescription(_anon_func_1(comment))
				ast[tracking.section.id] = {
					section = tracking.section,
					contents = { }
				}
			else
				local fn = match(heading, "^" .. tostring(lead) .. "%s+@function%s+(.+)%s+::(.+)")
				if fn then
					local typ
					fn, typ = match(heading, "^" .. tostring(lead) .. "%s+@function%s+(.+)%s+::(.+)")
					local names
					do
						local _accum_0 = { }
						local _len_0 = 1
						for name in fn:gmatch("%S+") do
							_accum_0[_len_0] = name
							_len_0 = _len_0 + 1
						end
						names = _accum_0
					end
					local main = names[1]
					if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
						errorOut("Functions must be contained within a section.", _anon_func_2(context, main, pairs))
					end
					ast[tracking.section.id].contents[main] = {
						is = "function",
						name = names,
						type = typ,
						summary = table.concat(_anon_func_3(comment, stripLead, summary_boundary), '\n')
					}
					ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_4(comment, summary_boundary))
				else
					local typ = match(heading, "^" .. tostring(lead) .. "%s+@type%s+(.+)")
					if typ then
						local names
						do
							local _accum_0 = { }
							local _len_0 = 1
							for name in typ:gmatch("%S+") do
								_accum_0[_len_0] = name
								_len_0 = _len_0 + 1
							end
							names = _accum_0
						end
						local main = names[1]
						if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
							errorOut("Types must be contained within a section.", _anon_func_5(context, main, pairs))
						end
						ast[tracking.section.id].contents[main] = {
							is = "type",
							name = names,
							summary = table.concat(_anon_func_6(comment, stripLead, summary_boundary), '\n')
						}
						ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_7(comment))
					else
						local cls = match(heading, "^" .. tostring(lead) .. "%s+@class%s+(.+)")
						if cls then
							local names
							do
								local _accum_0 = { }
								local _len_0 = 1
								for name in cls:gmatch("%S+") do
									_accum_0[_len_0] = name
									_len_0 = _len_0 + 1
								end
								names = _accum_0
							end
							local main = names[1]
							if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
								errorOut("Classes must be contained within a section.", _anon_func_8(context, main, pairs))
							end
							ast[tracking.section.id].contents[main] = {
								is = "class",
								name = names,
								summary = table.concat(_anon_func_9(comment, stripLead, summary_boundary), '\n')
							}
							ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_10(comment))
						else
							local cst = match(heading, "^" .. tostring(lead) .. "%s+@consta?n?t?%s+(.+)%s+::(.+)")
							if cst then
								cst, typ = match(heading, "^" .. tostring(lead) .. "%s+@consta?n?t?%s+(.+)%s+::(.+)")
								local names
								do
									local _accum_0 = { }
									local _len_0 = 1
									for name in cst:gmatch("%S+") do
										_accum_0[_len_0] = name
										_len_0 = _len_0 + 1
									end
									names = _accum_0
								end
								local main = names[1]
								if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
									errorOut("Constants must be contained within a section.", _anon_func_11(context, main, pairs))
								end
								ast[tracking.section.id].contents[main] = {
									is = "constant",
									name = names,
									type = typ,
									summary = table.concat(_anon_func_12(comment, stripLead, summary_boundary), '\n')
								}
								ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_13(comment))
							else
								local test = match(heading, "^" .. tostring(lead) .. "%s+@test%s+(.+)")
								if test then
									local names
									do
										local _accum_0 = { }
										local _len_0 = 1
										for name in test:gmatch("%S+") do
											_accum_0[_len_0] = name
											_len_0 = _len_0 + 1
										end
										names = _accum_0
									end
									local main = names[1]
									if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
										errorOut("Tests must be contained within a section.", _anon_func_14(context, main, pairs))
									end
									ast[tracking.section.id].contents[main] = {
										is = "test",
										name = names,
										summary = table.concat(_anon_func_15(comment, stripLead, summary_boundary), '\n')
									}
									ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_16(comment))
								else
									local tbl = match(heading, "^" .. tostring(lead) .. "%s+@table%s+(.+)")
									if tbl then
										local names
										do
											local _accum_0 = { }
											local _len_0 = 1
											for name in tbl:gmatch("%S+") do
												_accum_0[_len_0] = name
												_len_0 = _len_0 + 1
											end
											names = _accum_0
										end
										local main = names[1]
										if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
											errorOut("Tables must be contained within a section.", _anon_func_17(context, main, pairs))
										end
										ast[tracking.section.id].contents[main] = {
											is = "table",
											name = names,
											summary = table.concat(_anon_func_18(comment, stripLead, summary_boundary), '\n')
										}
										ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_19(comment))
									else
										local field = match(heading, "^" .. tostring(lead) .. "%s+@field%s+(.+)%s+::(.+)")
										if field then
											local fld
											fld, typ = match(heading, "^" .. tostring(lead) .. "%s+@field%s+(.+)%s+::(.+)")
											local names
											do
												local _accum_0 = { }
												local _len_0 = 1
												for name in fld:gmatch("%S+") do
													_accum_0[_len_0] = name
													_len_0 = _len_0 + 1
												end
												names = _accum_0
											end
											local main = names[1]
											if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
												errorOut("Fields must be contained within a section.", _anon_func_20(context, main, pairs))
											end
											ast[tracking.section.id].contents[main] = {
												is = "field",
												name = names,
												type = typ,
												summary = table.concat(_anon_func_21(comment, stripLead, summary_boundary), '\n')
											}
											ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_22(comment))
										else
											local var = match(heading, "^" .. tostring(lead) .. "%s+@vari?a?b?l?e?%s+(.+)%s+::(.+)")
											if var then
												var, typ = match(heading, "^" .. tostring(lead) .. "%s+@vari?a?b?l?e?%s+(.+)%s+::(.+)")
												local names
												do
													local _accum_0 = { }
													local _len_0 = 1
													for name in var:gmatch("%S+") do
														_accum_0[_len_0] = name
														_len_0 = _len_0 + 1
													end
													names = _accum_0
												end
												local main = names[1]
												if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
													errorOut("Variables must be contained within a section.", _anon_func_23(context, main, pairs))
												end
												ast[tracking.section.id].contents[main] = {
													is = "variable",
													name = names,
													type = typ,
													summary = table.concat(_anon_func_24(comment, stripLead, summary_boundary), '\n')
												}
												ast[tracking.section.id].contents[main].description, ast[tracking.section.id].contents[main].tags = parseDescription(_anon_func_25(comment))
											else
												local _exp_0 = tracking.editing
												if "title" == _exp_0 then
													ast.description[#ast.description + 1] = {
														type = "text",
														content = {
															""
														}
													}
													local _list_0 = (parseDescription(comment.content))
													for _index_1 = 1, #_list_0 do
														local l = _list_0[_index_1]
														ast.description[#ast.description + 1] = l
													end
												elseif "section" == _exp_0 then
													tracking.section.description[#tracking.section.description + 1] = {
														type = "text",
														content = {
															""
														}
													}
													local _list_0 = (parseDescription(comment.content))
													for _index_1 = 1, #_list_0 do
														local l = _list_0[_index_1]
														tracking.section.description[#tracking.section.description + 1] = l
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return ast
end
_module_0["parse"] = parse
return _module_0
