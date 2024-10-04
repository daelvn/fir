# fir.generic.emit.markdown

An emitter that works with a [GenericAST](/generic/parser.md#GenericAST) and turns it into markdown.

## API

This is the API provided to work with the generic markdown emitter.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [emit](#emit) | Emits Markdown from a `GenericAST` |
| [emitDescription](#emitDescription) | Emits Markdown from the description of an element. |
| [emitSection](#emitSection) | Emits Markdown from a GenericSection |

### emit

**Type:** `ast:GenericAST, options:table -> markdown:string`  

Emits Markdown from a `GenericAST`


#### Recognized options

- `tabs:table`: Adds tabbed syntax to the final output.
    - `use:boolean|"docsify"|"pymdownx"` (`false`): Outputs tab syntax, either  [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/) or [pymdownx.tabbed](https://facelessuser.github.io/pymdown-extensions/extensions/tabbed/#syntax).
    - `docsify_header:string` (`"####"`): **Unused**. Headers to use for docsify-tabs.
- `all:boolean` (`false`): Also emits hidden elements.
- `sections:table`: Settings for sections.
- `columns:table`: Settings for columns.
    - `[n]:table`: (where `n` can be any number or `"*"`). Specifies the column names for section `n` (with fallback).
        - `[1]:string` (`"Element"`) - Left column
        - `[2]:string` (`"Summary"`) - Right column
- `types:table`: Aliases for types.
    - `[type]:string`: (where `type` can be any of the types supported by [GenericAST](generic/parser.md#GenericAST)). Default values include `type=Types` and `function=Functions` among others.

### emitDescription

**Type:** `desc:[DescriptionLine], options:table -> markdown:string`  

Emits Markdown from the description of an element.


#### Inherited options

- `tabs:table`: Adds tabbed syntax to the final output.
    - `use:boolean|"docsify"|"pymdownx"` (`false`): Outputs tab syntax, either  [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/) or [pymdownx.tabbed](https://facelessuser.github.io/pymdown-extensions/extensions/tabbed/#syntax).
    - `docsify_header:string` (`"####"`): Headers to use for docsify-tabs.

#### Recognized options

- `headerOffset:number` (`1`): Offsets the header levels by n

### emitSection

**Type:** `section:GenericSection, options:table -> markdown:string`  

Emits Markdown from a GenericSection

This function takes the same options than [emit](#emit)
