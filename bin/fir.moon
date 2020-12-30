argparse                              = require "argparse"
fs                                    = require "filekit"

local args
with argparse!
  \name        "fir"
  \description "Language-agnostic documentation generator"
  \epilog      "fir v#{require 'fir.version'} - https://github.com/daelvn/fir"

  \help_description_margin 30

  -- LANGUAGES
  ll = with \flag "--list-languages"
    \description "Lists all available languages"
  l = with \option "-l --languages"
    \description "Loads a different module as a language file"
    \default "fir.languages"
  \group "Languages", l, ll

  -- CONFIG
  c = with \option "-c --config"
    \description "Configuration file for this project"
  cl = with \option "--config-language"
    \description "Uses an explicit language for the config file"
  \group "Configuration", c, cl

  -- DOCUMENTATION
  g = with \command "generate g"
    \description "Generates documentation for a project"
    with \flag "-v --viewer"
      \description "Generates the viewer as well"
  s = with \command "serve s"
    \description "Starts a live server to preview the documentation (requires python3)"
  \group "Documentation", g, s

  args = \parse!

-- list known languages
if args.list_languages
  for name, _ in pairs require args.languages do print name
  os.exit!

-- load config file
FILE = do
  if     args.c               then args.c
  elseif args.config          then args.config
  elseif fs.exists "Fir.lua"  then "Fir.lua"
  elseif fs.exists "Fir.moon" then "Fir.moon"
  else errors 1, "No Firfile found."

-- Also accept a custom language
LANGUAGE = do
  if     FILE\match "moon$"   then "moon"
  elseif FILE\match "lua$"    then "lua"
  elseif args.config_language then args.config_language
  else error "Cannot resolve format for Firfile."
io.stderr\write "Using #{FILE} (#{LANGUAGE})\n"

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

-- Add to project
project.available_languages = require args.languages

-- Generate docs
if args.generate
  import generate from require "fir.generator.generic"
  generate project.input, project
  -- Generate viewer
  if args.viewer or project.viewer
    readFile = (f) ->
      local content
      with fs.safeOpen f, "r"
        if .error then error .error
        content = \read "*a"
        \close!
      return content

    writeFile = (f, c) ->
      with fs.safeOpen f, "w"
        if .error then error .error
        \write c
        \close!
      return true
    
    if project.viewer.etlua
      etlua   = require "etlua"
      loadkit = require "loadkit"
      loadkit.register "etlua", (file) -> assert etlua.compile file\read "*a"
      viewer  = require project.viewer.etlua
      writeFile (fs.combine project.output, project.viewer.output), viewer project

-- Serve docs
if args.serve
  os.execute "python3 -m http.server -d #{project.output}"