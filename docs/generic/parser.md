# fir.generic.parser

A parser that works with the format provided by the [generic backend](/fir/generic/backend).

You can see an example of parser output [here](/fir/examples/generic-parser.html).

## Helpers

Several functions that aid in the process of parsing.

| Element | Summary |
|---------|---------|
| **Types** |  |
| [DescriptionLine](#DescriptionLine) | A single element in a description returned by `parseDescription` |
| **Functions** |  |
| [determineSummaryBoundary](#determineSummaryBoundary) | Gets the boundary line where a summary ends and the description begins |
| [parseDescription](#parseDescription) | Parses codeblocks, tags, headers and normal text in descriptions. |

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>DescriptionLine</strong>&nbsp;
</div>

A single element in a description returned by `parseDescription`


=== "Format"

    ```moon
    DescriptionLine {
      type      :: string (text|snippet|header)
      content   :: [string]
      language? :: string -- only when type is snippet
      title?    :: string -- only when type is snippet
      n?        :: number -- only when type is header
    }
    ```


<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>determineSummaryBoundary</strong>&nbsp;
<span class='annotate'>:: content:[GenericComment](/fir/generic/backend#GenericComment).content, lead:string -> boundary:number</span>
</div>


Gets the boundary line where a summary ends and the description begins

- Gets the boundary line where a summary ends and the description begins

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>parseDescription</strong>&nbsp;
<span class='annotate'>:: description:[string] -> description:[[DescriptionLine](/fir/generic/parser#DescriptionLine)], tags:[string]</span>
</div>


Parses codeblocks, tags, headers and normal text in descriptions.


#### Notes

- In a codeblock, the first character of every line is removed (for a space).

#### Supported tags

- `@internal` - Adds an `internal` true flag to the element.

## API

This is the API provided to work with the generic parser.

| Element | Summary |
|---------|---------|
| **Functions** |  |
| [parse](#parse) | Parses a list of GenericComments into a GenericAST |
| **Types** |  |
| [GenericAST](#GenericAST) | The AST produced by `parse`. |

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>parse</strong>&nbsp;
<span class='annotate'>:: comments:[[GenericComment](/fir/generic/backend#GenericComment)], language:Language -> ast:[GenericAST](/fir/generic/parser#GenericAST)</span>
</div>


Parses a list of GenericComments into a GenericAST

- Parses a list of GenericComments into a GenericAST

<div markdown class='fir-symbol fancy-scrollbar'>
### <strong>GenericAST</strong>&nbsp;
</div>

**Aliases:** `GenericSection, GenericSectionContent, GenericElement`

The AST produced by `parse`.


=== "Format"

    ```moon
    GenericAST {
      title       :: string
      description :: [DescriptionLine]
      [n]         :: GenericSection { -- where n is the ID of the section
        section :: GenericSectionDetails {
          id          :: number
          name        :: string
          description :: [DescriptionLine]
        }
        content :: GenericSectionContent {
          [name] :: GenericElement {
            is          :: string (type|function|constant|class)
            description :: [DescriptionLine]
            name        :: [string] -- an array, meant to also contain aliases
            summary     :: string
            type        :: string -- only when `is` is `"function"` or `"constant"`
          }
        }
      }
    }
    ```

