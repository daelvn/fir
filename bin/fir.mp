---# bin/fir #---
-- The command line interface to Fir.
--
-- It only works with the `generic` pipeline. If you wish to
-- use your custom functions that are not in `fir.generic.*`
-- you need to roll out your own script.
import "argparse"
import "filekit"       as fs
import "ansikit.style" as {:style}

--///--
-- TODO Integrate this into alfons
--///--
local args
with argparse!
  \name        "fir"
  \description "Language-agnostic documentation generator"
  \epilog      "fir v#{require 'fir.version'} - https://github.com/daelvn/fir"

  \help_description_margin 30

  -- CONFIG
  c = with \option "-c --config"
    \description "Configuration file for this project"
  cl = with \option "--config-language"
    \description "Uses an explicit language for the config file"
  \group "Configuration", c, cl

  -- DOCUMENTATION
  g = with \command "generate gen g"
    \description "Generates documentation for a project"
  d = with \command "dump d"
    \description "Dumps AST to stdout using tableview (does not generate docs)"
  \group "Documentation", g

  -- FLAGS
  sl = with \flag "-s --silent"
    \description "Does not print to stderr"
  \group "Flags", sl

  args = \parse!

-- load config file
FILE = do
  if     args.c               then args.c
  elseif args.config          then args.config
  elseif fs.exists "Fir.lua"  then "Fir.lua"
  elseif fs.exists "Fir.moon" then "Fir.moon"
  else error "No Firfile found."

-- Also accept a custom language
LANGUAGE = do
  if     FILE\match "moon$"   then "moon"
  elseif FILE\match "lua$"    then "lua"
  elseif args.config_language then args.config_language
  else error "Cannot resolve format for Firfile."
io.stderr\write "Using #{FILE} (#{LANGUAGE})\n" unless arg.silent

-- Load string
import readMoon, readLua, loadEnv from require "fir.file"
content, contentErr = switch LANGUAGE
  when "moon" then readMoon FILE
  when "lua"  then readLua  FILE
  else error "Cannot resolve format '#{LANGUAGE}' for Firfile."
unless content then error contentErr, 1

-- Load with environment
firEnv      = {}
fir, firErr = loadEnv content, firEnv
if firErr then error "Could not load Firfile: #{firErr}"

-- Run and get contents
list        = fir!
rconfig     = list and (list.config and list.config or {}) or {}
project     = firEnv
for k, v in pairs rconfig do project[k] = v

-- arrow
printArrow = (txt) -> io.stderr\write style "%{blue}==>%{white} #{txt}\n" unless args.silent
printError = (txt) -> io.stderr\write style "%{red}#{txt}\n"              unless args.silent
printPlus  = (txt) -> io.stderr\write style "%{green}+ #{txt}\n"          unless args.silent
printMini  = (txt) -> io.stderr\write style "%{yellow}-> #{txt}\n"        unless args.silent

-- readfile
readFile = (f) ->
  local content
  with io.open f, "r"
    content = \read "*a"
    \close!
  return content
-- writefile
writeFile = (f, t) ->
  with io.open f, "w"
    \write t
    \close!
-- mkdir
mkdirFor = (path) ->
  path = path\match "(.+)/.-"
  sep, pStr = (package.config\sub 1, 1), ""
  for dir in path\gmatch "[^" .. sep .. "]+" do
    pStr = pStr .. dir .. sep
    fs.makeDir pStr

-- Generate docs
if args.generate or args.dump
  printArrow "Generating docs#{project.name? and (' for ' .. project.name) or ''}"
  --- files ---
  -- check input
  unless project.input?
    printError "No input specified."
    printError "Please set an 'input' field (table) in #{FILE}"
    os.exit 1
  -- compile ignore list
  ignore = [fs.fromGlob ig for ig in *project.ignore] if project.ignore
  -- iterate files
  cwd   = fs.currentDir!
  files = {}
  for inp in *project.input
    for node in fs.iglob inp
      if fs.isFile node
        -- take ignores into account
        doIgnore = false
        if project.ignore
          for ig in *ignore
            doIgnore = true if node\match ig
        -- add file
        unless doIgnore
          fname = node\match "#{cwd}/(.+)"
          files[#files+1] = fname
          printPlus fname
  --- check language ---
  unless project.language?
    printError "No language specified."
    printError "Please set a 'language' field (table) in #{FILE}"
    os.exit 1
  --- extract comments ---
  import extract from require "fir.generic.backend"
  --printArrow "Extracting comments"
  --
  extracted = {}
  for file in *files
    --printMini file
    extracted[file] = (readFile file) |> extract(_, project.language, project.backend or {})
  --- parse comments ---
  import parse from require "fir.generic.parser"
  --printArrow "Parsing comments"
  --
  parsed = {}
  for file in *files
    --printMini file
    parsed[file] = extracted[file] |> parse(_, project.language)
  --- dump? ---
  if args.dump
    import generate from require "tableview"
    for file in *files
      print generate parsed[file]
    os.exit!
  --- emit ---
  unless project.format?
    printError "No format specified."
    printError "Please set a 'format' field (string) in #{FILE}"
    os.exit 1
  import emit from require "fir.generic.emit.#{project.format}"
  emitted = {}
  for file in *files
    --printMini file
    emitted[file] = parsed[file] |> emit(_, project.emit or {})
  --- write ---
  unless project.output?
    printError "No output folder specified."
    printError "Please set an 'output' field (string) in #{FILE}"
    os.exit 1
  --printArrow "Writing documentation..."
  -- make docs dir
  fs.makeDir project.output unless fs.isDir project.output
  -- write
  for file in *files
    -- transform if exists
    oldfile = file
    if project.transform
      file = fs.combine project.output, project.transform file
    --printMini file
    --
    mkdirFor file
    writeFile file, emitted[oldfile]