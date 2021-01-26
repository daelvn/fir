local _module_0 = { }
local find, sub, match = string.find, string.sub, string.match
local sanitize
sanitize = function(input)
	if "string" == type(input) then
		return input:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
	else
		return input
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
local lines
lines = function(s)
	local res, pos = { }, 1
	while true do
		local lep = string.find(s, "[\r\n]", pos)
		if not lep then
			break
		end
		local le = sub(s, lep, lep)
		if (le == "\r") and ((sub(s, lep + 1, lep + 1)) == "\n") then
			le = "\r\n"
		end
		local ln = sub(s, pos, lep - 1)
		res[#res + 1] = ln
		pos = lep + #le
	end
	if pos <= #s then
		res[#res + 1] = sub(s, pos)
	end
	return res
end
local lconcat
lconcat = function(ta, tb)
	local tc = { }
	for _index_0 = 1, #ta do
		local elem = ta[_index_0]
		tc[#tc + 1] = elem
	end
	for _index_0 = 1, #tb do
		local elem = tb[_index_0]
		tc[#tc + 1] = elem
	end
	return tc
end
local extract
extract = function(input, language, options)
	if input == nil then
		input = ""
	end
	if language == nil then
		language = { }
	end
	if options == nil then
		options = { }
	end
	local lt = lines(input)
	local comments = { }
	local comment = {
		content = { }
	}
	local tracking = {
		multi = false,
		ignore = false
	}
	if options.patterns == nil then
		options.patterns = false
	end
	if options.ignore == nil then
		options.ignore = "///"
	end
	if options.merge == nil then
		options.merge = true
	end
	if options.paragraphs == nil then
		options.paragraphs = true
	end
	local igstring = options.patterns and options.ignore or sanitize(options.ignore)
	local single, multis, multie
	if options.patterns then
		single = language.single or ""
		local _obj_0 = language.multi
		if _obj_0 ~= nil then
			multis = _obj_0[1]
		end
		local _obj_1 = language.multi
		if _obj_1 ~= nil then
			multie = _obj_1[2]
		end
	else
		single = (sanitize(language.single or ""))
		multis = (sanitize((function()
			local _obj_0 = language.multi
			if _obj_0 ~= nil then
				return _obj_0[1]
			end
			return nil
		end)() or false))
		multie = (sanitize((function()
			local _obj_0 = language.multi
			if _obj_0 ~= nil then
				return _obj_0[2]
			end
			return nil
		end)() or false))
	end
	for lc = 1, #lt do
		local _continue_0 = false
		repeat
			local line = lt[lc]
			if match(line, "^" .. tostring(single) .. tostring(igstring)) then
				tracking.ignore = not tracking.ignore
			elseif tracking.ignore then
				_continue_0 = true
				break
			elseif tracking.multi and multie and match(line, tostring(multie)) then
				tracking.multi = false
				comment["end"] = lc
				comment.content[#comment.content] = match(line, "^(.-)" .. tostring(multie))
				comments[#comments + 1] = comment
				comment = {
					content = { }
				}
			elseif tracking.multi then
				comment.content[#comment.content] = line
			elseif multis and match(line, "^" .. tostring(multis)) then
				tracking.multi = true
				comment.start = lc
				comment.content[#comment.content] = match(line, "^" .. tostring(multis) .. "(.+)")
			elseif single and match(line, "^" .. tostring(single)) then
				comment.start, comment["end"] = lc, lc
				comment.content[1] = match(line, "^" .. tostring(single) .. "(.-)$")
				comments[#comments + 1] = comment
				comment = {
					content = { }
				}
			end
			_continue_0 = true
		until true
		if not _continue_0 then
			break
		end
	end
	if options.merge then
		comments[0] = {
			type = false,
			start = 0,
			["end"] = -1
		}
		for i = #comments, 1, -1 do
			local _continue_0 = false
			repeat
				local curr = comments[i]
				local prev = comments[i - 1]
				if not (curr.start == prev["end"] + 1) then
					_continue_0 = true
					break
				end
				comments[i - 1] = {
					content = (lconcat(prev.content, curr.content)),
					start = prev.start,
					["end"] = curr["end"]
				}
				table.remove(comments, i)
				_continue_0 = true
			until true
			if not _continue_0 then
				break
			end
		end
		comments[0] = nil
	end
	local lastcomments = { }
	if options.paragraphs then
		for _index_0 = 1, #comments do
			local comment = comments[_index_0]
			local parts = { }
			local part = {
				start = 1
			}
			for lc = 1, #comment.content do
				if comment.content[lc] == "" then
					part["end"] = lc - 1
					parts[#parts + 1] = part
					part = {
						start = lc + 1
					}
				else
					part[#part + 1] = comment.content[lc]
				end
			end
			part["end"] = #comment.content
			parts[#parts + 1] = part
			for _index_1 = 1, #parts do
				local part = parts[_index_1]
				lastcomments[#lastcomments + 1] = {
					start = comment.start + part.start - 1,
					["end"] = comment.start + part["end"] - 1,
					content = (function()
						local _accum_0 = { }
						local _len_0 = 1
						for _index_2 = 1, #part do
							local l = part[_index_2]
							_accum_0[_len_0] = l
							_len_0 = _len_0 + 1
						end
						return _accum_0
					end)()
				}
			end
		end
		comments = lastcomments
	end
	return comments
end
_module_0["extract"] = extract
return _module_0
