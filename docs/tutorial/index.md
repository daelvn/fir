# Tutorial

This page explains how to document your code to work with the generic/default parser.

## Top header

A first-level header (`#`) with an according description is inserted once with the following syntax (`<single><lead>#...#<lead><single>` [?](#languages)):

=== "Python"
    ```py
    ### Title ###
    # Description
    ```

=== "Lua/MoonScript"
    ```lua
    ---# Title #---
    -- Description
    ```

The description can span as many lines as you wish as long as there is no empty line in the middle. If you want an empty line, just use an empty comment (this will also split the description into paragraphs).

### Hiding the document

You can stop the document from being generated if you place `@internal` in the description as the first word. This will stop the page from being generated unless `all` is set to `true` in the [`emit` options](emit/markdown.md#emit).

## Section

You can add a section (`##`) with the following syntax (`<single>#...#<single>` [?](#languages)):

=== "**Python**"

    ```py
    ## Title ##
    # Description
    ```

=== "**Lua/MoonScript**"

    ```lua
    --# Title #--
    -- Description
    ```

The description can span as many lines as you wish as long as there is no empty line in the middle. If you want an empty line, just use an empty comment (this will also split the description into paragraphs).

Every section generates with its own table of contents, separating between Types and Functions.

### Hiding a section

You can stop a section from being generated if you place `@internal` in the description as the first word. This will stop the section from being emitted unless `all` is set to `true` in the [`emit` options](generic/emit/markdown.md#emit).

## Functions

You can document a function with the following syntax:

=== "**Python**"

    ```py
    ## @function name alias1 alias2 :: type signature
    ## Summary
    # Description
    ```

=== "**Lua/MoonScript**"

    ```lua
    --- @function name alias1 alias2 :: type signature
    --- Summary
    -- Description
    ```

The aliases must be separated by spaces and are not mandatory. The type signature is mandatory for a function and will be copied verbatim. The summary will be placed in its own paragraph and will be used for the table of contents as well.

The description can span as many lines as you wish as long as there is no empty line in the middle. If you want an empty line, just use an empty comment (this will also split the description into paragraphs).

### Hiding a function

You can stop a function from being generated if you place `@internal` in the description as the first word. This will stop the function from being emitted unless `all` is set to `true` in the [`emit` options](generic/emit/markdown.md#emit).

## Types

You can document a type with the following syntax:

=== "**Python**"

    ```py
    ## @type name alias1 alias2
    ## Summary
    #:type Format
    # Describe your type here
    ```

=== "**Lua/MoonScript**"

    ```lua
    --- @type name alias1 alias2
    --- Summary
    --:type Format
    -- Describe your type here
    ```

It is customary to describe your type within a [code block](#code-block). Everything else is mostly the same as functions.

## Constants

You can document a constant (does not need to be a constant, but...) using the following syntax:

!!! note
    You can also use `@const` instead of `@constant`.

=== "**Python**"

    ```py
    ## @constant name alias1 alias2 :: type
    ## Summary
    # Description
    ```

=== "**Lua/MoonScript**"

    ```lua
    --- @constant name alias1 alias2 :: type
    --- Summary
    -- Description
    ```

The aliases must be separated by spaces and are not mandatory. The type is mandatory for a constant and will be copied verbatim. The summary will be placed in its own paragraph and will be used for the table of contents as well.

The description can span as many lines as you wish as long as there is no empty line in the middle. If you want an empty line, just use an empty comment (this will also split the description into paragraphs).

## Classes

You can document classes with the following syntax:

=== "**Python**"

    ```py
    ## @class name alias1 alias2
    ## Summary
    # Description
    ```

=== "**Lua/MoonScript**"

    ```lua
    --- @class name alias1 alias2
    --- Summary
    -- Description
    ```

The aliases must be separated by spaces and are not mandatory. The summary will be placed in its own paragraph and will be used for the table of contents as well.

The description can span as many lines as you wish as long as there is no empty line in the middle. If you want an empty line, just use an empty comment (this will also split the description into paragraphs).

## Descriptions

There are several tricks to make your descriptions look better.

### Headers

You can place headers within descriptions as such. They will be automatically indented properly.

=== "**Python**"

    ```py
    ## Header
    # Description follow-up
    ```

=== "**Lua/MoonScript**"

    ```lua
    --# Header
    -- Description follow-up
    ```

### Code blocks

You can add a code block with the following syntax:

=== "**Python**"

    ```py
    #:language Title
    # code
    ```

=== "**Lua/MoonScript**"

    ```lua
    --:language Title
    -- code
    ```

If you need to continue a description after a codeblock, place a comment containing only `:` (no spaces) to stop the codeblock, or alternatively start a different codeblock.

## Ignoring comments

You can ignore a set of comments by placing `(single)///(single)` (like `#///#` or `--///--`) at both the start or the end of the region you want to ignore, like so:

=== "**Python**"

    ```py
    #///#
    # These comments will be ignored
    #///#
    ```

=== "**Lua/MoonScript**"

    ```lua
    --///--
    -- These comments will be ignored
    --///--
    ```

These comments will not be extracted at all. You can use this to document within your functions without the results actually being in the output (in fact, this is recommended).

## Linking to symbols

You can use `@@@symbol@@@` outside of inline code or a code block to automatically link to a symbol in the project. Symbols are collected by taking all the names and aliases of all exported documentation.

If there is a name conflict, you can prefix it with its parent module, like `@@@parent.symbol@@@`.

## Languages

The language table passed to `extract` and `parse` define the comments that the Fir generic pipeline will look for.

### Lead

The `<lead>` character mentioned [here](#top-header) is the *last* character from the `single` comment field. So if your language looks like `{single = "--"}`, the lead will be `"-"`.

## Examples

The Fir source code is documented using Fir! Read through the source code and compare to the documentation to see how it's documented.
