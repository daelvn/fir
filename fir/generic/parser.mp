---# fir.generic.parser #---
-- A parser that works with the format provided by the [generic backend](#/generic/backend.md).
{:match, :find, :gsub, :sub} = string

--# Utils #--
-- @internal
-- Several utils used internally.

--- @function sanitize :: input:string -> escaped:string
--- Takes any string and escapes it to work with patterns.
sanitize = (input) -> input\gsub "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0" if "string" == type input

--- @function trim :: input:string -> trimmed:string, n:number
--- Trims the whitespace at each end of a string.
-- Taken from [Lua-users wiki's StringTrim (`trim11`)](http://lua-users.org/wiki/StringTrim).
trim = (input) -> return if n = find input, "%S" then match input, ".*%S", n else ""

--# Helpers #--
-- Several functions that aid in the process of parsing.

--- @type DescriptionLine
--- A single element in a description returned by `parseDescription`
--:moon Format
-- DescriptionLine {
--   type      :: string (text|snippet|header)
--   content   :: [string]
--   language? :: string -- only when type is snippet
--   title?    :: string -- only when type is snippet
--   n?        :: number -- only when type is header
-- }

--- @function parseDescription :: description:[string] -> description:[DescriptionLine], tags:[string]
--- Parses codeblocks, tags, headers and normal text in descriptions.
-- Returns an array of DescriptionLines and an array of tags.
--# Notes
-- - In a codeblock, the first character of every line is removed (for a space).
--# Supported tags
-- - `@internal` - Adds an `internal` true flag to the element.
--///--
parseDescription = (desc) ->
  incode      = false
  ndesc, code, tags = {}, {}, {}
  for line in *desc
    -- close snippet
    if line == ":"
      ndesc[#ndesc+1] = code if incode
      incode = false
    -- add to snippet
    elseif incode
      code.content[#code.content+1] = sub line, 2
    -- tags
    elseif tag = match line, "^%s-@(%w+)(.-)"
      tag, value = match line, "^%s-@(%w+)(.-)"
      tags[tag] = (value == "") and true or value
    -- headers
    elseif header = match line, "^###%s+(.+)"
      ndesc[#ndesc+1] = {content: {trim header}, type: "header", n: 3}
    elseif header = match line, "^##%s+(.+)"
      ndesc[#ndesc+1] = {content: {trim header}, type: "header", n: 2}
    elseif header = match line, "^#%s+(.+)"
      ndesc[#ndesc+1] = {content: {trim header}, type: "header", n: 1}
    elseif headern = match line, "^(%d)%s+(.+)"
      header, n = match line, "^(%d)%s+(.+)"
      ndesc[#ndesc+1] = {content: {trim header}, type: "header", :n}
    -- snippets
    elseif snippet = match line, "^:(%w+)%s+(.+)"
      -- if there was a previous snippet open, close it
      ndesc[#ndesc+1] = code if incode
      -- init snippet
      language, title = match line, "^:(%w+)%s+(.+)"
      code            = {:language, :title, content: {}, type: "snippet"}
      incode          = true
    -- add line
    else
      ndesc[#ndesc+1] = {type: "text", content: {line\match " ?(.+)"}}
  -- add last and return
  ndesc[#ndesc+1] = code if incode
  return ndesc, tags
--///--

--# API #--
-- This is the API provided to work with the generic parser.

--- @type GenericAST
--- The AST produced by `parse`.
--:moon Format
-- GenericAST {
--   title       :: string
--   description :: [DescriptionLine]
--   [n]         :: GenericSection { -- where n is the ID of the section
--     section :: GenericSectionDetails {
--       id          :: number
--       name        :: string
--       description :: [DescriptionLine]
--     }
--     content :: GenericSectionContent {
--       [name] :: GenericElement {
--         is          :: string (type|function)
--         description :: [DescriptionLine]
--         name        :: [string] -- an array, meant to also contain aliases
--         summary     :: string
--         type        :: string -- only when is == function
--       }
--     }
--   }
-- }

--- @function parse :: comments:[GenericComment], language:Language -> ast:GenericAST
--- Parses a list of GenericComments into a GenericAST
--///--
export parse = (comments, language) ->
  ast = {}
  -- get character for special comments
  lead = sanitize sub language.single, -1
  -- keep track of variables
  tracking = {
    editing: false             -- keep track of the part currently being edited, for fallbacks
    section: {id: 0, name: ""} -- keep track of the section being modified
  }
  -- iterate comments
  for comment in *comments
    heading = comment.content[1]
    if title = match heading, "^#{lead}#(.+)##{lead}.+"
      tracking.editing          = "title"
      ast.title                 = trim title
      ast.description, ast.tags = parseDescription [l for l in *comment.content[2,]]
    elseif section = match heading, "^#(.+)#.+"
      tracking.editing             = "section"
      tracking.section             = {
        id:          tracking.section.id+1
        name:        trim section
      }
      tracking.section.description, tracking.section.tags = parseDescription [l for l in *comment.content[2,]]
      ast[tracking.section.id] = {section: tracking.section, contents: {}}
    elseif fn = match heading, "^#{lead}%s+@function%s+(.+)%s+::(.+)"
      fn, typ = match heading, "^#{lead}%s+@function%s+(.+)%s+::(.+)"
      ast[tracking.section.id].contents[fn] = {
        is:          "function"
        name:        [name for name in fn\gmatch "%S+"]
        type:        typ
        summary:     match (comment.content[2] or ""), "^-%s+(.+)"
      }
      ast[tracking.section.id].contents[fn].description, ast[tracking.section.id].contents[fn].tags = parseDescription [l for l in *comment.content[3,]]
    elseif typ = match heading, "^#{lead}%s+@type%s+(.+)"
      ast[tracking.section.id].contents[typ] = {
        is:          "type"
        name:        [name for name in typ\gmatch "%S+"]
        summary:     match (comment.content[2] or ""), "^-%s+(.+)"
      }
      ast[tracking.section.id].contents[typ].description, ast[tracking.section.id].contents[typ].tags = parseDescription [l for l in *comment.content[3,]]
    else
      switch tracking.editing
        when "title"
          ast.description[#ast.description+1] = {type: "text", content: {""}}
          for l in *(parseDescription comment.content) do ast.description[#ast.description+1] = l
        when "section"
          tracking.section.description[#tracking.section.description+1] = {type: "text", content: {""}}
          for l in *(parseDescription comment.content) do tracking.section.description[#tracking.section.description+1] = l
  -- return
  return ast
--///--

--///--
-- readFile = (f) ->
--   local content
--   with io.open f, "r"
--     content = \read "*a"
--     \close!
--   return content
-- import extract  from require "fir.generic.backend"
-- import generate from require "tableview"
-- print generate parse (extract (readFile "fir/generic/backend.moon"), {single: "--"}, {}), {single: "--"}
--///--