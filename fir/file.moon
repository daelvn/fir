-- fir.file (originally alfons.file, alfons.env)
-- Gets the contents of a firfile
fs = require "filekit"

readMoon = (file) ->
  local content
  with fs.safeOpen file, "r"
    -- check that we could open correctly
    if .error
      return nil, "Could not open #{file}: #{.error}"
    -- read and compile
    import to_lua from require "moonscript.base"
    content, err = to_lua \read "*a"
    -- check that we could compile correctly
    unless content
      return nil, "Could not read or parse #{file}: #{err}"
    \close!
  -- return
  return content

readLua = (file) ->
  local content
  with fs.safeOpen file, "r"
    -- check that we could open correctly
    if .error
      return nil, "Could not open #{file}: #{.error}"
    -- read and compile
    content = \read "*a"
    -- check that we could compile correctly
    unless content
      return nil, "Could not read #{file}: #{content}"
    \close!
  -- return
  return content

loadEnv = (content, env) ->
  local fn
  switch _VERSION
    -- use loadstring on 5.1
    when "Lua 5.1"
      fn, err = loadstring content
      unless fn
        return nil, "Could not load Firfile content (5.1): #{err}"
      setfenv fn, env
    -- use load otherwise
    when "Lua 5.2", "Lua 5.3", "Lua 5.4"
      fn, err = load content, "Fir", "t", env
      unless fn
        return nil, "Could not load Firfile content (5.2+): #{err}"
  -- return
  return fn

{ :readMoon, :readLua, :loadEnv }