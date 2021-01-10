# fir.generic.parser

A parser that works with the format provided by the [generic backend](#/generic/backend.md).

## Helpers

Several functions that aid in the process of parsing.

| Element | Summary |
|---------|---------|
| **Types** |  |
| [DescriptionLine](#DescriptionLine) | A single element in a description returned by `parseDescription` |
| **Functions** |  |
| [parseDescription](#parseDescription) | Parses codeblocks, tags, headers and normal text in descriptions. |

### DescriptionLine

A single element in a description returned by `parseDescription`

```moon
DescriptionLine {
  type      :: string (text|snippet|header)
  content   :: [string]
  language? :: string -- only when type is snippet
  title?    :: string -- only when type is snippet
  n?        :: number -- only when type is header
}
```

### parseDescription

**Type:** `description:[string] -> description:[DescriptionLine], tags:[string]`  

Parses codeblocks, tags, headers and normal text in descriptions.

Returns an array of DescriptionLines and an array of tags.

#### Notes

- In a codeblock, the first character of every line is removed (for a space).

#### Supported tags

- `@internal` - Adds an `internal` true flag to the element.

## API

This is the API provided to work with the generic parser.

| Element | Summary |
|---------|---------|
| **Types** |  |
| [GenericAST](#GenericAST) | The AST produced by `parse`. |
| **Functions** |  |
| [parse](#parse) | Parses a list of GenericComments into a GenericAST |

### GenericAST

The AST produced by `parse`.

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
        is          :: string (type|function)
        description :: [DescriptionLine]
        name        :: [string] -- an array, meant to also contain aliases
        summary     :: string
        type        :: string -- only when is == function
      }
    }
  }
}
```

### parse

**Type:** `comments:[GenericComment], language:Language -> ast:GenericAST`  

Parses a list of GenericComments into a GenericAST

