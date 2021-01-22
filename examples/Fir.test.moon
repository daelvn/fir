config:
  -- general config
  format: "tests" -- fir.generic.emit.markdown
  name:   "Fir/tests"

  -- language (moon/mp)
  language: {single: "--"}

  -- files
  input:     {"examples/*.lua"} -- formatted for filekit.iglob
  transform: (path) -> (path\match "examples/(.+)%.lua") .. ".test.lua"
  output:    "examples"
  ignore: {  -- formatted for filekit.fromGlob
    "*.test.lua"
    "module/*"
  }

  -- tests
  emit:
    unpack: {"field"}
    docs: false
    --print: false