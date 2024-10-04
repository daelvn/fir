config:
  -- general config
  format: "markdown" -- fir.generic.emit.markdown
  name:   "Fir"

  -- language (moon/yue)
  language: {single: "--"}

  -- files
  input:     {
    "fir/**.yue"
    { "fir/**.md", verbatim: true }
  } -- formatted for filekit.iglob

  transform: (path) ->
    if path\match "yue$"
      (path\match "fir/(.+)%.yue") .. ".md"
    else
      path\match "fir/(.+)"

  output:    "docs"

  ignore: {  -- formatted for filekit.fromGlob
    "fir/version.yue"
    "fir/file.yue"
  }
