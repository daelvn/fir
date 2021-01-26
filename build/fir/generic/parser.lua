local _module_0 = { }
local match, find, gsub, sub = string.match, string.find, string.gsub, string.sub
local sanitize
sanitize = function(input)
	if "string" == type(input) then
		return input:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
	end
end
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
			code.content[#code.content + 1] = sub(line, 2)
		else
			do
				local tag = match(line, "^%s-@(%w+)(.-)")
				if tag then
					local value
					tag, value = match(line, "^%s-@(%w+)(.-)")
					tags[tag] = (value == "") and true or value
				else
					do
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
									do
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
										else
											do
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
												elseif match(line, "%s-%?%?%s-(.+)") then
													line = match(line, "%s-%?%?%s-(.+)")
													ndesc[#ndesc + 1] = {
														content = {
															line
														},
														type = "test"
													}
												else
													do
														local verbatimt = match(line, "%s-%?!%s-(.+)")
														if verbatimt then
															ndesc[#ndesc + 1] = {
																content = {
																	verbatimt
																},
																type = "verbatim-test"
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
															do
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
	for _index_0 = 1, #comments do
		local comment = comments[_index_0]
		local heading = comment.content[1]
		do
			local title = match(heading, "^" .. tostring(lead) .. "#(.+)#" .. tostring(lead) .. ".+")
			if title then
				tracking.editing = "title"
				ast.title = trim(title)
				ast.description, ast.tags = parseDescription((function()
					local _accum_0 = { }
					local _len_0 = 1
					local _list_0 = comment.content
					for _index_1 = 2, #_list_0 do
						local l = _list_0[_index_1]
						_accum_0[_len_0] = l
						_len_0 = _len_0 + 1
					end
					return _accum_0
				end)())
			else
				do
					local section = match(heading, "^#(.+)#.+")
					if section then
						tracking.editing = "section"
						tracking.section = {
							id = tracking.section.id + 1,
							name = trim(section)
						}
						tracking.section.description, tracking.section.tags = parseDescription((function()
							local _accum_0 = { }
							local _len_0 = 1
							local _list_0 = comment.content
							for _index_1 = 2, #_list_0 do
								local l = _list_0[_index_1]
								_accum_0[_len_0] = l
								_len_0 = _len_0 + 1
							end
							return _accum_0
						end)())
						ast[tracking.section.id] = {
							section = tracking.section,
							contents = { }
						}
					else
						do
							local fn = match(heading, "^" .. tostring(lead) .. "%s+@function%s+(.+)%s+::(.+)")
							if fn then
								local typ
								fn, typ = match(heading, "^" .. tostring(lead) .. "%s+@function%s+(.+)%s+::(.+)")
								if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
									error("@function " .. tostring(fn) .. ": Functions must be contained within a section.")
								end
								ast[tracking.section.id].contents[fn] = {
									is = "function",
									name = (function()
										local _accum_0 = { }
										local _len_0 = 1
										for name in fn:gmatch("%S+") do
											_accum_0[_len_0] = name
											_len_0 = _len_0 + 1
										end
										return _accum_0
									end)(),
									type = typ,
									summary = match((comment.content[2] or ""), "^-%s+(.+)")
								}
								ast[tracking.section.id].contents[fn].description, ast[tracking.section.id].contents[fn].tags = parseDescription((function()
									local _accum_0 = { }
									local _len_0 = 1
									local _list_0 = comment.content
									for _index_1 = 3, #_list_0 do
										local l = _list_0[_index_1]
										_accum_0[_len_0] = l
										_len_0 = _len_0 + 1
									end
									return _accum_0
								end)())
							else
								do
									local typ = match(heading, "^" .. tostring(lead) .. "%s+@type%s+(.+)")
									if typ then
										if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
											error("@type " .. tostring(typ) .. ": Types must be contained within a section.")
										end
										ast[tracking.section.id].contents[typ] = {
											is = "type",
											name = (function()
												local _accum_0 = { }
												local _len_0 = 1
												for name in typ:gmatch("%S+") do
													_accum_0[_len_0] = name
													_len_0 = _len_0 + 1
												end
												return _accum_0
											end)(),
											summary = match((comment.content[2] or ""), "^-%s+(.+)")
										}
										ast[tracking.section.id].contents[typ].description, ast[tracking.section.id].contents[typ].tags = parseDescription((function()
											local _accum_0 = { }
											local _len_0 = 1
											local _list_0 = comment.content
											for _index_1 = 3, #_list_0 do
												local l = _list_0[_index_1]
												_accum_0[_len_0] = l
												_len_0 = _len_0 + 1
											end
											return _accum_0
										end)())
									else
										do
											local cls = match(heading, "^" .. tostring(lead) .. "%s+@class%s+(.+)")
											if cls then
												if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
													error("@class " .. tostring(cls) .. ": Classes must be contained within a section.")
												end
												ast[tracking.section.id].contents[cls] = {
													is = "class",
													name = (function()
														local _accum_0 = { }
														local _len_0 = 1
														for name in cls:gmatch("%S+") do
															_accum_0[_len_0] = name
															_len_0 = _len_0 + 1
														end
														return _accum_0
													end)(),
													summary = match((comment.content[2] or ""), "^-%s+(.+)")
												}
												ast[tracking.section.id].contents[cls].description, ast[tracking.section.id].contents[cls].tags = parseDescription((function()
													local _accum_0 = { }
													local _len_0 = 1
													local _list_0 = comment.content
													for _index_1 = 3, #_list_0 do
														local l = _list_0[_index_1]
														_accum_0[_len_0] = l
														_len_0 = _len_0 + 1
													end
													return _accum_0
												end)())
											else
												do
													local cst = match(heading, "^" .. tostring(lead) .. "%s+@consta?n?t?%s+(.+)%s+::(.+)")
													if cst then
														cst, typ = match(heading, "^" .. tostring(lead) .. "%s+@consta?n?t?%s+(.+)%s+::(.+)")
														if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
															error("@const " .. tostring(cst) .. ": Classes must be contained within a section.")
														end
														ast[tracking.section.id].contents[cst] = {
															is = "constant",
															name = (function()
																local _accum_0 = { }
																local _len_0 = 1
																for name in cst:gmatch("%S+") do
																	_accum_0[_len_0] = name
																	_len_0 = _len_0 + 1
																end
																return _accum_0
															end)(),
															type = typ,
															summary = match((comment.content[2] or ""), "^-%s+(.+)")
														}
														ast[tracking.section.id].contents[cst].description, ast[tracking.section.id].contents[cst].tags = parseDescription((function()
															local _accum_0 = { }
															local _len_0 = 1
															local _list_0 = comment.content
															for _index_1 = 3, #_list_0 do
																local l = _list_0[_index_1]
																_accum_0[_len_0] = l
																_len_0 = _len_0 + 1
															end
															return _accum_0
														end)())
													else
														do
															local test = match(heading, "^" .. tostring(lead) .. "%s+@test%s+(.+)")
															if test then
																if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
																	error("@test " .. tostring(test) .. ": Tests must be contained within a section.")
																end
																ast[tracking.section.id].contents[test] = {
																	is = "test",
																	name = (function()
																		local _accum_0 = { }
																		local _len_0 = 1
																		for name in test:gmatch("%S+") do
																			_accum_0[_len_0] = name
																			_len_0 = _len_0 + 1
																		end
																		return _accum_0
																	end)(),
																	summary = match((comment.content[2] or ""), "^-%s+(.+)")
																}
																ast[tracking.section.id].contents[test].description, ast[tracking.section.id].contents[test].tags = parseDescription((function()
																	local _accum_0 = { }
																	local _len_0 = 1
																	local _list_0 = comment.content
																	for _index_1 = 3, #_list_0 do
																		local l = _list_0[_index_1]
																		_accum_0[_len_0] = l
																		_len_0 = _len_0 + 1
																	end
																	return _accum_0
																end)())
															else
																do
																	local task = match(heading, "^" .. tostring(lead) .. "%s+@task%s+(.+)")
																	if task then
																		if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
																			error("@task " .. tostring(task) .. ": Tasks must be contained within a section.")
																		end
																		ast[tracking.section.id].contents[test] = {
																			is = "task",
																			name = (function()
																				local _accum_0 = { }
																				local _len_0 = 1
																				for name in test:gmatch("%S+") do
																					_accum_0[_len_0] = name
																					_len_0 = _len_0 + 1
																				end
																				return _accum_0
																			end)(),
																			summary = match((comment.content[2] or ""), "^-%s+(.+)")
																		}
																		ast[tracking.section.id].contents[task].description, ast[tracking.section.id].contents[task].tags = parseDescription((function()
																			local _accum_0 = { }
																			local _len_0 = 1
																			local _list_0 = comment.content
																			for _index_1 = 3, #_list_0 do
																				local l = _list_0[_index_1]
																				_accum_0[_len_0] = l
																				_len_0 = _len_0 + 1
																			end
																			return _accum_0
																		end)())
																	else
																		do
																			local tbl = match(heading, "^" .. tostring(lead) .. "%s+@table%s+(.+)")
																			if tbl then
																				if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
																					error("@table " .. tostring(tbl) .. ": Tables must be contained within a section.")
																				end
																				ast[tracking.section.id].contents[tbl] = {
																					is = "table",
																					name = (function()
																						local _accum_0 = { }
																						local _len_0 = 1
																						for name in tbl:gmatch("%S+") do
																							_accum_0[_len_0] = name
																							_len_0 = _len_0 + 1
																						end
																						return _accum_0
																					end)(),
																					summary = match((comment.content[2] or ""), "^-%s+(.+)")
																				}
																				ast[tracking.section.id].contents[cls].description, ast[tracking.section.id].contents[cls].tags = parseDescription((function()
																					local _accum_0 = { }
																					local _len_0 = 1
																					local _list_0 = comment.content
																					for _index_1 = 3, #_list_0 do
																						local l = _list_0[_index_1]
																						_accum_0[_len_0] = l
																						_len_0 = _len_0 + 1
																					end
																					return _accum_0
																				end)())
																			else
																				do
																					local field = match(heading, "^" .. tostring(lead) .. "%s+@field%s+(.+)%s+::(.+)")
																					if field then
																						local var
																						var, typ = match(heading, "^" .. tostring(lead) .. "%s+@field%s+(.+)%s+::(.+)")
																						if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
																							error("@field " .. tostring(field) .. ": Fields must be contained within a section.")
																						end
																						ast[tracking.section.id].contents[field] = {
																							is = "field",
																							name = (function()
																								local _accum_0 = { }
																								local _len_0 = 1
																								for name in field:gmatch("%S+") do
																									_accum_0[_len_0] = name
																									_len_0 = _len_0 + 1
																								end
																								return _accum_0
																							end)(),
																							type = typ,
																							summary = match((comment.content[2] or ""), "^-%s+(.+)")
																						}
																						ast[tracking.section.id].contents[field].description, ast[tracking.section.id].contents[field].tags = parseDescription((function()
																							local _accum_0 = { }
																							local _len_0 = 1
																							local _list_0 = comment.content
																							for _index_1 = 3, #_list_0 do
																								local l = _list_0[_index_1]
																								_accum_0[_len_0] = l
																								_len_0 = _len_0 + 1
																							end
																							return _accum_0
																						end)())
																					else
																						do
																							local var = match(heading, "^" .. tostring(lead) .. "%s+@vari?a?b?l?e?%s+(.+)%s+::(.+)")
																							if var then
																								var, typ = match(heading, "^" .. tostring(lead) .. "%s+@vari?a?b?l?e?%s+(.+)%s+::(.+)")
																								if (not ast[tracking.section.id]) or (not ast[tracking.section.id].contents) then
																									error("@var " .. tostring(var) .. ": Variables must be contained within a section.")
																								end
																								ast[tracking.section.id].contents[var] = {
																									is = "variable",
																									name = (function()
																										local _accum_0 = { }
																										local _len_0 = 1
																										for name in var:gmatch("%S+") do
																											_accum_0[_len_0] = name
																											_len_0 = _len_0 + 1
																										end
																										return _accum_0
																									end)(),
																									type = typ,
																									summary = match((comment.content[2] or ""), "^-%s+(.+)")
																								}
																								ast[tracking.section.id].contents[var].description, ast[tracking.section.id].contents[var].tags = parseDescription((function()
																									local _accum_0 = { }
																									local _len_0 = 1
																									local _list_0 = comment.content
																									for _index_1 = 3, #_list_0 do
																										local l = _list_0[_index_1]
																										_accum_0[_len_0] = l
																										_len_0 = _len_0 + 1
																									end
																									return _accum_0
																								end)())
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
