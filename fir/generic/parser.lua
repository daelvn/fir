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
	return ast
end
_module_0["parse"] = parse
return _module_0
