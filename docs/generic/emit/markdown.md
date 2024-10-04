# fir.generic.emit.markdown

An emitter that works with a [`GenericAST`](/fir/generic/parser#GenericAST) and turns it into markdown.

## API

This is the API provided to work with the generic markdown emitter.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [emit](#emit) | Emits Markdown from a [`GenericAST`](/fir/generic/parser#GenericAST) |
| [emitDescription](#emitDescription) | Emits Markdown from the description of an element. |
| [emitSection](#emitSection) | Emits Markdown from a [`GenericSection`](/fir/generic/parser#GenericAST) |
| [listAllSymbols](#listAllSymbols) | Locates all symbols in an AST |
| [replaceSymbols](#replaceSymbols) | Returns a string with the symbol syntax replaced with its documentation location |

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emit</strong>&nbsp;
<span class='annotate'>:: ast:[GenericAST](/fir/generic/parser#GenericAST), options:table -> markdown:string</span>
</div>


Emits Markdown from a [`GenericAST`](/fir/generic/parser#GenericAST)

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
- `symbols:{string:string}`: Map of symbols to their documentation locations
- `symbols_in_code:boolean|'mkdocs'` (false): Whether to link symbols inside code. Only supports MkDocs.

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitDescription</strong>&nbsp;
<span class='annotate'>:: desc:[[DescriptionLine](/fir/generic/parser#DescriptionLine)], options:table -> markdown:string</span>
</div>


Emits Markdown from the description of an element.

- `tabs:table`: Adds tabbed syntax to the final output.
    - `use:boolean|"docsify"|"pymdownx"` (`false`): Outputs tab syntax, either  [docsify-tabs](https://jhildenbiddle.github.io/docsify-tabs/#/) or [pymdownx.tabbed](https://facelessuser.github.io/pymdown-extensions/extensions/tabbed/#syntax).
    - `docsify_header:string` (`"####"`): Headers to use for docsify-tabs.
- `symbols:{string:string}`: Map of symbols to their documentation location
- `symbols_in_code:boolean|'mkdocs'` (false): Whether to link symbols inside code. Only supports MkDocs.

#### Recognized options

- `headerOffset:number` (`1`): Offsets the header levels by n

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>emitSection</strong>&nbsp;
<span class='annotate'>:: section:[GenericSection](/fir/generic/parser#GenericAST), options:table -> markdown:string</span>
</div>


Emits Markdown from a [`GenericSection`](/fir/generic/parser#GenericAST)



<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>listAllSymbols</strong>&nbsp;
<span class='annotate'>:: ast:[GenericAST](/fir/generic/parser#GenericAST) -> {[symbol: string]: location:string}</span>
</div>


Locates all symbols in an AST

- `module:string`: Module string to use
- `url_prefix:string`: Prefix of all documentation urls

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>replaceSymbols</strong>&nbsp;
<span class='annotate'>:: str:string, symbols:{string:string} -> str:string</span>
</div>


Returns a string with the symbol syntax replaced with its documentation location

`<symbol>`
