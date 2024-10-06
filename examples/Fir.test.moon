config:
  -- general config
  format: "tests" -- 
  name:   "Fir/tests"
  emit:
    print: 'tap'
    auto_unpack: true

  -- language (moon/yue)
  language: {single: "--"}

  -- files
  input:     {"examples/testable.moon"}
  transform: (path) -> (path\match "examples/(.+)%.moon") .. ".test.moon"
  output:    "examples"
  ignore: {  -- formatted for filekit.fromGlob
    "*.test.lua"
    "module/*"
  }

  -- tests
  -- emit:
    -- unpack: { "field" }
    -- docs: false
