---# fir.generic.backend #---
-- A generic implementation of a [backend](#/backend.md) for the Fir
-- documentation generator.
--
-- This specific implementation uses a `language` module (defaults to `fir.generic.languages`) to
-- parse comments from any file.
--
-- Check out an example output of this backend [here](/examples/generic-backend.html).
{:find, :sub, :match} = string

--# Utils #--
-- @internal
-- Several utils used internally.

--- @function sanitize :: input:string -> escaped:string
--- Takes any string and escapes it to work with patterns.
sanitize = (input) -> if "string" == type input then return input\gsub "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0" else return input

--- @function trim :: input:string -> trimmed:string, n:number
--- Trims the whitespace at each end of a string.
-- Taken from [Lua-users wiki's StringTrim (`trim11`)](http://lua-users.org/wiki/StringTrim).
trim = (input) -> return if n = find input, "%S" then match input, ".*%S", n else ""

--- @function lines :: input:string -> lines:table
--- Splits a table into lines.
-- Taken from [Penlight's `stringx` (`splitlines`)](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#splitlines).
lines = (s) ->
  res, pos = {}, 1
  while true
    lep = string.find s, "[\r\n]", pos
    break unless lep
    le = sub s, lep, lep
    le = "\r\n" if (le == "\r") and ((sub s, lep+1, lep+1) == "\n")
    ln          = sub s, pos, lep-1
    res[#res+1] = ln
    pos         = lep + #le
  if pos <= #s
    res[#res+1] = sub s, pos
  return res

--- @function lconcat :: la:[*], lb:[*] -> merged:[*]
--- Concatenates two lists
lconcat = (ta, tb) ->
  tc = {}
  for elem in *ta do tc[#tc+1] = elem
  for elem in *tb do tc[#tc+1] = elem
  return tc

--# API #--
-- This is the API provided to work with the generic backend.

--- @type Language
--- Language type accepted by [`extract`](#extract).
--:moon Format
-- Language {
--   single     :: string
--   multi      :: [string]
--   extensions :: [string]
-- }
--:

--- @type GenericComment
--- Comment returned by [`extract`](#extract).
--:moon Format
-- GenericComment {
--   start   :: number
--   end     :: number
--   content :: [string]
-- }
--:

--- @function extract :: input:string, language?:Language, options?:table -> comments:[GenericComment]
--- Extracts comment from a string separated by newlines.
--# Available options
-- - `patterns:boolean` (`false`): Whether to use patterns for the language fields and ignore string or not.
-- - `ignore:string` (`"///"`): String used to determine when to start or stop ignoring comments.
-- - `merge:boolean` (`true`): Whether to merge adjacent single-line comments.
-- - `paragraphs:boolean` (`true`): Whether to split multi-line comments by empty strings (`""`).

--///--
extract = (input="", language={}, options={}) ->
  -- lt:table       - (l)ines (t)able, lines in the file
  -- comments:table - comments that were parsed
  -- comment:table  - current comment
  --   start:number     - line start
  --   end:number       - line end
  --   type:string      - type of comment (multi|single)
  --   content:[string] - comment strings 
  -- tracking:table - table for variables that are getting tracked
  --   multi:boolean  - whether we are in multiline mode
  --   ignore:boolean - whether comments are currently being ignored
  lt       = lines input
  comments = {}
  comment  = {content:{}}
  tracking = {
    multi:  false
    ignore: false
  }
  -- options
  options.patterns   = false if options.patterns?
  options.ignore     = "///" if options.ignore?
  options.merge      = true  if options.merge?
  options.paragraphs = true  if options.paragraphs?
  -- sanitize language
  igstring = options.patterns and options.ignore or sanitize options.ignore
  local single, multis, multie
  if options.patterns
    single = language.single or ""
    multis = language.multi?[1]
    multie = language.multi?[2]
  else
    single = (sanitize language.single    or "")
    multis = (sanitize language.multi?[1] or false)
    multie = (sanitize language.multi?[2] or false)
  -- line loop
  -- lc:number - (l)ine (c)ount
  for lc=1, #lt
    line = lt[lc]
    -- (single)/// signals to start ignoring all contents
    if match line, "^#{single}#{igstring}"
      tracking.ignore = not tracking.ignore
    -- continue if currently ignoring
    elseif tracking.ignore
      continue
    -- close multiline comment
    elseif tracking.multi and multie and match line, "#{multie}"
      tracking.multi                    = false
      comment.end                       = lc
      comment.content[#comment.content] = match line, "^(.-)#{multie}"
      comments[#comments+1]             = comment
      comment                           = content: {}
    -- if multiline, shove into current comment
    elseif tracking.multi
      comment.content[#comment.content] = line
    -- start multiline comment
    elseif multis and match line, "^#{multis}"
      tracking.multi                    = true
      comment.start                     = lc
      comment.content[#comment.content] = match line, "^#{multis}(.+)"
    -- add single line comment
    elseif single and match line, "^#{single}"
      comment.start, comment.end = lc, lc
      comment.content[1]         = match line, "^#{single}(.-)$"
      comments[#comments+1]      = comment
      comment                    = content: {}
  -- merge adjacent single comments
  if options.merge
    comments[0] = {type: false, start: 0, end: -1}
    for i=#comments, 1, -1
      curr = comments[i]
      prev = comments[i-1]
      continue unless curr.start == prev.end+1
      comments[i-1] = {content: (lconcat prev.content, curr.content), start: prev.start, end: curr.end}
      table.remove comments, i
    comments[0] = nil
  -- split in paragraphs
  lastcomments = {}
  if options.paragraphs
    -- iterate comments
    for comment in *comments
      -- iterate contents
      parts    = {}
      part     = {start: 1}
      for lc=1, #comment.content
        -- split by empty line
        if comment.content[lc] == ""
          part.end        = lc - 1
          parts[#parts+1] = part
          part            = {start: lc+1}
        else
          part[#part+1] = comment.content[lc]
      part.end        = #comment.content
      parts[#parts+1] = part
      -- split parts into several comments
      --print generate parts
      for part in *parts
        lastcomments[#lastcomments+1] = {start: comment.start+part.start-1, end: comment.start+part.end-1, content: [l for l in *part]}
    comments = lastcomments
  -- return
  return comments
--///--

--///--
-- readFile = (f) ->
--   local content
--   with io.open f, "r"
--     content = \read "*a"
--     \close!
--   return content
--print generate extract (readFile "fir/generic/backend.moon"), {single: "--"}, {}
--///--

{ :extract }