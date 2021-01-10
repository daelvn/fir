config:
  -- general config
  format: "markdown" -- fir.generic.emit.markdown
  name:   "Fir"

  -- language (moon/mp)
  language: {single: "--"}

  -- files
  input:     {"fir/**.mp"} -- formatted for filekit.iglob
  transform: (path) -> (path\match "fir/(.+)%.mp") .. ".md"
  output:    "docs"
  ignore: {  -- formatted for filekit.fromGlob
    "fir/version.mp"
    "fir/file.mp"
  }