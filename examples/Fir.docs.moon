config:
  -- general config
  format: "markdown" -- fir.generic.emit.markdown
  name:   "Fir/tests"

  -- language (moon/yue)
  language: {single: "--"}

  -- files
  input:     {"examples/*.test.lua"}
  transform: (path) -> (path\match "examples/(.+)%.test.lua") .. ".md"
  output:    "examples"
