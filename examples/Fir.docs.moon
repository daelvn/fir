config:
  -- general config
  format: "markdown" -- fir.generic.emit.markdown
  name:   "Fir/tests"

  -- language (moon/mp)
  language: {single: "--"}

  -- files
  input:     {"examples/*.test.lua"} -- formatted for filekit.iglob
  transform: (path) -> (path\match "examples/(.+)%.test.lua") .. ".md"
  output:    "examples"
  ignore: {  -- formatted for filekit.fromGlob
    "module/*"
  }