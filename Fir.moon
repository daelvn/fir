config:
  name:   "Fir"
  -- general config
  format: "markdown" -- fir.generic.emit.markdown
  emit:
    symbols_in_code: true
    inline_type: true
    tabs:
      use: "pymdownx"

  -- language (moon/yue)
  language: {single: "--"}

  -- files
  input: {
    "fir/**.yue"
    { "fir/**.md", verbatim: true }
  } -- formatted for filekit.iglob

  transform: (path) ->
    if path\match "yue$"
      (path\match "fir/(.+)%.yue") .. ".md"
    else
      path\match "fir/(.+)"

  output: "docs"

  ignore: {
    "fir/version.yue"
    "fir/file.yue"
  }
