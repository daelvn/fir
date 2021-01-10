# fir.generic.emit.markdown

An emitter that works with a [GenericAST](#/generic/parser.md?id=GenericAST) and turns it into markdown.

You can see an example of the output of this formatter [here](/examples/generic-emit-markdown.md).

## API

This is the API provided to work with the generic markdown emitter.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [emit](#emit) | Emits Markdown from a GenericAST |
| [emitDescription](#emitDescription) | Emits Markdown from the description of an element. |
| [emitSection](#emitSection) | Emits Markdown from a GenericSection |

### emit

**Type:** `ast:GenericAST, options:table -> markdown:string`  

Emits Markdown from a GenericAST


#### Recognized options

- `tabs:table` (`{use=false}`): Adds [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/) comments for code snippets.
  - `header:string` (`"####"`): Headers to use for docsify-tabs.
- `all:boolean` (`false`): Also emits hidden elements.
- `sections:table` (): Settings for sections.
- `columns:table` (): Settings for columns.
  - `[n]:table` (): (where `n` can be any number or `"*"`). Specifies the column names for section `n` (with fallback).
    - `[1]:string` (`"Element"`) - Left column
    - `[2]:string` (`"Summary"`) - Right column
- `types:table` (): Aliases for types.
  - `[type]:string` (): (where `type` can be any of the types supported by [GenericAST](generic/parser.md#GenericAST)). Default values include `type=Types` and `function=Functions`

### emitDescription

**Type:** `desc:[DescriptionLine], options:table -> markdown:string`  

Emits Markdown from the description of an element.


#### Inherited options

- `tabs:table` (`{use=false}`): Adds [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/) comments for code snippets.
  - `header:string` (`"####"`): Headers to use for docsify-tabs.

#### Recognized options

- `headerOffset:number` (`1`): Offsets the header levels by n

### emitSection

**Type:** `section:GenericSection, options:table -> markdown:string`  

Emits Markdown from a GenericSection

This function takes the same options than [emit](#emit)
