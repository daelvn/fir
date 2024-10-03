config:
  -- general config
  format: "markdown" -- fir.generic.emit.markdown
  name:   "Fir"

  -- language (moon/yue)
  language: {single: "--"}

  -- files
  input:     {"fir/**.yue"} -- formatted for filekit.iglob
  transform: (path) -> (path\match "fir/(.+)%.yue") .. ".md"
  output:    "docs"
  ignore: {  -- formatted for filekit.fromGlob
    "fir/version.yue"
    "fir/file.yue"
  }
