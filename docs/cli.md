# Fir CLI

This page describes the CLI to the Fir framework. It can only use the [generic](generic/documenting.md) documentation format (but it can use different output formats).

## Installing

The Fir CLI comes with the Fir framework via LuaRocks automatically.

## Configuration

The most important part to maintaining the documentation of a project with Fir is the configuration. The configuration takes form as a Lua or MoonScript file and it defines the inputs, outputs, formats and other things related to documentation.

The file must be named `Fir.lua` or `Fir.moon` for it to be detected automatically, but you can also use `-c` or `--config` to change the configuration file, and `--config-language` to set the language it should be loaded as (only supports `lua` and `moon`).

Here follows a complete description of all the options that the Fir CLI accepts.

<!-- TODO include backend and emit options -->

<!-- tabs:start -->

#### **Lua**

```lua
--- General config
name = "Fir"      -- name of your project, not mandatory
--- Format
-- turns into fir.generic.emit.<format>
format = "markdown" -- only markdown is included by default
--- Language
-- defines the way comments should be extracted
-- with support for single-line and multiline comments.
language = {
  single = "--",
  multi  = {
    "--[[",
    "]]--"
  }
}
--- Files
-- Input
-- Every entry is passed through filekit.iglob (reference below),
-- so you can use wildcards.
input = {"fir/**.mp"}
-- Transform
-- Function that changes the filepath to be written.
-- If the input is fir/generic/emit/markdown.mp, this function
-- will transform it into `generic/emit/markdown.md`
transform = function (path)
  return (path:match "fir/(.+)%.mp") .. ".md"
end
-- Output folder
output = "docs"
-- Ignore
-- List of files to ignore. Also supports wildcards (reference below).
ignore = {
  "fir/version.mp",
  "fir/file.mp"
}
```

#### **MoonScript**

```moon
config:
  --- General config
  name: "Fir"      -- name of your project, not mandatory
  --- Format
  -- turns into fir.generic.emit.<format>
  format: "markdown" -- only markdown is included by default
  --- Language
  -- defines the way comments should be extracted
  -- with support for single-line and multiline comments.
  language:
    single: "--"
    multi: {
      "--[["
      "]]--"
    }
  }
  --- Files
  -- Input
  -- Every entry is passed through filekit.iglob (reference below),
  -- so you can use wildcards.
  input: {"fir/**.mp"}
  -- Transform
  -- Function that changes the filepath to be written.
  -- If the input is fir/generic/emit/markdown.mp, this function
  -- will transform it into `generic/emit/markdown.md`
  transform: (path) -> (path\match "fir/(.+)%.mp") .. ".md"
  -- Output folder
  output: "docs"
  -- Ignore
  -- List of files to ignore. Also supports wildcards (reference below).
  ignore: {
    "fir/version.mp"
    "fir/file.mp"
  }
```

<!-- tabs:end -->

## Generating

Then you can simply generate your docs with `fir generate` (or `fir g` for shory). This will automatically create all folders and files necessary.

## Viewing

You may only want the Markdown files, but I recommend using a project like [Docsify](https://docsify.js.org/#/) to make your documentation look better as a webpage. The Markdown generic emitter has some facilities to integrate with Docsify (like comments for the [`docsify-tabs` plugin](https://jhildenbiddle.github.io/docsify-tabs/#/)).