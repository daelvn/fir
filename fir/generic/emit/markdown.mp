---# fir.generic.emit.markdown #---
-- An emitter that works with a [GenericAST](#/generic/parser.md?id=GenericAST) and turns it into markdown.
--
-- You can see an example of the output of this formatter [here](/examples/generic-emit-markdown.md).
{:rep} = string
import generate from require "tableview"

--# Utils #--
-- @internal
-- Utils to work internally.

--- @function bkpairs :: tbl:table -> Iterator
--- Iterates over a table in key order.
bkpairs = (t) ->
  a = {}
  table.insert a, n for n in pairs t
  table.sort a
  i    = 0
  iter = ->
    i += 1
    if a[i] == nil
      return nil
    else
      return a[i], t[a[i]]
  return iter
    
--# API #--
-- This is the API provided to work with the generic markdown emitter.

--- @function emitDescription :: desc:[DescriptionLine], options:table -> markdown:string
--- Emits Markdown from the description of an element.
--# Inherited options
-- - `tabs:table` (`{use=false}`): Adds [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/) comments for code snippets.
--   - `header:string` (`"####"`): Headers to use for docsify-tabs.
--# Recognized options
-- - `headerOffset:number` (`1`): Offsets the header levels by n
--///--
emitDescription = (desc, options={}) ->
  md = {}
  -- options
  options.headerOffset = 1
  -- emit
  for line in *desc
    switch line.type
      when "header"
        md[#md+1] = (rep "#", line.n + options.headerOffset) .. " " .. line.content[1]
      when "snippet"
        if options.tabs.use
          if md[#md] == "<!-- tabs:end -->"
            md[#md] = ""
          else
            md[#md+1] = "<!-- tabs:start -->"
          md[#md+1] = ""
          md[#md+1] = "#{options.tabs.header} #{line.title}"
          md[#md+1] = ""
        md[#md+1] = "```#{line.language}"
        for codeline in *line.content
          md[#md+1] = codeline
        md[#md+1] = "```"
        if options.tabs.use
          md[#md+1] = ""
          md[#md+1] = "<!-- tabs:end -->"
      when "text"
        md[#md+1] = line.content[1]
  -- return
  return table.concat md, "\n"
--///--

--- @function emitSection :: section:GenericSection, options:table -> markdown:string
--- Emits Markdown from a GenericSection
-- This function takes the same options than [emit](#emit)
--///--
emitSection = (section, options) ->
  md = {}
  -- failsafe option checking
  options.tabs        = use: false if options.tabs?
  options.tabs.header = "####"     if options.tabs.header?
  options.all         = false      if options.all?
  options.columns     = {}         if options.columns?
  options.types       = {
    type: "Types"
    function: "Functions"
  }                                if options.types?
  -- exit if internal
  if section.section.tags.internal and not options.all
    return table.concat md, "\n"
  -- emit title and description
  if section.section.name
    md[#md+1] = "## #{section.section.name}"
    md[#md+1] = ""
  if section.section.description
    md[#md+1] = emitDescription section.section.description, {headerOffset: 2, tabs: options.tabs}
  -- sort content
  byis = {}
  for k, v in pairs section.contents
    byis[v.is]  or= {}
    byis[v.is][k] = v
  print generate byis
    -- TODO order functions inside alphabetically
  -- create TOC
  -- Header
  md[#md+1] = ""
  if options.columns[section.id]
    md[#md+1] = "| #{options.columns[section.id][1]} | #{options.columns[section.id][2]} |"
  elseif options.columns["*"]
    md[#md+1] = "| #{options.columns['*'][1]} | #{options.columns['*'][2]} |"
  else
    md[#md+1] = "| Element | Summary |"
  md[#md+1]   = "|---------|---------|"
  -- elements
  for ty, elems in pairs byis
    -- subheaders
    md[#md+1] = "| #{options.types[ty]} |  |"
    for elemk, elemv in bkpairs elems
      md[#md+1] = "| [#{elemk}](##{elemk}) | #{elemv.summary} |"
  return table.concat md, "\n"
--///--

--- @function emit :: ast:GenericAST, options:table -> markdown:string
--- Emits Markdown from a GenericAST
--# Recognized options
-- - `tabs:table` (`{use=false}`): Adds [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/) comments for code snippets.
--   - `header:string` (`"####"`): Headers to use for docsify-tabs.
-- - `all:boolean` (`false`): Also emits hidden elements.
-- - `sections:table` (): Settings for sections.
-- - `columns:table` (): Settings for columns.
--   - `[n]:table` (): (where `n` can be any number or `"*"`). Specifies the column names for section `n` (with fallback).
--     - `[1]:string` (`"Element"`) - Left column
--     - `[2]:string` (`"Summary"`) - Right column
-- - `types:table` (): Aliases for types.
--   - `[type]:string` (): (where `type` can be any of the types supported by [GenericAST](#/generic/backend?id=GenericAST)). Default values include `type=Types` and `function=Functions`
--///-
emit = (ast, options={}) ->
  md = {}
  -- options
  options.tabs        = use: false if options.tabs?
  options.tabs.header = "####"     if options.tabs.header?
  options.all         = false      if options.all?
  options.columns     = {}         if options.columns?
  options.types       = {
    type: "Types"
    function: "Functions"
  }                                if options.types?
  -- exit if internal
  if ast.tags.internal and not options.all
    return nil, "(internal)"
  -- emit title and description
  if ast.title
    md[#md+1] = "# #{ast.title}"
    md[#md+1] = ""
  if ast.description
    md[#md+1] = emitDescription ast.description, {headerOffset: 1, tabs: options.tabs}
  -- emit sections
  for i=1, #ast
    md[#md+1] = emitSection ast[i], options
  -- return
  return table.concat md, "\n"
--///-- 

-- Test
readFile = (f) ->
  local content
  with io.open f, "r"
    content = \read "*a"
    \close!
  return content
import "fir.generic.backend" as {:extract}
import "fir.generic.parser"  as {:parse}
import "lunamark"            as lm

writer = lm.writer.html.new {}
render = lm.reader.markdown.new writer, {}

const languageMoon = {single: "--"}
readFile "fir/generic/backend.moon"
  |> (extract _, languageMoon, {})
  |> (parse _, languageMoon)
  |> emit
  |> render
  |> print