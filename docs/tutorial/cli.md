# CLI

This page describes the CLI to the Fir framework. It can only use the [generic](generic/documenting.md) documentation format (but it can use different output formats).

## Installing

The Fir CLI comes with the Fir framework via LuaRocks automatically.

## Configuration

The most important part to maintaining the documentation of a project with Fir is the configuration. The configuration takes form as a Lua or MoonScript file and it defines the inputs, outputs, formats and other things related to documentation.

The file must be named `Fir.lua` or `Fir.moon` for it to be detected automatically, but you can also use `-c` or `--config` to change the configuration file, and `--config-language` to set the language it should be loaded as (only supports `lua` and `moon`).

!!! note "About MoonScript"
    **Note:** To use a Fir.moon configuration file, or any configuration file written in MoonScript, you need to install MoonScript via LuaRocks with the following command: `luarocks install moonscript`

Here follows a complete description of all the options that the Fir CLI accepts.

=== "Lua"
    ```lua
    --- General config
    name = "Fir"      -- name of your project, not mandatory
    --- Format
    -- turns into fir.generic.emit.<format>
    format = "markdown" -- only markdown is included by default
    --- Emit options
    emit = {
      tabs = {
        use = false,            -- Whether to use Tab syntax in Markdown or not
        docsify_header = "####" -- Header to use in the Docsify Tab syntax
      },
      all = false,  -- Also emit `@internal` sections
      columns = {}, -- Modify the TOC
      types = {     -- TOC section titles
        type = "Types",
        function = "Functions",
        constant = "Constants",
        class = "Classes",
        test = "Tests",
        table = "Tables",
        field = "Fields",
        variable = "Variables"
      }
    }
    --- Backend options
    backend = {
      patterns = false,   -- Whether to use patterns for the language strings
      ignore = "///",     -- String used to determine when to start or stop ignoring comments
      merge = true,       -- Whether to merge adjacent single-line comments
      paragraphs = true,  -- Whether to split multi-line comments by empty strings
    }
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
    -- Every entry is passed through lpath.fs.glob, so you can use
    -- wildcards. Reference below.
    input = {
      "fir/**.yue",
      -- Verbatim files will be placed in the output folder as they
      -- are.
      { "fir/**.md", verbatim: true }
    }
    -- Transform
    -- Function that changes the filepath to be written.
    -- If the input is fir/generic/emit/markdown.yue, this function
    -- will transform it into `generic/emit/markdown.md`, for example.
    transform = function (path)
      if (path:match "yue$") then
        return (path:match "fir/(.+)%.yue") .. ".md"
      else
        return (path:match "fir/(.+)")
      end
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

=== "MoonScript"
    ```moon
    config:
      --- General config
      name: "Fir"      -- name of your project, not mandatory
      --- Format
      -- turns into fir.generic.emit.<format>
      format: "markdown" -- only markdown is included by default
      --- Emit options
      emit: {
        tabs: {
          use:  false,            -- Whether to use Tab syntax in Markdown or not
          docsify_header:  "####" -- Header to use in the Docsify Tab syntax
        },
        all:  false,  -- Also emit `@internal` sections
        columns:  {}, -- Modify the TOC
        types:  {     -- TOC section titles
          type:  "Types",
          function:  "Functions",
          constant:  "Constants",
          class:  "Classes",
          test:  "Tests",
          table:  "Tables",
          field:  "Fields",
          variable:  "Variables"
        }
      }
      --- Backend options
      backend:  {
        patterns:  false,   -- Whether to use patterns for the language strings
        ignore:  "///",     -- String used to determine when to start or stop ignoring comments
        merge:  true,       -- Whether to merge adjacent single-line comments
        paragraphs:  true,  -- Whether to split multi-line comments by empty strings
      }
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
      -- Verbatim files will be placed in the output folder as they
      -- are.
      --- Files
      -- Input
      -- Every entry is passed through lpath.fs.glob (reference below),
      -- so you can use wildcards.
      input: {
        "fir/**.yue"
        -- Verbatim files will be placed in the output folder as they
        -- are.
        { "fir/**.md", verbatim: true }
      }
      -- Transform
      -- Function that changes the filepath to be written.
      -- If the input is fir/generic/emit/markdown.yue, this function
      -- will transform it into `generic/emit/markdown.md`
      transform: (path) ->
        if path\match "yue$"
          (path\match "fir/(.+)%.mp") .. ".md"
        else
          path\match "fir/(.+)"
      -- Output folder
      output: "docs"
      -- Ignore
      -- List of files to ignore. Also supports wildcards (reference below).
      ignore: {
        "fir/version.mp"
        "fir/file.mp"
      }
    ```

### Wildcards

Wildcards work as described in the [lpath `fs.glob`](https://github.com/starwing/lpath#fsdirfsscandirfsglob) function documentation, with a modification that has been made by Fir.

`**` not followed by the path separator will be turned into `**/*`. This is because `fs.glob` does not work with `**.txt` directly, but needs to have `**/*.txt`.

## Generating

Then you can simply generate your docs with `fir generate` (or `fir g` for shory). This will automatically create all folders and files necessary.

## Viewing

You may only want the Markdown files, but I recommend using a project like [Docsify](https://docsify.js.org/#/) or [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) to make your documentation look better as a webpage. The Markdown generic emitter has some facilities to integrate with both Docsify (like comments for the [`docsify-tabs` plugin](https://jhildenbiddle.github.io/docsify-tabs/#/)) and MkDocs.

This page is currently using Material for MkDocs.
